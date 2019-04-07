# change root password (optional)
passwd root

# update resources
apt update

# install nginx, php, git, composer, mysql, phpmyadmin, ftp, firewall
add-apt-repository ppa:ondrej/php;apt update;apt -y install nginx php7.3-fpm php7.3-mysql mysql-server php7.3-curl php7.3-mbstring php7.3-xml ufw vsftpd phpmyadmin git composer;apt dist-upgrade

# link phpmyadmin to the home directory
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
apt -y install software-properties-common;add-apt-repository ppa:certbot/certbot;apt update;apt -y install python-certbot-nginx;certbot --nginx

# SQL command to set a user in MySQL
# CREATE USER yedort;SET PASSWORD FOR yedort = 'a1a1a1a1';
