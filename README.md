# EE和粽子

妈妈（EE）和宝宝（小粽子）的体重记录 App，手账风格。

## 功能

- **记录体重** — 抱着宝宝称一次，自己称一次，自动算出宝宝体重
- **成长曲线** — WHO 女婴体重百分位图（P3–P97），直观看宝宝发育
- **体重趋势** — 妈妈产后体重变化折线图
- **历史日记** — 时间线浏览所有记录，长按可删除

## 截图

| 首页 | 记录 | 日记 |
|:---:|:---:|:---:|
| 拍立得主图 + 统计卡片 + 迷你图表 | 双卡片输入 + 自动计算 | 时间线 + 和纸胶带装饰 |

## 设计

手账 / 日记本风格（Journal / Scrapbook）：

- 米黄笔记本背景 + 浅色横格线
- 和纸胶带、拍立得相框、卡片微旋转
- 手写字体 Caveat + 中文衬线 Noto Serif SC + 标题 ZCOOL XiaoWei
- 暖色调：墨棕 `#5c4a3a`、橙 `#d97757`（宝宝）、绿 `#788c5d`（妈妈）

## 技术栈

- SwiftUI + SwiftData
- Swift Charts（WHO 百分位 + 体重趋势）
- iOS 17+

## 构建

用 Xcode 打开 `EEandZongzi.xcodeproj`，选择目标设备，Run。

首次运行需在 Signing & Capabilities 中设置你自己的 Development Team。

## License

MIT
