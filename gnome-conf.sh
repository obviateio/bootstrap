#!/bin/bash
PREFIX='/org/gnome/terminal/legacy/profiles:/:'
PROFILE=`dconf dump /org/gnome/terminal/|grep profiles|awk -F':' '{print $3}'|tr -d ']'`

declare -A SETTINGS
# Get your prefered settings via: dconf dump /org/gnome/terminal/
SETTINGS[foreground-color]="'rgb(131,148,150)'"
SETTINGS[visible-name]="'Main'"
SETTINGS[login-shell]="false"
SETTINGS[palette]="['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"
SETTINGS[custom-command]="'zsh'"
SETTINGS[use-system-font]="false"
SETTINGS[use-custom-command]="true"
SETTINGS[use-theme-colors]="false"
SETTINGS[font]="'Ubuntu Mono derivative Powerline 13'"
SETTINGS[use-theme-transparency]="false"
SETTINGS[allow-bold]="true"
SETTINGS[background-color]="'rgb(0,43,54)'"
SETTINGS[background-transparency-percent]="15"

for X in "${!SETTINGS[@]}"
do
	if [[ ${SETTINGS[$X]} == *"'"* ]]; then
		#settings array (like pallet) need no single quotes
		TMP="dconf write $PREFIX$PROFILE/$X \"${SETTINGS[$X]}\""
	else
		#most settings should have single and double quotes
		TMP="dconf write $PREFIX$PROFILE/$X ${SETTINGS[$X]}"
	fi
	#TMP="dconf write $PREFIX$PROFILE/$X ${SETTINGS[$X]}"
	echo $TMP
	eval $TMP
done

dconf write /org/cinnamon/sounds/switch-enabled 'false'
dconf write /org/cinnamon/settings-daemon/peripherals/touchpad/motion-threshold '5'
dconf write /org/cinnamon/settings-daemon/peripherals/touchpad/natural-scroll 'false'
dconf write /org/cinnamon/settings-daemon/peripherals/touchpad/vertical-edge-scrolling 'false'
dconf write /org/cinnamon/settings-daemon/peripherals/touchpad/tap-to-click 'false'
dconf write /org/cinnamon/desktop/keybindings/media-keys/screensaver "['<Super>l', 'XF86ScreenSaver']"
dconf write /org/cinnamon/desktop/background/picture-options 'zoom'
dconf write /org/cinnamon/desktop/background/slideshow/image-source 'xml:///usr/share/cinnamon-background-properties/linuxmint-serena.xml'
dconf write /org/cinnamon/desktop/background/slideshow/random-order 'true'
dconf write /org/cinnamon/desktop/background/slideshow/delay '5'
dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled 'true'
dconf write /org/cinnamon/desktop/interface/clock-show-date 'true'


exit
