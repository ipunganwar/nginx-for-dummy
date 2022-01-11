# Load Balancer

## Source :
 - http://nginx.org/en/docs/http/load_balancing.html
 - https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/

## Our Use-Case
How to use:
`git clone && cd load-balancer-sample`


### Using PHP Sample
We will create 3 web-server using php & make sure to create response file and running server:
- `echo 'PHP Server 1' > s1` -> `php -S localhost:10001 s1`
- `echo 'PHP Server 2' > s2` -> `php -S localhost:10002 s2`
- `echo 'PHP Server 3' > s3` -> `php -S localhost:10003 s3` 

Then checking response from each server:
    - `cat s1` OR `curl http://localhost:10001`
    ```
        PHP Server 1
    ```
    - `cat s2` OR `curl http://localhost:10002`
    ```
        PHP Server 2
    ```
    - `cat s3` OR `curl http://localhost:10003`
    ```
        PHP Server 3
    ```

### Nginx Conf
Then install `brew install nginx`

First we need to testing our configuration has been running:
- `nginx -c $PWD/testing-php-resp.conf`
- `curl http://localhost:8888`

The output like this:
```
PHP Server 1
```
If this one has been expected, then stop our nginx for a while: `nginx -s stop`


## Load Balancer Main Use-Case
- `nginx -c $PWD/load-balancer.conf`

### BASH
- `while sleep 0.5; do curl http://localhost:8888; done`

### ZSH
- `while true; do curl http://localhost:8888; sleep 0.5; done`

```
Output

PHP Server 2
PHP Server 3
PHP Server 1
PHP Server 2
PHP Server 3
PHP Server 1
PHP Server 2
PHP Server 3
PHP Server 1
PHP Server 2
```

Then we can stop PHP Server 3, it will come like this:
```
PHP Server 2
PHP Server 1
PHP Server 2
PHP Server 1
PHP Server 2
PHP Server 1
PHP Server 2
PHP Server 1
PHP Server 2
```

# Load Balance Upstream Options
## Sticky Sessions (ip hash)
The server will only serve from 1 webserver, relly from session user.

```
upstream php_servers {
    ip_hash;
    server localhost:10001;
    server localhost:10002;
    server localhost:10003;
  }
```

run:
- `nginx -c $PWD/load-balancer-sticky.conf`
- `while true; do curl http://localhost:8888; sleep 0.5; done`

The output like this:
```
PHP Server 2
PHP Server 2
PHP Server 2
PHP Server 2
PHP Server 2
PHP Server 2
PHP Server 2
```

Then i try to down PHP Server 2, the output like this:
```
PHP Server 1
PHP Server 1
PHP Server 1
PHP Server 1
PHP Server 1
```

## Active Connections

nginx config
```
http {
    upstream php_servers {
    least_conn;
    server localhost:10001;
    server localhost:10002;
    server localhost:10003;
  }
}
```
run:
- `nginx -c $PWD/load-balancer.conf`
- `php -S localhost:10002 slow.php`
- `while true; do curl http://localhost:8888; sleep 1; done`


```
leepy server finally done! 
PHP Server 2
PHP Server 3
PHP Server 3
PHP Server 2
```