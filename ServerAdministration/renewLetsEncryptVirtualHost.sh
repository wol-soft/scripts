#!/bin/sh

mv /etc/apache2/sites-enabled/$1.conf ./$1.conf
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
sudo certbot run -a webroot -i apache -w $DIR/$1

rm /etc/apache2/sites-enabled/$1.conf
mv ./$1.conf /etc/apache2/sites-enabled/$1.conf
rmdir $1

rm /etc/apache2/sites-enabled/${1}-le-ssl.conf
service apache2 reload
