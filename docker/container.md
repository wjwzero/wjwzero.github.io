### 导出和导入容器
> $ docker export 1e560fca3906 > ubuntu.tar
### 导入容器快照
> $ cat docker/ubuntu.tar | docker import - test/ubuntu:v1