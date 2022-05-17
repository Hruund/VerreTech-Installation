echo ------------------
echo INSTALLATION FRONT
echo ------------------
echo \n
echo Installation Apache2 and Yarn
echo ------------------
apt-get install apache2 -y
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install yarn -y
echo \n
echo Clone repo
echo ------------------
cd /var/lib/
git clone https://github.com/Hruund/VerreTech.git
echo \n
echo Initialisation de yarn
echo ------------------
cd /var/lib/VerreTech/
yarn install
echo \n
echo Build du front-end
echo ------------------
yarn build
echo \n
echo Transfere sur apache2
echo ------------------
cp -a /var/lib/VerreTech/dist/. /var/www/html/verretech/
touch /etc/apache2/sites-available/verretech.conf
echo -e "<VirtualHost *:80>\n
    ServerAdmin admin@verretech.com\n
    ServerName 195.110.58.84\n
    ServerAlias www.verretech.com\n
    DocumentRoot /var/www/html/verretech\n
    ErrorLog ${APACHE_LOG_DIR}/error.log\n
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n
</VirtualHost>" >> /etc/apache2/sites-available/verretech.conf
sudo a2ensite verretech.conf
sudo systemctl reload apache2
