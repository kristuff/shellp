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
#  FILE          : ftb.sh
#  DESCRIPTION   : fail2ban helper functions
#  AUTHOR        : kristuff (https://github.com/kristuff)
#  CREATED       : ?
#  REVISION      : 2021-02-21
#  DEVNOTES      : interactive mode only, requires echolor 

ftb() {
    local JAILS JAIL JAIL_CONF CURRENT_IGNOREIP NEW_IGNOREIP EDITOR result

    # my param
    EDITOR=nano
    JAIL_CONF=/etc/fail2ban/jail.local

    if [ -z "$1" ]; then
        # TODO help
        echo "usage: ftb {stop|reload|restart|start|logs|status [<JAIL>]|unban <IP>|conf|version}"
    else
        case "$1" in

            "reload")
                if [ -z "$2" ]; then
                    echolor " Loading fail2ban" -c white
                    fail2ban-client reload > /dev/null 2>/dev/null

                    if [ $? -eq 0 ]; then
                        echolor " ✓" -c green -n
                        echolor " fail2ban successfully reloaded" -c white
                    else
                        echolor " ✗" -c red -n
                        echolor " fail2ban failed to reload" -c white 
                        return 1 
                    fi

                else
                    echolor " Loading fail2ban jail: [" -c white -n
                    echolor "$2" -c cyan -n
                    echolor "]" -c white

                    result=`fail2ban-client reload "$2"`
                    if [ "$result" = "OK" ]; then
                        echolor " ✓ $result" -c green
                    else
                        echolor " ✗ $result" -c red
                        return 1 

                    fi
                fi
                ;;

            "start")
                echolor " Starting fail2ban" -c white
                fail2ban-client start > /dev/null 2>/dev/null
                if [ $? -eq 0 ]; then
                    echolor " ✓" -c green -n
                    echolor " fail2ban successfully started" -c white
                else
                    echolor " ✗" -c red -n
                    echolor " fail2ban failed to start" -c white
                    return 1 
                fi;
       			;;

            "stop")
                echolor " Stopping fail2ban" -c white
                fail2ban-client stop > /dev/null 2>/dev/null
                if [ $? -eq 0 ]; then
                    echolor " ✓" -c green -n
                    echolor " fail2ban successfully stopped" -c white
                else
                    echolor " ✗" -c red -n
                    echolor " fail2ban failed to stop" -c white 
                    return 1 
                fi;
       			;;

            "restart")
                echolor " Restarting fail2ban" -c white
                fail2ban-client restart > /dev/null 2>/dev/null
                if [ $? -eq 0 ]; then
                    echolor " ✓" -c green -n
                    echolor " fail2ban successfully restarted" -c white
                else
                    echolor " ✗" -c red -n
                    echolor " fail2ban failed to restart" -c white 
                    return 1 
                fi;
       			;;

  			"status")
                # Prints jail(s) statut
 				if [ -z "$2" ]; then
                    # Prints all jails status
                    # Display fail2ban status using 'fail2ban-client status'
                    # Status
                    # |- Number of jail:      4
                    # `- Jail list:           apache, apache-overflows, apache-noscript, ssh
                    JAILS=$(fail2ban-client status | grep "Jail list" | sed -E 's/^[^:]+:[ \t]+//' | sed 's/,//g')
                    for JAIL in $JAILS
                    do
                        fail2ban-client status $JAIL
                    done
                else
                    # Prints given jail status
                    fail2ban-client status "$2"
                fi
                ;;

		    "unban")
 				if [ -z "$2" ]; then
                    echo "  [error] ftb unban usage: # ftb unban <ip>"
                else
                    JAILS=$(fail2ban-client status | grep "Jail list" | sed -E 's/^[^:]+:[ \t]+//' | sed 's/,//g')
                    for JAIL in $JAILS
                    do
                        if [ `fail2ban-client status "$JAIL" |grep -q "$2"` ]; then
                  
                            fail2ban-client set $JAIL unbanip "$2" > /dev/null 2>/dev/null
                            if [ $? -eq 0 ]; then
                                echolor " ✓" -c green -n
                                echolor " IP [" -c white -n
                                echolor "$2" -c yellow -n
                                echolor "] unbanned on jail $JAIL" -c white
                            else
                                echolor " ✗" -c red -n
                                echolor " Error when unban IP [" -c white -n
                                echolor "$2" -c yellow -n
                                echolor "] on jail $JAIL" -c white
                            fi;
                        else
                            echolor " ✓" -c green -n
                            echolor " IP [" -c white -n
                            echolor "$2" -c yellow -n
                            echolor "] was not banned on jail $JAIL" -c white
                        fi
                    done
                fi
                ;;

            "ignoreip-remove")
                if [ -z "$2" ]; then
                    echo "  [error] ftb ignoreip-add usage: $ ftb ignoreip-remove <ip>"
                else
                    CURRENT_IGNOREIP=$(grep ignoreip $JAIL_CONF |sed '/^#/d' |cut -d "=" -f2 |xargs)
                    if echo "$CURRENT_IGNOREIP" | grep "$2" > /dev/null
                    then
                        NEW_IGNOREIP=${CURRENT_IGNOREIP//$2/}
                        sed -i "/ignoreip /c\ignoreip = $NEW_IGNOREIP" "$JAIL_CONF"
                        echolor " ✓ " -c green -n
                        echolor "IP [" -c white -n
                        echolor "$2" -c yellow -n
                        echolor "] successfully removed from ignoreip list." -c white
                        echolor " Make sure to reload fail2ban to apply changes." -c white
                    else
                        echolor " ✗" -c gray -n
                        echolor " IP [" -c white -n
                        echolor "$2" -c yellow -n
                        echolor "] was not found in ignoreip"
                    fi
                fi
                ;;
           
            "ignoreip-add")
                if [ -z "$2" ]; then
                    echo "  [error] ftb ignoreip-add usage: $ ftb ignoreip-add <ip>"
                else
                    CURRENT_IGNOREIP=$(grep ignoreip $JAIL_CONF |sed '/^#/d' |cut -d "=" -f2 |xargs) 
                    sed -i "/ignoreip /c\ignoreip = $CURRENT_IGNOREIP $2" $JAIL_CONF
                    echolor " ✓ " -c green -n
                    echolor "IP [" -c white -n
                    echolor "$2" -c yellow -n
                    echolor "] successfully added to ignoreip list. " -c white
                    echolor " Make sure to reload fail2ban to apply changes." -c white
                fi
                ;;

            "ignoreip-list")
                CURRENT_IGNOREIP=$(grep ignoreip $JAIL_CONF |sed '/^#/d' |cut -d "=" -f2 |xargs)
                for IP in $CURRENT_IGNOREIP
                do
                    echolor " IP [" -c white -n
                    echolor "$IP" -c yellow -n
                    echolor "] is ignored " -c white
                done
                ;;

            "seeconf")
                sed '{/^$/d;/^#/d}' "$JAIL_CONF"
                ;;

            "conf")
                nano "$JAIL_CONF"
                ;;

            "version")
                fail2ban-client version
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
_ftb()
{
    local cur prev JAILS CURRENT_IGNOREIP
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$prev" in

        "ftb")
            COMPREPLY=( $(compgen -W "start restart stop reload logs status unban seeconf conf ignoreip-list ignoreip-remove ignoreip-add version" -- "${cur}"  ) )
            return 0
            ;;

        "status"|"reload")
            # auto comlete with jail list
            JAILS=$(fail2ban-client status | grep "Jail list" | sed -E 's/^[^:]+:[ \t]+//' | sed 's/,//g')
            COMPREPLY=( $(compgen -W "$JAILS" -- "${cur}") )
            return 0
            ;;

        "ignoreip-remove")
            # auto comlete with current ignoreip list
            CURRENT_IGNOREIP=$(grep ignoreip /etc/fail2ban/jail.local |sed '/^#/d' |cut -d "=" -f2 |sed 's/ /\n/g')
            COMPREPLY=( $(compgen -W "$CURRENT_IGNOREIP" -- "${cur}") )
            return 0
            ;;            

    esac
}

complete -F _ftb ftb
