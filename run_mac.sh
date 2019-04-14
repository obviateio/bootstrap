#!/bin/bash
BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

if [ ! $P ]; then
    echo "Don't invoke this file directly. Use run.sh"
    exit
fi

echo "Running macOS Install"

# https://github.com/ryanoasis/nerd-fonts