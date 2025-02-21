SHELL = /bin/sh
current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY:
help: ## Display available targets
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf " \033[36m%-20s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY:
## TODO: parameterize the model to dynamically pass -n mdx / mdx_extra
run: ## Run the demucs spliting the tracks placed in the input folder
	docker run --rm -i \
		--name=demucs \
		-v $(current-dir)input:/data/input \
		-v $(current-dir)output:/data/output \
		-v $(current-dir)models:/data/models \
		--gpus all \
		gpu-test:11-8 \
		"python3 -m demucs.separate --out /data/output \
		/data/input/$(track)"
.PHONY:
build: ## Build docker image with all needed to run the facebook demucs ML code
	docker build --no-cache -t gpu-test:11-8 .
