# F-Droid Repo Plan

这份文档定义 `MC_AndroidApp` 的 F-Droid 发布策略。

目标：

- 让 `MC_AndroidApp` 下的多个 Android 子项目统一进入一个自托管 F-Droid repo
- 以后在手机上通过 F-Droid / Neo Store 检查更新
- 尽量减少手动下载 APK 的流程
- 为后续自动化发布留出稳定结构

---

## 1. 结论

`MC_AndroidApp` 里的所有 Android 项目，**可以统一纳入一个自建的 F-Droid repo**。

推荐采用下面这套分层：

1. `MC_AndroidApp` 负责管理**源码与项目文档**
2. 单独维护一个 **F-Droid 发布目录 / 发布仓库**
3. 通过统一脚本把各子项目的 release APK 发布到该 repo
4. 手机端只订阅这一个 repo 地址

这样以后每个 app 发新版本时，不需要手动下载 APK，只要在 F-Droid / Neo Store 里检查更新即可。

---

## 2. 推荐架构

### 源码仓

```text
~/GitProjects/MC_AndroidApp
```

职责：
- 管理所有 Android app 的源码
- 管理项目文档、模板、脚本
- 作为发布流程的“源头”

示例：

```text
MC_AndroidApp/
├── god-mode/
├── another-app/
├── templates/
├── tooling/
├── new projectwizard.md
└── fdroid-repo-plan.md
```

---

### F-Droid 发布层

建议独立于源码仓。

推荐路径之一：

```text
~/GitProjects/MC_AndroidApp_FDroid
```

或者未来用远程托管：
- GitHub Pages
- Cloudflare Pages
- VPS / NAS 静态目录

职责：
- 存放 release APK
- 存放 repo metadata / index
- 存放 repo 图标与说明
- 作为手机客户端订阅的实际源地址

**为什么建议独立？**

因为源码仓和发布仓的职责不同：

- 源码仓频繁改代码
- 发布仓只关心“交付出去的包和索引”

分开后：
- 边界更清晰
- 更容易部署到静态托管
- 更容易做自动化
- 不会把发布物和源码搅在一起

---

## 3. 为什么不直接用官方 F-Droid 主仓

官方 F-Droid 主仓不是不能进，但不适合作为现在的第一步。

原因：
- 审核流程更重
- 对可复现构建、源码、依赖和许可有要求
- 上线和更新速度受平台流程影响
- 某些实验性 app、特殊权限 app、闭源依赖 app 可能不容易通过

而你现在的核心诉求是：

- 多个自家 app 统一更新
- 更新尽量省事
- 自己可控

所以**自建 F-Droid repo**是更合适的起点。

---

## 4. 每个子项目必须满足的发布前提

如果想纳入统一 F-Droid repo，每个 app 最好遵循以下硬约束。

### 4.1 稳定的 applicationId

例如：
- `com.marxs.godmode`
- `com.marxs.voicekeyboard`
- `com.marxs.notecalc`

规则：
- 一旦发布出去，尽量不要改
- 改了就相当于变成一个新 app

---

### 4.2 递增的 versionCode

每次发布新版本时：
- `versionCode` 必须递增
- `versionName` 可以按语义化版本管理

否则客户端无法把它识别为升级版本。

推荐：
- `versionName`: `0.1.0`, `0.2.0`, `1.0.0`
- `versionCode`: 单调递增整数

---

### 4.3 稳定签名

同一个 app 的所有后续版本必须使用同一套签名密钥。

否则：
- 用户无法覆盖安装升级
- F-Droid 客户端也无法正常升级链路

所以未来需要建立统一签名管理策略：
- debug 签名只用于开发测试
- release 签名必须长期保存
- keystore 必须安全备份

---

### 4.4 可生成可分发的 release APK

每个项目最好都能稳定输出：
- release APK
- 版本号明确
- 包名明确

如果将来要更正式，也可增加：
- AAB
- mapping 文件
- release note

但对 F-Droid repo 来说，最基本的是 APK。

---

## 5. 推荐的目录与职责分工

### 5.1 在 `MC_AndroidApp` 源码仓内

后续建议逐步增加：

```text
MC_AndroidApp/
├── tooling/
│   ├── fdroid/
│   └── release/
├── shared-docs/
├── templates/
├── god-mode/
└── ...
```

其中：

#### `tooling/fdroid/`
放 F-Droid 相关工具脚本与说明：
- 发布脚本
- 元数据模板
- repo 初始化脚本
- 校验脚本

#### `tooling/release/`
放通用发布工具：
- 构建 release APK
- 收集 APK
- 规范命名
- 版本检查

#### `shared-docs/`
放跨项目共享规则：
- 签名规范
- 版本号规范
- Play / F-Droid 双发布策略

#### `templates/`
放新 app 模板，包括未来要补的：
- 基础 Android app 模板
- release note 模板
- F-Droid metadata 模板

---

### 5.2 在 F-Droid 发布仓内

推荐未来维护成类似：

```text
MC_AndroidApp_FDroid/
├── repo/
├── metadata/
├── assets/
├── tools/
└── README.md
```

