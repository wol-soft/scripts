# Scripts
Contains scripts for daily business

## Server Administration

### Renew Let's Encrypt Virtual Host

This script provides an easy way to renew the certificate for any virtual host. For example renewing the certificate for a virtual host which works as a proxy for another application (eg. GitLab).

Requirements:
* Your virtual host is defined in a file __ServerName__.conf in the sites-enabled directory of apache. (for example: GitLab-proxy for gitlab.example.com requires the configuration file at /etc/apache2/sites-enabled/gitlab.example.com.conf)
* Your virtual host configuration already links the Let's Encrypt certificate

An example virtual host configuration may look like:
```ApacheConf
<VirtualHost *:80 *:443>
    ServerName gitlab.example.com

    AllowEncodedSlashes NoDecode

    ProxyRequests     Off
    ProxyPreserveHost On
    # Provided by nginx for example
    ProxyPass / http://127.0.0.1:8888/ nocanon
    <Location />
        ProxyPassReverse /
        Order deny,allow
        Allow from all
    </Location>

    RewriteEngine on
    RewriteCond %{HTTPS} off
    RewriteCond %{SERVER_NAME} =gitlab.example.com
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]

    SSLCertificateFile /etc/letsencrypt/live/gitlab.example.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/gitlab.example.com/privkey.pem

    Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
```

The usage of the script would now be:
```Shell
./ServerAdministration/renewLetsEncryptVirtualHost.sh gitlab.example.com
```
The script will replace the current virtual host by another pointing at a temporary directory to renew the certificate. Afterwards the old configuration will be restored.