#!/bin/bash

ETC_HOSTS=/etc/hosts
IFS=$'\n'

function dirs_older {
        PATH_TO_SEARCH=$1
        FILES_AGE=$2
        logger "dirs older"
        date=$(date +"%b %d %H:%M" -d "$FILES_AGE day ago")
        for var in $(ls -ld $PATH_TO_SEARCH*/  | awk '{printf "%s %s %s %s\n", $6, $7, $8, $9}')
        do
                if [ "$date" \> "$var" ]
                then
                        dir_name=$(echo "$var" | awk '{print $NF}' | grep -oP '(?<=\/home\/anton\/).+')
                        dir_creation=$(echo "$var" | awk '{print $1" "$2" "$3}')
                        printf "$dir_name " ; tput setaf 1 ; echo "$dir_creation" ; tput setaf 7
                fi
        done
}

function files_older {
        PATH_TO_SEARCH=$1
        FILES_AGE=$2
        logger "files older"
        date=$(date +"%b %d %H:%M" -d "$FILES_AGE day ago")
        for var in $(ls -l -p $PATH_TO_SEARCH | egrep -v /$ | sed -n '1!p' | awk '{printf "%s %s %s %s\n", $6, $7, $8, $9}')
        do
                if [ "$date" \> "$var" ]
                then
                        file_name=$(echo "$var" | awk '{print $NF}')
                        file_creation=$(echo "$var" | awk '{print $1" "$2" "$3}')
                        printf "$file_name " ; tput setaf 2 ; echo "$file_creation" ; tput setaf 7
                fi
        done
}

function pc_monitoring {
        logger "pc monitoring"
        tput setaf 1 ; echo "Total PIDS: `top -bn1 | grep Tasks | awk '{printf $2}'`" ; tput setaf 7
        tput setaf 2 ; echo "Total MEMORY usage: `free -m | awk 'NR==2{printf "%s/%s", $3,$2 }'` MB" ; tput setaf 7
        tput setaf 3 ; echo "Total CPU usage: `top -bn1 | grep load | awk '{printf "%.2f", $(NF-2)}'` %" ; tput setaf 7
        tput setaf 4 ; echo "Total DISC usage: `df -h | awk '$NF=="/"{printf "%d/%d (%s)\n", $3,$2,$5}'` GB" ; tput setaf 7
}

function add_app_to_hosts {
        logger "add app to hosts"
        sudo grep -qxF '192.168.56.4 myapp.com' $ETC_HOSTS || echo '192.168.56.4 myapp.com' >> $ETC_HOSTS
}

function change_app_in_hosts {
        logger "change app in hosts"
        read -p "Input app name: " app
        sudo sed -i -- "s/.*myapp\.com/$app/g" $ETC_HOSTS
}

function delete_file {
        logger "deleting"
        DELETE_FILE_PATH=$1DELETE_ME
        while [ ! -d  $DELETE_FILE_PATH ] && [ ! -f  $DELETE_FILE_PATH ]
        do
                sleep 2
        done
        logger "deleting" "find"
        $(date > ~/temp) ; $(rm -rf $DELETE_FILE_PATH)
}

function logger {
        action=$1
        if [ $# -eq 1 ]
        then
                user_pid=`ps aux | grep './script.sh' | awk 'NR==1{printf "User: %s, PID: %s", $1, $2}'`
                log="Date: `date`, Action: $action, $user_pid"
                echo $log >> ~/script.log
        else
                echo "Date: `date`, Find DELETE_ME in home folder, delete it" >> ~/script.log
        fi
}

case $1 in
    dirs_older) "$@"; exit;;
    files_older) "$@"; exit;;
    pc_monitoring) "$@"; exit;;
    add_app_to_hosts) "$@"; exit;;
    change_app_in_hosts) "$@"; exit;;
    delete_file) "$@"; exit;;
esac

