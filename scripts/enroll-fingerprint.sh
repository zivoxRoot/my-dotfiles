#!/bin/sh

# Let the user choose which finger to enroll through a rofi menu then enroll it

CHOICE=$(echo -e "Left index\nLeft thumb\nRight index\nRight thumb" | rofi -dmenu -p "Choose a finger: ")
case "$CHOICE" in
	"Left index") FINGER="left-index-finger" ;;
	"Left thumb") FINGER="left-thumb" ;;
	"Right index") FINGER="right-index-finger" ;;
	"Right thumb") FINGER="right-thumb" ;;
	*) exit 1 ;;
esac

kitty --hold fprintd-enroll -f "$FINGER"
