# 
# nginx + quiche build image
#

# build quiche binary
FROM debian:latest AS builder

# dependencies
RUN apt-get update && apt-get install -y cmake golang git curl libpcre3-dev zlib1g-dev

# rust need to be installed via rustup since it requires 1.39
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- --default-toolchain stable -y
ENV PATH=/root/.cargo/bin:$PATH

# build nginx + quiche
WORKDIR /build
RUN git clone --recursive https://github.com/cloudflare/quiche.git && \
    curl -q -s https://nginx.org/download/nginx-1.16.1.tar.gz | tar xzf - && \
    cd nginx-1.16.1 && patch -p1 -i ../quiche/extras/nginx/nginx-1.16.patch

WORKDIR /build/nginx-1.16.1
RUN ./configure \
   	    --with-http_ssl_module \
   	    --with-http_v2_module \
   	    --with-http_v3_module \
   	    --with-openssl=../quiche/deps/boringssl \
   	    --with-quiche=../quiche && \
    make -j`nproc` && \
    make install

# setup binary image
FROM debian:latest

# only runtime for nginx and procps
RUN apt-get update && apt-get install -y ca-certificates libpcre3 zlib1g procps

COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /build/quiche/examples/cert.* /usr/local/nginx/conf/

# copy sample config
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

EXPOSE 8080/tcp
EXPOSE 8443/tcp
EXPOSE 8443/udp

# run ngnix foreground
ENTRYPOINT [ "/usr/local/nginx/sbin/nginx", "-g", "daemon off;" ]
