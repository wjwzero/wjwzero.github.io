### 1.下载数据源

> wget http://mirrors.aliyun.com/repo/Centos-7.repo

### 2. 位置与备份
> cd /etc/yum.repos.d/
  mv Centos-Base.repo Centos-Base.repo_back
  
> cp Centos-7.repo /etc/yum.repos.d/
  cd /etc/yum.repos.d/
  mv Centos-7.repo Centos-Base.repo
 
 ### 3. 清空缓存
> yum clean all
  yum makecache
  yum -y update 