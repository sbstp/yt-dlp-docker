FROM debian:bullseye-slim AS builder

RUN apt-get update && apt-get install -y bzip2 curl tar && \
    curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 && \
    tar -xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2

FROM python:3.10-slim-bullseye

COPY --from=builder /phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
RUN apt-get update && apt-get install -y ffmpeg fontconfig
ENV OPENSSL_CONF=/etc/ssl/
RUN /usr/local/bin/phantomjs --help
RUN pip install yt-dlp

ENTRYPOINT [ "yt-dlp" ]
