### 安装

```
sudo yum groupinstall 'Development Tools'
sudo yum install -y openssl-devel git 
git clone https://github.com/wg/wrk.git wrk
cd wrk
make
# 将可执行文件移动到 /usr/local/bin 位置
sudo cp wrk /usr/local/bin
```
### 简单使用

```
# wrk -t12 -c400 -d30s http://www.baidu.com
```

```
使用方法: wrk <选项> <被测HTTP服务的URL>                            
  Options:                                            
    -c, --connections <N>  跟服务器建立并保持的TCP连接数量  
    -d, --duration    <T>  压测时间           
    -t, --threads     <N>  使用多少个线程进行压测   
                                                      
    -s, --script      <S>  指定Lua脚本路径       
    -H, --header      <H>  为每一个HTTP请求添加HTTP头      
        --latency          在压测结束后，打印延迟统计信息   
        --timeout     <T>  超时时间     
    -v, --version          打印正在使用的wrk的详细版本信息
                                                      
  <N>代表数字参数，支持国际单位 (1k, 1M, 1G)
  <T>代表时间参数，支持时间单位 (2s, 2m, 2h)
```

### 报告解析例子
```
Running 30s test @ http://www.baidu.com （压测时间30s）
  12 threads and 400 connections （共12个测试线程，400个连接）
              （平均值） （标准差）  （最大值）（正负一个标准差所占比例）
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    （延迟）
    Latency   386.32ms  380.75ms   2.00s    86.66%
    (每秒请求数)
    Req/Sec    17.06     13.91   252.00     87.89%
  Latency Distribution （延迟分布）
     50%  218.31ms
     75%  520.60ms
     90%  955.08ms
     99%    1.93s 
  4922 requests in 30.06s, 73.86MB read (30.06s内处理了4922个请求，耗费流量73.86MB)
  Socket errors: connect 0, read 0, write 0, timeout 311 (发生错误数)
Requests/sec:    163.76 (QPS 163.76,即平均每秒处理请求数为163.76)
Transfer/sec:      2.46MB (平均每秒流量2.46MB)
```

### POST 使用LUA脚本 
```
wrk.method="POST"
wrk.headers["Content-Type"]="application/x-www-form-urlencoded"
wrk.headers["token"]="0565ce2b602938923fc67ee3c5fec96a0565ce2b602938923fc67ee3c5fec96a"
wrk.body='app_id=4700458&sign=bb48548f5c661fe4f1504edba41a8bf4&status_list=[{\"device_id\":201907021057000,\"time\":\"2019-11-12 13:56:16\",\"status\":1,\"ip\":\"120.237.87.194\"}]'
```
