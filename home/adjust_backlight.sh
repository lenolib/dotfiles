#!/bin/bash
set -e

percent_change=$1
max=$(cat /sys/class/backlight/intel_backlight/max_brightness);
curr=$(cat /sys/class/backlight/intel_backlight/brightness);
min=1;

new=$(( $curr + $percent_change * $max / 100 ));
if (( $new < $min )); then
	new=$min;
else
	if (( $new > $max )); then
		new=$max;
	fi
fi


echo "Setting new brightness: $new";
# NOTE: By default, the backlight file needs to be chmod:ed with o+w to be writable
echo $new > /sys/class/backlight/intel_backlight/brightness