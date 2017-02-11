#!/bin/sh

# Update the system
apt-get update
apt-get upgrade

################################################################################
# This is a port of the JHipster Dockerfile,
# see https://github.com/jhipster/jhipster-docker/
################################################################################

export LANGUAGE='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
locale-gen en_US.UTF-8
dpkg-reconfigure locales

# Install utilities
apt-get -y install vim git zip bzip2 fontconfig curl language-pack-en

# @Trifon - Additional utilities (MidnightCommander, wget)
apt-get -y install mc wget

# @Trifon - Time zone(UTC+2)
ln -fs /usr/share/zoneinfo/Europe/Sofia /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

# Install Oracle Java 8
echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
echo 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886

apt-get update

echo oracle-java-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get install -y --force-yes oracle-java8-installer
update-java-alternatives -s java-8-oracle


################################################################################
# Install the graphical environment
################################################################################

# Force encoding
echo 'LANG=en_US.UTF-8' >> /etc/environment
echo 'LANGUAGE=en_US.UTF-8' >> /etc/environment
echo 'LC_ALL=en_US.UTF-8' >> /etc/environment
echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment

# Run GUI as non-privileged user
echo 'allowed_users=anybody' > /etc/X11/Xwrapper.config

# Install Ubuntu desktop and VirtualBox guest tools
apt-get install -y xubuntu-desktop virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# Remove light-locker (see https://github.com/jhipster/jhipster-devbox/issues/54)
apt-get remove -y light-locker --purge

################################################################################
# Install the development tools
################################################################################

# Install Ubuntu Make - see https://wiki.ubuntu.com/ubuntu-make
add-apt-repository -y ppa:ubuntu-desktop/ubuntu-make

apt-get update
apt-get upgrade

apt install -y ubuntu-make

# Install XDebug
# - http://purencool.com/installing-xdebug-on-ubuntu
apt-get install -y apache2 php php-xdebug
# Configure XDebug in Apache
read -d '' php_config <<- EOF
# Trifon
# Added for xdebug
zend_extension="/usr/lib/php/20151012/xdebug.so"
xdebug.remote_enable=1
xdebug.remote_handler=dbgp xdebug.remote_mode=req
xdebug.remote_host=127.0.0.1 xdebug.remote_port=9000
EOF 
echo "$php_config" >> /etc/php5/apache2/php.ini

service apache2 restart

# Install PHP Storm Edtor(It is PAID application)
# su -c 'umake ide phpstorm /home/vagrant/.local/share/umake/ide/phpstorm' vagrant

# Install Eclipse PHP
# - http://askubuntu.com/questions/603076/how-to-install-eclipse-php-in-ubuntu-14-04
curl -L http://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/neon/2/eclipse-php-neon-2-linux-gtk-x86_64.tar.gz > /tmp/eclipse-php-neon-2-linux-gtk-x86_64.tar.gz
mkdir /home/vagrant/.local/share/umake/ide/eclipse-php -p
tar -zxvf /tmp/eclipse-php*.tar.gz -C /home/vagrant/.local/share/umake/ide/eclipse-php --strip-components=1
rm /tmp/eclipse-php-neon-2-linux-gtk-x86_64.tar.gz
chown -R vagrant:vagrant /home/vagrant/.local/share/umake/ide/eclipse-php
su -c 'desktop-file-install /vagrant/eclipse_php.desktop' vagrant


# Install Chromium Browser
apt-get install -y chromium-browser

# Install MySQL Workbench
apt-get install -y mysql-workbench

# Install PgAdmin
apt-get install -y pgadmin3

# Increase Inotify limit (see https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit)
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system

# Install Docker
curl -sL https://get.docker.io/ | sh

# Install docker compose
curl -L https://github.com/docker/compose/releases/download/1.10.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Add user "vagrant" to Linux group "docker" (docker commands can be launched without sudo)
usermod -aG docker vagrant

# Clean the box
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove
dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1
rm -f /EMPTY
