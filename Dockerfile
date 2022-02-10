FROM debian:bullseye-slim AS download

RUN apt-get update \
 && apt-get install -y curl dumb-init \
 && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
 && curl --no-progress-meter -OL https://s3.amazonaws.com/clickhouse-builds/22.2/dd61d1c2de387dff1c75fd8ed7c587483857382d/package_aarch64/clickhouse-client_22.2.1.3693_all.deb \
 && curl --no-progress-meter -OL https://s3.amazonaws.com/clickhouse-builds/22.2/dd61d1c2de387dff1c75fd8ed7c587483857382d/package_aarch64/clickhouse-common-static_22.2.1.3693_arm64.deb \
 && curl --no-progress-meter -OL https://s3.amazonaws.com/clickhouse-builds/22.2/dd61d1c2de387dff1c75fd8ed7c587483857382d/package_aarch64/clickhouse-server_22.2.1.3693_all.deb \
 && dpkg -i /tmp/*.deb \
 && rm *.deb

ENTRYPOINT ["/usr/bin/dumb-init"]

WORKDIR /var/lib/clickhouse-server
USER 999:999
CMD ["/usr/bin/clickhouse-server", "-C", "/etc/clickhouse-server/config.xml"]
