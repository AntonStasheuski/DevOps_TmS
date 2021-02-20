# Task list

Create provisioning script for vagrant(Centos 8.3). Instance should have static IP for SSH connection.

1. Provision script(hw8_vagrant_provision.sh) should do following actions:
    * Create service user hw8. Home folder = /opt/hw8. Add ssh public key for           this user.
    * Add this user to sudoers group(sudo without password)
    * Update /etc/hosts file with record “127.0.0.1 myownapp.com”
    * Restrict ssh with access via password
    * Restrict ssh root access
    * Install mc, vim and git packages
    * Update DNS to 8.8.8.8 and 1.1.1.1
    * Check that address myownapp.com can be resolved. If not execute step 3
    * Print external(White) IP of you vagrant centos instance
    * Create dir /var/log/myownapp and set up hw8 user as owner of the dir
2. Learn rsync command
3. Refresh your knowledge regarding useful bash commands and 12 factors
4. How to put iftop command output to the file?

# Documentation

* https://www.vagrantup.com/docs/cli/provision
* https://www.vagrantup.com/docs/provisioning/shell