# A Sample Docker containter for curl + quiche

## Build

```
docker build -t quiche-curl .
```

It always build latest quiche and curl.

## Run

```
docker run -it quiche-curl curl --http3 https://cloudflare-quic.com
```
