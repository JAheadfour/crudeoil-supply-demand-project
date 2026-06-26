# Chapter 2 - A Crude Oil Assay: 深度讲解

## 先给你结论

这一章的核心是：原油不是一种商品，而是一张质量表。API gravity、sulfur、TAN、metals、viscosity、salt、BS&W 等指标共同决定炼厂愿意付多少钱。你看到 WTI、Brent、Maya、Dubai 这些名字时，真正要问的是：这桶油能炼出什么，处理它要花多少钱，谁有能力接收它。

## 脑内模型

把 crude assay 当成炼厂的入场体检。轻质低硫原油像容易处理的原料，能多产 gasoline、diesel、jet fuel；重质高硫原油像需要特殊厨房和厨师的原料，便宜但只有复杂炼厂能吃下。价格差就是“产品收入 - 处理成本 - 操作风险”的结果。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| 三种密度表达 | 这一节不是让你背标题，而是让你抓住：/ 指标 / 英文 / 含义 / 直觉 / /---/---/---/---/ / 公制密度 / Metric density / kg/m3，水约为 1000 kg/m3 / 工程和科学表达 / / 比重 / Specific gravity, SG / 原油密度除以水密度 / SG < 1 会浮在水上 / / API 度 / API gravity / American Petroleum Institute 的倒置尺度 / 数字越大，油越轻 / API gravity 的直觉陷阱非常重要：API 数字越高，密度越低。它是一个倒置指标，不是“越高越重”。 |
| 关键公式 | 这一节不是让你背标题，而是让你抓住：```text API gravity = 141.5 / SG - 131.5 SG = 141.5 / (API gravity + 131.5) Density kg/m3 ≈ SG * 1000 ``` WTI 示例：若 API gravity 为 39.6，则 SG 约为 0.827，密度约为 827 kg/m3。一桶 42 US gallons 约等于 159 liters，所以一桶 WTI 的质量约为 131 kg，而同体积水约为 159 kg。 |
| Hydrometer 的原理 | 这一节不是让你背标题，而是让你抓住：Hydrometer 是现场测量比重或 API gravity 的简单仪器。它利用 Archimedes principle：仪器在液体中下沉到“排开液体重量等于仪器自身重量”的位置。液体越密，hydrometer 浮得越高；液体越轻，则沉得更低。实际读数通常要校正到 60 degrees F 的参考温度。 |
| API density 分类 | 这一节不是让你背标题，而是让你抓住：/ Class / API gravity / 炼厂含义 / /---/---:/---/ / Light / >31 degrees API / 通常产出更多汽油、柴油、航煤，较容易加工 / / Medium / 22-31 degrees API / 产品结构较均衡，多数炼厂能处理 / / Heavy / 10-22 degrees API / 常需要 coker 或 hydrocracker 来减少低价值残渣 / / Extra-heavy / <10 degrees API / 比水还重，运输常需要 diluent 或加热 / 注意：市场命名不一定等于严格工程分类。判断质量时看 assay 数字，而不是只看商品名。 |

## 现实推演

假设两桶油都叫 crude：一桶 40 API、0.3% sulfur，另一桶 20 API、3% sulfur、TAN 高。前者很多炼厂都能接收，产品 slate 好；后者可能需要 coker、hydrocracker、hydrotreating 和防腐能力。后者不是“没价值”，而是必须折价到复杂炼厂觉得值得冒险。

## 概念怎么串起来

- `Class`：API gravity cue 读的时候要防止这个误区或抓住这个 cue：Decision cue
- `Light`：>31 degrees API 读的时候要防止这个误区或抓住这个 cue：Easier high-value product yield
- `Medium`：22-31 degrees API 读的时候要防止这个误区或抓住这个 cue：Broad refinery compatibility
- `Heavy`：10-22 degrees API 读的时候要防止这个误区或抓住这个 cue：More residue; complex conversion units matter
- `Extra-heavy`：<10 degrees API 读的时候要防止这个误区或抓住这个 cue：Denser than water; transport often needs diluent or heat
- `Class`：Sulfur by weight 读的时候要防止这个误区或抓住这个 cue：Decision cue
- `Sweet`：<0.5% 读的时候要防止这个误区或抓住这个 cue：Lower corrosion and desulfurization burden
- `Medium-sour`：roughly 0.5%-2.0% 读的时候要防止这个误区或抓住这个 cue：Requires sulfur-aware refinery economics
- `Sour`：around/above 2.0% 读的时候要防止这个误区或抓住这个 cue：Hydrotreating and corrosion controls become central

## 读完必须会解释

- 为什么 API 越高反而越轻
- 为什么 sweet/sour 不只是环保标签，而是炼厂成本标签
- 为什么 heavy-sour crude 可以便宜但仍然很重要

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/chapters/crude-oil-assay
