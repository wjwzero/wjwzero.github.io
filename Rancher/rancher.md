# 第2节：Rancher环境


## Docker安装

1. 禁用selinux、IPV6、firewalld
  - 禁用IPV6
   
   cat /etc/default/grub 增加
   GRUB_CMDLINE_LINUX="ipv6.disable=1 rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet"
   grub2-mkconfig -o /boot/grub2/grub.cfg 然后重启

1. 安装依赖包
>yum install -y yum-utils device-mapper-persistent-data
3. 配置镜像仓库
>yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
4. 安装Docker
> yum list docker-ce --showduplicates | sort -r
> yum install docker-ce -y
> 

5. 配置docker的IP cat/etc/docker/daemon.json
```shell
{
"bip":"172.200.0.1/24",
"registry-mirrors":[
	"https://fo1rscgw.mirror.aliyuncs.com"
    ]
}
修改为自动启动
systemctl enable docker 
systemctl start docker
```
6. 修改hosts
>   hostnamectl set-hostname node22
> vi /etc/hosts 添加 10.0.10.21 node22 
7. Rancher Docker安装
``` shell
  docker run -d --restart=unless-stopped -p 8000:80 -p 8443:443  -v /data1/rancher:/var/lib/rancher/   -v /root/var/log/auditlog:/var/log/auditlog -e AUDIT_LEVEL=3 rancher/rancher:v2.2.3
```

7. Rancher配置环境，主机加入Rancher

8. Rancher配置K8S


## Rancher 学习笔记
1. 主机驱动的概念
   1. 配置Docker-machine用于直接安装Rancher
2. Rancher2.0 安装
   1. docker login --username=jmax_swarm@jimi --password jimi@docker registry.cn-shenzhen.aliyuncs.com
   2. docker login --username=chengxuwei --password 123456 172.16.0.101:2001
   3. docker pull rancher/rancher:v2.2.3
``` shell
  docker run -d --restart=unless-stopped -p 8000:80 -p 8443:443  -v /data1/rancher:/var/lib/rancher/   -v /root/var/log/auditlog:/var/log/auditlog -e AUDIT_LEVEL=3 rancher/rancher:v2.2.3
```

  3. 第一坑：kernel:unregister_netdevice: waiting for lo to become free. Usage count = 1（丢给kernel开发人员）
     第二坑：ABRT has detected 1 problem(s). For more info run: abrt-cli list --since 1559282820

  4. 优先启动单个ETCD+Control+Work节点

## harbor 学习笔记

1. 安装docker、Docker-compose （依赖python 的pip）
2. 下载离线包https://github.com/vmware/harbor  harbor-offline-installer-v1.8.0.tgz  可能需要翻墙
3. 解压后，执行./prepare
4. 执行install 

## GlusterFS 文件系统安装

1. 前置准备
> yum search centos-release-gluster
> yum install centos-release-gluster41  
2. 安装GlusterFS
>  yum install glusterfs glusterfs-libs glusterfs-server
>  systemctl start glusterd
>  systemctl enable glusterd
3. 开放端口
  默认情况下，glusterd守护进程将监听“tcp/24007”，但仅打开该端口是不够的，因为你每添加一个卷时，它都会打开一个新端口（可通过“gluster volume status”命令查看卷的端口占用情况），所以你有以下几种选择：

  针对节点ip开放所有端口；
  开放一个足够大的端口段；
  每加一个卷就开一个端口；
  直接关闭防火墙。
  我的倾向是选择前三种。
4. GlusterFS节点探测
> gluster peer probe 10.0.10.22 (server1上执行)
> gluster peer probe 10.0.10.22 (server2上执行)

5. 创建数据卷
> gluster volume create myvol replica 3 10.0.10.21:/disk1/myvol 10.0.10.22:/disk1/myvol 10.0.10.23:/disk1/myvol
> gluster volume start myvol
> gluster volume info myvol
6. 开始NFS 
> gluster volume set myvol nfs.disable off
> gluster volume set myvol nfs.addr-namelookup off
> gluster volume set myvol nfs.export-volumes on
> gluster volume set myvol server.allow-insecure on
> gluster volume stop myvol
> gluster volume start myvol
7. 坑
> yum install -y nfs-utils  rpcbind
nfs-utils  rpcbind
1. 测试GlusterFS卷（可选）


  至此，GlusterFS已经安装完成了，我们可以将卷挂载到操作系统的某个目录进行读写测试：
  # mount -t glusterfs server1:/myvol /mnt
  # for i in `seq -w 1 100`; do cp -rp /var/log/messages /mnt/copy-test-$i; done
  检查挂载点：

  # ls -lA /mnt | wc -l
  你应该看到有100个文件，接下来，去检查每台节点上的GlusterFS卷目录：

  # ls -lA /opt/myvol
  配置端口，和密码

## ganesha安装
>yum install nfs-ganesha nfs-ganesha-gluster
>systemctl start nfs-ganesha
``` export 配置文件

EXPORT
{
   # Export Id (mandatory, each EXPORT must have a unique Export_Id)
   Export_Id = 77;

   # Exported path (mandatory)
   Path = "/myvol"; # assuming 'testvol' is the Gluster volume name

   # Pseudo Path (required for NFS v4)
   Pseudo = "/myvol";

   # Required for access (default is None)
   # Could use CLIENT blocks instead
   Access_Type = RW;

   # Allow root access
   Squash = No_Root_Squash;

   # Security flavor supported
   SecType = "sys";

   # Exporting FSAL
   FSAL {
     Name = "GLUSTER";
     Hostname = "10.0.10.21";  # IP of one of the nodes in the trusted pool
     Volume = "myvol";
   }
}


```