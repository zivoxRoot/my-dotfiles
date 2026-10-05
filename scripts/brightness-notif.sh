#!/bin/sh

BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
BRIGHTNESS_PERCENT=$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))

dunstify \
	--app-name=brightness \
	--expire-time=1000 \
	--icon="display-brightness-medium" \
	--stack-tag=BRIGHTNESS \
	--hints="int:value:$BRIGHTNESS_PERCENT" \
	"Brightness: $BRIGHTNESS_PERCENT"
