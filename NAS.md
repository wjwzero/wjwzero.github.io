### ECS挂载 阿里云NAS

+ CentOS 安装NFS客户端
```
sudo yum install nfs-utils
```
+ 修改同时发起NFS请求数量; 如何修改同时发起的NFS请求数量 建议使用方法二 无需重启服务器 
    1. 安装NFS客户端，详情请参见安装NFS客户端。
    2. 执行以下命令，修改同时发起的NFS请求数量。
        ```  
            echo "options sunrpc tcp_slot_table_entries=128" >> /etc/modprobe.d/sunrpc.conf
            echo "options sunrpc tcp_max_slot_table_entries=128" >>  /etc/modprobe.d/sunrpc.conf
            // 说明 您只需在首次安装NFS客户端后执行一次此操作（必须通过root用户操作），之后无需重复执行。
        ```
    3. 挂载文件系统，详情请参见挂载NFS文件系统。
    4. 执行以下命令，再次修改同时发起的NFS请求数量。
        ```
            sysctl -w sunrpc.tcp_slot_table_entries=128
        ```
    5. 卸载文件系统，详情请参见在Linux系统中卸载文件系统。
    6. 重新挂载文件系统，详情请参见挂载NFS文件系统。
    7. 执行以下命令查看修改结果。
        ```
            // 如果返回值为128，则说明修改成功。
            cat /proc/sys/sunrpc/tcp_slot_table_entries
        ```
参考 
> https://help.aliyun.com/knowledge_detail/125389.html#task-1130493 
 
 
+ 挂载NAS 挂载命令 (阿里云NAS 控制台中的挂载命令  /mnt 宿主机目录)
```
sudo mount -t nfs -o vers=3,nolock,proto=tcp,noresvport xxxxxxx.cn-shenzhen.nas.aliyuncs.com:/ /mnt
``` 

+ 卸载文件系统
    执行umount /mnt 命令，卸载NFS文件系统。  
    其中，/mnt目录请使用实际值替换。  
    卸载命令格式：umount /挂载的目录地址。