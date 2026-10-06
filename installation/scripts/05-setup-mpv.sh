#!/bin/sh

# Downloads two scripts/plugins for mpv for a better UI experience

# Dependency: curl

mkdir -p "$HOME/.config/mpv/scripts"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"
curl https://raw.githubusercontent.com/po5/thumbfast/refs/heads/master/thumbfast.lua > "$HOME/.config/mpv/scripts/thumbfast.lua"
