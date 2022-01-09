# nginx-for-dummy
How to run this repo
 - docker-compose up

## Mime.types
to Handle Content-Type such as: HTML, CSS etc.
if not set the Content-Type will set as text/plain.

How to know That:

 ```
curl -I http://localhost/style.css

 HTTP/1.1 200 OK
Server: nginx/1.21.5
Date: Sun, 09 Jan 2022 05:40:56 GMT
Content-Type: text/css
Content-Length: 980
Last-Modified: Thu, 12 Apr 2018 19:12:50 GMT
Connection: keep-alive
ETag: "5acfafb2-3d4"
Accept-Ranges: bytes
```

## Prefix Match in Location Block
```
# Prefix Match
    location /greet {
        return 200 'Hello NGINX "/greet" location.';
# }

# Preferential Prefix Match
    location ^~ /Greet2 {
       return 200 'Hello NGINX "/greet" location.';
# }

# Exact Match
    location = /greet {
       return 200 'Hello NGINX "/greet" location. EXACT-MATCH';
# }

# REGEX Match (case sensitive)
    location ~ /greet[0-9] {
       return 200 'Hello NGINX "/greet" location. REGEX-MATCH SENSITIVE';
# }

# REGEX Match (case INsensitive)
    location ~* /greet[0-9] {
       return 200 'Hello NGINX "/greet" location. REGEX-MATCH INSENSITIVE';
# }

```


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

# Try_Files Redirect
try_files redirective will redirect and rewrite if path not found

```
server {
    try_files path1 path2 final;
    //OR
    location / {
        try_files path1 path2 final;
    }
}
```

in our case we will implement this case
```
try_files $uri /cat.png /greet /friendly_404; //cat.png is not-found

location /greet {
    return 200 'Hello User';
}
location /friendly_404 {
    return 404 'Sorry, that file you search is not found';
}
```

# Directives

```
######## (1) Array Directive ########
# Can be specified multiple times without ovveriding a previous setting
# Gets inherited by all child context
# Child context can ovveride inheritance by re-declaring directive
####################################
acces_log /var/log/nginx/access.log;
access_log /var/log/nginx/custom.log.gz custom_format;

http {

    # Include statement - non directive
    include mime.types;

    server {
        listen 80;
        server_name site1.com;

        # Inherits access_log from parent context (1)
    }

    server {
        listen 80;
        server_name site2.com;

        ######## (2) Standart Directive ########
        # Can only be declared once. A second declaration ovverides the first.
        # Get inheritanced by all child context
        # Child context can ovveride inheritance by re-declaring directive
        ####################################
        root /site/site2;

        # Completely ovverides inheritances from (1)
        access_log off;

        location /image {
            # Uses root directive inherited from (2)
            try_files $uri /stock.png;
        }
        
        location /secret {
            ######## (3) Action Directive ########
            # invokes an action such as rewrite or redirect
            # Inheritance does not apply as the request is either stopped (redirect/response) or re-evaluated (re-write)
            ####################################
            return 403 'You do not have permission to view this.';
        }
    }
}