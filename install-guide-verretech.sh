echo -------------------------------------------
echo INSTALLATION VERRETECH FRONTEND AND BACKEND
echo -------------------------------------------
echo -------------------------------------------
ip=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)
echo -e "\n"
echo PLEASE, ENTER YOUR MYSQL PASSWORD ON ROOT TO CREATE DATABASE AND SETUP VERRETECH DATABASE
read -sp 'Password: ' mysqlpass
echo -e "\n"
echo Installation Apache2 and Yarn
echo -------------------------------------------
apt-get install apache2 -y
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install yarn -y
echo -e "\n"
echo Clone repo
echo -------------------------------------------
cd /var/lib/
git clone https://github.com/Hruund/VerreTech.git
cd /var/lib/VerreTech/
git pull
touch .env
echo -e "VUE_APP_SERVER_IP=$ip
VUE_APP_TOKEN_PORT=4000
VUE_APP_PRODUCT_PORT=5000
VUE_APP_USER_PORT=6500
VUE_APP_CART_PORT=7000" >> .env
echo -e "\n"
echo Build du front-end
echo -------------------------------------------
yarn build
echo -e "\n"
echo Initialisation de yarn
echo -------------------------------------------
yarn install
echo -e "\n"
echo MYSQL Set-Up
echo -------------------------------------------
mysql -uroot -p"$mysqlpass" -e "CREATE DATABASE verretech"
mysql -uroot -p"$mysqlpass" verretech < /var/lib/VerreTech-Installation/verretech.sql
mysql -uroot -p"$mysqlpass" -e "CREATE USER 'back'@'%' IDENTIFIED BY 'VerreTech@2021';"
mysql -uroot -p"$mysqlpass" -e "GRANT ALL PRIVILEGES ON *.* TO 'back'@'%' WITH GRANT OPTION;"
echo -e "\n"
echo Transfere sur apache2
echo -------------------------------------------
cp -a /var/lib/VerreTech/dist/. /var/www/html/verretech/
touch /etc/apache2/sites-available/verretech.conf
echo -e "<VirtualHost *:80>\n
    ServerAdmin admin@verretech.fr\n
    ServerName $ip\n
    ServerAlias www.verretech.fr\n
    DocumentRoot /var/www/html/verretech\n
    ErrorLog ${APACHE_LOG_DIR}/error.log\n
    CustomLog ${APACHE_LOG_DIR}/access.log combined\n
</VirtualHost>" >> /etc/apache2/sites-available/verretech.conf
sudo a2ensite verretech.conf
sudo systemctl reload apache2
echo -e "\n"
echo BackEnd Installation
echo -------------------------------------------
apt-get install docker -y
apt-get install docker-compose -y
cd /var/lib/VerreTech-Installation/
touch .env
echo -e "PORT_TOKEN = 4000
PORT_PRODUCT = 5000
PORT_USER = 6500
PORT_CART = 7000
HOSTNAME_DDB = '$ip'
USERNAME_DDB = 'back'
PASSWORD_DDB = 'VerreTech@2021'
DATABASE_DDB = 'verretech'
PASSPHRASE = 'SUPERBE PHRASE DENCRYPTAGE'" >> .env
sed -i "s/localhost/$ip/g" Dockerfile_cart/Dockerfile
sed -i "s/localhost/$ip/g" Dockerfile_product/Dockerfile
sed -i "s/localhost/$ip/g" Dockerfile_token/Dockerfile
sed -i "s/localhost/$ip/g" Dockerfile_user/Dockerfile
docker-compose up -d
docker build
docker-compose up -d
