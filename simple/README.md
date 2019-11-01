# A Sample Docker containter for testing quiche

## Build

```
docker build -t quiche-simple .
```

## Server

Run quiche http3 server as follows:

```
$ docker run -e RUST_LOG=info -p 127.0.0.1:8443:8443/udp -t quiche-simple /quiche/http3-server --listen 0.0.0.0:8443 --root /quiche/examples
```

You can run quiche client using same docker container:

```
$ docker run -e RUST_LOG=info -t quiche-simple /quiche/http3-client --no-verify https://host.docker.internal:8443/test.html
[2019-11-01T00:05:39.555435685Z INFO  http3_client] connecting to 192.168.65.2:8443 from 172.17.0.3:46454 with scid 4b05b565408f6040297731f858146a5f3342efd4
[2019-11-01T00:05:39.570349751Z INFO  http3_client] sending HTTP request [Header(":method", "GET"), Header(":scheme", "https"), Header(":authority", "host.docker.internal"), Header(":path", "/test.html"), Header("user-agent", "quiche")]
[2019-11-01T00:05:39.574262116Z INFO  http3_client] got response headers [Header(":status", "200"), Header("server", "quiche"), Header("content-length", "14")] on stream id 0
Hello HTTP/3!
[2019-11-01T00:05:39.574338057Z INFO  http3_client] 1/1 response(s) received in 18.728663ms, closing...
[2019-11-01T00:05:39.740110276Z INFO  http3_client] connection closed, recv=9 sent=14 lost=0 rtt=7.988284ms cwnd=16109
```

`test.html` contains `Hello HTTP/3!` so you can see this is working.

On the other hand server log looks like this:

```
[2019-11-01T00:05:39.557772556Z WARN  http3_server] Doing version negotiation
[2019-11-01T00:05:39.559191491Z WARN  http3_server] Doing stateless retry
[2019-11-01T00:05:39.571958379Z INFO  http3_server] a1910884e4780d88cd5ccd0622aecc9a5416c48f got request [Header(":method", "GET"), Header(":scheme", "https"), Header(":authority", "host.docker.internal"), Header(":path", "/test.html"), Header("user-agent", "quiche")] on stream id 0
[2019-11-01T00:05:39.720209151Z INFO  http3_server] a1910884e4780d88cd5ccd0622aecc9a5416c48f connection collected recv=12 sent=9 lost=0 rtt=6.703525ms cwnd=16938
```

Don't forget to kill the container if it's still running.

## Client

You can use quiche client to access outside hosts.

```
$ docker run -e RUST_LOG=info -t quiche-simple /quiche/http3-client --no-verify https://blog.cloudflare.com
[2019-11-01T00:06:58.518131059Z INFO  http3_client] connecting to 104.18.26.46:443 from 172.17.0.3:49381 with scid 99b575d137ea258fd7e107cb8a0ddfb55459840e
[2019-11-01T00:06:58.591300466Z INFO  http3_client] sending HTTP request [Header(":method", "GET"), Header(":scheme", "https"), Header(":authority", "blog.cloudflare.com"), Header(":path", "/"), Header("user-agent", "quiche")]
[2019-11-01T00:06:59.041537656Z INFO  http3_client] got response headers [Header(":status", "200"), Header("date", "Fri, 01 Nov 2019 00:06:58 GMT"), Header("content-type", "text/html; charset=utf-8"), Header("set-cookie", "__cfduid=d261494133a1b9df8483b991d66dbab561572566818; expires=Sat, 31-Oct-20 00:06:58 GMT; path=/; domain=.blog.cloudflare.com; HttpOnly; Secure"), Header("x-powered-by", "Express"), Header("cache-control", "public, max-age=60"), Header("vary", "Accept-Encoding"), Header("cf-cache-status", "REVALIDATED"), Header("expires", "Fri, 01 Nov 2019 00:07:58 GMT"), Header("alt-svc", "h3-23=\":443\"; ma=86400"), Header("expect-ct", "max-age=604800, report-uri=\"https://report-uri.cloudflare.com/cdn-cgi/beacon/expect-ct\""), Header("server", "cloudflare"), Header("cf-ray", "52e9a0384d157f0a-SFO-DOG")] on stream id 0

...

</script>

</body>

[2019-11-01T00:06:59.082492273Z INFO  http3_client] 1/1 response(s) received in 564.196497ms, closing...
[2019-11-01T00:06:59.290486166Z INFO  http3_client] connection closed, recv=62 sent=37 lost=0 rtt=24.484129ms cwnd=16033
```
