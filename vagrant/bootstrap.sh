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

echo ""
echo "### Add ruby 2.1 ppa"
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update

echo "### Installing necessary packages"
apt-get -q -y install \
    htop build-essential git git-flow nodejs \
    mysql-server-5.5 mysql-client-5.5 libmysqlclient-dev \
    ruby2.1 ruby2.1-dev ruby1.9.1-dev libssl-dev zlib1g-dev libsqlite3-dev

echo ""
echo "### Make Ruby2.1 default"
update-alternatives --set ruby /usr/bin/ruby2.1

echo "### Installing necessary gems"
gem install rails
gem install bundler

echo ""
echo "### Configure MySQL for remote connections"
sed -i -e"s/bind-address/#bind-address/g" /etc/mysql/my.cnf
mysql -uroot -e"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
service mysql restart

echo ""
echo "### Cleanup packages"
apt-get -q -y autoremove

echo ""
echo "### Bootstrap completed"

exit 0
