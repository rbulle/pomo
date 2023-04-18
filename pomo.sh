#!/bin/bash

sounds_dir="/System/Library/PrivateFrameworks/ScreenReader.framework/Versions/A/Resources/Sounds/"
pomo_sound="${sounds_dir}DrillOut.aiff"
sbreak_sound="${sounds_dir}DrillIn.aiff"
lbreak_sound="${sounds_dir}Alert.aiff"
end_sound="${sounds_dir}WebPageLoaded.aiff"

cats_dir="/Users/raphaelbulle/Documents/code/pomo/cats/"

set -e # Considered as bad practice but will do for now

trap ctrl_c INT

function ctrl_c()
{
    worktime_rough=$((($i - 1) * $pomo_duration))
    worktime_hour=$(($worktime_rough / 60))
    worktime_min=$(($worktime_rough % 60))
    afplay $end_sound 
    echo -e "\nCongratulations! You have completed $(($i - 1)) pomos and worked for at least $worktime_hour h $worktime_min min!"
}

function display_cat {
    num_cats=$(ls $cats_dir | wc -l)
    selected_cat=$((1 + $RANDOM%($num_cats)))
    cat_path="$cats_dir$selected_cat.txt"
    num_char=$(wc -m $cat_path | awk '{print $1}')
    num_lines=$(wc -l $cat_path | awk '{print $1}')
    divisor=$((num_char+num_lines))

    count=0
    while IFS= read -r -n1 char
    do
        echo -n "$char"
        count=$((count+1))
        if [[ $count%81 -eq 0 ]]
        then
            echo ""
        fi
        sleep $(echo "scale=8; $1*60/$divisor" | bc)
    done < "$cat_path"
    echo ""
}

if [[ "$1" == "help" ]]
then
    echo -e "Usage:\n$( basename $0 ) <pomo duration in minutes> <short break duration in minutes> <long break duration in minutes> <number of pomos between long breaks>" >&2
    exit 1
fi

if test -z "$1"
then
    pomo_duration="25"
    sbreak_duration="5"
    lbreak_duration="15"
    intervals="4"
else
    pomo_duration=$1
    sbreak_duration=$2
    lbreak_duration=$3
    intervals=$4
fi

echo -e "Let's work!\nPomos duration:\t\t $pomo_duration min\nShort breaks duration:\t $sbreak_duration min\nLong breaks duration:\t $lbreak_duration min\nLong breaks every:\t $intervals pomos"

i=1
while :
do
    afplay $pomo_sound 
    echo "Starting $pomo_duration min pomo!"
    osascript -e 'display notification "Time to work!" with title "pomo"'

    display_cat $pomo_duration
    i=$(( $i + 1))
    if (($i % $intervals == 0 ))
    then
        afplay $lbreak_sound
        echo "$lbreak_duration min long break!"
        osascript -e 'display notification "Time for a long break!" with title "pomo"'
        caffeinate -dimt "$(($lbreak_duration*60))"
    else
       afplay $sbreak_sound
       echo "$sbreak_duration min short break!"
       osascript -e 'display notification "Time for a short break!" with title "pomo"'
       caffeinate -dimt "$(($sbreak_duration*60))"
    fi
done

