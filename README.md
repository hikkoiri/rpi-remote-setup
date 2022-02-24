# rpi-remote-setup

> Currently the script is broken. There were some issues when expanding compatability to Ubuntu. But now I am too lazu to fix it. The commands inside the script are still helpful when running manually.

## Purpose

I am sick of setting up Raspberry Pi's from scratch, because everytime it is the same procedure:
You google and find a setup guide. You use it. Then something does not work. You google the error and find a fix. Then you want to apply the fix and it does not work, because there are two new errors popping up. You know where I am going with that.

Administrating Pi's is time-consuming, not consistent, boring and mostly likely a pain in the a**.

So lets automate it!

## About

This project includes one bash script, which is the one and only holy solution for everyone.
This guide will lead you to the most essentials configurations and gives tips and advice on the fly.
So dont be afraid to try it out.

With that script you can (but dont need to):

- Change the Pi's hostname
- Disable Bluetooth
- Disable Wifi
- Configure Public Key Authentication
- Configure Firewall rules
- Install commonly used software, like docker, docker-compose and git
- Setup Prometheus Node Exporter service

## Installation guide

1) Flash [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) on a SD card running [Win Disk Imager](https://sourceforge.net/projects/win32diskimager/) as administrator. (It works also fine with RaspiOS)
2) Before plugging the SD card into the Pi, enable SSH:
  
```bash
#switch to boot partition
cd /e
#create ssh file
touch ssh
```

3) Insert the SD card into the Pi and start it.
4) Log on to Pi for the first time, download this awesome file & execute it.

```bash
ssh pi@raspberrypi
#enter default password raspberry

curl -fsSL https://raw.githubusercontent.com/hikkoiri/rpi-remote-setup/master/setup.sh -o pi-setup.sh
chmod +x pi-setup.sh
sudo ./pi-setup.sh

#when finished, you can delete the script
rm pi-setup.sh
```
