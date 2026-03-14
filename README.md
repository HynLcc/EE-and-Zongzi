# EE & Zongzi

A journal-style weight tracker for mom and baby.

[中文](#中文) | [English](#english)

---

## English

### The Story

Zongzi came into the world on a quiet autumn morning in 2025 — a tiny, warm little dumpling placed into his mother's arms.

In those early days, EE would step onto the bathroom scale twice each morning: once cradling Zongzi against her chest, and once standing alone. The difference between the two numbers was her son's weight — a small subtraction that somehow held the entire weight of love.

She wanted to watch Zongzi grow, ounce by ounce. She also wanted to take care of herself, because being a good mom starts with being well. But the notebook on the nightstand kept getting buried under burp cloths and pacifiers, and the numbers in her phone's notes app were a mess of typos and forgotten dates.

So this app was made for her — styled like the journal she never had time to keep. Warm paper, washi tape, handwritten numbers. A quiet little place to write down two weights and let the math do the rest.

Every entry is a tiny love letter: *Today you weighed 6.2 kg. You're growing so well, little Zongzi.*

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

2025 年秋天一个安静的早晨，粽子来到了这个世界——一个小小的、暖暖的小团子，被放进了妈妈的怀里。

那些日子里，EE 每天早上都会站上体重秤两次：一次抱着粽子，一次自己站上去。两个数字相减，就是儿子的体重——一道简单的减法，却好像承载了全部的爱。

她想看着粽子一点一点长大，也想好好照顾自己，因为当一个好妈妈，要先让自己好好的。可是床头的小本子总被口水巾和奶嘴埋住，手机备忘录里的数字也乱成了一团，日期记错、小数点打歪。

所以就有了这个 App——做成她一直没时间写的那本手账的样子。暖暖的纸张，和纸胶带，手写的数字。一个安静的小角落，写下两个体重，剩下的交给计算。

每一条记录都是一封小小的情书：*今天你 6.2 公斤了，长得真好呀，小粽子。*

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
