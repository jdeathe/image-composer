# -----------------------------------------------------------------------------
# Constants
# -----------------------------------------------------------------------------
BUILD_VARIANTS := php71 php70 php56
DOCKER_USER := jdeathe
DOCKER_IMAGE_NAME := composer
SHPEC_ROOT := test/shpec

# Tag validation patterns
DOCKER_IMAGE_TAG_PATTERN := ^(latest|[0-9]+\.[0-9]+\.[0-9]+-php[57][0-9])?$
DOCKER_IMAGE_RELEASE_TAG_PATTERN := ^[0-9]+\.[0-9]+\.[0-9]+-php[57][0-9]?$

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

# Docker image/container settings
DOCKER_CONTAINER_OPTS ?=
DOCKER_IMAGE_TAG ?= 1.5.2-php71
DOCKER_RESTART_POLICY ?= no

# Package install settings
BIN_PREFIX ?= /usr/local
WRAPPER_NAME ?= composer

# Docker build --no-cache parameter
NO_CACHE ?= false

# Directory path for release packages
DIST_PATH ?= ./dist

# Number of seconds expected to complete container startup including bootstrap.
STARTUP_TIME ?= 2

# ------------------------------------------------------------------------------
# Application container build arguments
# ------------------------------------------------------------------------------
COMPOSER_CACHE_DIR ?= /opt/getcomposer.org/var/cache
COMPOSER_FILENAME ?= composer.phar
COMPOSER_HOME ?= /opt/getcomposer.org/etc
COMPOSER_INSTALL_PATH ?= /opt/getcomposer.org
COMPOSER_VERSION ?= 1.5.2
COMPOSER_WORKSPACE ?= /workspace
PHP_PACKAGE_PREFIX ?= php71
PHP_VERSION ?= 7.1.11

# ------------------------------------------------------------------------------
# Application container configuration
# ------------------------------------------------------------------------------
COMPOSER_ALLOW_SUPERUSER ?= 1
COMPOSER_AUTH ?=
COMPOSER_BIN_DIR ?= vendor/bin
COMPOSER_DISCARD_CHANGES ?= false
COMPOSER_HTACCESS_PROTECT ?= 0
COMPOSER_MIRROR_PATH_REPOS ?= 0
COMPOSER_NO_INTERACTION ?= 0
COMPOSER_PROCESS_TIMEOUT ?= 300
COMPOSER_VENDOR_DIR ?= vendor
HTTP_PROXY_REQUEST_FULLURI ?= 0
HTTPS_PROXY_REQUEST_FULLURI ?= 0
http_proxy ?= 
no_proxy ?=
