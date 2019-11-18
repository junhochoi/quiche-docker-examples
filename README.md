# Docker Examples for quiche

Here is a collection of Dockerfile for various quiche use, as the following:

- curl/ curl + quiche for http3 client
- nginx/ nginx + quiche for http3 server
- simple/ quiche command line server and clients

Please read README.md file in each directory for instructions.

To build images, please run the following:

```
$ make
```

Or you can build individual images, as follows:

```
$ make simple
$ make nginx
$ make curl
```

Those images are available on Docker Hub so you can pull it instead of building locally:

- https://cloud.docker.com/repository/registry-1.docker.io/junhochoi/quiche-docker-examples

Note: this is not for your production use.
