FROM debian:bookworm-slim AS builder

COPY assets/phantomjs-2.1.1-linux-x86_64.tar.bz2 /phantomjs.tar.bz2

RUN apt-get update && apt-get install -y bzip2 tar && \
    tar -xvjf phantomjs.tar.bz2

FROM python:3.10-slim-bookworm

COPY --from=builder /phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
RUN echo "deb https://deb.debian.org/debian/ sid main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y -t sid ffmpeg fontconfig
RUN ffmpeg -version
ENV OPENSSL_CONF=/etc/ssl/
RUN /usr/local/bin/phantomjs --version
RUN pip install yt-dlp==2024.8.6

ENTRYPOINT [ "yt-dlp" ]
