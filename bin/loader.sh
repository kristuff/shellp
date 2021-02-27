#!/usr/bin/env bash
#      _        _ _        
#   __| |_  ___| | |_ __   
#  (_-< ' \/ -_) | | '_ \  
#  /__/_||_\___|_|_| .__/ 
#                  |_|
#
#  This file is part of Kristuff/shellp
#  (c) 2016-2021 Kristuff <contact@kristuff.fr>
#  For the full copyright and license information, please view 
#  the LICENSE file that was distributed with this source code.
#  
#  FILE          : loader
#  DESCRIPTION   : sysadmin scripts loader
#  AUTHOR        : kristuff (https://github.com/kristuff)
#  CREATED       : 2016-10-15
#  REVISION      : 2020-04-25
#  DEVNOTES      : interactive mode only, requires echolor 

# ----------------------------------
# do nothing in non interactive mode
# ----------------------------------
[ -z "$PS1" ] && return

# ---------------------------------------
# load core script files from current dir
# ---------------------------------------
SOURCE_DIR=$(dirname "$BASH_SOURCE")

# ---------------------------------------
# helper function to source or execute
# scripts files
# ---------------------------------------
function loadscript() {
    local CURRENT_LINE
	if [ -f "$1" ]; then
        # source file. note the '.' 
	   . "$1"
    	echolor " ✓ " -c green -n
    	echolor "file: [" -c grey -f bold -n
		echolor "$1" -c white -n
		echolor "] successfully loaded"  -c grey
	else
    	echolor " ✗ " -c red -n
		echolor "Failed to load script: [" -c grey -n
		echolor "$1" -c red -n
		echolor "]. The file doesn't exist." -c grey
	fi 
}

function exescript() {
    if [ -f "$1" ]; then
        "$1"
    else
        echo "exescript error: file "$1" doesn't exist."
    fi
}

function banner() { 
    echolor "     _        _ _       " -c magenta
    echolor "  __| |_  ___| | |_ __  " -c magenta
    echolor " (_-< ' \/ -_) | | '_ \ " -c magenta
    echolor " /__/_||_\___|_|_| .__/ " -c magenta -n 
    echolor " v0.1 " -c white -b magenta 
    echolor "                 |_|    " -c magenta
    echo
}

function footer() { 
    echolor " ---------------------------------------------" -c darkgray
    echolor " kristuff/shellp " -c darkgray -n 
    echolor "v0.1" -c gray -n
    echolor " | Made with " -c darkgray -n 
    echolor "♥" -c red -n 
    echolor " in France " -c darkgray 
    echolor " © 2020-2021 Kristuff (" -c darkgray -n
    echolor "https://github.com/kristuff" -c darkgray -n -f underlined
    echolor ")" -c darkgray 
    echo
}   

# Go
banner
loadscript $SOURCE_DIR/zapt.sh
loadscript $SOURCE_DIR/zlog.sh
loadscript $SOURCE_DIR/zban.sh
loadscript $SOURCE_DIR/apa.sh
loadscript $SOURCE_DIR/ftb.sh
echo
footer

# remove temp functions
unset -f banner
unset -f footer
unset -f loadscript
unset -f exescript
