ARG PHP_VERSION="5.6.32"

FROM php:${PHP_VERSION}-cli-alpine

ARG COMPOSER_FILENAME="composer.phar"
ARG COMPOSER_INSTALL_PATH="/opt/getcomposer.org"
ARG COMPOSER_VERSION="1.5.6"
ARG COMPOSER_WORKSPACE="/workspace"
ARG PHP_PACKAGE_PREFIX="php56"
ARG PHP_VERSION
ARG RUN_WRAPPER_DIST_PATH="/opt/deathe.org-run-wrapper"
ARG RUN_WRAPPER_NAME="composer"

ARG COMPOSER_CACHE_DIR="${COMPOSER_INSTALL_PATH}/var/cache"
ARG COMPOSER_HOME="${COMPOSER_INSTALL_PATH}/etc"
ARG COMPOSER_RELEASE_URI="https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/${COMPOSER_FILENAME}"
ARG RELEASE_VERSION="${COMPOSER_VERSION}-${PHP_PACKAGE_PREFIX}"

COPY src \
	/tmp/src/

RUN \
	apk add \
		--update \
		--no-cache \
		ca-certificates \
		curl \
		freetype \
		git \
		libjpeg-turbo \
		libmcrypt \
		libpng \
		openssh \
		openssl \
	&& update-ca-certificates \
	&& apk add \
		--no-cache \
		--virtual .build-deps \
		autoconf \
		automake \
		bash \
		curl-dev \
		freetype-dev \
		gcc \
		g++ \
		libjpeg-turbo-dev \
		libmcrypt-dev \
		libpng-dev \
		make \
		pcre-dev \
		pkgconfig \
		re2c \
		zlib-dev \
	&& if [[ ${PHP_VERSION%%.*} == 5 ]]; \
		then \
			pecl install apcu-4.0.11; \
		else \
			pecl install apcu-5.1.8; \
		fi \
	&& docker-php-ext-enable \
		apcu \
	&& if [[ ${PHP_VERSION%.*} != 7.2 ]]; \
		then \
			docker-php-ext-install \
				mcrypt; \
		fi \
	&& docker-php-ext-configure \
		gd \
			--with-gd \
			--with-freetype-dir=/usr/include/ \
			--with-png-dir=/usr/include/ \
			--with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install \
		bcmath \
		gd \
		opcache \
		zip \
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
		'date.timezone=%s\n' \
		"${PHP_TIMEZONE:-UTC}" \
		> "${PHP_INI_DIR}/conf.d/date.ini" \
	&& printf -- \
		'memory_limit=-1\n' \
		> "${PHP_INI_DIR}/conf.d/resource-limits.ini" \
	&& printf -- \
		'%s\n%s\n%s\n' \
		"opcache.enable_cli=1" \
		"opcache.max_accelerated_files=32531" \
		> ${PHP_INI_DIR}/conf.d/opcache.ini \
	&& mkdir -p \
		"${RUN_WRAPPER_DIST_PATH}" \
	&& cd /tmp/src \
	&& DIST_PATH="${RUN_WRAPPER_DIST_PATH}" \
		WRAPPER_NAME="${RUN_WRAPPER_NAME}" \
		make build-wrapper \
	&& apk del \
		.build-deps \
	&& rm -rf \
		/tmp/* \
		/var/cache/apk/*

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
	install="\
docker run \
--rm \
--entrypoint /bin/cat \
jdeathe/composer:${RELEASE_VERSION} \
${RUN_WRAPPER_DIST_PATH}/${RUN_WRAPPER_NAME} \
> /usr/local/bin/${RUN_WRAPPER_NAME} \
&& chmod 766 /usr/local/bin/${RUN_WRAPPER_NAME}" \
	uninstall="\
rm -f /usr/local/bin/${RUN_WRAPPER_NAME}" \
	org.deathe.name="composer" \
	org.deathe.version="${RELEASE_VERSION}" \
	org.deathe.release="jdeathe/composer:${RELEASE_VERSION}" \
	org.deathe.license="MIT" \
	org.deathe.vendor="jdeathe" \
	org.deathe.url="https://github.com/jdeathe/image-composer" \
	org.deathe.description="Alpine - PHP CLI ${PHP_VERSION} / Composer ${COMPOSER_VERSION}."

WORKDIR \
	"${COMPOSER_WORKSPACE}"

ENTRYPOINT \
	["php", "/usr/local/bin/composer"]

CMD \
	["--help"]