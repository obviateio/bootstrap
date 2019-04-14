#!/bin/bash
BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

# Do some basic "universal" setup.
mkdir -p ~/Development
mkdir -p ~/.aws


# OS Detection. Mac? Ubuntu? Server?
if [ `uname` = 'Darwin' ]; then
    # This is a mac
    P=1 bash run_mac.sh
else
    if [ ! -f /etc/lsb-release ]; then
        echo "Not a mac and no lsb-release. Giving up"
        exit
    else
        if cat /etc/lsb-release |grep -q Ubuntu; then
            # This is ubuntu, check for server before invoke
            SRV=`apt list --installed 2>/dev/null|grep ubuntu-server|wc -l`
            P=1 SRV=$SRV bash run_ubuntu.sh
        else
            echo "Not Ubuntu, not supported. Giving up"
        fi
    fi
fi

# https://github.com/seebi/dircolors-solarized/blob/master/dircolors.ansi-dark
# .dircolors.ansi-darks