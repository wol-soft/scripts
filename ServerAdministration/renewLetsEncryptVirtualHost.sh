#!/bin/sh

mkdir $1.conf
mv /etc/apache2/sites-enabled/* ./$1.conf
mkdir $1

DIR="$( cd "$( dirname "$0" )" && pwd )"
FILE="/etc/apache2/sites-enabled/$1.conf"

/bin/cat <<EOM >$FILE
<VirtualHost *:80>
    ServerName $1
    DocumentRoot $DIR/$1/
</VirtualHost>
EOM

service apache2 reload
sudo certbot certonly -a webroot -n -w $DIR/$1 -d $1

rm /etc/apache2/sites-enabled/$1.conf
mv ./$1.conf/* /etc/apache2/sites-enabled/
rmdir $1.conf
rmdir $1

service apache2 reload
