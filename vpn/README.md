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

## WIT
```bash
sudo apt install network-manager-l2tp-gnome
```
- 添加第二层隧道协议
  - 网关: 59.172.155.68
  - 帐号: 学号


## VPNHotspot
- Share your vpn connection through your phone.
