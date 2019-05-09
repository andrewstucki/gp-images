DOCKER_REPO := andrewstucki
TARGETS := bootstrap dev generator

.PHONY: $(TARGETS)
$(TARGETS):
	@echo "Building $@"

.PHONY: build-%
build-%: %
	@set -e; \
		TAG=$$(grep -E "^$<=" TAGS -m 1 | cut -d '=' -f 2); \
		if [ "$$TAG" == "" ]; then \
			echo "Unable to find image tag"; \
			exit 1; \
		fi; \
		if [ "$$TAG" == "latest" ]; then \
			docker build -t $(DOCKER_REPO)/$< -f Dockerfile.$< .; \
		else \
			docker build -t $(DOCKER_REPO)/$< -t $(DOCKER_REPO)/$<:$$TAG -f Dockerfile.$< .; \
		fi; \
		if [ "$(RELEASE)" == "true" ]; then \
			docker push $(DOCKER_REPO)/$<; \
		fi;
