# Composer Image

Docker image of the [Composer](https://github.com/jadu/meteor) dependency manager for PHP.

*WARNING:* This is currently WIP - NOT ready for general use.

## Building

### Remove local image tags

```
$ for VERSION in 7.1.11 7.0.25 5.6.32; \
  do \
    COMPOSER_VERSION=1.5.2 \
    PHP_VERSION=${VERSION} \
    PHP_PACKAGE_PREFIX=php${${PHP_VERSION%.*}//./} \
    DOCKER_IMAGE_TAG=${COMPOSER_VERSION}-${PHP_PACKAGE_PREFIX} \
    make clean; \
  done
```

### Build image tags

```
$ for VERSION in 7.1.11 7.0.25 5.6.32; \
  do \
    COMPOSER_VERSION=1.5.2 \
    PHP_VERSION=${VERSION} \
    PHP_PACKAGE_PREFIX=php${${PHP_VERSION%.*}//./} \
    DOCKER_IMAGE_TAG=${COMPOSER_VERSION}-${PHP_PACKAGE_PREFIX} \
    make; \
  done
```

### Build local binary

```
$ for VERSION in 7.1.11 7.0.25 5.6.32; \
  do \
    COMPOSER_VERSION=1.5.2 \
    PHP_VERSION=${VERSION} \
    PHP_PACKAGE_PREFIX=php${${PHP_VERSION%.*}//./} \
    DOCKER_IMAGE_TAG=${COMPOSER_VERSION}-${PHP_PACKAGE_PREFIX} \
    make install; \
  done
```

## Extract run template

Run template for use on [Project Atomic's](http://www.projectatomic.io/) based environments.

```
$ docker inspect \
  --format '{{ .ContainerConfig.Labels.run }}' \
  --type=image \
  jdeathe/composer:1.5.2-php56
```

## Extract image description

```
$ docker inspect \
  --format '{{ index .ContainerConfig.Labels "org.deathe.description" }}' \
  --type=image \
  jdeathe/composer:1.5.2-php56
```
