# Building

To build all images for support PHP versions the following bash snippets can be used to run the Make targets.

## Clean

Optionally, remove existing images before building.

```
$ for BUILD_DIR in $(find . -type d -regex '\./php[57][0-9]$' | sed 's~./~~' | sort -r);
  do \
    cd ${BUILD_DIR} && \
    make clean; \
    cd - &> /dev/null; \
  done
```

## Build

Build all supported image variants.

```
$ for BUILD_DIR in $(find . -type d -regex '\./php[57][0-9]$' | sed 's~./~~' | sort -r);
  do \
    cd ${BUILD_DIR} && \
    make; \
    cd - &> /dev/null; \
  done
```

## Install

Generate and install the binary on host.

```
$ make install
```