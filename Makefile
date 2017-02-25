DOCKER_COMPOSE=$(shell which docker-compose)
DOCKER_COMPOSE_TARGETS=-f docker-compose.yml

define DOCKER_NICE
  trap '$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_TARGETS) down' SIGINT SIGTERM && \
  $(DOCKER_COMPOSE) $(DOCKER_COMPOSE_TARGETS)
endef

export DOCKER_NICE

default: run

init:

build: init
	bash -c "$$DOCKER_NICE build"

rebuild: init
	bash -c "$$DOCKER_NICE build --no-cache"

compile: init
	bash -c "$$DOCKER_NICE run app webpack"

add:
	bash -c "git add ."

commit: add
	@read -p "Enter commit message: " message; \
	git commit -am "$$message"

deploy: add commit
	git push

run: init
	bash -c "$$DOCKER_NICE up"

.PHONY: init
.PHONY: build
.PHONY: rebuild
.PHONY: compile
.PHONY: run
