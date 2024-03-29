# docker_swarm搭建
## docker准备
1. 节点分配 node01作为manager节点;node02作为worker节点

    ```
        # vim /etc/hosts
        127.0.0.1   localhost
        xxx.xxx.xxx.xx  node01
        xxx.xxx.xxx.xx  node02
        // 修改hostname
        # hostname set-hostname node1
        // 查看hostname
        # hostname
    ```
2. 配置SSH免密登录
    ```
        # ssh-keygen -t rsa -P ''
        # ssh-copy-id -i .ssh/id_rsa.pub root@192.168.139.176
        # ssh-copy-id -i .ssh/id_rsa.pub root@192.168.139.177
    ```
3. 安装ansible
    ```
        # yum -y install ansible
        # cat /etc/ansible/hosts | grep -v ^# | grep -v ^$
        [node]
        192.168.139.176
        192.168.139.177
        # sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
        # ansible node -m copy -a 'src=/etc/selinux/config dest=/etc/selinux/'
        # systemctl stop firewalld
        # systemctl disable firewalld
        # ansible node -a 'systemctl stop firewalld'
        # ansible node -a 'systemctl disable firewalld'
    ```
    关闭防火墙
4. 安装docker  docker-ce-18.06.1.ce-3.el7版本

    ```
        # yum install -y yum-utils device-mapper-persistent-data lvm2
        # yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
        # yum list docker-ce --showduplicates | sort -r
        # yum -y install docker-ce
    ```
5. 开启 DOCKER HTTP API
    ```
        # vi /lib/systemd/system/docker.service
        ////
        [Service]
        #下添加以下两行
        ExecStart=
        ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix://var/run/docker.sock
        ////
        
        # ansible node -m command -a  'systemctl daemon-reload'
        # ansible node -m command -a  'systemctl restart docker.service'
    ```    
6. 使用ansible在worker节点安装docker
    ```
        # ansible node -m copy -a 'src=/etc/yum.repos.d/docker-ce.repo dest=/etc/yum.repos.d/'
        # ansible node -m yum -a "state=present name=docker-ce"
        # ansible node -a 'docker --version'
        192.168.139.173 | SUCCESS | rc=0 >>
        Docker version 17.06.0-ce, build 02c1d87
        192.168.139.174 | SUCCESS | rc=0 >>
        Docker version 17.06.0-ce, build 02c1d87
        # ansible node -a 'systemctl start docker'
        # ansible node -a 'systemctl status docker'
        # ansible node -a 'systemctl enable docker'
    ```
7. 启动docker 配置开机启动
    ```
        # systemctl start docker
        # systemctl status docker
        # systemctl enable docker
    ```
### 配置docker swarm集群
1. 创建docker swarm集群
    ```
        # docker swarm init --listen-addr 0.0.0.0
    ```
2. manager节点查看加入 worker节点命令
    ```
        # docker swarm join-token worker
        To add a worker to this swarm, run the following command:
            docker swarm join --token SWMTKN-1-3sxxeeexxx xxx.xx.xxx.xx:2377
    ```
3. 将规划的节点worker加入
    ```
        # docker swarm join --token SWMTKN-1-3sxxeeexxx xxx.xxx.xxx.xx:2377
        This node joined a swarm as a worker.
    ```
4. 确认是否加入节点
    ```
        # docker node ls
    ```
5. 查看docker swarm的网络
    ```
        # docker network ls
    ```
6. 创建网络
   ```
       # docker network create -d overlay --attachable xxxx  
       // --attachable 其他独立容器可与此网络通信
   ```    
## 安装Portainer
1. docker 安装Portainer
    ```
        # docker service create \
        --name portainer \
        --publish 9000:9000 \
        --constraint 'node.role == manager' \
        --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=/mnt/acs_mnt/nas/data/portainer,dst=/data \
        portainer/portainer \
        -H unix:///var/run/docker.sock
    ```
    
参考
> https://blog.51cto.com/lookingdream/2060292

---
## 部署步骤

1. 挂载NAS 
    > NAS
2. 添加标签
    ```
        docker node update --label-add role=manager [nodeName]  //用于安装 portainer
        docker node update --label-add node=[nodeName] [nodeName]
    ``` 
3. 安装 portainer
    ```
        docker service create \
        --name portainer \
        --publish 9000:9000 \
        --replicas=1 \
        --constraint 'node.role == manager' \
        --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock \
        --mount type=bind,src=/mnt/acs_mnt/nas/data/portainer,dst=/data \
        portainer/portainer \
        -H unix:///var/run/docker.sock
    ```
3. 创建网络 docker network create -d overlay --attachable itms-chn
4. 部署数据源  
注 ES vm： 

    在   /etc/sysctl.conf文件最后添加一行
    vm.max_map_count=262144
    sysctl 立即生效 /sbin/sysctl -p
