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
echo MYSQL Set-Up
echo ------------------
mysql -uroot -p -e "create database verretech"
mysql -uroot -p verretech < verretech.sql
echo \n
echo Set-Up and Front IP
echo ------------------
touch .env
echo -e "VUE_APP_SERVER_IP=localhost
VUE_APP_TOKEN_PORT=4000
VUE_APP_PRODUCT_PORT=5000
VUE_APP_USER_PORT=6500
VUE_APP_CART_PORT=7000" >> .env
ip=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
sed -i "s/localhost/$ip/g" .env
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
echo\n
echo BackEnd Installation
echo ------------------
apt-get install docker -y
apt-get install docker-compose -y
cd /var/lib/VerreTech-Installation/
sed -i "s/localhost/$ip/g" Dockerfile_cart/Dockerfile
sed -i "s/localhost/$ip/g" Dockerfile_product/Dockerfile
sed -i "s/localhost/$ip/g" Dockerfile_token/Dockerfile
sed -i "s/localhost/$ip/g" Dockerfile_user/Dockerfile
docker-compose up
