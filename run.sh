#!/bin/bash

if [ ! -d "nocodb" ]
then
  # clone nocodb repo
  #  git clone https://github.com/nocodb/nocodb.git
  wget https://github.com/nocodb/nocodb/archive/refs/heads/develop.zip && \
  unzip develop.zip -d nocodb
fi

cd ./nocodb/nocodb-develop/packages/nocodb-sdk
#build nocodb-sdk if build not exists
if [ ! -d "build/main" ]
then
  npm install && \
  npm run build
fi

# build gui \
#  cd ../nc-gui && \
#  npm install && \
#  npm run generate && \
# copy gui build to nocodb \
# install nocodb dependencies \
cd ../nocodb && \
rm -r tests && \
npm install && \
nest build && \
mkdir ./dist/run/nc-gui && \
#  rsync -rvzh ../ncgui/dist/ ./dist/run/nc-gui/ && \
cd ../../../../src && \
npm install && \
node index.js

