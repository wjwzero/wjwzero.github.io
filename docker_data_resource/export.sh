#!/bin/bash
# 文件目录
base_url="/data1/export"
dir_array=("redis" "es" "mysql")
# redis aof 地址
redis_aof_url="/mnt/acs_mnt/nas/data/redis-default"
# es 访问地址
es_url="http://localhost:9200"
# mysq 容器名称获取容器Id
mysql_container_name="mysql-default.itms.cn"
for dir in ${dir_array[*]}; do
    if [ ! -d "${base_url}/${dir}/" ]; then
        mkdir ${base_url}"/"${dir}
    else
        rm -rf ${base_url}/${dir}/*
    fi
done

# 导出redis
cp ${redis_aof_url}/appendonly.aof /data1/export/redis/appendonly.aof

# 导出数据库脚本文件
database_array=("itms_async_manage" "itms_authorizeation" "itms_core_device" "itms_device_proxy" "itms_id_generator" "itms_pay_prod" "itms_report")
for database_name in ${database_array[*]}; do
    echo "正在处理:$database_name"
    sudo docker exec -i ${mysql_container_name} mysqldump -uroot -pjimi@itms ${database_name} >/data1/export/mysql/${database_name}.sql
done

# 导出es
# --match='^((?!inforom).)*$' \   不匹配device_unbind_inforom(设备解绑)
docker run --net=host --rm -ti -v ${base_url}/es:/tmp taskrabbit/elasticsearch-dump \
multielasticdump \
--direction=dump \
--match='^((?!inforom).)*$' \  
--input=${es_url} \
--output=/tmp/

echo "除设备解绑日志数据，其他数据都已导出"

## 单独导出device_unbind_inforom
docker run --net=host --rm -ti -v /tmp:/tmp taskrabbit/elasticsearch-dump \
--input=${es_url}/device_unbind_inforom \
--output=/tmp/device_unbind_inforom_mapping.json \
--type=mapping

docker run --net=host --rm -ti -v /tmp:/tmp taskrabbit/elasticsearch-dump \
--input=${es_url}/device_unbind_inforom \ 
--output=/tmp/device_unbind_inforom.json \
--type=data