说明：

#### `repo/`
实际对外发布的 repo 内容：
- APK
- index
- repo 图标
- 签名后生成的元数据

这是最终会被托管到公网静态站点的核心目录。

#### `metadata/`
每个 app 的描述元信息：
- app 名称
- 简介
- 描述
- 分类
- 更新说明
- 可能的 screenshots / links

#### `assets/`
仓库级素材：
- repo icon
- banner
- 公共图形资源

#### `tools/`
发布仓自己的辅助脚本：
- 初始化 repo
- 更新 index
- 发布到静态站点

---

## 6. 推荐的发布流程

以后每个 app 的一次发布，建议统一走下面流程：

### Step 1：在子项目内构建 release APK
例如：
- `god-mode/` 构建 release APK

### Step 2：校验发布信息
至少检查：
- applicationId
- versionCode
- versionName
- 签名是否正确

### Step 3：复制 APK 到 F-Droid 发布仓
按既定规则落位到发布仓。

### Step 4：更新 metadata 与 repo index
让 F-Droid / Neo Store 能识别新版本。

### Step 5：把发布仓同步到公网地址
例如：
- GitHub Pages
- Cloudflare Pages
- VPS 静态目录

### Step 6：手机客户端检查更新
手机上的 F-Droid / Neo Store 添加该 repo 后，就能看到更新。

---

## 7. 适合你的最小落地路线

我建议分三阶段做，而不是一口气把所有细节都上满。

### 阶段 A：先把“规则和目录”定下来
当前正在做的就是这个阶段。

输出：
- 发布策略文档
- 目录规划
- app 的版本与签名规范

### 阶段 B：做最小可用的自建 repo
目标：
- 先让 `god-mode` 能通过自建 F-Droid repo 安装 / 更新

输出：
- 一个最小发布仓
- 一个可访问地址
- 一条可重复的发布链路

### 阶段 C：把流程脚本化
目标：
- 一条命令完成构建、收集、发布、更新索引

输出：
- 可复用脚本
- 以后新 app 也能快速纳入同一流程

这条路线最稳，不容易一开始就做成一团乱麻。

---

## 8. 对 `MC_AndroidApp` 的具体建议

建议从现在起，把“能接 F-Droid 发布”作为新子项目的默认要求之一。

每个子项目至少要补齐这些信息：

- 稳定的包名
- 清晰的版本策略
- release 构建方法
- 简单的 app 描述
- 图标 / 截图等基础素材

也就是说，未来每个子项目除了代码本身，还要尽量具备：

```text
<project>/
├── README.md
├── PROJECT.md
├── CHANGELOG.md
├── docs/releases/
├── res/icons/
├── res/screenshots/
└── scripts/release/
```

这样以后接 F-Droid 会轻松很多。

---

## 9. 发布策略建议

### 建议 1：源码仓与发布仓分离
我认为这是最重要的一条。

不要把 F-Droid repo 成品直接跟源码搅在同一个目录层里长期维护。
否则：
- commit 会变脏
- APK 和索引会污染代码历史
- 仓库体积会膨胀
- 职责会混乱

---

### 建议 2：先支持自用和小范围分发
先把链路跑通，服务你的设备与测试机。

后面如果某些 app 足够成熟，再考虑：
- 单独进官方 F-Droid 主仓
- 或同时保留自建 repo 与官方上架

---

### 建议 3：签名策略尽早定
如果现在随便签，后面会很麻烦。

最晚在开始正式 F-Droid 发布前，要明确：
- release keystore 放哪里
- 怎么备份
- 怎么避免丢失
- 哪些 app 共用流程，哪些 app 独立保管

---

### 建议 4：把 F-Droid 兼容性当作“发布能力”而不是“开发结构”
也就是说：
- 开发时仍按正常 Android 工程组织
- 发布时通过脚本与元数据层接入 F-Droid

不要为了 F-Droid 反向扭曲代码结构。

---

## 10. 最终推荐决策

对于 `MC_AndroidApp`，我推荐的正式路线是：

### 现在立刻采用
- `MC_AndroidApp` 继续作为 Android app 源码 monorepo
- 新项目默认按统一目录结构创建
- 未来发布统一接入一个自建 F-Droid repo

### 下一步执行
1. 在 `MC_AndroidApp` 根目录建立 `tooling/fdroid/` 预留位置
2. 先挑 `god-mode` 作为第一个接入 F-Droid 的试点项目
3. 单独创建 `MC_AndroidApp_FDroid` 发布仓
4. 跑通最小发布链路
5. 再把后续 app 陆续纳入

---

## 11. 下一步我建议直接做什么

下一步最值得做的是下面两件：

### A. 在 `MC_AndroidApp` 里补一个 `tooling/fdroid/README.md`
把后续工具层的职责固定下来。

### B. 开始创建 `MC_AndroidApp_FDroid` 的最小骨架
先把发布仓目录结构定出来，为后续接 `god-mode` 做准备。

我建议按顺序：
- 先 A
- 再 B

这样后面所有脚本和发布动作都会更稳。