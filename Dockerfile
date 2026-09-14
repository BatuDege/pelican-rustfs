FROM rustfs/rustfs:1.0.0-rc.6 AS rustfs

FROM alpine:3.24

LABEL org.opencontainers.image.title="Pelican RustFS"
LABEL org.opencontainers.image.description="RustFS S3-compatible object storage Yolk for Pelican"
LABEL org.opencontainers.image.source="https://github.com/BatuDege/pelican-rustfs"

RUN apk add --no-cache ca-certificates tini \
    && addgroup -g 10001 -S container \
    && adduser -u 10001 -S -D -h /home/container -G container container \
    && mkdir -p /home/container/data \
    && chown -R 10001:10001 /home/container

COPY --from=rustfs /usr/bin/rustfs /usr/bin/rustfs

ENV HOME=/home/container \
    RUSTFS_ADDRESS=:9000 \
    RUSTFS_CONSOLE_ADDRESS=:9001 \
    RUSTFS_CONSOLE_ENABLE=true \
    RUSTFS_VOLUMES=/home/container/data

WORKDIR /home/container

COPY --chown=container:container entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER container

EXPOSE 9000
EXPOSE 9001

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]
