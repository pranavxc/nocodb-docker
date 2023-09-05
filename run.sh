#!/bin/bash

if [ ! -d "nocodb" ]
then
  # clone nocodb repo
  #  git clone https://github.com/nocodb/nocodb.git
  wget https://github.com/nocodb/nocodb/archive/refs/heads/develop.zip && \
  unzip develop.zip -d nocodb && \
  # install 0x \
  npm install -g 0x && \
  cd ./nocodb/nocodb-develop && \
  # build nocodb-sdk \
  cd ./packages/nocodb-sdk && \
  npm install && \
  npm run build && \
  # build gui \
  cd ../nc-gui && \
  npm install && \
  npm run generate && \
  # copy gui build to nocodb \
  rsync -rvzh ./dist/ ../nocodb/src/run/nc-gui/ && \
  # install nocodb dependencies \
  cd ../nocodb && \
  npm install
else
  cd ./nocodb/nocodb-develop/packages/nocodb
fi

0x -- node -r ts-node/register -r tsconfig-paths/register src/run/local.ts
