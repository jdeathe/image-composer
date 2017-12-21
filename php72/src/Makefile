export SHELL := /usr/bin/env bash
export PATH := ${PATH}

define USAGE
Usage: make [options] [target] ...
Usage: VARIABLE="VALUE" make [options] -- [target] ...

This Makefile allows you to build, install and create release packages for the
container image defined by the Dockerfile.

Targets:
  build-wrapper             Builds the run wrapper.
  help                      Show this help.
Variables:
  - DOCKER_CONTAINER_OPTS   Set optional docker parameters to append that will 
                            be appended to the create and run templates.
  - DOCKER_IMAGE_TAG        Defines the image tag name.
  - DIST_PATH               Ouput directory path - where the release package 
                            artifacts are placed.
  - WRAPPER_NAME            Name for the run wrapper.

endef

include environment.mk
include default.mk

# UI constants
COLOUR_NEGATIVE := \033[1;31m
COLOUR_POSITIVE := \033[1;32m
COLOUR_RESET := \033[0m
CHARACTER_STEP := --->
PREFIX_STEP := $(shell \
	printf -- '%s ' \
		"$(CHARACTER_STEP)"; \
)
PREFIX_SUB_STEP := $(shell \
	printf -- ' %s ' \
		"$(CHARACTER_STEP)"; \
)
PREFIX_STEP_NEGATIVE := $(shell \
	printf -- '%b%s%b' \
		"$(COLOUR_NEGATIVE)" \
		"$(PREFIX_STEP)" \
		"$(COLOUR_RESET)"; \
)
PREFIX_STEP_POSITIVE := $(shell \
	printf -- '%b%s%b' \
		"$(COLOUR_POSITIVE)" \
		"$(PREFIX_STEP)" \
		"$(COLOUR_RESET)"; \
)
PREFIX_SUB_STEP_NEGATIVE := $(shell \
	printf -- '%b%s%b' \
		"$(COLOUR_NEGATIVE)" \
		"$(PREFIX_SUB_STEP)" \
		"$(COLOUR_RESET)"; \
)
PREFIX_SUB_STEP_POSITIVE := $(shell \
	printf -- '%b%s%b' \
		"$(COLOUR_POSITIVE)" \
		"$(PREFIX_SUB_STEP)" \
		"$(COLOUR_RESET)"; \
)

.DEFAULT_GOAL := build-wrapper

docker := $(shell \
	command -v docker \
)

# Run wrapper prerequisites
install := $(shell \
	command -v install \
)
m4 := $(shell \
	command -v m4 \
)

.PHONY: \
	_prerequisites-wrapper \
	_usage \
	build-wrapper \
	help

_prerequisites-wrapper:
ifeq ($(docker),)
docker := docker
endif

ifeq ($(install),)
	$(error "Please install the install package.")
endif

ifeq ($(m4),)
	$(error "Please install the m4 package.")
endif

_usage:
	@: $(info $(USAGE))

build-wrapper: _prerequisites-wrapper
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ echo "$(PREFIX_STEP)Building run wrapper"
	@ $(m4) \
		-D WRAPPER_NAME="$(WRAPPER_NAME)" \
		-D WRAPPER_PRE_RUN="$(WRAPPER_PRE_RUN)" \
		-D WRAPPER_RUN="$(docker) run \
	$(DOCKER_CONTAINER_PARAMETERS) \
	$(DOCKER_CONTAINER_OPTS) \
	$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG_TEMPLATE)" \
		-D PHP_VERSION_DEFAULT="$(PHP_VERSION)" \
		run-wrapper.sh.m4 \
		> $($@_dist_path)/$(WRAPPER_NAME); \
	if [[ $${?} -eq 0 ]]; then \
		chmod +x $($@_dist_path)/$(WRAPPER_NAME); \
		echo "$(PREFIX_SUB_STEP_POSITIVE)Build complete"; \
	else \
		echo "$(PREFIX_SUB_STEP_NEGATIVE)Build error"; \
		exit 1; \
	fi

help: _usage
