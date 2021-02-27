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
#  FILE          : zapt.sh
#  DESCRIPTION   : apt/apt-get helper functions
#  AUTHOR        : kristuff (https://github.com/kristuff)
#  CREATED       : ?
#  REVISION      : 2021-02-21
#  DEVNOTES      : interactive mode only, requires echolor 

# ----------------------------------
# do nothing in non interactive mode
# ----------------------------------
[ -z "$PS1" ] && return

zapt() {
    if [ -z "$1" ]; then
        #_help
        echo "usage: todo..."
    else
        case "$1" in
            "up")
 		        echolor "► Run " -c darkgray -n 
                echolor "apt-get update" -c white
			    apt-get update
 		        echolor "► Run " -c darkgray -n 
                echolor "apt-get upgrade" -c white
			    apt-get upgrade
 		        echolor "► Run " -c darkgray -n 
                echolor "apt-get dist-upgrade" -c white
			    apt-get dist-upgrade
 		        echolor "► Run " -c darkgray -n 
                echolor "apt-get autoclean" -c white
			    apt-get autoclean
 		        echolor "► Run " -c darkgray -n 
                echolor "apt-get clean" -c white
			    apt-get clean
 		        echolor "► Run " -c darkgray -n 
                echolor "apt-get autoremove" -c white
			    apt-get autoremove
                echolor "✓ " -c green -n 
                echolor "Done" -c white
                ;;
            "check")
 		        echolor "► apt-get dependencies checking " -c darkgray 
    			apt-get install -f
                ;;
			"list")
				# display a list of installed packages
				dpkg-query -l
				;;
            "search")
                # search a package
                if [ -z "$2" ]; then
                    echo "usage: zapt search PACKAGE."
                else
                    apt-cache search "$2"
                fi
                ;;

            * )
                echo "invalid parameters"
                ;;
        esac
    fi
}

# *********************
# autocomplete function
# *********************
_zapt()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

	case "$prev" in
        "zapt")
            COMPREPLY=( $(compgen -W "up check list search" -- "${cur}"  ) )
            return 0
            ;;
	esac
}
complete -F _zapt zapt
