#!/bin/bash
#Source: https://forums.kleientertainment.com/topic/64441-dedicated-server-quick-setup-guide-linux/

### VARIABLES ###
username="\"YOUR_STEAM_USER\""
password="\"YOUR_STEAM_PASS\""
filename="YOUR_PACKAGED_BS_FILE_NAME"
url="URL_TO_YOUR_PACKAGED_BS_FILES"

sudo dpkg --add-architecture i386
apt-get update
apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386

useradd -m steam
cd /home/steam

#This step requires an archive built with its rwx file permissions preserved. Only ownership should need to be fixed.
wget $url
tar -xzpvf /home/steam/$filename.tar.gz -C / 
chown -R steam:steam /home/steam/$filename

cd /home/steam
sudo -u steam mkdir /home/steam/steamcmd
cd /home/steam/steamcmd
sudo -u steam wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
sudo -u steam tar -xvzf steamcmd_linux.tar.gz
sudo -u steam ./steamcmd.sh +login $username $password +force_install_dir /home/steam/$filename +app_update 228780 validate +quit
cd /home/steam/$filename
sudo -u steam sh /home/steam/$filename/srcds_run.sh +maxplayers 16 +map duel_box

rm /home/steam/$filename.tar.gz

sudo -u steam /home/steam/$filename/srcds_run.sh +maxplayers 16 +map duel_box
sudo -u steam pwd