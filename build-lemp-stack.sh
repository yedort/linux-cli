# switch to the root/superuser
sudo su

# change root password (optional)
passwd root

# update resources, upgrade default packages, remove unneeded packages, delete downloaded package archive files
apt update;apt -y full-upgrade;apt -y autoclean

# install nginx, php 5.6, php 7.4, git, composer, mysql, phpmyadmin, ftp (vsftpd), firewall (ufw)
apt -y install software-properties-common;add-apt-repository ppa:ondrej/php;apt update;apt -y install nginx php5.6-fpm php5.6-cli php5.6-mysql php5.6-curl php5.6-mbstring php5.6-xml php5.6-zip php7.4-fpm php7.4-cli php7.4-mysql php7.4-curl php7.4-mbstring php7.4-xml php7.4-zip git composer mysql-server phpmyadmin vsftpd ufw

# add php extensions to php.ini files
export php_extensions=('curl' 'mysqli' 'pdo_mysql' 'mbstring');for ext in "${php_extensions[@]}";do echo "extension="$ext >> /etc/php/5.6/fpm/php.ini;echo "extension="$ext >> /etc/php/5.6/cli/php.ini;echo "extension="$ext >> /etc/php/7.4/fpm/php.ini;echo "extension="$ext >> /etc/php/7.4/cli/php.ini;done

# create a mysql user and grant permissions
mysql -u root -p -e "CREATE USER yedort;SET PASSWORD FOR yedort = 'a1a1a1a1';GRANT ALL PRIVILEGES ON *.* TO yedort;FLUSH PRIVILEGES"

# link phpmyadmin to the server directory
ln -s /usr/share/phpmyadmin /var/www/phpmyadmin

# add user for ftp (optional)
adduser yedort;passwd yedort

# firewall settings
ufw default deny;ufw default allow outgoing;ufw allow ssh;ufw allow 22;ufw allow 'Nginx Full';ufw allow 80;ufw allow 443;ufw allow 53;ufw allow 20;ufw allow 21;ufw allow 990;ufw allow 40000:50000/tcp;ufw enable

# nginx settings
rm /etc/nginx/sites-enabled/default;ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default;nano /etc/nginx/sites-available/default
# info about config file: https://www.nginx.com/resources/wiki/start/topics/examples/server_blocks

# ftp settings
cp /etc/vsftpd.conf /etc/vsftpd.conf.orig;echo "yedort" | sudo tee -a /etc/vsftpd.userlist;chown -R yedort:yedort /var/www;echo 'allow_writeable_chroot=YES' >> /etc/vsftpd.conf;nano /etc/vsftpd.conf
# info about config file: https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-18-04

# ssl installation and settings (optional)
add-apt-repository ppa:certbot/certbot;apt update;apt -y install python-certbot-nginx;certbot --nginx
