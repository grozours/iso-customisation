#!/bin/bash

# populate pacman
pacman-key --init
pacman-key --populate archlinux

# update pacman database
pacman -Sy

#pid_gpg_to_kill=$(ps -eaf | grep [gpg]-agent | awk '{print $2}')
#kill -9 $pid_gpg_to_kill


