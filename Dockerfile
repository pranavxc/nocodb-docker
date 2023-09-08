FROM alpine:3.15
WORKDIR /usr/src/app

ENV NC_DOCKER 0.6
ENV NODE_ENV production
ENV PORT 8080
ENV NC_TOOL_DIR=/usr/app/data/

RUN apk --update --no-cache add \
    nodejs \
    tar \
    dumb-init \
    wget \
    rsync \
    npm


RUN mkdir -p /usr/app/data/
RUN mkdir -p /usr/src/app/results/

COPY ./run.sh /usr/src/app/
COPY ./src/ /usr/src/app/src/

#  npm install -g nest && \

RUN cd /usr/src/app/src && \
  npm install && \
  npm install -g 0x && \
  npm install -g npm-run-all && \
  npm install -g tsc-alias && \
  npm install -g @nestjs/cli@9.0.0 && \
  npm install -g typescript@4.7.4


EXPOSE 8080
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start Nocodb
CMD ["sh", "/usr/src/app/run.sh"]
