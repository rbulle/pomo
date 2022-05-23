# Pomo :tomato:

## What is Pomo ?

Pomo is a little bash script I have written in order to launch pomodoro sessions from terminal. It is a modest script displaying messages in command line, playing little sounds and displaying notifications when it's time to work/relax.

## Installation

First git clone this repository:

    git clone https://github.com/rbulle/pomo.git

Go to the cloned directory:

    cd pomo/

Then, 3 choices:
1) Run pomo directly (from the cloned directory):

    bash pomo

2) Make it executable:

    chmod +x pomo

and then run it (from the cloned directory):

    ./pomo

3) Add the location (absolute path) of the directory `pomo/` to your `.bashrc`, source it:

    source ~/.bashrc

and run pomo from any directory with:

    pomo

## How does it work ?

In pomo you can set pomodori, short breaks and long breaks durations (in minutes) and the intervals (number of pomodori) between long breaks as follow:

    pomo <pomodori duration> <short breaks duration> <long breaks duration> <intervals>

If you run pomo solely:

    pomo

it will pass the default parameters:

    pomo 25 5 15 4

## What does it use ?

It uses `afplay` to play beeps when a pomo session or a break start, the sounds are located in a System subdirectory specific to MacOS.
It also uses `osascript` to display notifications when a pomo session or a break start.

## Compatibility

It has only been tested on MacOS Big Sur (11.6) and very likely won't work on other OS without modifications on the lines using `afplay` and `osascript` at least.

## License

Please do whatever you want with this.
