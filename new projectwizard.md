# New Project Wizard

这份文档定义 `MC_AndroidApp` 下所有 Android 子项目的推荐目录结构与落地规则。

目标不是做“最复杂的架构”，而是做一套：

- **能长期复用**
- **新项目可快速起步**
- **文档、资源、构建产物边界清晰**
- **适合 AI / 人类协作开发**
- **适合单 App，也适合以后演进成多 module**

---

## 1. Monorepo 总原则

在 `MC_AndroidApp` 根目录下，每个 Android 应用都是一个独立子目录，例如：

- `god-mode/`
- `voice-keyboard/`
- `battery-doctor/`
- `notecalc/`

每个子项目都尽量遵循同一套结构，这样带来的好处是：

1. 任何新项目都能快速复制已有结构
2. AI coding agent 更容易理解项目边界
3. 文档位置稳定，不会每次都乱放
4. build 输出、设计资源、发布材料更容易统一管理
5. 后续接 CI/CD、脚本模板、自动发版更轻松

---

## 2. 推荐目录结构

每个子项目推荐采用如下结构：

```text
<project-name>/
├── README.md
├── PROJECT.md
├── CHANGELOG.md
├── .gitignore
├── app/
├── docs/
│   ├── product/
│   ├── tech/
│   ├── design/
│   └── releases/
├── res/
│   ├── branding/
│   ├── screenshots/
│   ├── icons/
│   └── raw/
├── scripts/
│   ├── dev/
│   ├── build/
│   └── release/
├── build-artifacts/
│   ├── apk/
│   ├── aab/
│   └── mapping/
├── gradle/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── gradlew
└── gradlew.bat
```

---

## 3. 各目录职责说明

### `README.md`
给人快速看懂项目。

建议包含：
- 项目简介
- 当前能力
- 使用方法
- 开发命令
- 目录说明
- 当前状态（prototype / alpha / beta / shipping）

这是“第一次打开项目时看的文件”。

---

### `PROJECT.md`
给协作者和 AI 看项目约束。

建议包含：
- 项目目标
- 非目标
- 当前版本范围
- 技术选型
- 已知约束
- 后续里程碑

如果说 `README.md` 偏对外，`PROJECT.md` 更偏内部执行说明。

---

### `CHANGELOG.md`
记录版本演进。

建议按版本维护：
- Added
- Changed
- Fixed
- Removed

这样以后做 release note、发 GitHub Release、回看历史都会省很多事。

---

### `app/`
Android 主应用 module。

对于大多数单应用项目，第一阶段都可以先只保留一个 `app/`。

如果以后项目变复杂，再扩展成：
- `core/`
- `feature-*`
- `shared/`
- `benchmark/`
- `wear/`

但在项目早期，**不要过早模块化**。先让结构可扩展，但默认保持简单。

---

### `docs/`
项目文档目录，统一收纳所有“会被反复引用”的文字材料。

推荐子目录：

#### `docs/product/`
放产品相关文档：
- PRD
- 用户场景
- 需求清单
- 竞品分析
- feature spec

#### `docs/tech/`
放技术相关文档：
- 技术方案
- 架构说明
- 权限策略
- 平台限制说明
- 调研结论

#### `docs/design/`
放设计说明：
- UI wireframe
- 信息架构
- 交互说明
- 文案规范
- 视觉规范

#### `docs/releases/`
放发布相关文档：
- release checklist
- store listing 草稿
- 测试记录
- 已发版说明

**原则：** 会反复查阅的说明，优先放 `docs/`，不要散落在聊天记录里。

---

### `res/`
这里不是 Android module 里的 `app/src/main/res`，而是**项目级资源目录**。

用于存放不直接参与 Android 编译、但与项目密切相关的资产。

推荐子目录：

#### `res/branding/`
- logo 源文件
- 品牌配色
- banner
- 营销图底稿

#### `res/screenshots/`
- README 截图
- 发布截图
- 演示截图
- before/after 图

#### `res/icons/`
- 原始 app icon
- adaptive icon 源图
- 导出前素材

#### `res/raw/`
- 原始参考图片
- 调研素材
- 样例文件
- demo 数据

**原则：**
- 代码编译资源进 `app/src/main/res`
- 项目资料资源进根级 `res/`

这俩必须严格分开。

---

### `scripts/`
脚本统一目录。

推荐子目录：

#### `scripts/dev/`
开发辅助：
- 本地检查
- 环境初始化
- 清理缓存
- 安装 debug 包

#### `scripts/build/`
构建脚本：
- 打 debug APK
- 打 release AAB
- 导出 mapping
- 复制产物到指定目录

#### `scripts/release/`
发布脚本：
- 生成 release note
- 整理截图
- 校验版本号
- 发布前检查

**原则：**
只要某个命令未来可能重复执行两次以上，就值得脚本化。

---

### `build-artifacts/`
项目统一产物目录。

