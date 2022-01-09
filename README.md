# nginx-for-dummy
How to run this repo
 - docker build -t nginx-server .
 - docker run -p 80:80 --name nginx -d nginx-server

## Mime.types
to Handle Content-Type such as: HTML, CSS etc.
if not set the Content-Type will set as text/plain.

## Handle Redirect with 307
Use Case: 
    - Redirect Image

```
 server {
    listen 80;
    server_name localhost;
    root /sites/demo;

    location /logo {
      return 307 /thumb.png;
    }
```