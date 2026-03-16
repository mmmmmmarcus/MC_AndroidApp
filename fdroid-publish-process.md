# F-Droid Publish Process

这份文档定义 `MC_AndroidApp` 当前已落地的 F-Droid 发布 process。

当前正式可调用的 process：

- `tooling/fdroid/publish-god-mode.sh`

---

## 1. Process name

### `publish-god-mode`

用途：
- 将 `god-mode` 的当前版本发布到自建 F-Droid repo
- 更新 GitHub Pages 背后的 repo 内容
- 让 F-Droid / Neo Store 能看到新版更新

---

## 2. What it does

执行这个 process 时，实际会完成：

1. 构建 `god-mode` release APK
2. 读取构建输出中的版本信息
3. 使用稳定 app signing key 对 APK 签名
4. 将 APK 放入 `MC_AndroidApp_FDroid/repo/`
5. 运行 `fdroid update` 生成 / 更新 repo index
6. 清理不需要提交的临时文件
7. 提交并推送 `MC_AndroidApp_FDroid`
8. 让 GitHub Pages 上的 F-Droid 源更新内容

---

## 3. Current command

```bash
cd ~/GitProjects/MC_AndroidApp
./tooling/fdroid/publish-god-mode.sh
```

---

## 4. Expected local prerequisites

当前这条 process 默认依赖本机已有：

- `~/GitProjects/MC_AndroidApp`
- `~/GitProjects/MC_AndroidApp_FDroid`
- Android SDK
- Java 21
- `fdroidserver`
- `apksigner`
- 本地 keystore：
  - app signing key
  - F-Droid repo signing key

---

## 5. Output target

当前发布目标：

- GitHub Pages repo: `MC_AndroidApp_FDroid`
- F-Droid 源地址：
  - <https://mmmmmmarcus.github.io/MC_AndroidApp_FDroid/repo>

---

## 6. When to call it

适合场景：
- `god-mode` 提升了版本号并准备发布
- 想让手机上的 F-Droid / Neo Store 收到新版
- 想刷新自建 F-Droid repo 内容

---

## 7. Current scope limitation

当前这条 process 还是 **God Mode 专用入口**。

也就是说，目前它还不是“发布任意 app 的通用脚本”，而是：
- 已经可用
- 已经跑通
- 但范围先锁定在 `god-mode`

这是刻意的，先把单条链路做稳，再抽象成通用版。

---

## 8. Next evolution

后续建议升级为：

### `publish-app.sh`
支持类似：

```bash
./tooling/fdroid/publish-app.sh god-mode
./tooling/fdroid/publish-app.sh another-app
```

到那时，`publish-god-mode.sh` 可以：
- 保留为兼容入口
- 或退化成对通用脚本的薄包装

---

## 9. Process alias suggestion

以后在对话里，你可以直接这样 call：

- “跑一下 `publish-god-mode` process”
- “把 God Mode 走一遍 F-Droid publish process”
- “执行 `tooling/fdroid/publish-god-mode.sh`”

这三种我都会视为同一个流程入口。