推荐子目录：
- `build-artifacts/apk/`
- `build-artifacts/aab/`
- `build-artifacts/mapping/`

用于集中存放整理后的产物副本，方便：
- 发给人测试
- 做归档
- 接 release 流程
- 避免每次都去 Gradle 深层目录里翻

**重要建议：**
- Gradle 默认输出仍然在 module 的 `build/`
- 但对外使用的产物，可复制一份到 `build-artifacts/`
- `build-artifacts/` 默认建议加入 `.gitignore`

也就是说：
- `build/` 是临时构建目录
- `build-artifacts/` 是整理后的交付目录

---

### `gradle/` / `gradlew` / `build.gradle.kts`
这些保持 Android 标准工程结构，不要发明新轮子。

Monorepo 的统一性，应该体现在：
- 文档布局
- 资源布局
- 脚本布局
- 项目约定

而不是把标准 Android 工程硬改得面目全非。

---

## 4. 最小可落地模板

对于一个刚启动的新 Android 项目，建议至少具备：

```text
<project-name>/
├── README.md
├── PROJECT.md
├── .gitignore
├── app/
├── docs/
│   ├── product/
│   └── tech/
├── res/
│   └── screenshots/
├── scripts/
│   └── build/
├── build-artifacts/
├── gradle/
├── build.gradle.kts
├── settings.gradle.kts
├── gradle.properties
├── gradlew
└── gradlew.bat
```

这是我认为**最平衡**的一版：
- 不会太重
- 也不至于后期失控

---

## 5. 子项目命名规则

建议所有子项目目录使用：

- **小写字母**
- **kebab-case**
- **避免空格**
- **避免情绪化命名**

例如：
- `god-mode`
- `voice-keyboard`
- `quick-toggles`
- `watch-input-bridge`

不建议：
- `GodMode`
- `MySuperApp`
- `android_project_final_v2`

目录名是给工具链、脚本、CI、AI 一起读的，越稳定越好。

---

## 6. 根仓库层级建议

`MC_AndroidApp` 根目录未来建议逐步形成：

```text
MC_AndroidApp/
├── README.md
├── new projectwizard.md
├── templates/
├── shared-docs/
├── tooling/
├── god-mode/
├── another-app/
└── more-apps/
```

### `templates/`
放项目模板：
- 文档模板
- 项目脚手架模板
- issue / release note 模板

### `shared-docs/`
放跨项目共享文档：
- Android 权限研究
- Play Store 发布策略
- UI 规范共识
- 通用技术决策记录

### `tooling/`
放 monorepo 级脚本：
- 批量检查子项目结构
- 批量构建
- 创建新项目骨架
- 统一 lint / format / release 辅助工具

这三个目录不是现在必须建，但未来非常值得有。

---

## 7. 新项目创建流程建议

以后每创建一个新的 Android app，建议按下面步骤走：

1. 在根目录创建新的子目录，如 `voice-keyboard/`
2. 放入最小模板结构
3. 写好 `README.md`
4. 写好 `PROJECT.md`
5. 初始化 Android 工程
6. 建立 `docs/`、`res/`、`scripts/`、`build-artifacts/`
7. 把项目状态写清楚（idea / prototype / active）

这样做的好处是：
- 新项目不会只有代码没有上下文
- 后续交给 AI 接手时，信息更全
- 多项目并行时不会很快变成垃圾场

---

## 8. 对已有项目的落地建议

以 `god-mode/` 为例，我建议后续补齐到这个方向：

```text
god-mode/
├── README.md
├── PROJECT.md
├── CHANGELOG.md
├── app/
├── docs/
│   ├── product/
│   ├── tech/
│   └── releases/
├── res/
│   ├── screenshots/
│   └── icons/
├── scripts/
│   ├── build/
│   └── release/
├── build-artifacts/
└── ... Android 标准工程文件
```

注意：这不是要求一次补完。

正确做法是：
- 先把规范写清楚
- 后续新项目严格按规范建
- 老项目逐步补齐

这样成本最低，也最现实。

---

## 9. 最终约定

从现在开始，`MC_AndroidApp` 内所有新建 Android 子项目默认遵循以下原则：

1. **每个 app 一个独立子目录**
2. **每个子项目至少包含 README / PROJECT / docs / scripts 的基础结构**
3. **编译资源与项目资料资源严格分离**
4. **构建临时目录与交付产物目录严格分离**
5. **默认简单，允许后续扩展，不预设过度复杂架构**
6. **目录命名统一使用 kebab-case**

---

## 10. 我建议的下一步

下一步最值得做的是这两件事之一：

### 方案 A：给 `god-mode/` 补齐这套标准结构
把它变成第一个“标准样板项目”。

### 方案 B：在根目录创建 `templates/android-app-base/`
做一个真正可复制的新项目模板，以后开新 app 直接套。

如果你愿意，我下一轮就直接继续把其中一个做掉。