### Flatpack apps
- Spotify
  ```bash
  flatpak install flathub com.spotify.Client
  ```
- Show Me Lyrics
  ```bash
  flatpak install flathub com.github.muriloventuroso.givemelyrics
  ```
- Kdenlive
  ```bash
  flatpak install flathub org.kde.kdenlive
  ```
- Minecraft
  ```bash
  flatpak install flathub io.mrarm.mcpelauncher
  flatpak install flathub com.mojang.Minecraft
  ```
- VLC
  ```bash
  flatpak install flathub org.videolan.VLC
  ```
- Planner
  ```bash
  flatpak install flathub com.github.alainm23.planner
  ```
- WPS office
  ```bash
  flatpak install flathub com.wps.Office
  ```
- [Fcitx5](https://www.csslayer.info/wordpress/fcitx-dev/fcitx5-on-flatpak/)
  ```bash
  # 添加 flathub 到用户级
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  # 添加 fcitx5-unstable 到用户级配置
  flatpak remote-add --user --if-not-exists fcitx5-unstable https://flatpak.fcitx-im.org/unstable-repo/fcitx5-unstable.flatpakrepo
  
  flatpak install org.fcitx.Fcitx5
  flatpak install org.fcitx.Fcitx5.Addon.ChineseAddons
  # 例如需要 Rime： flatpak install org.fcitx.Fcitx5.Addon.Rime
  # 可以用 flatpak remote-ls fcitx5-unstable 查看有哪些包
  ```
- Joplin
  ```bash
  flatpak install flathub net.cozic.joplin_desktop
  ```
- Standard Notes
  ```bash
  flatpak install flathub org.standardnotes.standardnotes￼content_copy
  ```
- Foliate
  ```bash
  flatpak install flathub com.github.johnfactotum.Foliate
  ```
- Fluent Reader(RSS reader)
  ```bash
  flatpak install flathub me.hyliu.fluentreader
  ```
- Flameshot
  ```bash
  flatpak install flathub org.flameshot.Flameshot
  ```
- O20.Word
  ```bash
  flatpak install flathub io.gitlab.o20.word￼content_copy
  ```
- Popsicle
  ```bash
  flatpak install flathub com.system76.Popsicle
  ```
- Steam
  ```bash
  flatpak install flathub com.valvesoftware.Steam
  ```
- Qv2ray
  ```bash
 flatpak install flathub com.github.Qv2ray
  ```
- Stremio
  ```bash
  flatpak install flathub com.stremio.Stremio
  ```
- Telegram
  ```bash
  flatpak install flathub org.telegram.desktop￼content_copy
  ```

#### Usage
Run this command in terminal (you could add other commands, like proxychains)
```bash
proxychians4 flatpak run com.stremio.Stremio
```

## Chrome Os
- Install snapd on Chrome Os linux vm
```bash
sudo apt install -y libsquashfuse0 squashfuse fuse snapd
```
