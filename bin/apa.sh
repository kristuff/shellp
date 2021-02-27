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
#  FILE          : apa.sh
#  DESCRIPTION   : apache2 helper functions
#  AUTHOR        : kristuff (https://github.com/kristuff)
#  CREATED       : 2016-10-15
#  REVISION      : 2021-02-21
#  DEVNOTES      : interactive mode only

# ----------------------------------
# do nothing in non interactive mode
# ----------------------------------
[ -z "$PS1" ] && return

# -------------
# main function
# -------------
apa() {    
    local usage
	usage="Usage: apa {enable|disable|start|stop|site|site+|site-|conf|seeconf|logconf}"

    if [ -z "$1" ]; then
        echo  "$usage"
    else
        case "$1" in

            "stop"|"srv-")
                # stop apache service
                # /etc/init.d/apache2 stop
				systemctl stop apache2.service
                ;;

		 	"start"|"srv+")
				# restart apache
				# /etc/init.d/apache2 restart
                systemctl restart apache2.service
				;;

			"conf")
				# edit apache conf
				nano /etc/apache2/apache2.conf
				;;

			"seeconf")
				# show apache conf
				grep -v '^#' /etc/apache2/apache2.conf | grep -v '^$'
				;;

			"site")
                # edit (with nano) apache config file
 				if [ -z "$2" ]; then
                    echo "Usage: apa site <FILE>."
					echo "File is the name of the file in [/etc/apache2/sites-available/]. Press Tab to see available files."
                else
                    nano /etc/apache2/sites-available/"$2"
                fi
                ;;

  			"enable"|"site+")
                # enable a site
                if [ -z "$2" ]; then
                    echo "Usage: apa enable <FILE>."
                    echo "File is the name of file in [/etc/apache2/sites-available/]. Press Tab to see available files."
                else
					a2ensite "$2"
                fi
          		;;

            "disable"|"site-")
                # disable a site
                if [ -z "$2" ]; then
                    echo "Usage: apa disable <FILE>."
                    echo "File is the name of file in [/etc/apache2/sites-enabled/]. Press Tab to see available files."
                else
                    a2dissite "$2"
                fi
                ;;

			"logconf")
                # edit logrotate conf
				nano /etc/logrotate.d/apache2
				;;

			* )
				echo "Error: invalid paramaters"
				echo "$usage"
                ;;
        esac
    fi
}

# ---------------------
# autocomplete function
# ---------------------
_apa()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$prev" in
        "apa")
            # auto comlete with hard coded options 
            COMPREPLY=( $(compgen -W "enable disable start stop site site- site+ conf seeconf logconf" -- "${cur}"  ) )
            return 0
            ;;
	    
        "site"|"enable"|"site+")
            # auto comlete with files present in /etc/apache2/sites-available
		    COMPREPLY=( $(compgen -W "$(\ls /etc/apache2/sites-available/)" -- "${cur}") )
 		    return 0
		    ;;

 	    "disable"|"site-")
            # auto comlete with files present in /etc/apache2/sites-enabled
            COMPREPLY=( $(compgen -W "$(\ls /etc/apache2/sites-enabled/)" -- "${cur}") )
            return 0
            ;;
    esac
}
complete -F _apa apa
