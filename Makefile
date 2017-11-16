export SHELL := /usr/bin/env bash
export PATH := ${PATH}

define USAGE
Usage: make [options] [target] ...
Usage: VARIABLE="VALUE" make [options] -- [target] ...

This Makefile allows you to build, install and create release packages for the
container image defined by the Dockerfile.

Targets:
  all                       Combines targets build images and install.
  build                     Builds the image. This is the default target.
  build-wrapper             Builds the run wrapper.
  clean                     Clean up build artifacts.
  dist                      Pull a release version from the registry and save a
                            package suitable for offline distribution. Image is 
                            saved as a tar archive, compressed with xz.
  distclean                 Clean up distribution artifacts.
  help                      Show this help.
  install                   Install the run wrapper.
  images                    Show container's image details.
  load                      Loads from the distribution package. Requires 
                            DOCKER_IMAGE_TAG variable.
  pull                      Pull the release image from the registry. Requires 
                            the DOCKER_IMAGE_TAG variable.
  rm-wrapper                Purge run-wrapper.
  rmi                       Untag (remove) the image.
  test                      Run all test cases.

Variables:
  - BIN_PREFIX              Parent directory for /bin/WRAPPER_NAME.
                            Default: /usr/local
  - DOCKER_CONTAINER_OPTS   Set optional docker parameters to append that will 
                            be appended to the create and run templates.
  - DOCKER_IMAGE_TAG        Defines the image tag name.
  - DIST_PATH               Ouput directory path - where the release package 
                            artifacts are placed.
  - NO_CACHE                When true, no cache will be used while running the 
                            build target.
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

.DEFAULT_GOAL := build

# Package prerequisites
docker := $(shell \
	command -v docker \
)
m4 := $(shell \
	command -v m4 \
)
xz := $(shell \
	command -v xz \
)

# Testing prerequisites
shpec := $(shell \
	command -v shpec \
)

# Used to test docker host is accessible
get-docker-info := $(shell \
	$(docker) info \
)

.PHONY: \
	_prerequisites \
	_require-bin-path \
	_require-docker-image-tag \
	_require-docker-release-tag \
	_require-package-path \
	_require_run_wrapper \
	_test-prerequisites \
	_usage \
	all \
	build \
	build-all \
	build-wrapper \
	clean \
	dist \
	distclean \
	help \
	install \
	images \
	load \
	pull \
	rm-wrapper \
	rmi \
	test

_prerequisites:
ifeq ($(docker),)
	$(error "Please install the docker (docker-engine) package.")
endif

ifeq ($(m4),)
	$(error "Please install the m4 package.")
endif

ifeq ($(xz),)
	$(error "Please install the xz package.")
endif

ifeq ($(get-docker-info),)
	$(error "Unable to connect to docker host.")
endif

