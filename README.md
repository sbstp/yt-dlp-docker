# yt-dlp-docker
Tools to build a container with `yt-dlp`, `ffmpeg` and `quickjs`.

`quickjs` is the JavaScript runtime yt-dlp uses to solve YouTube's JS challenges (EJS). It is enabled via `/etc/yt-dlp/config` in the image. See the [EJS setup guide](https://github.com/yt-dlp/yt-dlp/wiki/ejs) for details.

## Build the image
* `make build`

## Install the shim script globally
* `make install`

## Run the yt-dlp image via the shim script
* `yt-dlp [args]`
