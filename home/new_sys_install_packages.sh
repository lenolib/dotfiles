#!/bin/sh
sudo apt-get install \
graphviz \
mosh \
htop \
vim \
unity-tweak-tool \
vlc \
ranger \
nemo \
keepassx \
gnome-control-center \
git \
eclipse \
tmux \
kcachegrind \
docx2txt \
wine \
p7zip-full \
sysinfo \
software-properties-common \
sshfs \
compizconfig-settings-manager \
ipython \
curl \
gcp \
nmon \
runsnakerun \
nautilus-dropbox \
gitg \
indicator-multiload \
indicator-cpufreq \

# [Python stuff]
sudo apt-get install \
ipython \
python-pip \
python-dev \
gfortran
libpng12-dev \
libfreetype6-dev \
libatlas-base-dev \
python-mysqldb \
restview \

sudo pip install \
numpy \
scipy \
matplotlib \
scikit-learn \
pandas \
spyder \

# [MS fonts]
sudo apt-get install ttf-mscorefonts-installer

# [Replace nautilus with nemo]
# http://www.webupd8.org/2013/10/install-nemo-with-unity-patches-and.html

# cv for checking progress of basic unix commands
# https://github.com/Xfennec/cv.git

# [spotify]
sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
sudo apt-get update
sudo apt-get install spotify-client




sudo apt-get install compiz-plugins
