#!/bin/bash

function dirsolder {
        logger "dirs older"
        IFS=$'\n'
        read -p "Input dir's older than: " days
        date=$(date +"%b %d %H:%M" -d "$days day ago")
        for var in $(ls -ld ~/*/  | awk '{printf "%s %s %s %s\n", $6, $7, $8, $9}')
        do
                if [ "$date" \> "$var" ]
                then
                        dir_name=$(echo "$var" | awk '{print $NF}' | grep -oP '(?<=\/home\/anton\/).+')
                        dir_creation=$(echo "$var" | awk '{print $1" "$2" "$3}')
                        printf "$dir_name " ; tput setaf 1 ; echo "$dir_creation" ; tput setaf 7
                fi
        done
}

function filesolder {
        logger "files older"
        IFS=$'\n'
        read -p "Input file's older than: " days
        date=$(date +"%b %d %H:%M" -d "$days day ago")
        for var in $(ls -l -p ~/ | egrep -v /$ | sed -n '1!p' | awk '{printf "%s %s %s %s\n", $6, $7, $8, $9}')
        do
                if [ "$date" \> "$var" ]
                then
                        file_name=$(echo "$var" | awk '{print $NF}')
                        file_creation=$(echo "$var" | awk '{print $1" "$2" "$3}')
                        printf "$file_name " ; tput setaf 2 ; echo "$file_creation" ; tput setaf 7
                fi
        done
}

function pcmonitoring {
        logger "pc monitoring"
        tput setaf 1 ; echo "Total PIDS: `top -bn1 | grep Tasks | awk '{printf $2}'`" ; tput setaf 7
        tput setaf 2 ; echo "Total MEMORY usage: `free -m | awk 'NR==2{printf "%s/%s", $3,$2 }'` MB" ; tput setaf 7
        tput setaf 3 ; echo "Total CPU usage: `top -bn1 | grep load | awk '{printf "%.2f", $(NF-2)}'` %" ; tput setaf 7
        tput setaf 4 ; echo "Total DISC usage: `df -h | awk '$NF=="/"{printf "%d/%d (%s)\n", $3,$2,$5}'` GB" ; tput setaf 7
}

function addapptohosts {
        logger "add app tohosts"
        sudo grep -qxF '192.168.56.4 myapp.com' /etc/hosts || echo '192.168.56.4 myapp.com' >> /etc/hosts
}

function changeappinhosts {
        logger "change app in hosts"
        read -p "Input app name: " app
        sudo sed -i -- "s/192.168.56.4 myapp.com/192.168.56.4 $app/g" /etc/hosts
}

function deletefile {
        logger "deleting"
        while true; do
                if ls -l ~/ | grep 'DELETE_ME' > /dev/null
                then
                        logger "deleting" "find"
                        $(date > ~/temp) ; $(rm -rf ~/DELETE_ME)
                fi
                sleep 5
        done
}

function logger {
        if [ $# -eq 1 ]
        then
                user_pid=`ps aux | grep './script.sh' | awk 'NR==1{printf "User: %s, PID: %s", $1, $2}'`
                log="Date: `date`, Action: $1, $user_pid"
                echo $log >> ~/script.log
        else
                echo "Date: `date`, Find DELETE_ME in home folder, delete it" >> ~/script.log
        fi
}

while true; do
        echo "-------------------Menu--------------------"
        echo "| 1 - Dir's older tnan: n days            |"
        echo "| 2 - File's older tnan: n days           |"
        echo "| 3 - System monitoring                   |"
        echo "| 4 - Add myapp to /etc/hosts             |"
        echo "| 5 - Chanfe myapp in /etc/hosts          |"
        echo "| 6 - Delete DELETE_ME in ~/ (parallel)   |"
        echo "| 0 - Exit                                |"
        echo "-------------------------------------------"
        read -p "Select action: " action

        case "$action" in
                1   ) dirsolder ;;
                2   ) filesolder ;;
                3   ) pcmonitoring ;;
                4   ) addapptohosts ;;
                5   ) changeappinhosts ;;
                6   ) deletefile & ;;
                0   ) exit ;;
        esac
done