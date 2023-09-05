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
    rsync

COPY ./run.sh /usr/src/appEntry/start.sh


EXPOSE 8080
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Start Nocodb
CMD ["/usr/src/appEntry/start.sh"]
