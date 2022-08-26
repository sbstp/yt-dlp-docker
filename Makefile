.PHONY: build
build:
	docker build -t yt-dlp .

.PHONY: install
install:
	cp yt-dlp /usr/local/bin
