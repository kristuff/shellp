# shellp

*sysadmin/webmaster bash scripts* 

> This project was primarily designed to group all my *alias* and usual tasks in structured functions with auto-completion, when working on my *Debian* server. Most scripts are intented to be used in interactive mode, may contain hard coded paths and use external libs. 

## Included

-  **ftb.sh** function `ftb` to help working with *fail2ban*
-  **apa.sh** function `apa` to help working with *apache2*
-  **zban.sh** function `zban` to help working with *iptables/ip6tables*
-  **zapt.sh** function `zapt` to help working with *apt/apt-get*
-  **zlog.sh** function `zlog` to help display logs 

## Usage

Source the file `loader.sh` in your .bashrc:

```bash
. /YOUR_PATH/bin/loader.sh
```
