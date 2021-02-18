################################################################################
# Help                                                                         #
################################################################################
help()
{
   echo "------------------------------------------------------------------------------------------------------------------------------------------------"
   echo "| options:                                                                                                                                     |"
   echo "| servers_list_adrs          Print info from server_list in (Server 1 is: IP, Server 2 is: IP...) format.                                      |"
   echo "| ssh_command                Run ssh commands on servers, conditions (server in servers_list, command should be in variables_file).            |"
   echo "| uppercase                  All string in uppercase.                                                                                          |"
   echo "| lowercase                  All string in lowercase.                                                                                          |"
   echo "| first_last_elements        Variable in variables_file exmpl: SENT=”First Second Tree Goal Last”.                                             |"
   echo "------------------------------------------------------------------------------------------------------------------------------------------------"
   echo
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

SERVER_LIST_PATH="/etc/server_list"
SSH_COMMANDS_PATH="/etc/ssh_commands"
SENT_DEFAULT_VALUE="SENT=”First Second Tree Goal Last”"
IFS=$'\n'

function servers_list_adrs {
    local server_number=0
    for server_name in `cat $SERVER_LIST_PATH`; do
        echo "Server $server_number is: $server_name"; ((server_number++))
    done
}

function uppercase {
    local string=$1
    echo ${string^^}
}

function lowercase {
    local string=$1
    echo "${string,,}"
}

function first_last_elements {
    if [ $# -eq 0 ]; then
        local SENT=$SENT_DEFAULT_VALUE
    else
        local SENT=$1
    fi
    string_to_array $SENT
}

function ssh_command {
    local user=$1
    local ip_adr=$2
    local command=$3
    if grep "^${ip_adr}$" "$SERVER_LIST_PATH"; then
        if grep "^${command}$" "$SSH_COMMANDS_PATH"; then
            ssh  "$user"@"$ip_adr" -f "$command"
        else
            echo "Can't find command in $SSH_COMMANDS_PATH"
        fi
    else
        echo "Can't find server in $SERVER_LIST_PATH"
    fi
}

function string_to_array {
    local string=`echo "$1" | grep -oP '(?<=SENT=”).+(?=”)'`
    IFS=" " read -a array <<< $string
    echo "First array element: ${array[0]}"
    echo "Last array element: ${array[-1]}"
}

case $1 in
    help) "$@"; exit;;
    servers_list_adrs) "$@"; exit;;
    uppercase) "$@"; exit;;
    ssh_command) "$@"; exit;;
    lowercase) "$@"; exit;;
    first_last_elements) "$@"; exit;;
esac
