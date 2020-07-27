FROM alpine:3.8

ENV MC_VER=1.4.4
LABEL org.label-schema.version=${MC_VER}

RUN apk --no-cache add openjdk8-jre curl jq && \
    \
    curl -fsSL https://launchermeta.mojang.com/mc/game/version_manifest.json \
        | jq -r ".versions[] | select(.id == \"$MC_VER\") | .url" \
        | xargs curl -fsSL \
        | jq -r ".downloads.server.url" \
        | xargs curl -fsSL -o /minecraft_server.jar && \
    \
    apk --no-cache del jq

WORKDIR /mc

ENV INIT_MEM=1G \
    MAX_MEM=4G \
    SERVER_JAR=/minecraft_server.jar

CMD exec java "-Xms$INIT_MEM" "-Xmx$MAX_MEM" -jar "$SERVER_JAR" nogui