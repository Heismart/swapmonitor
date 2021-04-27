# swapmonitor
SWAP占用分析工具,方便查找哪些进程占用Swap交换区,特别在做深度学习且资源有限的时候，观察性能不错的小工具

### 简介
````
    ___                       
   / __|_ __ ____ _ _ __      
   \__ \ V  V / _\` | '_ \     
   |___/\_/\_/\__,_| .__/     
      / _ \ _  _ __|_| _ _  _ 
     | (_) | || / -_) '_| || |
      \__\_\\_,_\___|_|  \_, |
                         |__/ 
    :: 帮助 ::
    运行./swap_monitor.sh,选择以下任一种查询方式:
    
    >方式1 根据进程ID统计 pid
    >方式2 根据进程名统计 pname
    >方式3 统计全部 all
    
````
### 使用
> 直接下载 执行文件 swapmonitor 或 git clone https://github.com/Heismart/swapmonitor.git
> 
> chmod +x swapmonitor && cp ./swapmonitor /usr/local/bin
> 
> swapmonitor
> 
> 根据提示输入即可

>> 注： swapmonitor.sh 为Shell源码

### 适用操作系统

##### 目前已经经过测试的操作系统:
- Ubuntu
- CentOS

### 需求
有需求，请在 Issues 中告诉我。
