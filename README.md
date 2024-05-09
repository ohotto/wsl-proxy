# WSL 一键设置宿主机代理

## 使用方法

初次使用：

```sh
wget https://raw.githubusercontent.com/ohotto/wsl-proxy/main/proxy.sh && chmod +x proxy.sh && . ./proxy.sh
```


运行过一次后再次使用：

> 注意：必须使用`. ./proxy.sh`而**不是**`./proxy.sh`运行脚本，否则配置不会生效！

```sh
. ./proxy.sh
```

## 注意事项

- 代理设置仅在本次shell会话中生效，如需要持久化，请自行将代理配置添加到`~/.bashrc`
    - `export HTTP_PROXY=http://proxy.example.com:port`
    - `export HTTPS_PROXY=http://proxy.example.com:port`
    - `export SOCKS5_PROXY=socks5://proxy.example.com:port`
- 宿主机代理端口配置保存在`~/.proxy_config`，第一次运行脚本时会生成配置