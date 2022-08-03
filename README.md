# howto-jira-ubuntu20.04
install standar jira service ...

## 步驟
1. install java: jdk
2. install jira
3. install docker service for database
4. get license (prod. or trial)
5. link to self database
6. setting nginx

## 安裝：JDK
<a href="https://www.oracle.com/java/technologies/downloads/#java11" target="_blank" rel="noopener">oracle java 11 download list</a>

choice { x64 Compressed Archive } <br />
accept the license require... <br />
login your account and start download. <br />


## 設定：Nginx
- install
```bash
:~$ sudo apt update -y

:~$ sudo apt install -y nginx

:~$ sudo systemctl enable nginx & sudo systemctl start nginx
```

- setting
```bash
:~$ sudo vim /etc/nginx/nginx.conf
http {
        log_format compression '$remote_addr - $remote_user [$time_local] '
                       '"$request" $status $bytes_sent '
                       '"$http_referer" "$http_user_agent" "$gzip_ratio"';

        access_log /spool/logs/nginx-access.log compression buffer=32k;
        ...

:~$ sudo vim /etc/nginx/sites-avaliable/jira-confluence
server {
   listen 443 ssl;
   server_name work-zoe.tpigame.com;

   ssl_certificate /etc/ssl/certs/work-zoe.crt;
   ssl_certificate_key /etc/ssl/private/work-zoe.key;
   ssl_session_timeout 10h;
   ssl_session_cache shared:MozSSL:10m; # about 40000 sessions
   ssl_session_tickets off;

   # intermediate configuration
   ssl_protocols TLSv1.2 TLSv1.3;
   ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
   ssl_prefer_server_ciphers off;

   # HSTS (ngx_http_headers_module is required) (63072000 seconds)
   add_header Strict-Transport-Security "max-age=63072000" always;

   # OCSP stapling
   ssl_stapling on;
   ssl_stapling_verify on;

   location /secure/ForgotLoginDetails.jspa {
      return 301 https://work-zoe.tpigame.com;
   }

   location /jira {
      # NGINX usually only allows 1M per request.
      # Increase this to JIRA's maximum attachment size (10M by default)
      client_max_body_size 10M;

      proxy_set_header Host $host:$server_port;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Authorization "";
      proxy_pass http://localhost:8080;
   }

   location /confluence {
      # NGINX usually only allows 1M per request.

      # Increase this to JIRA's maximum attachment size (10M by default)
      client_max_body_size 10M;

      proxy_set_header Host $host:$server_port;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-Server $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Authorization "";
      proxy_pass http://localhost:8090;
   }
}
```

