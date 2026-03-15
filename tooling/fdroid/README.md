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
