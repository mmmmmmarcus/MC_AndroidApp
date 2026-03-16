# MegaDoc

`MC_AndroidApp` 根目录文档索引。

这份文档的目的很简单：
- 告诉人和 AI：每份根目录文档是干什么的
- 避免文档一多就互相打架
- 让新项目、新协作者、新会话都能快速找到入口

---

## Root Docs Index

### `README.md`
**仓库总入口。**

适合先看它来理解：
- 这个 monorepo 是干什么的
- 里面有哪些 Android 子项目
- 当前整体管理方式

如果第一次打开仓库，先看这个。

---

### `new projectwizard.md`
**新 Android 子项目的目录结构规范。**

适合用来回答：
- 新 app 应该怎么建目录
- `docs / res / scripts / build-artifacts / app` 分别怎么用
- 新项目最小模板长什么样
- 命名规则是什么

任何要新开 app 的场景，优先参考这份文档。

---

### `fdroid-repo-plan.md`
**统一 F-Droid 发布策略文档。**

适合用来回答：
- 为什么要自建 F-Droid repo
- 源码仓和发布仓怎么分工
- 子项目要满足哪些发布前提
- 后续应该怎么接入统一更新源

任何涉及发布、分发、更新链路的问题，优先参考这份文档。

---

### `tooling/fdroid/README.md`
**F-Droid 工具层索引。**

适合用来回答：
- 当前有哪些 F-Droid 工具脚本
- 哪个脚本是当前标准发布入口
- 源码仓侧和发布仓侧的工具边界是什么

---

## Recommended Reading Order

### 场景 1：第一次接触这个仓库
1. `README.md`
2. `megadoc.md`
3. 按需要进入具体文档

### 场景 2：要新建一个 Android app
1. `megadoc.md`
2. `new projectwizard.md`
3. 参考已有子项目目录

### 场景 3：要做统一分发 / 自动更新
1. `megadoc.md`
2. `fdroid-repo-plan.md`
3. `tooling/fdroid/README.md`

### 场景 4：要直接调用既有发布流程
1. `megadoc.md`
2. `tooling/fdroid/README.md`
3. 执行 `tooling/fdroid/publish-god-mode.sh`

---

## Doc Ownership

### 仓库级文档
放在根目录。

适合内容：
- 总体规则
- 总体规范
- 总体发布策略
- 跨项目共享约定

### 项目级文档
放在各子项目自己的目录中。

例如：
- `<project>/README.md`
- `<project>/PROJECT.md`
- `<project>/CHANGELOG.md`
- `<project>/docs/...`

适合内容：
- 某个 app 的产品定义
- 某个 app 的技术方案
- 某个 app 的发布记录

---

## Rule of Thumb

当你准备新增一份文档时，先问自己：

### 这份文档是在讲“整个仓库”的规则吗？
如果是，放根目录。

### 这份文档是在讲“某个具体 app”的事情吗？
如果是，放进对应子项目。

### 这份文档是在讲“未来可复用的工具链 / 模板 / 通用规范”吗？
优先考虑：
- 根目录文档
- `templates/`
- `tooling/`
- `shared-docs/`

---

## Current Root Docs Snapshot

当前根目录重点文档如下：

- `README.md`
- `megadoc.md`
- `new projectwizard.md`
- `fdroid-repo-plan.md`
- `tooling/fdroid/README.md`

当前已落地的可调用 process：

- `tooling/fdroid/publish-god-mode.sh` — 发布 God Mode 到自建 F-Droid repo 并推送到 GitHub Pages

如果未来根目录文档继续增长，建议把这份索引持续维护，确保它始终是“总导航页”。

---

## Suggested Next Evolution

如果后续文档继续变多，我建议未来在根目录逐步补：

- `shared-docs/` — 跨项目共享规则与研究
- `templates/` — 新项目模板与文档模板
- `tooling/` — 自动化脚本与工具层

到那时，`megadoc.md` 继续担任根目录导航文档即可。
