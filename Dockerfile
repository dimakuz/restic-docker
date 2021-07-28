FROM ubuntu:rolling

RUN apt-get update \
    && \
    apt-get install -y \
        restic \
        rclone \
        ca-certificates \
        curl \
        jq \
    && \
    rm -rf /var/lib/apt/lists/* && \
    curl -s https://raw.githubusercontent.com/fabianonline/telegram.sh/master/telegram > /usr/local/bin/telegram && \
    chmod +x /usr/local/bin/telegram

ADD docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]