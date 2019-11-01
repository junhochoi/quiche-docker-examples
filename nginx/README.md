# A Sample Docker Container for nginx + quiche

To use docker hub image without local build, use
`junhochoi/quiche-docker-examples:nginx` as an image name.

## Build

```
docker build -t quiche-nginx .
```

## Run

The following command will run nginx into background. You may change the command line
options as follows:

- Document root directory will be host's current directory. Change `$(pwd)` to other document root directory.
- `127.0.0.1:8443/udp` will servce http/3 traffic. Change `-p 127.0.0.1:8443:8443/udp` line to change which port of host to listen http3
- `127.0.0.1:8443/tcp` will servce http/2 traffic. Change `-p 127.0.0.1:8443:8443/tcp` line to change which port of host to listen http2
- `127.0.0.1:8080/tcp` will servce http 1.1 (plaintext) traffic. Change `-p 127.0.0.1:8080:8080/tcp` line to change which port of host to listen http

```
docker run -d -v $(pwd):/usr/local/nginx/html -p 127.0.0.1:8443:8443/udp -p 127.0.0.1:8443:8443/tcp -p 127.0.0.1:8080:8080/tcp -it nginx-quiche
```

After running this, you can run the following command to check the service is running.
Assuming you have [curl + http3](https://github.com/curl/curl/blob/master/docs/HTTP3.md) installed.

```
curl https://127.0.0.1:8080
curl --http2 -k https://127.0.0.1:8443
curl --http3 -k https://127.0.0.1:8443
```

or you can use curl and simple container in this repository.
