export SHELL := /usr/bin/env bash
export PATH := ${PATH}

include environment.mk

.DEFAULT_GOAL := build

%:
	@ cd ../ && \
	DOCKER_IMAGE_TAG=$(DOCKER_IMAGE_TAG) \
	PHP_PACKAGE_PREFIX=$(PHP_PACKAGE_PREFIX) \
	PHP_VERSION=$(PHP_VERSION) \
	$(MAKE) -f Makefile $@
