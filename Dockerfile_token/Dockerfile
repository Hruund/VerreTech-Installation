FROM node:14.18.0-alpine

RUN apk add --no-cache git

WORKDIR /app

RUN git clone https://github.com/Hruund/VerreTech-BackEnd.git

RUN npm i --prefix ./VerreTech-BackEnd

EXPOSE 4000/tcp

RUN touch ./VerreTech-BackEnd/.env

RUN echo "PORT_USER = 6500" >> ./VerreTech-BackEnd/.env

RUN echo "PORT_TOKEN = 4000" >> ./VerreTech-BackEnd/.env

RUN echo "PORT_CART = 7000" >> ./VerreTech-BackEnd/.env

RUN echo "PORT_PRODUCT = 5000" >> ./VerreTech-BackEnd/.env

RUN echo "HOSTNAME_DDB = '54.36.191.244'" >> ./VerreTech-BackEnd/.env

RUN echo "USERNAME_DDB = 'back'" >> ./VerreTech-BackEnd/.env

RUN echo "PASSWORD_DDB = 'VerreTech@2021'" >> ./VerreTech-BackEnd/.env

RUN echo "DATABASE_DDB = 'verretech'" >> ./VerreTech-BackEnd/.env

RUN echo "PASSPHRASE = 'SUPERBE PHRASE DENCRYPTAGE'" >> ./VerreTech-BackEnd/.env

CMD ["node", "./VerreTech-BackEnd/token.js"]