_require-bin-path:
	$(eval $@_bin_path := $(realpath \
		$(BIN_PREFIX)/bin \
	))
	@ if [[ -n $($@_bin_path) ]] && [[ ! -d $($@_bin_path) ]]; then \
		echo "$(PREFIX_STEP)Creating package directory"; \
		mkdir -p $($@_bin_path); \
	fi; \
	if [[ ! $${?} -eq 0 ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Failed to make package path: $($@_bin_path)"; \
		exit 1; \
	elif [[ -z $($@_bin_path) ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Undefined BIN_PATH"; \
		exit 1; \
	fi

_require-docker-image-tag:
	@ if [[ -z $$(if [[ $(DOCKER_IMAGE_TAG) =~ $(DOCKER_IMAGE_TAG_PATTERN) ]]; then echo $(DOCKER_IMAGE_TAG); else echo ''; fi) ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Invalid DOCKER_IMAGE_TAG value: $(DOCKER_IMAGE_TAG)"; \
		exit 1; \
	fi

_require-docker-release-tag:
	@ if [[ -z $$(if [[ $(DOCKER_IMAGE_TAG) =~ $(DOCKER_IMAGE_RELEASE_TAG_PATTERN) ]]; then echo $(DOCKER_IMAGE_TAG); else echo ''; fi) ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Invalid DOCKER_IMAGE_TAG value: $(DOCKER_IMAGE_TAG)"; \
		echo "$(PREFIX_SUB_STEP)A release tag is required for this operation."; \
		exit 1; \
	fi

_require-package-path:
	@ if [[ -n $(DIST_PATH) ]] && [[ ! -d $(DIST_PATH) ]]; then \
		echo "$(PREFIX_STEP)Creating package directory"; \
		mkdir -p $(DIST_PATH); \
	fi; \
	if [[ ! $${?} -eq 0 ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Failed to make package path: $(DIST_PATH)"; \
		exit 1; \
	elif [[ -z $(DIST_PATH) ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Undefined DIST_PATH"; \
		exit 1; \
	fi

_require_run_wrapper:
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ if [[ ! -f $($@_dist_path)/$(WRAPPER_NAME) ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)This operation requires the $(WRAPPER_NAME) run wrapper."; \
		echo "$(PREFIX_SUB_STEP)Try building it with make build-wrapper."; \
		exit 1; \
	fi

_test-prerequisites:
ifeq ($(shpec),)
	$(error "Please install shpec.")
endif

_usage:
	@: $(info $(USAGE))

all: _prerequisites | build images install

build: _prerequisites _require-docker-image-tag | build-wrapper
	@ echo "$(PREFIX_STEP)Building $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"
	@ if [[ $(NO_CACHE) == true ]]; then \
		echo "$(PREFIX_SUB_STEP)Skipping cache"; \
	fi
	@ $(docker) build \
		$(DOCKER_BUILD_ARGS) \
		--no-cache=$(NO_CACHE) \
		-t $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) \
		.; \
	if [[ $${?} -eq 0 ]]; then \
		echo "$(PREFIX_SUB_STEP_POSITIVE)Build complete"; \
	else \
		echo "$(PREFIX_SUB_STEP_NEGATIVE)Build error"; \
		exit 1; \
	fi

build-wrapper: _prerequisites
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
		src/run-wrapper.sh.m4 \
		> $($@_dist_path)/$(WRAPPER_NAME); \
	if [[ $${?} -eq 0 ]]; then \
		echo "$(PREFIX_SUB_STEP_POSITIVE)Build complete"; \
	else \
		echo "$(PREFIX_SUB_STEP_NEGATIVE)Build error"; \
		exit 1; \
	fi

clean: _prerequisites | rm-wrapper rmi

dist: _prerequisites _require-docker-release-tag _require-package-path | pull
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ if [[ -s $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz ]]; then \
		echo "$(PREFIX_STEP)Saving package"; \
		echo "$(PREFIX_SUB_STEP)Package path: $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz"; \
		echo "$(PREFIX_SUB_STEP_POSITIVE)Package already exists"; \
	else \
		echo "$(PREFIX_STEP)Saving package"; \
		$(docker) save \
			$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) | \
			$(xz) -9 > \
				$($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz; \
		if [[ $${?} -eq 0 ]]; then \
			echo "$(PREFIX_SUB_STEP)Package path: $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz"; \
			echo "$(PREFIX_SUB_STEP_POSITIVE)Package saved"; \
		else \
			echo "$(PREFIX_SUB_STEP_NEGATIVE)Package save error"; \
			exit 1; \
		fi; \
	fi

distclean: _prerequisites _require-docker-release-tag _require-package-path | clean
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ if [[ -e $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz ]]; then \
		echo "$(PREFIX_STEP)Deleting package"; \
		echo "$(PREFIX_SUB_STEP)Package path: $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz"; \
		find $($@_dist_path) \
			-name $(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz \
			-delete; \
		if [[ ! -e $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz ]]; then \
			echo "$(PREFIX_SUB_STEP_POSITIVE)Package cleanup complete"; \
		else \
			echo "$(PREFIX_SUB_STEP_NEGATIVE)Package cleanup failed"; \
			exit 1; \
		fi; \
	else \
		echo "$(PREFIX_STEP)Package cleanup skipped"; \
	fi

images: _prerequisites
	@ $(docker) images \
		$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG);

help: _usage

install: | _prerequisites _require-bin-path _require-package-path _require_run_wrapper
	$(eval $@_bin_path := $(realpath \
		$(BIN_PREFIX)/bin \
	))
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ echo "$(PREFIX_STEP)Installing run wrapper"
	@ install \
		$($@_dist_path)/$(WRAPPER_NAME) \
		$($@_bin_path); \
		if [[ $${?} -eq 0 ]]; then \
			echo "$(PREFIX_SUB_STEP_POSITIVE)Installed $($@_bin_path)/$(WRAPPER_NAME)"; \
		else \
			echo "$(PREFIX_SUB_STEP_NEGATIVE)Install failed"; \
			exit 1; \
		fi

load: _prerequisites _require-docker-release-tag _require-package-path
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ echo "$(PREFIX_STEP)Loading image from package"; \
	echo "$(PREFIX_SUB_STEP)Package path: $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz"; \
	if [[ ! -s $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz ]]; then \
		echo "$(PREFIX_STEP_NEGATIVE)Package not found"; \
		echo "$(PREFIX_SUB_STEP_NEGATIVE)To create a package try: DOCKER_IMAGE_TAG=\"$(DOCKER_IMAGE_TAG)\" make dist"; \
		exit 1; \
	else \
		$(xz) -dc $($@_dist_path)/$(DOCKER_IMAGE_NAME).$(DOCKER_IMAGE_TAG).tar.xz | \
			$(docker) load; \
		echo "$(PREFIX_SUB_STEP)$$(if [[ -n $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)) ]]; then echo $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); else echo $$($(docker) images -q docker.io/$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); fi;)"; \
		echo "$(PREFIX_SUB_STEP_POSITIVE)Image loaded"; \
	fi

pull: _prerequisites _require-docker-image-tag
	@ echo "$(PREFIX_STEP)Pulling image from registry"
	@ $(docker) pull \
		$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG); \
	if [[ $${?} -eq 0 ]]; then \
		echo "$(PREFIX_SUB_STEP)$$(if [[ -n $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)) ]]; then echo $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); else echo $$($(docker) images -q docker.io/$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); fi;)"; \
		echo "$(PREFIX_SUB_STEP_POSITIVE)Image pulled"; \
	else \
		echo "$(PREFIX_SUB_STEP_NEGATIVE)Error pulling image"; \
		exit 1; \
	fi

rm-wrapper: _prerequisites
	$(eval $@_dist_path := $(realpath \
		$(DIST_PATH) \
	))
	@ if [[ -f $($@_dist_path)/$(WRAPPER_NAME) ]]; then \
		echo "$(PREFIX_STEP)Purging run wrapper"; \
		rm -f \
			$($@_dist_path)/$(WRAPPER_NAME); \
		if [[ $${?} -eq 0 ]]; then \
			echo "$(PREFIX_SUB_STEP_POSITIVE)Run wrapper Purged"; \
		else \
			echo "$(PREFIX_SUB_STEP_NEGATIVE)Error purging run wrapper"; \
			exit 1; \
		fi; \
	else \
		echo "$(PREFIX_STEP)Purging run wrapper skipped"; \
	fi

rmi: _prerequisites _require-docker-image-tag
	@ if [[ -n $$(if [[ -n $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)) ]]; then echo $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); else echo $$($(docker) images -q docker.io/$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); fi;) ]]; then \
		echo "$(PREFIX_STEP)Untagging image"; \
		echo "$(PREFIX_SUB_STEP)$$(if [[ -n $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)) ]]; then echo $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); else echo $$($(docker) images -q docker.io/$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)); fi;) : $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"; \
		$(docker) rmi \
			$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) 1> /dev/null; \
		if [[ $${?} -eq 0 ]]; then \
			echo "$(PREFIX_SUB_STEP_POSITIVE)Image untagged"; \
		else \
			echo "$(PREFIX_SUB_STEP_NEGATIVE)Error untagging image"; \
			exit 1; \
		fi; \
	else \
		echo "$(PREFIX_STEP)Untagging image skipped"; \
	fi

test: _test-prerequisites
	@ if [[ -z $$(if [[ -n $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):latest) ]]; then echo $$($(docker) images -q $(DOCKER_USER)/$(DOCKER_IMAGE_NAME):latest); else echo $$($(docker) images -q docker.io/$(DOCKER_USER)/$(DOCKER_IMAGE_NAME):latest); fi;) ]]; then \
		$(MAKE) build; \
	fi;
	@ echo "$(PREFIX_STEP)Functional test";
	@ SHPEC_ROOT=$(SHPEC_ROOT) $(shpec);
