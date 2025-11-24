FROM alpine:3

RUN apk add --update --no-cache deno ffmpeg python3 py3-pip
RUN python3 -m venv /app/venv && /app/venv/bin/pip install "yt-dlp[default]==2025.11.12"

RUN ffmpeg -version
RUN /app/venv/bin/yt-dlp --version

ENTRYPOINT [ "/app/venv/bin/yt-dlp" ]
