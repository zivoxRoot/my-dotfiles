#!/usr/bin/env bash
# backup-pi [--notify]  Snapshot ~/backup to the Pi (hardlinks vs previous snapshot).
set -euo pipefail

SOURCE="$HOME/backup/"
REMOTE="server@100.115.51.54"
MOUNT="/mnt/storage"
BASE="/mnt/storage/backups/laptop/snapshots"
KEEP_DAYS=90
MIN_KEEP=7

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/backup-pi"
LOG="$STATE/last.log"
TAG="backup-pi"
NOTIFY=0; [[ "${1:-}" == "--notify" ]] && NOTIFY=1
mkdir -p "$STATE"; : > "$LOG"

# notify <urgency> <title> <body> [percent] [timeout_ms]
# Same stack tag = each notification replaces the previous one (reminder -> progress -> result)
notify() {
  (( NOTIFY )) || return 0
  local args=(-u "$1" -h "string:x-dunst-stack-tag:$TAG")
  [[ -n "${4:-}" ]] && args+=(-h "int:value:$4")
  [[ -n "${5:-}" ]] && args+=(-t "$5")
  dunstify "${args[@]}" "$2" "$3"
}

fail() {
  echo "Backup failed: $1" >&2
  notify critical "Backup failed" "$1 (log: $LOG)"
  exit 1
}

stamp=$(date +%F_%H%M)

# Pi reachable AND the external disk mounted (never write to the SD card)
ssh -o ConnectTimeout=10 -o BatchMode=yes "$REMOTE" "mountpoint -q '$MOUNT' && mkdir -p '$BASE'" \
  || fail "Pi unreachable or $MOUNT not mounted"

notify normal "Backup" "Starting..." 0

rsync_cmd=(rsync -a --partial --no-inc-recursive --info=progress2
           --link-dest=../latest "$SOURCE" "$REMOTE:$BASE/.inprogress/")

rc=0
if (( NOTIFY )); then
  # rsync separates progress updates with \r; turn them into lines, update only when % changes
  "${rsync_cmd[@]}" 2>>"$LOG" | tr '\r' '\n' | {
    last=""
    while read -r line; do
      if [[ $line =~ ([0-9]+)% && "${BASH_REMATCH[1]}" != "$last" ]]; then
        last=${BASH_REMATCH[1]}
        notify normal "Backup in progress" "${last}%" "$last"
      fi
    done
  } || rc=$?
else
  "${rsync_cmd[@]}" || rc=$?
fi
(( rc == 0 || rc == 24 )) || fail "rsync exited with code $rc"   # 24 = files vanished, harmless

ssh "$REMOTE" bash -s -- "$BASE" "$stamp" "$KEEP_DAYS" "$MIN_KEEP" <<'EOF' || fail "finalize/prune failed"
set -euo pipefail
base=$1 stamp=$2 keep_days=$3 min_keep=$4
cd "$base"
mv .inprogress "$stamp"
ln -sfn "$stamp" latest
cutoff=$(date -d "$keep_days days ago" +%F)
ls -1d 20* | sort -r | tail -n +"$((min_keep + 1))" | while read -r snap; do
  if [[ "${snap:0:10}" < "$cutoff" ]]; then rm -rf -- "$snap"; fi
done
EOF

date +%F > "$STATE/last-success"
echo "Snapshot $stamp done"
notify normal "Backup complete" "Snapshot $stamp" 100 6000
