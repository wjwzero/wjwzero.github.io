## 阿里云nginx获取真实IP    
    set_real_ip_from 0.0.0.0/0;
    real_ip_header  X-Forwarded-For;
    
## 阿里云nginx websocket配置


    http块加入:
    
        map $http_upgrade $connection_upgrade {
            default upgrade;
            ''      close;
        }
    
    server_location 块加入:
    
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";    