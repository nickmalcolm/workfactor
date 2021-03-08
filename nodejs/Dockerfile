FROM node:15-alpine

WORKDIR /app

RUN apk add --no-cache --virtual .gyp python make g++ \
    && npm install bcrypt \
    && apk del .gyp

COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

COPY . .

CMD [ "node", "benchmark.js" ]