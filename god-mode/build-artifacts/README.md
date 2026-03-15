# build-artifacts

这个目录用于存放整理后的交付产物副本。

建议用途：
- `apk/`：最终交付测试或发布的 APK 副本
- `aab/`：如未来需要 Play / store 产物
- `mapping/`：release mapping 等辅助文件

注意：
- Gradle 原始输出仍在 module 的 `build/` 目录
- 这里是面向交付与归档的整理目录
