#!/bin/bash

cliphist list | dmenu -b -l 10 -i -fn "MartianMono NFM Cond Med:14" -nb "#282828" -nf "#ebdbb2" -sb "#fabd2f" -sf "#282828"| cliphist decode | wl-copy
