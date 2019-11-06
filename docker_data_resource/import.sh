#!/bin/bash

# 文件目录
base_url="/data1/export"
# redis容器名称或者id
redis_container_name="redis-default-pre.itms.cn"
# es 访问地址
es_url="http://localhost:9200"
# mysql容器名称或者id
mysql_container_name="mysql-default-pre.itms.cn"
# mysql 连接信息
mysql_host="rm-wz9l8me99g3935pm7.mysql.rds.aliyuncs.com"
mysql_root="root"
mysql_password="jimi@itms1"
#导入redis
docker exec -i ${redis_container_name} redis-cli -a jimi@redis flushall
docker exec -i ${redis_container_name} redis-cli -a jimi@redis --pipe <${base_url}/redis/appendonly.aof

# 导入mysql
database_array=("itms_async_manage" "itms_authorizeation" "itms_core_device" "itms_device_proxy" "itms_id_generator" "itms_pay_prod" "itms_report")
for database_name in ${database_array[*]}; do
    echo "正在处理:${database_name}"
    sudo docker exec -i ${mysql_container_name} mysql -h${mysql_host} -u${mysql_root} -p${mysql_password} <<<"DROP DATABASE IF EXISTS ${database_name};CREATE DATABASE ${database_name} CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';"
    sudo docker exec -i ${mysql_container_name} mysql -h${mysql_host} -u${mysql_root} -p${mysql_password} ${database_name} <${base_url}/mysql/${database_name}.sql
done

# 删除es索引
curl -XDELETE "${es_url}/_all"

# 导入es
# mapping
docker run --net=host --rm -ti -v ${base_url}/es:/tmp taskrabbit/elasticsearch-dump \
multielasticdump \
--direction=load \
--output=${es_url} \
--input=/tmp/

echo "除设备解绑日志数据，其他数据都已导入"

docker run --net=host --rm -ti -v /tmp:/tmp taskrabbit/elasticsearch-dump \
--input=/tmp/device_unbind_inforom_mapping.json \
--output=${es_url}/device_unbind_inforom \
--type=mapping

docker run --net=host --rm -ti -v /tmp:/tmp taskrabbit/elasticsearch-dump \
--input=/tmp/device_unbind_inforom.json \
--limit=10000 \
--output=${es_url}/device_unbind_inforom \
--type=data
