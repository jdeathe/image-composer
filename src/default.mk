
define DOCKER_BUILD_ARGS
--force-rm \
--file $(PHP_PACKAGE_PREFIX)/Dockerfile \
--build-arg "COMPOSER_CACHE_DIR=$(COMPOSER_CACHE_DIR)" \
--build-arg "COMPOSER_FILENAME=$(COMPOSER_FILENAME)" \
--build-arg "COMPOSER_HOME=$(COMPOSER_HOME)" \
--build-arg "COMPOSER_INSTALL_PATH=$(COMPOSER_INSTALL_PATH)" \
--build-arg "COMPOSER_WORKSPACE=$(COMPOSER_WORKSPACE)" \
--build-arg "COMPOSER_VERSION=$(COMPOSER_VERSION)" \
--build-arg "PHP_PACKAGE_PREFIX=$(PHP_PACKAGE_PREFIX)" \
--build-arg "PHP_VERSION=$(PHP_VERSION)"
endef

define DOCKER_CONTAINER_PARAMETERS
--rm \
\$${TTY:+--interactive} \
\$${TTY:+--tty} \
--volume \$${PWD}:/workspace\$${CONSISTENCY:-} \
--volume $(WRAPPER_NAME)-etc:/opt/getcomposer.org/etc\$${CONSISTENCY:-} \
--volume $(WRAPPER_NAME)-\$${PHP_PACKAGE_PREFIX}-cache:/opt/getcomposer.org/var/cache\$${CONSISTENCY:-} \
--env "COMPOSER_ALLOW_SUPERUSER=\"\$${COMPOSER_ALLOW_SUPERUSER:-$(COMPOSER_ALLOW_SUPERUSER)}\"" \
--env "COMPOSER_AUTH=\"\$${COMPOSER_AUTH:-$(COMPOSER_AUTH)}\"" \
--env "COMPOSER_BIN_DIR=\"\$${COMPOSER_BIN_DIR:-$(COMPOSER_BIN_DIR)}\"" \
--env "COMPOSER_CACHE_DIR=\"\$${COMPOSER_CACHE_DIR:-$(COMPOSER_CACHE_DIR)}\"" \
--env "COMPOSER_DISCARD_CHANGES=\"\$${COMPOSER_DISCARD_CHANGES:-$(COMPOSER_DISCARD_CHANGES)}\"" \
--env "COMPOSER_HOME=\"\$${COMPOSER_HOME:-$(COMPOSER_HOME)}\"" \
--env "COMPOSER_HTACCESS_PROTECT=\"\$${COMPOSER_HTACCESS_PROTECT:-$(COMPOSER_HTACCESS_PROTECT)}\"" \
--env "COMPOSER_INSTALL_PATH=\"\$${COMPOSER_INSTALL_PATH:-$(COMPOSER_INSTALL_PATH)}\"" \
--env "COMPOSER_MIRROR_PATH_REPOS=\"\$${COMPOSER_MIRROR_PATH_REPOS:-$(COMPOSER_MIRROR_PATH_REPOS)}\"" \
--env "COMPOSER_NO_INTERACTION=\"\$${COMPOSER_NO_INTERACTION:-$(COMPOSER_NO_INTERACTION)}\"" \
--env "COMPOSER_PROCESS_TIMEOUT=\"\$${COMPOSER_PROCESS_TIMEOUT:-$(COMPOSER_PROCESS_TIMEOUT)}\"" \
--env "COMPOSER_VENDOR_DIR=\"\$${COMPOSER_VENDOR_DIR:-$(COMPOSER_VENDOR_DIR)}\"" \
--env "HTTP_PROXY_REQUEST_FULLURI=\"\$${HTTP_PROXY_REQUEST_FULLURI:-$(HTTP_PROXY_REQUEST_FULLURI)}\"" \
--env "HTTPS_PROXY_REQUEST_FULLURI=\"\$${HTTPS_PROXY_REQUEST_FULLURI:-$(HTTPS_PROXY_REQUEST_FULLURI)}\"" \
--env "http_proxy=\"\$${http_proxy:-$(http_proxy)}\"" \
--env "no_proxy=\"\$${no_proxy:-$(no_proxy)}\""
endef

define DOCKER_IMAGE_TAG_TEMPLATE
$(COMPOSER_VERSION)-\$${PHP_PACKAGE_PREFIX}
endef

define WRAPPER_PRE_RUN
local CONSISTENCY; \
local DOCKER_VERSION=\"\$$(docker version --format '{{.Client.Version}}')\"; \
local -a DOCKER_VERSION_PARTS; \
local PHP_VERSION=\"\$${PHP_VERSION:-$(PHP_VERSION)}\"; \
local PHP_VERSION_SHORT; \
local PHP_PACKAGE_PREFIX=\"php\"; \
local TTY=\"\$$(tty)\"; \
DOCKER_VERSION_PARTS=(\$$(printf -- '%s' \"\$${DOCKER_VERSION//[.-]/ }\")); \
if [[ \$${DOCKER_VERSION_PARTS[0]} -ge 17 ]] \
  && [[ \$${DOCKER_VERSION_PARTS[1]} -ge 06 ]]; then \
  CONSISTENCY=\":cached\"; \
fi; \
if [[ \$${PHP_VERSION} =~ ^[57]\.[0-9]\.[0-9]+$$ ]]; then \
  PHP_VERSION_SHORT=\"\$${PHP_VERSION%.*}\"; \
  PHP_PACKAGE_PREFIX+=\"\$${PHP_VERSION_SHORT//./}\"; \
elif [[ \$${PHP_VERSION} =~ ^[57]\.[0-9]$$ ]]; then \
  PHP_PACKAGE_PREFIX+=\"\$${PHP_VERSION//./}\"; \
elif [[ \$${PHP_VERSION} =~ ^(56|70|71)$$ ]]; then \
  PHP_PACKAGE_PREFIX+=\"\$${PHP_VERSION}\"; \
else \
  PHP_PACKAGE_PREFIX+=\"56\"; \
fi
endef
