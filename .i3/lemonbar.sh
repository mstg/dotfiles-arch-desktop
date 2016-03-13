#!/bin/bash
kill -9 `ps ux | grep '/bin/bash /home/mustafa/.i3/lemonbar.sh' | awk -F\  -v pid=$$ 'pid != $2 {print $2}'` > /dev/null 2>&1
kill -9 `ps ux | grep 'tail -f /tmp/lemonbar_sc' | awk -F\  -v pid=$$ 'pid != $2 {print $2}'` > /dev/null 2>&1
killall lemonbar
killall zx
zx
zx -x 1920

scf1="/tmp/lemonbar_sc1"
scf2="/tmp/lemonbar_sc2"
font="-*-dejavu sans-medium-r-*-*-11-*-*-*-*-*-microsoft-*"

if [ -f $scf1 ]; then
    rm $scf1
fi

if [ -f $scf2 ]; then
    rm $scf2
fi

touch $scf1
touch $scf2

user=$(uname -n)
release=$(uname -r)

#BG="#2C3E50"
BG="#181818"
RED="#E74C3C"
GREEN="#2ECC71"

sc1=""
sc2=""

while :; do
    DTIME=$(date +"%d-%m-%Y %H:%M")
    sc2="%{c}$DTIME"

    echo $sc2 > $scf2

    title=$(xdotool getwindowfocus getwindowname)
    volume=$(awk -F"[][]" '/%/ { print $2; exit }' <(amixer sget Master) | tr -d "%")
    mutestate=$(awk -F"[][]" '/\[(on|off)\]/ { print $4; exit }' <(amixer sget Master))

    title_s="%{c}($title)"

    sc1="%{l}[$user, $release] $title_s %{r}"

    if [ $mutestate == "off" ]; then
        sc1+="%{F$RED}$volume"
    else
		    sc1+="%{F$GREEN}$volume"
	  fi

    sc1+="%%{F-} - $DTIME"

    echo $sc1 > $scf1
done &

tail -f $scf1 | lemonbar -p -B $BG -g 1920x20 -f "$font" &
tail -f $scf2 | lemonbar -p -B $BG -g 1920x20+1920 -f "$font" &
