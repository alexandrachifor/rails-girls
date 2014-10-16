#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

locale-gen en_GB.UTF-8

echo ""
echo "### Fixing dns entries"
sed -i -e"s/domain-name-servers, //g" /etc/dhcp/dhclient.conf
if [ -z "`grep -Fl 'prepend domain-name-servers 8.8.8.8,8.8.4.4;' /etc/dhcp/dhclient.conf`" ]; then
    echo $'\n'"prepend domain-name-servers 8.8.8.8,8.8.4.4;" >> /etc/dhcp/dhclient.conf
fi
(dhclient -r && dhclient eth0)

ntpdate ntp.ubuntu.com

echo ""
echo "### Add color prompt"
touch /home/vagrant/.nano_history
chown vagrant:vagrant /home/vagrant/.nano_history
sed -i -e"s/#force_color_prompt=yes/force_color_prompt=yes/g" /home/vagrant/.bashrc
source /home/vagrant/.bashrc

echo ""
echo "### Change default editor to vim"
if [ -z "`grep -Fl 'EDITOR=vim' /home/vagrant/.bashrc`" ]; then
    echo $'\n''export EDITOR=vim' >> /home/vagrant/.bashrc
    source /home/vagrant/.bashrc
fi

echo ""
echo "### Updating apt data"
apt-get update

echo "### Installing necessary packages"
apt-get -q -y install \
    htop build-essential git git-flow nodejs npm \
    mysql-server-5.5 mysql-client-5.5 libmysqlclient-dev \
    libssl-dev zlib1g-dev

echo ""
echo "### Cleanup packages"
apt-get -q -y autoremove

echo ""
echo "### Bootstrap completed"

exit 0
