#!/usr/bin/env bash

cat <<'EOF' > "$HOME/.config/systemd/user/backup-remind.service"
[Unit]
Description=Backup reminder

[Service]
Type=oneshot
ExecStart=%h/my-dotfiles/scripts/backup-remind.sh
EOF

cat <<'EOF' > "$HOME/.config/systemd/user/backup-remind.timer"
[Unit]
Description=Daily backup reminder

[Timer]
OnCalendar=*-*-* 21:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Start service
systemctl --user daemon-reload
systemctl --user enable --now backup-remind.timer
