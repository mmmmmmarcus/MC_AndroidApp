# PROJECT — God Mode

## Goal

`god-mode` 是一个面向 Android 高权限系统开关与快捷磁贴控制的轻量工具应用。

第一阶段目标：
- 提供少量高频、实用、可明确解释的系统行为开关
- 保持极简 UI
- 通过 Quick Settings Tile 提升操作效率
- 为未来纳入统一 F-Droid 更新链路做好发布结构准备

## Non-goals

当前阶段不做：
- 复杂插件系统
- 大量低频系统调参项
- Root 依赖功能
- 过度配置化的 tile 自定义

## Current scope

当前已确认范围：
- 触感反馈开关
- 永不锁屏开关
- 单个 Touch Feedback Quick Settings Tile

## Publishing assumptions

为了接入统一 F-Droid repo，项目默认遵循：
- 稳定 applicationId：`com.marxs.androidgodmode`
- 递增 versionCode
- 后续 release 使用稳定签名
- 输出可分发 APK

## Next milestone

- 补齐项目级发布资料
- 接入 `MC_AndroidApp_FDroid` 作为首个试点 app
- 后续视需要增加 release 自动化脚本
