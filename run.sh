#!/bin/bash

if [ ! -d "nocodb" ]
then
  # clone nocodb repo
  #  git clone https://github.com/nocodb/nocodb.git
  wget https://github.com/nocodb/nocodb/archive/refs/heads/develop.zip && \
  unzip develop.zip -d nocodb && \
  # install 0x \
  npm install -g 0x && \
  npm install -g nest && \
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
  # install nocodb dependencies \
  cd ../nocodb && \
  rm -r tests && \
  npm install && \
  nest build && \
  rsync -rvzh ../ncgui/dist/ ./dist/run/nc-gui/
  cd ../../../../
#else
#  cd ./nocodb/nocodb-develop/packages/nocodb
fi

cd src
node index.js
