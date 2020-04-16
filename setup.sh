#!/bin/bash

function pause(){
    read -p "$*"
}

function welcome(){
    clear
    echo -e "${RED}Hello and welcome to the automated Raspberry Pi Setup${NC}"
    echo "This setup is divided in 2 phases:"
    echo
    echo "  - During the configuration phase, you can enter your own preferences."
    echo "    The program will guide you through some questions."
    echo "    You can stop and restart the configuration at any point in time."
    echo "    At the end of the configuration phase you will see a brief summary of your inputs."™
    echo "  - The installation phase will begin, when you confirm your inputs."
    echo "    PLEASE DO NOT STOP THE PROGRAM DURING THE INSTALLATION PHASE."
    echo "    At the end of the installation, the RPi will reboot."
    echo
    pause 'Press [Enter] key to continue...'
    clear
    
}

function check_root(){
  if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit 1
  fi
}

function change_hostname_prompt(){
    echo -e "${RED}Configuration [1/6]${NC}"
    echo
    echo "The default hostname of the RPi is 'raspberry'."
    echo "Do you want to change it? [y/n]"
    read change_hostname_prompt_yn
    if  [ "$change_hostname_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        echo
        echo "Please type in your new hostname:"
        read change_hostname_prompt_new_hostname
        
        elif [ "$change_hostname_prompt_yn" == "n" ]; then
        echo "Registered a No"
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        change_hostname_prompt
    fi
    clear
}

function disable_bluetooth_prompt(){
    echo -e "${RED}Configuration [2/6]${NC}"
    echo
    echo "Bluetooth is turned on per default."
    echo "Do you want to turn Bluetooth off? [y/n]"
    read disable_bluetooth_prompt_yn
    if  [ "$disable_bluetooth_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$disable_bluetooth_prompt_yn" == "n" ]; then
        echo "Registered a No"
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        disable_bluetooth_prompt
    fi
    clear
}

function disable_wifi_prompt(){
    echo -e "${RED}Configuration [3/6]${NC}"
    echo
    echo "Wifi is turned on per default."
    echo "That may not be necessary, when the RPi is plugged in over a LAN cable."
    echo "Do you want to turn Wifi off? [y/n]"
    read disable_wifi_prompt_yn
    if  [ "$disable_wifi_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$disable_wifi_prompt_yn" == "n" ]; then
        echo "Registered a No"
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        disable_wifi_prompt
    fi
    clear
}

function configure_pub_key_auth_prompt(){
    echo -e "${RED}Configuration [4/6]${NC}"
    echo
    echo "The time to use username and password to log onto a system is over."
    echo "Nowadays you use Public Key Authentication."
    echo
    echo "To find out your public key, open a new terminal on your development machine and execute:"
    echo "cat ~/.ssh/id_rsa.pub"
    echo
    echo "If you dont have a SSH keys yet, try the following command to create some:"
    echo "ssh-keygen -t rsa -b 4096"
    echo
    echo "Please paste your own public key in here:"
    
    read configure_pub_key_auth_prompt_pub_key
    if  [ "$configure_pub_key_auth_prompt_pub_key" != "" ]; then
        echo "Registered new public SSH key."
    else
        clear
        echo "Invalid Input. This field can not be empty."
        configure_pub_key_auth_prompt
    fi
    clear
}


function configure_firewall_prompt(){
    echo -e "${RED}Configuration [5/6]${NC}"
    echo
    echo "Please enter a comma-separated list of ports, which should be opened up for inbound traffic."
    echo "To enable SSH, HTTP and HTTPS your input would look like this:"
    echo "22,80,443"
    echo
    echo "Please enter your input: (Empty list is possible)"
    
    
    read configure_firewall_prompt_ports
    
    IFS=', ' read -r -a configure_firewall_prompt_port_array <<< "$configure_firewall_prompt_ports"
    
    for element in "${configure_firewall_prompt_port_array[@]}"
    do
        echo "Registered port $element"
    done
    clear
}

function install_docker_prompt(){
    echo -e "${RED}Configuration [6/6]${NC}"
    echo
    echo "Do you want to install Docker? [y/n]"
    read install_docker_prompt_yn
    if  [ "$install_docker_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$install_docker_prompt_yn" == "n" ]; then
        echo "Registered a No"
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        install_docker_prompt
    fi
    clear
}



function summary(){
    echo -e "${RED}Configuration summary${NC}"
    echo
    echo "Change Hostname? $change_hostname_prompt_yn"
    if  [ "$change_hostname_prompt_new_hostname" != "" ]; then
        echo "New Hostname: $change_hostname_prompt_new_hostname"
    fi
    echo "Disable Bluetooth? $disable_bluetooth_prompt_yn"
    echo "Disable Wifi? $disable_wifi_prompt_yn"
    echo "Public SSH key: $configure_pub_key_auth_prompt_pub_key"
    echo "Firewall open inbound ports: $configure_firewall_prompt_ports"
    echo "Install Docker? $install_docker_prompt_yn"
    echo
    echo -e "${RED}Do you want to start the installation?"
    echo -e "This is your last chance to stop and restart the setup script.${NC}"
    echo "Continue with installation? [y/n]"
    
    read start_installation_yn
    if  [ "$start_installation_yn" == "y" ]; then
        echo "Registered a Yes. Starting with the installation."
        #start_installation
        elif [ "$start_installation_yn" == "n" ]; then
        echo "Registered a No. Exiting."
        exit 1;
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        summary
    fi
}

function start_installation(){
    clear
    # step 1 - hostname
     if  [ "$change_hostname_prompt_yn" == "y" ]; then
      current_hostname=$(cat /etc/hostname)
      sudo sed -i "s/$current_hostname/$change_hostname_prompt_new_hostname/g" /etc/hostname
      sudo sed -i "s/$current_hostname/$change_hostname_prompt_new_hostname/g" /etc/hosts
    else        
      echo "Skipped."
    fi
    

    # step 2 - bluetooth
    if  [ "$disable_bluetooth_prompt_yn" == "y" ]; then
     echo "dtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
    else        
      echo "Skipped."
    fi


    # step 3 - wifi    
    if  [ "$disable_wifi_prompt_yn" == "y" ]; then
     echo "dtoverlay=pi3-disable-wifi" | sudo tee -a /boot/config.txt
    else        
      echo "Skipped."
    fi

    # step 4 - pub key
    configure_pub_key_auth_prompt_pub_key
    mkdir /home/pi/.ssh
    chmod 700 /home/pi/.ssh
    echo $configure_pub_key_auth_prompt_pub_key > /home/pi/.ssh/authorized_keys
    chmod 400 /home/pi/.ssh/authorized_keys
    chown pi:pi /home/pi -R

    #lock down ssh
    sed -i "s/X11Forwarding yes/#X11Forwarding no/g" /etc/ssh/sshd_config
    sed -i "s/UsePAM yes/#UsePAM no/g" /etc/ssh/sshd_config
    sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config 
    service ssh restart

    # step 5 - update os
    apt-get update
    apt-get upgrade
    
    # step 6 - configure firewall
    apt install ufw
    for element in "${configure_firewall_prompt_port_array[@]}"
    do
        ufw allow $element
    done
    ufw enable
    
    #step 7 - install_docker
    #TODO implement

    #step 8 - restart
    # installation succesful
    echo -e "${GREEN}INSTALLATION SUCCESSFUL!${NC}"
    echo "The Pi will restart in 60 seconds."
    sleep 60
    reboot
}


#color config
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# collect information
check_root
welcome
change_hostname_prompt
disable_bluetooth_prompt
disable_wifi_prompt
configure_pub_key_auth_prompt
configure_firewall_prompt
install_docker_prompt
summary

