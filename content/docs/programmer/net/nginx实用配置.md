title: nginx实用配置
date: 2023-09-24 23:01:41
categories: [nginx]
tags: [nginx]

from: [这里](https://blog.csdn.net/weixin_44779019/article/details/102027039?ydreferer=aHR0cHM6Ly9jbi5iaW5nLmNvbS8%3D)

```nginx
	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}
	location /test_vul_id_1000003 {
		alias /home/test_vul_id_1000003;
		autoindex on;
	}
```
```nginx
	location /test_vul_id_1000003 {
		root /home;
		autoindex on;
	}
```

## 非以上配置访问404原因
```nginx
	location /test_vul_id_1000003 {
		root /home/test_vul_id_1000003;
		autoindex on;
	}
```
如以上配置, `nginx` 配置文件会将 `root` 加上 以上的 `localtion` , 导致访问时实际定位是 `/home/test_vul_id_1000003/test_vul_id_1000003` 所以就 `404` 了


## 生效命令
```bash
nginx -t
nginx -s reload
service nginx restart
```
