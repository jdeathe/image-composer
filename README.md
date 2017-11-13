# Composer Image

Docker image of the [Composer](https://github.com/jadu/meteor) dependency manager for PHP.

*WARNING:* This is currently WIP - NOT ready for general use.

## Building

### Clean

```
$ for BUILD_DIR in $(find . -type d -regex '\./php[57][0-9]$' | sed 's~./~~' | sort -r);
  do \
    cd ${BUILD_DIR} && \
    make clean; \
    cd - &> /dev/null; \
  done
```

### Build

```
$ for BUILD_DIR in $(find . -type d -regex '\./php[57][0-9]$' | sed 's~./~~' | sort -r);
  do \
    cd ${BUILD_DIR} && \
    make; \
    cd - &> /dev/null; \
  done
```

### Install

```
$ for BUILD_DIR in $(find . -type d -regex '\./php[57][0-9]$' | sed 's~./~~' | sort -r);
  do \
    cd ${BUILD_DIR} && \
    make install; \
    cd - &> /dev/null; \
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
