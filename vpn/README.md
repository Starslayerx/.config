# openvpn
- network-manager-openvpn-gnome
- network-manager-openvpn
- openvpn


# ssr
- python needed
```shell
sudo apt install python
```
- 安装依赖
```shell
sudo apt install libcanberra-gtk-module libcanberra-gtk3-module gconf2 gconf-service libappindicator1
```
- 可选依赖
```shell
sudo apt-get install libssl-dev libsodium-dev
```
- 安装本地包
```shell
sudo dpkg -i *.deb
```
- 配置代理

| 代理协议 | 主机 | 端口 |
| - | - | - |
| http | 127.0.0.1 | 12333 |
| https | 127.0.0.1 | 12333 |
| socks | 127.0.0.1 | 1080 |
| (忽略主机) |localhost, 127.0.0.0/8, ::1| |
