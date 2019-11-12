### 创建卷
1、在每台机器执行：
> mkdir -p {指定路径}   

2、在一台机器执行：
> gluster volume create gv0 replica 3 glusterfs1:{指定路径} glusterfs2:{指定路径} glusterfs3:{指定路径}

3、启动卷
> gluster volume start gv0

4、查看卷
> gluster volume info


### 删除卷

>1.设置所有节点开机自启glusterfs

>2.gluster peer status检查节点情况

>3.gluster volume stop 停止你要删除的卷

>4.gluster volume  delete 删除你要删的卷

>5.rm -f  彻底删除硬盘上的卷残留