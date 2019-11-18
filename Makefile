#
# Makefile for building docker images
#
DOCKER      = docker
REPO        = junhochoi/quiche-docker-examples
SIMPLE_TAG  = simple
NGINX_TAG   = nginx
CURL_TAG    = curl
BUILD_TAG   = base-build

.PHONY: simple nginx curl publish clean

all: simple nginx curl

# build simple image
simple: simple/test.html simple/Dockerfile
	$(DOCKER) build -t $(REPO):$(SIMPLE_TAG) simple/

# build nginx image
nginx: nginx/Dockerfile
	$(DOCKER) build -t $(REPO):$(NGINX_TAG) nginx/

# build curl image
curl: curl/Dockerfile
	$(DOCKER) build -t $(REPO):$(CURL_TAG) curl/

push: simple nginx curl
	$(DOCKER) push $(REPO):$(SIMPLE_TAG)
	$(DOCKER) push $(REPO):$(NGINX_TAG)
	$(DOCKER) push $(REPO):$(CURL_TAG)

clean:
	@for id in `$(DOCKER) images -q $(REPO)`; do \
		echo ">> Removing $$id"; \
		$(DOCKER) rmi -f $$id; \
	done
