#!/bin/bash
git clone https://aur.archlinux.org/aurutils.git
cd aurutils
makepkg -si --skippgpcheck --noconfirm
