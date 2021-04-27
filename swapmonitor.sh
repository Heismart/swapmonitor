#!/bin/bash
# 统计当前swap使用情况
# Author: kennyluo(luogenji@hotmail.com)
# Website: www.stathub.cn (or github.com/heismart)

function getProgramSwapUsedByPID {
    SUM=0
    PID=$1
    if [ $PID -eq 1 ];then
            exit
    fi
    if [ -z $(ps -p "$PID" -o pid=) ]; then
        exit
    fi
    PROGNAME=$(ps -p "$PID" -o comm --no-headers)
    PROGCWD=$(ls -l /proc/"$PID" 2>/dev/null |grep "cwd" | awk '{ print $NF }')
    for SWAP in $(grep Swap /proc/"$PID"/smaps 2>/dev/null| awk '{ print $2 }'); do
        let SUM=$SUM+$SWAP
    done
    echo -e "$PID\t$SUM\t$PROGNAME\t$PROGCWD" | awk -F'\t' 'BEGIN{
        print("\n")
        printf("%-10s %-15s %-20s %s\n","PID","Swap-Used","Progarm","Program-Path")
        printf("%-10s %-15s %-20s %-s\n","----","------","------","-----------")
    }{
        pid=$1;
        pused=$2;
        pname=$3;
        pcwd=$4;

        if(pused<1024)
           pused=sprintf("%.2f",pused)
        else if(pused<1048576)
           pused=sprintf("%.2fMB",pused/1024)
        else
           pused=sprintf("%.2fGB",pused/1024/1024)
    }
    END{
        printf("%-10s %-15s %-20s %s\n",pid,pused,pname,pcwd);
    }'
    exit
}

function getProgramSwapUsedByName {
    SUM=0
    for PID in $(ps -ef | grep "$1" | grep -v 'grep ' | awk '{print $2}'); do
        if [ $PID -eq 1 ];then
            continue;
        fi
        PROGNAME=$(ps -p "$PID" -o comm --no-headers)
        PROGCWD=$(ls -l /proc/"$PID" 2>/dev/null |grep "cwd" | awk '{ print $NF }')
        for SWAP in $(grep Swap /proc/"$PID"/smaps 2>/dev/null| awk '{ print $2 }'); do
            let SUM=$SUM+$SWAP
        done
        if [ $SUM -gt 0 ];then 
            echo -e "$PID\t$SUM\t$PROGNAME\t$PROGCWD"
        fi
        SUM=0
    done | sort -sn -k2 | awk -F'\t' 'BEGIN{
        print("\n")
        printf("%-10s %-15s %-20s %s\n","PID","Swap-Used","Progarm","Program-Path")
        printf("%-10s %-15s %-20s %-s\n","----","------","------","-----------")
      }{
        pid[NR]=$1;
        pused[NR]=$2;
        pname[NR]=$3;
        pcwd[NR]=$4;

        if(pused[NR]<1024)
           pused[NR]=sprintf("%.2f",pused[NR])
        else if(pused[NR]<1048576)
           pused[NR]=sprintf("%.2fMB",pused[NR]/1024)
        else
           pused[NR]=sprintf("%.2fGB",pused[NR]/1024/1024)
        }
        END{
            for(id=1;id<=length(pid);id++)
            {
                printf("%-10s %-15s %-20s %s\n",pid[id],pused[id],pname[id],pcwd[id]);
            }
        }'
    exit
}

function getProgramsSwapUsed {
    SUM=0
    for DIR in $(find /proc/ -maxdepth 1 -type d | grep -e "^/proc/[0-9]") ; do
        PID=$(echo "$DIR" | cut -d / -f 3)
        if [ $PID -eq 1 ];then
            continue;
        fi
        PROGNAME=$(ps -p "$PID" -o comm --no-headers)
        PROGCWD=$(ls -l /proc/"$PID" 2>/dev/null |grep "cwd" | awk '{ print $NF }')
        for SWAP in $(grep Swap "$DIR"/smaps 2>/dev/null| awk '{ print $2 }'); do
            let SUM=$SUM+$SWAP
        done
        if [ $SUM -gt 0 ];then 
            echo -e "$PID\t$SUM\t$PROGNAME\t$PROGCWD"
        fi
        SUM=0
    done | sort -sn -k2 | awk -F'\t' 'BEGIN{
        print("\n")
        printf("%-10s %-15s %-20s %s\n","PID","Swap-Used","Progarm","Program-Path")
        printf("%-10s %-15s %-20s %-s\n","----","------","------","-----------")
      }{
        pid[NR]=$1;
        pused[NR]=$2;
        pname[NR]=$3;
        pcwd[NR]=$4;

        if(pused[NR]<1024)
           pused[NR]=sprintf("%.2f",pused[NR])
        else if(pused[NR]<1048576)
           pused[NR]=sprintf("%.2fMB",pused[NR]/1024)
        else
           pused[NR]=sprintf("%.2fGB",pused[NR]/1024/1024)
        }
        END{
            for(id=1;id<=length(pid);id++)
            {
                printf("%-10s %-15s %-20s %s\n",pid[id],pused[id],pname[id],pcwd[id]);
            }
        }'
    exit
}

function usage {
    echo "
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
    "
}

while true ;do
usage
read -p "SWAP占用率的统计方式: " action
case $action in
    pid) read -p "输入进程ID:" Pid
    getProgramSwapUsedByPID "$Pid"
    break
    ;;
    pname) read -p "输入进程名称:" Pname
    getProgramSwapUsedByName "$Pname"
    break
    ;;
    all)
    getProgramsSwapUsed
    break
    ;;
    *) usage
    ;;
esac
done