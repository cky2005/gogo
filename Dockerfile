FROM alpine:3.6

ENV VER=2.45 PORT=8080 ID=23ad6b10-8d1a-40f7-8ad0-e3e35cd38297

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && mkdir -m 777 /v2raybin \ 
 && cd /v2raybin \
 && curl -L -H "Cache-Control: no-cache" -o v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip \
 && unzip v2ray.zip \
 && mv /v2raybin/v2ray-v$VER-linux-64/v2ray /v2raybin/ \
 && cp /v2raybin/v2ray-v$VER-linux-64/vpoint_vmess_freedom.json /v2raybin/config.json \
 && sed -i "s/\/var\/log\/v2ray\/access.log//" /v2raybin/config.json \
 && sed -i "s/\/var\/log\/v2ray\/error.log//" /v2raybin/config.json \
 && sed -i "s/warning//" /v2raybin/config.json \
 && sed -i "s/10086/$PORT/g" /v2raybin/config.json \
 && sed -i "s/23ad6b10-8d1a-40f7-8ad0-e3e35cd38297/$ID/g" /v2raybin/config.json \
 && chmod +x /v2raybin/v2ray \
 && rm -rf v2ray.zip \
 && rm -rf v2ray-v$VER-linux-64 \
 && chgrp -R 0 /v2raybin \
 && chmod -R g+rwX /v2raybin
 
COPY ./entrypoint.sh /

RUN chmod +x /entrypoint.sh 

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE $PORT
