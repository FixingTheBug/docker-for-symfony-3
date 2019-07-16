Docker containers for Symfony 3.4
====

This repository provides standard containers for Symfony 3.4.

Containers are:

- webserver-tech: Nginx
- app-tech: Php
- db-tech: MySql

Clone the repo and run
```
docker-compose build
```

And then:
```
docker-compose up -d
```

You should be able to access the site at http://localhost:90

### Common problems

- If you have already MySql running on the port 3306, change the port in the docker-compose.yml file

- Same with the port 80: if Apache or any other webservers are running on the port 80, change the port in the docker-compose.yml file

- If you see the error 404, you should check the index path in environment/nginx/conf.d

- For the error 500, open the localhost:90/app_dev.php file and you should be able to see the problem (or open the logs)

- If you receive an error like:
```angular2
  An exception occured in driver: SQLSTATE[HY000] [2002] php_network_getaddresses: getaddrinfo failed: Name or service not known  
```
most probably you have a problem in the database configuration in symfony/app/config/parameters.yml. Run:
```
docker inspect db-tech
```
to find out the gateway IP address of the container. Also, double check the database credentials.

- If you receive the error "You are not allowed to access this file. Check app_dev.php for more information.", inspect your app-tech container and find the gateway IP Address:
```
docker inspect app-tech
```
check your /symfony/web/app_dev.php and modify it with the IP address you found:
```
if (isset($_SERVER['HTTP_CLIENT_IP'])
    || isset($_SERVER['HTTP_X_FORWARDED_FOR'])
    || !(in_array(@$_SERVER['REMOTE_ADDR'], ['127.0.0.1', 'fe80::1', '::1', '172.20.0.1']) || php_sapi_name() === 'cli-server')
) {
    header('HTTP/1.0 403 Forbidden');
    exit('You are not allowed to access this file. Check '.basename(__FILE__).' for more information.');
}
``` 
