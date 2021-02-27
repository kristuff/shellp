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
#  DESCRIPTION   : logs reader functions
#  AUTHOR        : kristuff (https://github.com/kristuff)
#  CREATED       : 2016-10-15
#  REVISION      : 2020-04-25
#  DEVNOTES      : interactive mode only, requires ccze 

# ----------------------------------
# do nothing in non interactive mode
# ----------------------------------
[ -z "$PS1" ] && return


zlogshow(){
    if [ -z "$1" ]; then
        echo "zlogshow() invalid argument"
    else
        # todo lengh
        cat "$1" | ccze -A
    fi
}

zlogfollow(){
     if [ -z "$1" ]; then
        echo "zlogshow() invalid argument"
    else
        # todo lengh
        tail -500f "$1" | ccze -A
    fi
}

zlog() {
    local usage
	usage="usage: zlog {varlog|sys|sys1|aut|aut1|apa|apa1|ape|ape1|apvh|apvh1|ftb|ftb1|mail|mail1|mailw|mailw1|find|zfind}"

    if [ -z "$1" ]; then
        echo  "$usage"
    else
        case "$1" in

            "varlog")
                # edit (with nano) apache config file
 				if [ -z "$2" ]; then
                    echo "usage: zapa varlog FILE."
					echo "File is the name of the file in [/var/log/]. Press Tab Tab to see available files."
                else
                    zlogfollow /var/log/"$2" 
                fi
                ;;

            "sys")
				zlogfollow /var/log/syslog 
                ;;
            "sys1")
				zlogfollow /var/log/syslog.1 
                ;;
            "aut")
                zlogfollow /var/log/auth.log 
                ;;           
            "aut1")
                zlogfollow /var/log/auth.log.1 
                ;;           
			"apa")
                zlogfollow /var/log/apache2/access.log 
                ;;
 			"apa1")
                zlogfollow /var/log/apache2/access.log.1 
                ;;
         	"ape")
                zlogfollow /var/log/apache2/error.log 
                ;;
         	"ape1")
                zlogfollow /var/log/apache2/error.log.1 
                ;;
            "apvh")
                zlogfollow /var/log/apache2/other_vhosts_access.log 
                ;;
		    "apvh1")
                zlogfollow /var/log/apache2/other_vhosts_access.log.1 
                ;;
		    "ftb")
 				zlogfollow /var/log/fail2ban.log 
                 ;;
		    "ftb1")
 				zlogfollow /var/log/fail2ban.log.1 
                 ;;
            "mail")
 				zlogfollow /var/log/mail.log 
                 ;;
            "mail1")
 				zlogfollow /var/log/mail.log.1 
                 ;;
            "mailw")
 				zlogfollow /var/log/mail.warn 
                 ;;
            "mailw1")
 				zlogfollow /var/log/mail.warn.1 
                 ;;
            "user")
 				zlogfollow /var/log/user.log 
                 ;;
            "user1")
 				zlogfollow /var/log/user.log.1 
                 ;;
            "zfind")
                # find something in logs
 				if [ -z "$2" ]; then
                    echo "usage: zlog zfind X.X.X.X"
                else
                    find /var/log -name '*.gz' -exec zgrep -- "$2" {} + | ccze -A
                    #find . -name /var/log/\*.gz -print0 | xargs -0 zgrep "$2" | ccze -A
				fi
				;;
			"find")
                # find something in logs
 				if [ -z "$2" ]; then
                    echo "usage: zlog find X.X.X.X"
                else
			        find  /var/log/  -type f | xargs grep "$2" | ccze -A
				fi
				;;
            * )
                echo "invalid parameters" ;;
        esac
    fi
}

# *********************
# autocomplete function
# *********************
_zlog()
{
    local cur prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    case "$prev" in
        "zlog")
            COMPREPLY=( $(compgen -W "varlog sys sys1 aut aut1 apa apa1 ape ape1 apvh apvh1 ftb ftb1 mail mail1 mailw mailw1 user user1 zfind find" -- "${cur}"  ) )
            return 0
            ;;
        "varlog")
            # auto comlete with files present in /var/log 
		    COMPREPLY=( $(compgen -W '$(\ls /var/log/ -I "*.gz")' -- "${cur}") )
 		    return 0
		    ;;
    esac
}
complete -F _zlog zlog
