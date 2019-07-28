server {
    listen 80;
    index app_dev.php;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/web;

    location / {
            # try to serve file directly, fallback to app.php
            try_files $uri /app.php$is_args$args /app_dev.php$is_args$args;
        }

        # DEV
        location ~ ^/(app_dev|config)\.php(/|$) {
            fastcgi_pass app:9000;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            fastcgi_buffer_size 128k;
            fastcgi_buffers 4 256k;
            fastcgi_busy_buffers_size 256k;
        }

        # PROD
        location ~ ^/app\.php(/|$) {
            fastcgi_pass app:9000;
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
            fastcgi_param DOCUMENT_ROOT $realpath_root;
            fastcgi_buffer_size 128k;
            fastcgi_buffers 4 256k;
            fastcgi_busy_buffers_size 256k;
        }

        location ~ \.php$ {
            return 404;
        }
}
