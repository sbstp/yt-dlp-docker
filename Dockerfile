FROM alpine:3

RUN apk add --update --no-cache quickjs ffmpeg python3 py3-pip
RUN python3 -m venv /app/venv && /app/venv/bin/pip install "yt-dlp[default]==2026.10.26"

# yt-dlp only enables deno by default; enable the quickjs runtime instead
RUN mkdir -p /etc/yt-dlp && echo '--js-runtimes quickjs' > /etc/yt-dlp/config

# Fail the build if the quickjs runtime is missing or unsupported by yt-dlp
RUN /app/venv/bin/python -c "from yt_dlp.utils._jsruntime import QuickJsRuntime; info = QuickJsRuntime().info; assert info is not None and info.supported, f'unsupported JS runtime: {info}'; print(info.name, info.version)"

RUN ffmpeg -version
RUN /app/venv/bin/yt-dlp --version

ENTRYPOINT [ "/app/venv/bin/yt-dlp" ]
