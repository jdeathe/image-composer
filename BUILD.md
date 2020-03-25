# Building

To build all images for supported PHP versions the following Makefile targets are available.

For further details about usage of the Makefile run `make help`.

## Clean all

Optionally, remove existing images before building.

```
$ make clean-all
```

## Build all

Build all supported image variants.

**Note:** If you have set `COMPOSER_AUTH` in your environment the build may fail at the "Building run wrapper" step with the error `File name too long`. If this is the case you should simply unset the environment variable for the current session before building. i.e. `$ unset COMPOSER_AUTH`.

```
$ make build-all
```
