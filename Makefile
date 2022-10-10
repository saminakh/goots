APP_NAME ?= `grep 'app:' mix.exs | sed -e 's/\[//g' -e 's/ //g' -e 's/app://' -e 's/[:,]//g'`
APP_VSN ?= `cat version.txt`
BUILD ?= `git rev-parse --short HEAD`
TAG ?= "$(APP_VSN)-$(BUILD)"

build: ## Build the Docker image
	docker build --build-arg BOT_TOKEN=$(BOT_TOKEN) \
		--build-arg VOICE_CHANNEL_ID=231268398523219970 \
		-t $(APP_NAME):$(TAG) \
		--no-cache \
		-t $(APP_NAME):latest .

run: ## Run the app in Docker
	docker run --env-file config/docker.env \
		--expose 4000 -p 4000:4000 \
		--rm -it $(APP_NAME):latest

