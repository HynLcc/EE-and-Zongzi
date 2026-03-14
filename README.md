# EE & Zongzi

A journal-style weight tracker for mom and baby.

[中文](#中文) | [English](#english)

---

## English

### The Story

"Why does every baby app only track the baby's weight? What about the mom?"

That was EE's complaint one evening. She'd just finished weighing Zongzi — step on the scale holding him, step on again alone, subtract — the same little ritual every few days since he was born in the autumn of 2025. She had the baby's growth chart from three different apps. None of them cared about her number.

She wanted to watch Zongzi grow, ounce by ounce. But she also wanted to track her own postpartum recovery, because being a good mom starts with being well. Every parenting app on her phone had beautiful baby growth charts and zero space for the person doing all the heavy lifting.

So this app was made for her — one that records both weights in a single flow, because mom matters too. Styled like the journal she never had time to keep: warm paper, washi tape, handwritten numbers. A quiet little place to write down two weights and let the math do the rest.

Every entry is a tiny love letter: *Today you weighed 6.2 kg, little Zongzi. And mom is doing great too.*

### Features

- **Weight Recording** — Weigh yourself holding the baby, then weigh yourself alone. The app calculates baby's weight automatically.
- **Growth Chart** — WHO boys weight-for-age percentile bands (P3–P97) with your baby's actual data overlaid.
- **Weight Trend** — Mom's postpartum weight trend line chart.
- **History Diary** — Timeline view of all records with long-press to delete.

### Screenshots

| Dashboard | Record | History |
|:---:|:---:|:---:|
| Polaroid hero + stat cards + mini charts | Dual input cards + auto calculation | Timeline + washi tape decorations |

### Design

Journal / Scrapbook style:

- Warm beige notebook background with faint ruled lines
- Washi tape, polaroid frames, slight card rotations
- Handwritten font Caveat + Chinese serif Noto Serif SC + header ZCOOL XiaoWei
- Warm palette: ink-brown `#5c4a3a`, orange `#d97757` (baby), green `#788c5d` (mom)

### Tech Stack

- SwiftUI + SwiftData
- Swift Charts (WHO percentiles + weight trend)
- iOS 17+

### Build

Open `EEandZongzi.xcodeproj` in Xcode, select a target device, and Run.

You'll need to set your own Development Team in Signing & Capabilities on first run.

---

## 中文

### 故事

"为什么每个母婴 App 都只记宝宝的体重？妈妈的就不管了？"

这是 EE 某天晚上的吐槽。她刚称完粽子的体重——抱着儿子站上秤，再自己站上去，两个数字一减——从 2025 年秋天粽子出生起，每隔几天都重复这个小仪式。手机里三个母婴 App 都有漂亮的宝宝成长曲线，没有一个在意妈妈的那个数字。

她想看着粽子一点一点长大，也想记录自己产后恢复的过程，因为当一个好妈妈，要先让自己好好的。可是每个育儿 App 都把全部心思放在了宝宝身上，对那个每天抱着宝宝上秤的人视而不见。

所以就有了这个 App——一次称重，同时记录两个人的体重，因为妈妈也很重要。做成她一直没时间写的那本手账的样子：暖暖的纸张，和纸胶带，手写的数字。一个安静的小角落，写下两个体重，剩下的交给计算。

每一条记录都是一封小小的情书：*今天你 6.2 公斤了，小粽子。妈妈也很好哦。*

### 功能

- **记录体重** — 抱着宝宝称一次，自己称一次，自动算出宝宝体重
- **成长曲线** — WHO 男婴体重百分位图（P3–P97），直观看宝宝发育
- **体重趋势** — 妈妈产后体重变化折线图
- **历史日记** — 时间线浏览所有记录，长按可删除

### 截图

| 首页 | 记录 | 日记 |
|:---:|:---:|:---:|
| 拍立得主图 + 统计卡片 + 迷你图表 | 双卡片输入 + 自动计算 | 时间线 + 和纸胶带装饰 |

### 设计

手账 / 日记本风格（Journal / Scrapbook）：

- 米黄笔记本背景 + 浅色横格线
- 和纸胶带、拍立得相框、卡片微旋转
- 手写字体 Caveat + 中文衬线 Noto Serif SC + 标题 ZCOOL XiaoWei
- 暖色调：墨棕 `#5c4a3a`、橙 `#d97757`（宝宝）、绿 `#788c5d`（妈妈）

### 技术栈

- SwiftUI + SwiftData
- Swift Charts（WHO 百分位 + 体重趋势）
- iOS 17+

### 构建

用 Xcode 打开 `EEandZongzi.xcodeproj`，选择目标设备，Run。

首次运行需在 Signing & Capabilities 中设置你自己的 Development Team。

---

## License

MIT
