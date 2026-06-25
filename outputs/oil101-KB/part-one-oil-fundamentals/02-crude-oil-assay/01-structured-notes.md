# Chapter 2 - A Crude Oil Assay: Structured Notes

## 学习目标

读完这一章后，应该能够：

- 解释 crude oil assay 是什么，以及为什么它会直接影响成交价格。
- 区分 field、stream、blend 和 marker crude。
- 在 API gravity、specific gravity 和 metric density 之间转换。
- 用 API gravity 和 sulfur content 判断一桶原油在质量矩阵中的位置。
- 识别 TAN、metals、viscosity、pour point、RVP、carbon residue、salt、BS&W 等 assay 项目对炼厂的意义。

## 1. Crude Oil Assay 是什么

核心 idea：原油不是标准化商品，而是一组化学和物理属性的组合。Assay 是生产方或第三方给出的质量说明书，帮助炼厂估计这批 crude 能炼出什么产品、需要付出多少处理成本、以及是否符合采购合同。

| 概念 | 定义 | 为什么重要 |
|---|---|---|
| Crude oil grade | 一种具有相对稳定特性的原油品级 | 不同 grade 的收益和加工成本不同 |
| Assay | 对某一 grade 或 cargo 的性质分析 | 炼厂用它做采购、调油和装置排程 |
| Off spec | 实际交付质量偏离合同或 assay 规格 | 可能导致折价、改运、延迟或拒收 |
| Distressed cargo | 没有合适买家或接收方案的原油船货 | 通常需要大幅折价才容易成交 |
| Product yield | 炼后汽油、柴油、航煤、渣油等产品比例 | 决定这桶原油对炼厂的收入潜力 |

炼厂最关心的不是“这桶油叫什么名字”，而是 assay 里反映出的经济结果：轻质产品能产多少，硫、酸、金属、盐、水和沉积物会带来多少处理成本。

## 2. Fields、Streams、Blends、Markers

原油不是从地下湖泊中抽出来的，而是存在于多孔岩石结构中。一个 oilfield 可以包含一个或多个 reservoir，由一组 wells 开采。

| 层级 | 含义 | 学习重点 |
|---|---|---|
| Field | 同一地质结构上的油田或油藏组合 | 是生产的地质来源 |
| Stream | 一个或多个井口产出的原油经管线汇集后的流 | 性质相对稳定，但会随油田生命周期慢慢变化 |
| Blend | 多个 stream 混合后形成的商业品级 | 便于形成足够交易量，也能平滑极端性质 |
| Marker crude | 市场用作定价参照的代表性原油 | WTI、Brent、Dubai、Maya 等承担基准角色 |

例子：

| Marker | 类型 | 典型质量信号 |
|---|---|---|
| WTI | 美国轻质低硫 streams 的聚合，Cushing 交割中心相关 | Light-sweet |
| Brent | 北海多个 streams 的 blend | Light-sweet |
| Dubai | Middle East sour benchmark | Medium/sour |
| Maya | Mexican heavy-sour blend | Heavy-sour |
| Urals | 俄罗斯出口 blend | Medium-sour |

商业逻辑有两层：第一，足够的 blend 体量才能支持长距离管线和油轮经济；第二，混合可以降低单一 stream 过高 sulfur、TAN 或其他极端属性带来的交易障碍。

## 3. Density: 最重要的物理性质

核心 idea：density 是 assay 中最重要的单一物理性质，因为它暗示原油分子结构和炼后产品结构。通常 lighter crude 含有更多较短、较简单的烃分子，更容易产出 gasoline、diesel、jet fuel 等高价值产品；heavy crude 则更容易留下 residual fuel、bitumen 或 coke 相关问题。

### 三种密度表达

| 指标 | 英文 | 含义 | 直觉 |
|---|---|---|---|
| 公制密度 | Metric density | kg/m3，水约为 1000 kg/m3 | 工程和科学表达 |
| 比重 | Specific gravity, SG | 原油密度除以水密度 | SG < 1 会浮在水上 |
| API 度 | API gravity | American Petroleum Institute 的倒置尺度 | 数字越大，油越轻 |

API gravity 的直觉陷阱非常重要：API 数字越高，密度越低。它是一个倒置指标，不是“越高越重”。

### 关键公式

```text
API gravity = 141.5 / SG - 131.5
SG = 141.5 / (API gravity + 131.5)
Density kg/m3 ≈ SG * 1000
```

WTI 示例：若 API gravity 为 39.6，则 SG 约为 0.827，密度约为 827 kg/m3。一桶 42 US gallons 约等于 159 liters，所以一桶 WTI 的质量约为 131 kg，而同体积水约为 159 kg。

### Hydrometer 的原理

Hydrometer 是现场测量比重或 API gravity 的简单仪器。它利用 Archimedes principle：仪器在液体中下沉到“排开液体重量等于仪器自身重量”的位置。液体越密，hydrometer 浮得越高；液体越轻，则沉得更低。实际读数通常要校正到 60 degrees F 的参考温度。

### API density 分类

| Class | API gravity | 炼厂含义 |
|---|---:|---|
| Light | >31 degrees API | 通常产出更多汽油、柴油、航煤，较容易加工 |
| Medium | 22-31 degrees API | 产品结构较均衡，多数炼厂能处理 |
| Heavy | 10-22 degrees API | 常需要 coker 或 hydrocracker 来减少低价值残渣 |
| Extra-heavy | <10 degrees API | 比水还重，运输常需要 diluent 或加热 |

