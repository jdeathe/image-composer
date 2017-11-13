# Composer Image

Docker image of the [Composer](https://github.com/jadu/meteor) dependency manager for PHP.

*WARNING:* This is currently WIP - NOT ready for general use.

## Supported tags and respective `Dockerfile` links

- `1.5.2-php56`, `latest` [(php56/Dockerfile)](https://github.com/jdeathe/image-composer/blob/master/php56/Dockerfile)
- `1.5.2-php70` [(php70/Dockerfile)](https://github.com/jdeathe/image-composer/blob/master/php70/Dockerfile)
- `1.5.2-php71` [(php71/Dockerfile)](https://github.com/jdeathe/image-composer/blob/master/php71/Dockerfile)

## Extract run template

Run template for use on [Project Atomic's](http://www.projectatomic.io/) based environments where the [`atomic run`](https://github.com/projectatomic/atomic#atomic-run) command is available.

### Pull the image.

```
$ docker pull \
  jdeathe/composer:1.5.2-php56
```

### Inspect the run label.

The run label provides the `docker run` usage template.

```
$ docker inspect \
  --format '{{ .ContainerConfig.Labels.run }}' \
  --type=image \
  jdeathe/composer:1.5.2-php56
```
