FROM debian:bullseye-slim AS builder

ARG PHANTOMJS_URL="https://github.com/sbstp/yt-dlp-docker/blob/master/phantomjs-2.1.1-linux-x86_64.tar.bz2?raw=true"

RUN apt-get update && apt-get install -y bzip2 curl tar && \
    curl -L -o phantomjs.tar.bz2 "$PHANTOMJS_URL" && \
    tar -xvjf phantomjs.tar.bz2

FROM python:3.10-slim-bullseye

COPY --from=builder /phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
RUN apt-get update && apt-get install -y ffmpeg fontconfig
ENV OPENSSL_CONF=/etc/ssl/
RUN /usr/local/bin/phantomjs --help
RUN pip install yt-dlp

ENTRYPOINT [ "yt-dlp" ]
