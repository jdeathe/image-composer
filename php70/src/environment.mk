# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
BUILD_VARIANTS := php72 php71 php70 php56
DOCKER_IMAGE_NAME := composer
DOCKER_IMAGE_RELEASE_TAG_PATTERN := ^[0-9]+\.[0-9]+\.[0-9]+-php[57][0-9]?$
DOCKER_IMAGE_TAG_PATTERN := ^(latest|[0-9]+\.[0-9]+\.[0-9]+-php[57][0-9])?$
DOCKER_USER := jdeathe
SHPEC_ROOT := test/shpec

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
BIN_PREFIX ?= /usr/local
DIST_PATH ?= ./dist
DOCKER_CONTAINER_OPTS ?=
DOCKER_IMAGE_TAG ?= 1.8.6-php70
DOCKER_RESTART_POLICY ?= no
NO_CACHE ?= false
WRAPPER_NAME ?= composer

# ------------------------------------------------------------------------------
# Application container build arguments
# ------------------------------------------------------------------------------
COMPOSER_CACHE_DIR ?= /opt/getcomposer.org/var/cache
COMPOSER_FILENAME ?= composer.phar
COMPOSER_HOME ?= /opt/getcomposer.org/etc
COMPOSER_INSTALL_PATH ?= /opt/getcomposer.org
COMPOSER_VERSION ?= 1.8.6
COMPOSER_WORKSPACE ?= /workspace
PHP_PACKAGE_PREFIX ?= php70
PHP_VERSION ?= 7.0.33

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
