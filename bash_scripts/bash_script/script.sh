#!/bin/bash

function dirsolder {
        IFS=$'\n'
        read -p "Input dir's older than: " days
        date=$(date +"%b %d %H:%M" -d "$days day ago")
        for var in $(ls -ld ~/*/  | awk '{printf "%s %s %s %s\n", $6, $7, $8, $9}')
        do
                if [ "$date" \> "$var" ]
                then
                        dir_name=`echo $var | awk '{print $NF}' | grep -oP '(?<=\/home\/anton\/).+'`
                        dir_creation=`echo $var | awk '{print $1" "$2" "$3}'`
                        printf "$dir_name "
                        tput setaf 1 ; echo "$dir_creation" ; tput setaf 7
                fi
        done
}

function filesolder {
        IFS=$'\n'
        read -p "Input file's older than: " days
        date=$(date +"%b %d %H:%M" -d "$days day ago")
        for var in $(ls -l -p ~/ | egrep -v /$ | sed -n '1!p' | awk '{printf "%s %s %s %s\n", $6, $7, $8, $9}')
        do
                if [ "$date" \> "$var" ]
                then
                        file_name=`echo $var | awk '{print $NF}'`
                        file_creation=`echo $var | awk '{print $1" "$2" "$3}'`
                        printf "$file_name "
                        tput setaf 2 ; echo "$file_creation" ; tput setaf 7
                fi
        done
}

function pcmonitoring {
        total_pids=`top -bn1 | grep Tasks | awk '{printf $2}'`
        memory_usage=`free -m | awk 'NR==2{printf "%s/%s", $3,$2 }'`
        cpu_usage=`top -bn1 | grep load | awk '{printf "%.2f", $(NF-2)}'`
        disc_usage=`df -h | awk '$NF=="/"{printf "%d/%d (%s)\n", $3,$2,$5}'`

        tput setaf 1 ; echo "Total PIDS: $total_pids" ; tput setaf 7
        tput setaf 2 ; echo "Total MEMORY usage: $memory_usage MB" ; tput setaf 7
        tput setaf 3 ; echo "Total CPU usage: $cpu_usage %" ; tput setaf 7
        tput setaf 4 ; echo "Total DISC usage: $disc_usage GB" ; tput setaf 7
}

function addapptohosts {
        sudo grep -qxF '192.168.56.4 myapp.com' /etc/hosts || echo '192.168.56.4 myapp.com' >> /etc/hosts
}

function cvhangeappinhosts {
        read -p "Input app name: " app
        sudo sed -i -- "s/192.168.56.4 myapp.com/192.168.56.4 $app/g" /etc/hosts
}

function deletefile {
        while true; do
                if ls -l ~/ | grep 'DELETE_ME' > /dev/null
                then
                        `touch ~/temp`
                        `date > ~/temp`
                        `rm -rf ~/DELETE_ME`
                fi
                sleep 5
        done
}

deletefile