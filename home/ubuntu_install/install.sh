#!/bin/bash
set -e

read -p "apt-get update & upgrade? [y/N]: " RESP; if [ "$RESP" == "y" ]; then 
    apt-get update && apt-get upgrade
fi

read -p "Install mscorefonts? [y/N]: " RESP;
if [ "$RESP" == "y" ]; then 
    # https://askubuntu.com/questions/16225/how-can-i-accept-the-microsoft-eula-agreement-for-ttf-mscorefonts-installer
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
    apt-get install ttf-mscorefonts-installer
fi


read -p "Install apt packages? [y/N]: " RESP; if [ "$RESP" == "y" ]; then 
    cat apt-packages.txt | grep -v "#" | tr '\n' ' ' | xargs apt-get install

    # [Replace nautilus with nemo]
    # http://www.webupd8.org/2013/10/install-nemo-with-unity-patches-and.html
    add-apt-repository ppa:webupd8team/nemo
    apt-get update
    apt-get install nemo nemo-fileroller
fi


read -p "Get tmux-cssh from dennishafemann's git repo? [y/N]: " RESP; if [ "$RESP" == "y" ]; then
    wget https://raw.githubusercontent.com/dennishafemann/tmux-cssh/master/tmux-cssh
    chmod +x tmux-cssh && mv tmux-cssh $HOME/
fi


read -p "Install pip packages? [y/N]: " RESP; if [ "$RESP" == "y" ]; then
    pip install -r pip-packages.txt
fi



# [chrome]
read -p "Install chrome from google? [y/N]: " RESP; if [ "$RESP" == "y" ]; then
    apt-get install libxss1 libappindicator1 libindicator7
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome*.deb
fi

# [dconf]
read -p "Load dconf keys? [y/N]: " RESP; if [ "$RESP" == "y" ]; then
    while read dkey dvalue; do
        echo "Writing $dkey: $dvalue";
        dconf write $dkey "$dvalue";
    done < dconf-keys.values

    for ddir in `ls dconf_dir_dump`; do
        echo "Loading $ddir"
        cat dconf_dir_dump/$ddir | dconf load $(printf $ddir | tr _ /)
    done
fi

# [spotify]
read -p "Install spotify? [y/N]: " RESP; if [ "$RESP" == "y" ]; then
    sh -c 'echo "deb http://repository.spotify.com stable non-free" \
                   >> /etc/apt/sources.list.d/spotify.list'
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59
    spotify_debfile="spotify-client-0.9.17_0.9.17.8.gd06432d.31-1_amd64.deb"
    spotify_filehash="0cec1535d1c656452c6358dc244e013c761c9a329b4536ce853b0a007ce73cc6"
#    wget http://repository-origin.spotify.com/pool/non-free/s/spotify/$spotify_debfile
    if [ `sha256sum $spotify_debfile | cut -f1 -d ' '` == "$spotify_filehash" ]; then
        dpkg -i $spotify_debfile
    else
        echo "Spotify binary checksum does not match expected"
        exit 1
    fi
fi
# Fix libgcrypt11 error by http://www.webupd8.org/2015/04/fix-missing-libgcrypt11-causing-spotify.html
# tl;dr: install from old distro, like e.g. https://launchpad.net/ubuntu/+archive/primary/+files/libgcrypt11_1.5.3-2ubuntu4.2_amd64.deb

# [copy ~/.config subdirs]
# (Should keep this at end of script, but perhaps before homeshick)
read -p "Restore ~/.config subdirs? [y/N]: " RESP; if [ "$RESP" == "y" ]; then
    mkdir -p config_subdirs
    while read config_dirname; do
        echo "Copying $config_dirname"
        cp -r config_subdirs/$config_dirname $HOME/.config/
    done < home_dotconfig_subdirs
fi

read -p "Clone and install homeshick? [y/N]: " RESP; if [ "$RESP" == "y" ]; then 
    if [ ! -d $HOME/.homesick ]; then
        git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick
        read -p "I will clone and add your dotfiles repo. Specify it on the form username/reponame: " URLPART
        $HOME/.homesick/repos/homeshick/bin/homeshick clone https://github.com/$URLPART.git
    fi
fi

read -p "Install truecrypt? [y/N]: " RESP; if [ "$RESP" == "y" ]; then 
    add-apt-repository ppa:stefansundin/truecrypt
    apt-get update
    apt-get install truecrypt
fi

# TODO: fzf install
# TODO: docker:
#    apt-get install docker.io
#    sudo usermod -aG docker $USER
    # logout-login
#    docker login -u lenolib
