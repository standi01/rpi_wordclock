#!/bin/bash

USER_HOME=${HOME}

# Install latest updates of the os
echo -e "\e[34mInstalling latest updates of the current operating system:\e[0m"
sudo apt-get update && sudo apt-get upgrade -y
echo -e "\e[34mDone.\e[0m"

# Install 3rd party dependencies
echo -e "\e[34mInstalling 3rd party dependencies:\e[0m"
for pac in python-pip python-scipy scons git swig ttf-freefont
do
   echo -e "\e[34mInstalling dependency $pac...\e[0m"
   sudo apt-get install $pac -y
   echo -e "\e[34mDone.\e[0m"
done

# Install 3rd party python dependencies
echo -e "\e[34mInstalling 3rd party python dependencies:\e[0m"
for pac in pytz astral feedparser pillow svgwrite freetype-py netifaces
do
   echo -e "\e[34mInstalling python dependency $pac...\e[0m"
   sudo pip install $pac
   echo -e "\e[34mDone.\e[0m"
done

# Install jgarffs LED library
echo -e "\e[34mInstalling jgarffs LED library\e[0m"
cd ${USER_HOME}
git clone https://github.com/jgarff/rpi_ws281x.git
cd rpi_ws281x
sudo scons
cd ${USER_HOME}/rpi_ws281x/python
sudo python setup.py install

# Install fontdemo to render strings
echo -e "\e[34mInstalling fontdemo to render strings\e[0m"
cd ${USER_HOME}
git clone https://gist.github.com/5488053.git

# Install pywapi
echo -e "\e[34mInstalling pywapi\e[0m"
#Further details: https://code.google.com/p/python-weather-api/#Weather.com
cd ${USER_HOME}
wget https://launchpad.net/python-weather-api/trunk/0.3.8/+download/pywapi-0.3.8.tar.gz
tar -zxf pywapi-0.3.8.tar.gz
rm pywapi-0.3.8.tar.gz
cd pywapi-0.3.8
sudo python setup.py build
sudo python setup.py install

# Install the actual wordclock software
echo -e "\e[34mInstalling the actual wordclock software...\e[0m"
    cd ${USER_HOME}
    git clone https://github.com/bk1285/rpi_wordclock.git
    ln -s ${USER_HOME}/5488053/fontdemo.py ${USER_HOME}/rpi_wordclock/fontdemo.py

echo -e "\e[34mAdding the wordclock software to the startup scripts of the RPi...\e[0m"
    CRONTAB_FILE="/tmp/crontab.cache"
    sudo crontab -l > $CRONTAB_FILE
    echo "@reboot sudo python ${USER_HOME}/rpi_wordclock/wordclock.py" >> $CRONTAB_FILE
    sudo crontab $CRONTAB_FILE
    rm $CRONTAB_FILE

echo -e "\e[34mTo start the wordclock, system reboot required. Reboot now...?\e[0m"

echo -e "\e[34mOptional installation of the temperature sensor:\e[0m"
echo "- Install additional dependencies from http://www.airspayce.com/mikem/bcm2835/index.html"
echo "- Install am2302_rpi: sudo pip install am2302_rpi"
echo

# Check for correct locale
echo -e "\e[34mTodos\e[0m"
echo "Handle wifi-credentials, etc."
echo "Setup locales:"
echo "- Current locale is $LANG"
echo "- Should be utf-8. E.g. en_US.UTF-8"
echo "- If not, check this website, to adjust it: http://perlgeek.de/en/article/set-up-a-clean-utf8-environment"
