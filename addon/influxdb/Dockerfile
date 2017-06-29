FROM influxdb:1.3.0-alpine

# Install InfluxDB
ENV INFLUXDB_VERSION 1.3.0

ADD config.toml /config/config.toml
ADD run.sh /bin/run.sh
RUN chmod +x /bin/*.sh ;\
    apk add --no-cache --virtual .build-deps sed ; \
    apk del .build-deps

ENV PRE_CREATE_DB **None**
ENV SSL_SUPPORT **False**
ENV SSL_CERT **None**

# Admin server WebUI
EXPOSE 8083

# HTTP API
EXPOSE 8086

# Raft port (for clustering, don't expose publicly!)
#EXPOSE 8090

# Protobuf port (for clustering, don't expose publicly!)
#EXPOSE 8099

VOLUME ["/data"]

CMD ["/bin/run.sh"]
