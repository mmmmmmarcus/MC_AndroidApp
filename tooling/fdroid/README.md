# tooling/fdroid

这个目录用于放置 `MC_AndroidApp` 的 F-Droid 相关工具层。

## 目标

统一管理：
- F-Droid 发布脚本
- repo 初始化脚本
- metadata 模板
- 发布检查脚本
- 与各子项目对接的辅助工具

## 计划职责

后续会逐步加入：

1. `bootstrap-*`：初始化 F-Droid 发布仓
2. `publish-*`：将某个子项目的 release APK 发布到统一 repo
3. `validate-*`：校验包名、版本号、签名、产物命名
4. `templates/`：放 metadata / release 相关模板

## 边界

- 这里放的是**源码仓侧**的 F-Droid 工具
- 实际对外发布的 repo 内容，不建议长期直接放在源码仓里
- 真实发布目录建议独立为单独仓库，例如：`MC_AndroidApp_FDroid`

## First pilot

首个试点项目：
- `god-mode/`

## Current process entrypoints

### `publish-god-mode.sh`
把 `god-mode` 发布到自建 F-Droid repo 的当前标准脚本。

覆盖流程：
- 构建 release APK
- 用稳定 app key 进行签名
- 更新 `MC_AndroidApp_FDroid` 中的 repo index
- 推送到 GitHub Pages 背后的仓库

适合场景：
- 发布 `god-mode` 新版本
- 刷新 F-Droid / Neo Store 更新源
