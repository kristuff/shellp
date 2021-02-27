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
#  FILE          : zban.sh
#  DESCRIPTION   : iptables/ip6tables helper functions
#  AUTHOR        : kristuff (https://github.com/kristuff)
#  CREATED       : 2021-02-20
#  REVISION      : 2021-02-21
#  DEVNOTES      : interactive mode only, use DROP rules (may use REJECT)

# ----------------------------------
# do nothing in non interactive mode
# ----------------------------------
[ -z "$PS1" ] && return

zban() {
    local JAILS JAIL JAIL_CONF CURRENT_IGNOREIP NEW_IGNOREIP EDITOR result


    if [ -z "$1" ]; then
        echo "usage: zban {list|list6|bani <IP>|bani6 <IP>|bana <IP>|bana6 <IP>}"
    else
        case "$1" in

			"list")
				# current ban list 
                iptables -L -n --line-numbers 
                ;;

			"list6")
				# current ban list (ip6tables)
                ip6tables -L -n --line-numbers 
                ;;

	        "bani")
				# Ban insert: insert IP to iptables
 				if [ -z "$2" ]; then
                    echo "	[error] zban bani usage: $ zban bani <ip>"
                else
					iptables -I INPUT -s "$2" -j DROP
 					echo "	[ok] $2 inserted in iptables"
	            fi
				;;

            "bani6")
                if [ -z "$2" ]; then
				 # Ban insert6: insert IP to ip6tables
                    echo "  [error] zban bani6 usage: $ zban bani6 <ipv6>"
                else
                    ip6tables -I INPUT -s "$2" -j DROP &&  echo "  [ok] $2 inserted in ip6tables"
                fi
                ;;

 			"bana")
				# Ban add: add IP to iptables
                if [ -z "$2" ]; then
					echo "  [error] zban bana usage: $ zban bana <ip>"
                else
                    iptables -A INPUT -s "$2" -j DROP && echo "	[ok] $2 added to iptables"
                fi
                ;;

            "bana6")
				# Ban add6: add IP to ip6tables
                if [ -z "$2" ]; then
                    echo "  [error] zban bana6 usage: # zban bana6 <ipv6>"
                else
                    ip6tables -A INPUT -s "$2" -j DROP && echo "  [ok] $2 added to ip6tables"
                fi
                ;;

            * )
                # other inputs
                echo "invalid parameters"
                ;;
        esac


    fi
}

# *********************
# autocomplete function
# *********************
_zban()
{
    local cur prev JAILS CURRENT_IGNOREIP
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$prev" in
        "zban")
            COMPREPLY=( $(compgen -W "list list6 bana bana6 bani bani6" -- "${cur}"  ) )
            return 0
            ;;

    esac
}
complete -F _zban zban
