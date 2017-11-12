ARG PHP_VERSION="5.6.32"

FROM php:${PHP_VERSION}-cli-alpine

ARG COMPOSER_FILENAME="composer.phar"
ARG COMPOSER_INSTALL_PATH="/opt/getcomposer.org"
ARG COMPOSER_VERSION="1.5.2"
ARG COMPOSER_WORKSPACE="/workspace"
ARG PHP_PACKAGE_PREFIX="php56"

ARG COMPOSER_CACHE_DIR="${COMPOSER_INSTALL_PATH}/var/cache"
ARG COMPOSER_HOME="${COMPOSER_INSTALL_PATH}/etc"
ARG COMPOSER_RELEASE_URI="https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/${COMPOSER_FILENAME}"

RUN \
	apk add \
		--update \
		--no-cache \
		ca-certificates \
		curl \
		git \
		libmcrypt \
		openssh \
		openssl \
	&& update-ca-certificates \
	&& apk add \
		--no-cache \
		--virtual .build-deps \
		autoconf \
		automake \
		curl-dev \
		gcc \
		g++ \
		libmcrypt-dev \
		make \
		pcre-dev \
		pkgconfig \
		re2c \
		zlib-dev \
	&& pecl install \
		apcu-4.0.10 \
	&& docker-php-ext-enable \
		apcu \
	&& docker-php-ext-install \
		bcmath \
		mcrypt \
		opcache \
		zip \
	&& apk del \
		.build-deps \
	&& rm -rf \
		/tmp/* \
		/var/cache/apk/* \
	&& mkdir -p \
		"${COMPOSER_WORKSPACE}" \
	&& mkdir -p \
		"${COMPOSER_INSTALL_PATH}"/bin \
	&& mkdir -p \
		"${COMPOSER_CACHE_DIR}" \
	&& mkdir -p \
		"${COMPOSER_HOME}" \
	&& curl \
		-o "${COMPOSER_INSTALL_PATH}"/"${COMPOSER_FILENAME}" \
		-sfLO \
		"${COMPOSER_RELEASE_URI}" \
	&& install \
		"${COMPOSER_INSTALL_PATH}"/"${COMPOSER_FILENAME}" \
		"${COMPOSER_INSTALL_PATH}"/bin/composer \
	&& ln -sf \
		"${COMPOSER_INSTALL_PATH}"/bin/composer \
		/usr/local/bin/composer \
	&& printf -- \
		'memory_limit=-1\n' \
		> "${PHP_INI_DIR}/conf.d/memory-limit.ini" \
	&& printf -- \
		'date.timezone=%s\n' \
		"${PHP_TIMEZONE:-UTC}" \
		> "${PHP_INI_DIR}/conf.d/date_timezone.ini"

ENV \
	COMPOSER_ALLOW_SUPERUSER="1" \
	COMPOSER_AUTH="" \
	COMPOSER_BIN_DIR="vendor/bin" \
	COMPOSER_CACHE_DIR="${COMPOSER_CACHE_DIR}" \
	COMPOSER_DISCARD_CHANGES="false" \
	COMPOSER_HOME="${COMPOSER_HOME}" \
	COMPOSER_HTACCESS_PROTECT="0" \
	COMPOSER_INSTALL_PATH="${COMPOSER_INSTALL_PATH}" \
	COMPOSER_MIRROR_PATH_REPOS="0" \
	COMPOSER_NO_INTERACTION="0" \
	COMPOSER_PROCESS_TIMEOUT="300" \
	COMPOSER_VENDOR_DIR="vendor" \
	COMPOSER_VERSION="${COMPOSER_VERSION}" \
	HTTP_PROXY_REQUEST_FULLURI="0" \
	HTTPS_PROXY_REQUEST_FULLURI="0" \
	http_proxy="" \
	no_proxy=""

ARG RELEASE_VERSION="${COMPOSER_VERSION}-${PHP_PACKAGE_PREFIX}"
LABEL \
	maintainer="James Deathe <james.deathe@gmail.com>" \
	run="\
docker run \
--rm \
--interactive \
--tty \
--volume \${PWD}:/workspace \
--volume composer-etc:/opt/getcomposer.org/etc \
--volume composer-${PHP_PACKAGE_PREFIX}-cache:/opt/getcomposer.org/var/cache \
jdeathe/composer:${RELEASE_VERSION}" \
	org.deathe.name="composer" \
	org.deathe.version="${RELEASE_VERSION}" \
	org.deathe.release="jdeathe/composer:${RELEASE_VERSION}" \
	org.deathe.license="MIT" \
	org.deathe.vendor="jdeathe" \
	org.deathe.url="https://github.com/jdeathe/composer" \
	org.deathe.description="Alpine - PHP CLI ${PHP_VERSION} / Composer ${COMPOSER_VERSION}."

WORKDIR \
	"${COMPOSER_WORKSPACE}"

ENTRYPOINT \
	["php", "/usr/local/bin/composer"]

CMD \
	["--help"]