注意：市场命名不一定等于严格工程分类。判断质量时看 assay 数字，而不是只看商品名。

## 4. Sweet versus Sour: Sulfur Content

核心 idea：sulfur 是原油质量的第二根支柱。硫越高，通常价值越低，因为它减少有效烃含量、增加腐蚀风险，并在燃烧或产品销售前带来环保处理成本。

硫影响价值的三条路径：

- Energy/value：硫占据一部分 barrel，降低可转化为高价值烃产品的比例。
- Corrosion：硫化物会腐蚀管线、储罐和炼厂装置。
- Regulation：燃料中的硫会形成污染物，炼厂必须通过 hydrotreating 等工艺脱硫。

| Class | Sulfur content by weight | 典型例子 |
|---|---:|---|
| Sweet | <0.5% | WTI、Brent、Bonny Light |
| Medium-sour | 0.5%-2.0% 左右 | Urals、Oman Blend |
| Sour | 约 2.0% 及以上 | Dubai、Arab Heavy、Maya |

Sulfur 往往更容易和较大、较复杂的烃分子绑定，所以极端质量常见组合是 light-sweet 或 heavy-sour。汽油、柴油、航煤等较轻馏分天然硫含量通常低于 residual fuel 和 bitumen。

## 5. The Crude Quality Matrix

核心 idea：把 API gravity 和 sulfur content 放在二维图上，就得到原油质量矩阵。横轴通常从 heavy 到 light，纵轴从 sweet 到 sour。最容易加工、通常溢价最高的是 light-sweet；最难加工、常有折价的是 heavy-sour。

| Quadrant | 例子 | 经济含义 |
|---|---|---|
| Light-sweet | WTI、Brent、Bonny Light、Saharan Blend | 高价值产品 yield 好，能被很多炼厂接收 |
| Light-sour | Oman Blend、Arab Extra Light | 中间馏分潜力好，但需要脱硫 |
| Heavy-sweet | Doba、Dalia 等较少见例子 | 低硫是优点，但常被高 TAN 或其他问题抵消 |
| Heavy-sour | Maya、Arab Heavy、Dubai、Western Canadian Select | 单桶价格低，但只有复杂炼厂能有效处理 |

炼厂 complexity 决定买家范围。拥有 coking、hydrocracking、deep hydrotreating 能力的复杂炼厂可以购买折价 heavy-sour crude，并通过装置能力把“难处理”变成利润空间。缺少这些装置的简单炼厂更偏好 light-sweet crude。

## 6. Assay Sheet 的其他关键项目

| 项目 | 英文 | 含义 | 炼厂影响 |
|---|---|---|---|
| 总酸值 | Total Acid Number, TAN | 中和 1 gram crude 所需 KOH 的 mg 数 | TAN 高会带来 naphthenic acid corrosion 和折价 |
| 金属 | Vanadium, nickel | 重馏分中常见的催化剂毒物 | 会降低 catalyst 寿命和装置效率 |
| 黏度 | Viscosity | 原油流动难易程度，常用 cSt 表示 | 高黏度原油运输和进料可能要加热或稀释 |
| 倾点 | Pour point | 原油还能流动的最低温度 | 冷区管线和油轮运输风险高 |
| 雷德蒸气压 | Reid Vapor Pressure, RVP | 轻端挥发性，单位常为 psi | 高 RVP 表示轻端多，但产品环保规格会限制挥发 |
| 残炭 | Carbon residue | 加工中形成 coke 的倾向 | 影响 coker 负荷和残渣处理 |
| 沥青质 | Asphaltenes | 最重、芳香性强的分子群 | 可能堵管、增加 coke 问题，并与深色相关 |
| 氮 | Nitrogen | 原油中的氮化合物 | 会形成污染物，也会毒化 catalysts |
| 盐 | Salt | 进入常压塔前必须在 desalter 中去除 | 否则会造成下游腐蚀 |
| 基本沉积物和水 | BS&W | 水、泥砂和杂质的总括指标 | 通常希望进厂低于 1% by weight |

TAN 的规则：多数炼厂偏好 TAN under 0.5；around 0.7 and above 往往会被视为高度酸性并要求折价或特殊防腐能力。Doba 等高 TAN crude 是典型例子。

## 7. 为什么 Assay 最终会变成价格差

原油价格差不是抽象的“好坏”标签，而是 refinery yield calculation 的结果：

```text
Refinery value ≈ expected product revenue - processing costs - quality/operational risk
```

Expected product revenue 取决于汽油、柴油、航煤、燃料油等产品价格和产率。Processing costs 取决于 sulfur、metals、acid、viscosity、salt、water、carbon residue 等问题。炼厂装置越复杂，越有能力吃下折价原油；当全球 coking 或 hydrotreating 能力紧张时，heavy-sour 折价会扩大。当复杂炼厂有闲置能力时，折价可能收窄。

## 常见误区

- 把 API gravity 当作普通密度读数：API 越高，原油越轻，不是越重。
- 只凭名称判断质量：必须看 assay 中的 API、sulfur、TAN 等数字。
- 认为 sweet crude 一定总是便宜或贵：价格还取决于产品市场、炼厂配置和地区物流。
- 忽略温度参考：密度和体积会随温度变化，行业通常在标准参考温度下报告。
- 把 heavy-sour 视为“没人要”：它不是不能用，而是需要复杂炼厂和足够折价。
