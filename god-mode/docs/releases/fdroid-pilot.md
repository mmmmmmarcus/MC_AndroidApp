# God Mode F-Droid Pilot

`god-mode` 是 `MC_AndroidApp` 中第一个接入统一 F-Droid 发布链路的试点项目。

## Why this app first

原因很简单：
- 项目已经成型
- 应用边界清楚
- APK 分发价值高
- 非常适合作为“统一更新源”的首个验证对象

## App identity

- Project dir: `god-mode/`
- App name: `AndroidGodMode`
- Application ID: `com.marxs.androidgodmode`
- Current versionName: `0.9.0`
- Current versionCode: `9`

## What this pilot should validate

1. 子项目元信息能否标准化
2. 发布仓 metadata 能否稳定对应到 app
3. 后续 release APK 能否按统一流程纳入 F-Droid repo
4. 手机上的 F-Droid / Neo Store 能否正确识别后续更新

## Current limitation

当前会话环境下尚未跑通 release 构建与签名链路，因此本次试点先完成：
- 项目结构补齐
- metadata 建立
- 发布流程文档建立

后续再补：
- release keystore strategy
- release APK 构建脚本
- repo index 生成与托管
