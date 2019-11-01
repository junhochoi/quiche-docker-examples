# A Sample Docker containter for curl + quiche

To use docker hub image without local build, use
`junhochoi/quiche-docker-examples:curl` as an image name.

## Build

```
docker build -t quiche-curl .
```

It always build latest quiche and curl.

## Run

```
docker run -it quiche-curl curl --http3 https://cloudflare-quic.com
```
