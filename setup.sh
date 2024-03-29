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
    echo -e "${RED}Configuration [1/9]${NC}"
    echo
    echo "The default hostname of the RPi is 'raspberrypi'."
    echo "Do you want to change it? [y/n]"
    read change_hostname_prompt_yn
    if  [ "$change_hostname_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        echo
        echo "Please type in your new hostname:"
        read change_hostname_prompt_new_hostname
        
        elif [ "$change_hostname_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        change_hostname_prompt
    fi
    clear
}

function disable_bluetooth_prompt(){
    echo -e "${RED}Configuration [2/9]${NC}"
    echo
    echo "Bluetooth is turned on per default."
    echo "Do you want to turn Bluetooth off? [y/n]"
    read disable_bluetooth_prompt_yn
    if  [ "$disable_bluetooth_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$disable_bluetooth_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        disable_bluetooth_prompt
    fi
    clear
}

function disable_wifi_prompt(){
    echo -e "${RED}Configuration [3/9]${NC}"
    echo
    echo "Wifi is turned on per default."
    echo "That may not be necessary, when the RPi is plugged in over a LAN cable."
    echo "Do you want to turn Wifi off? [y/n]"
    read disable_wifi_prompt_yn
    if  [ "$disable_wifi_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$disable_wifi_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        disable_wifi_prompt
    fi
    clear
}

function configure_pub_key_auth_prompt(){
    echo -e "${RED}Configuration [4/9]${NC}"
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
    echo -e "${RED}Configuration [5/9]${NC}"
    echo
    echo "Please enter a comma-separated list of ports, which should be opened up for inbound traffic."
    echo "To enable SSH, HTTP and HTTPS your input would look like this:"
    echo "22,80,443"
    echo
    echo "Please enter your input: (Empty list is possible but not suggested)"
    
    read configure_firewall_prompt_ports
    
    IFS=', ' read -r -a configure_firewall_prompt_port_array <<< "$configure_firewall_prompt_ports"
    
    for element in "${configure_firewall_prompt_port_array[@]}"
    do
        echo "Registered port $element"
    done
    clear
}

function install_docker_prompt(){
    echo -e "${RED}Configuration [6/9]${NC}"
    echo
    echo "Do you want to install Docker? [y/n]"
    read install_docker_prompt_yn
    if  [ "$install_docker_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$install_docker_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        install_docker_prompt
    fi
    clear
}

function install_docker_compose_prompt(){
    echo -e "${RED}Configuration [7/9]${NC}"
    echo
    echo "Do you want to install Docker Compose? [y/n]"
    read install_docker_compose_prompt_yn
    if  [ "$install_docker_compose_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$install_docker_compose_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        install_docker_compose_prompt
    fi
    clear
}

function install_git_prompt(){
    echo -e "${RED}Configuration [8/9]${NC}"
    echo
    echo "Do you want to install git? [y/n]"
    read install_git_prompt_yn
    if  [ "$install_git_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$install_git_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        install_git_prompt
    fi
    clear
}


function install_prometheus_node_exporter_prompt(){
    echo -e "${RED}Configuration [9/9]${NC}"
    echo
    echo "Do you want to install the Prometheus Node Exporter Service? [y/n] (That also opens up the Port 9100)"
    read install_prometheus_node_exporter_prompt_yn
    if  [ "$install_prometheus_node_exporter_prompt_yn" == "y" ]; then
        echo "Registered a Yes."
        elif [ "$install_prometheus_node_exporter_prompt_yn" == "n" ]; then
        echo "Registered a No."
    else
        clear
        echo "Invalid Input. Please choose between y or n"
        install_prometheus_node_exporter_prompt
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
    echo "Install Docker Compose? $install_docker_compose_prompt_yn"
    echo "Install git? $install_git_prompt_yn"
    echo "Install Prometheus Node Exporter Service? $install_prometheus_node_exporter_prompt_yn"
    echo
    echo -e "${RED}Do you want to start the installation?"
    echo -e "This is your last chance to stop and restart the setup script.${NC}"
    echo "Continue with installation? [y/n]"
    
    read start_installation_yn
    if  [ "$start_installation_yn" == "y" ]; then
        echo "Registered a Yes. Starting with the installation."
        start_installation
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
    

    echo -e "${RED}Step 1 - Changing Hostname${NC}"
    if  [ "$change_hostname_prompt_yn" == "y" ]; then
      current_hostname=$(cat /etc/hostname)
      sed -i "s/$current_hostname/$change_hostname_prompt_new_hostname/g" /etc/hostname
      sed -i "s/$current_hostname/$change_hostname_prompt_new_hostname/g" /etc/hosts
    else        
      echo "Skipped."
    fi


    echo -e "${RED}Step 2 - Disabling Bluetooth${NC}"
    if  [ "$disable_bluetooth_prompt_yn" == "y" ]; then
     echo "dtoverlay=pi3-disable-bt" | tee -a /boot/config.txt
    else        
      echo "Skipped."
    fi


    echo -e "${RED}Step 3 - Disabling Wifi${NC}"
    if  [ "$disable_wifi_prompt_yn" == "y" ]; then
        echo "dtoverlay=pi3-disable-wifi" | tee -a /boot/config.txt
    else        
        echo "Skipped."
    fi


    echo -e "${RED}Step 4 - Configure Pub Key Authentication${NC}"
    mkdir /home/$(whoami)/.ssh
    chmod 700 /home/$(whoami)/.ssh
    echo $configure_pub_key_auth_prompt_pub_key > /home/$(whoami)/.ssh/authorized_keys
    chmod 400 /home/$(whoami)/.ssh/authorized_keys
    chown $(whoami):$(whoami) /home/$(whoami) -R
    #lock down ssh
    sed -i "s/X11Forwarding yes/#X11Forwarding no/g" /etc/ssh/sshd_config
    sed -i "s/UsePAM yes/#UsePAM no/g" /etc/ssh/sshd_config
    sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin no/g" /etc/ssh/sshd_config
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config 
    service ssh restart


    echo -e "${RED}Step 5 - Update OS${NC}"
    apt-get update -y
    apt-get upgrade -y


    echo -e "${RED}Step 6 - Setup firewall${NC}"
    apt install ufw -y
    for element in "${configure_firewall_prompt_port_array[@]}"
    do
        echo ufw allow $element
        ufw allow $element
    done
    ufw --force enable


    echo -e "${RED}Step 7 - Install Docker${NC}"
    if  [ "$install_docker_prompt_yn" == "y" ]; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm -rf get-docker.sh
        usermod -aG docker $(whoami)
    else        
        echo "Skipped."
    fi


    echo -e "${RED}Step 8 - Install Docker Compose${NC}"
    if  [ "$install_docker_compose_prompt_yn" == "y" ]; then
        apt install -y python3-pip libffi-dev
        pip3 install docker-compose
    else        
        echo "Skipped."
    fi


    echo -e "${RED}Step 9 - Install git${NC}"
    if  [ "$install_git_prompt_yn" == "y" ]; then
        apt install git -y
    else        
        echo "Skipped."
    fi

    echo -e "${RED}Step 10 - Summoning SSH Key Pair${NC}"
    ssh-keygen -t rsa -b 4096  -P '' -f $HOME/.ssh/id_rsa

    echo -e "${RED}Step 11 - Install Prometheus Node Exporter Service${NC}"
    if  [ "$install_prometheus_node_exporter_prompt_yn" == "y" ]; then
        ufw allow 9100
        apt install prometheus-node-exporter -y
    else        
        echo "Skipped."
    fi


    echo 
    echo -e "${GREEN}INSTALLATION SUCCESSFUL!${NC}"
    echo "The Pi will restart in 30 seconds to apply the changes."
    echo
    echo "You can reconnect with the following command:" 
    if  [ "$change_hostname_prompt_yn" == "y" ]; then
        echo "ssh $(whoami)@$change_hostname_prompt_new_hostname"
    else        
        echo "ssh $(whoami)@raspberrypi"
    fi
    sleep 30
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
install_docker_compose_prompt
install_git_prompt
install_prometheus_node_exporter_prompt
summary


