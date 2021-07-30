# .config
linux config files

### Some Notes

##### 7zip
```bash
sudo apt install p7zip-full
```
- set a password fot 7zip file
  ```bash
  7z a <archive name> -p<password> -mhe <files to add and encrypt>
  ```
- unzip 
  ```bash
  7z e <archive name>
  ```
- unzip with password
  ```bash
  7z e <name> -p<Password>
  ```

##### tar.gz
```bash
tar -xzf xxx.tar.gz
```

##### 禁用笔记本键盘
```bash
xinput set-prop "AT Translated Set 2 keyboard" "Device Enabled" 0
```


##### mac添加path
```bash
sudo vim /etc/paths
```
在最后一行添加路径
