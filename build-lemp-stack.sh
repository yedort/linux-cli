# switch to the root/superuser
sudo su

# change root password (optional)
passwd root

# update resources
apt update

# install nginx, php 5.6, php 7.4, git, composer, mysql, phpmyadmin, ftp (vsftpd), firewall (ufw)
apt -y install software-properties-common;add-apt-repository ppa:ondrej/php;apt update;apt -y install nginx php5.6-fpm php5.6-mysql php5.6-curl php5.6-mbstring php5.6-xml php5.6-zip php7.4-fpm php7.4-mysql php7.4-curl php7.4-mbstring php7.4-xml php7.4-zip mysql-server ufw vsftpd phpmyadmin git composer;apt -y dist-upgrade

# create a mysql user and grant permissions
mysql -u root -p -e "CREATE USER yedort;SET PASSWORD FOR yedort = 'a1a1a1a1';GRANT ALL PRIVILEGES ON *.* TO yedort;FLUSH PRIVILEGES"

# link phpmyadmin to the server directory
ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

# add user for ftp (optional)
adduser yedort;passwd yedort

# firewall settings
ufw default deny;ufw default allow outgoing;ufw allow 22/tcp;ufw allow 80/tcp;ufw allow 443/tcp;ufw allow 53;ufw allow 20/tcp;ufw allow 21/tcp;ufw allow 990/tcp;ufw allow 40000:50000/tcp;ufw allow 'Nginx Full';ufw enable

# nginx settings
rm /etc/nginx/sites-enabled/default;ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled;nano /etc/nginx/sites-available/default
# info about config file: https://www.nginx.com/resources/wiki/start/topics/examples/server_blocks

# ftp settings
cp /etc/vsftpd.conf /etc/vsftpd.conf.orig;echo "yedort" | sudo tee -a /etc/vsftpd.userlist;chown -R yedort:yedort /var/www/html;echo 'allow_writeable_chroot=YES' >> /etc/vsftpd.conf;nano /etc/vsftpd.conf
# info about config file: https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-18-04

# ssl installation and settings (optional)
add-apt-repository ppa:certbot/certbot;apt update;apt -y install python-certbot-nginx;certbot --nginx
