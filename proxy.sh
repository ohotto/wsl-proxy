#!/bin/bash

CONFIG_FILE=~/.proxy_config
valid_choice=true

set_ports(){
    echo
    read -p "请输入宿主机HTTP/HTTPS代理端口（如10809）：" HTTP_PORT
    read -p "请输入宿主机SOCKS5代理端口（如10808）：" SOCKS_PORT
    echo "HTTP_PORT=$HTTP_PORT" > $CONFIG_FILE
    echo "SOCKS_PORT=$SOCKS_PORT" >> $CONFIG_FILE
    echo "端口设置成功，HTTP: $HTTP_PORT, SOCKS: $SOCKS_PORT"
}

if [ ! -f "$CONFIG_FILE" ]; then
    echo
    echo "检测到第一次运行脚本，请设置宿主机代理端口。"
    set_ports
fi

source $CONFIG_FILE

hostip=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
wslip=$(hostname -I | awk '{print $1}')

PROXY_HTTP="http://${hostip}:${HTTP_PORT}"
PROXY_SOCKS5="socks5://${hostip}:${SOCKS_PORT}"

set_proxy(){
    export http_proxy="${PROXY_HTTP}"
    export HTTP_PROXY="${PROXY_HTTP}"
    export https_proxy="${PROXY_HTTP}"
    export HTTPS_proxy="${PROXY_HTTP}"
    export ALL_PROXY="${PROXY_SOCKS5}"
    export all_proxy="${PROXY_SOCKS5}"
    echo
    echo "已设置WSL通过宿主机代理"
}

unset_proxy(){
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset ALL_PROXY
    unset all_proxy
    echo
    echo "已取消WSL通过宿主机代理"
}

test_setting(){
    echo
    echo "宿主机 ip:" ${hostip}
    echo "WSL ip:" ${wslip}
    echo "当前 http 代理:" $http_proxy
    echo "当前 https 代理:" $https_proxy
    echo "当前全局代理:" $all_proxy
}

while true
do
    if $valid_choice; then
        echo
        echo -e "\033[33m-----------------------------------\033[0m"
        echo -e "\033[32m0. \033[0m配置宿主机HTTP/HTTPS/SOCKS端口号"
        echo -e "\033[33m-----------------------------------\033[0m"
        echo -e "\033[32m1. \033[0m设置WSL通过宿主机代理"
        echo -e "\033[32m2. \033[0m取消WSL通过宿主机代理"
        echo -e "\033[32m3. \033[0m列出WSL ip/宿主机 ip/当前代理设置"
        echo -e "\033[33m-----------------------------------\033[0m"
        echo -e "\033[32m4. \033[0m退出脚本"
        echo -e "\033[33m-----------------------------------\033[0m"
        echo
    fi

    read -p "请选择一个操作：" opt

    case $opt in
        0)
            set_ports
            valid_choice=true
            ;;
        1)
            set_proxy
            break
            ;;
        2)
            unset_proxy
            break
            ;;
        3)
            test_setting
            break
            ;;
        4)
            break
            ;;
        *)
            echo -e "\033[31m无效的选择，请重新选择。\033[0m"
            valid_choice=false
            ;;
    esac
done
