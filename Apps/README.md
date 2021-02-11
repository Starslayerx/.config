### Flatpack apps
- Spotify
  ```bash
  flatpak install flathub com.spotify.Client
  ```
- Minecraft
  ```bash
  flatpak install flathub io.mrarm.mcpelauncher
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
