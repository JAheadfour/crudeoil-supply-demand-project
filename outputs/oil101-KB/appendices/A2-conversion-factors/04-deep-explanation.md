# Appendix 2 - Conversion Factors: 深度讲解

## 先给你结论

这个 appendix 是单位转换生存指南。Oil market 到处是 barrels、tonnes、gallons、BTU、BOE、Mcf、MWh，如果口径不统一，价格和数量比较会立刻错掉。

## 脑内模型

转换不是背固定数字，而是先问物理属性和口径：barrel 是体积，tonne 是质量，barrel-to-tonne 取决于 density/API；HHV 和 LHV 的热值口径不同；BOE 是能量等价，不是价格等价。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| Density, API gravity, and why the barrel-to-tonne factor moves | 这一节不是让你背标题，而是让你抓住：Barrel-to-tonne conversion 取决于 density/API，不同 crude 不能用同一个精确因子。 |
| Standard oil-industry conversion factors | 这一节不是让你背标题，而是让你抓住：常用单位包括 barrel、gallon、metric tonne、BTU、BOE、MWh 等。 |
| High heating value versus low heating value | 这一节不是让你背标题，而是让你抓住：HHV 包含水蒸气凝结热，LHV 不包含，比较燃料时必须统一口径。 |
| Barrel of oil equivalent accounting | 这一节不是让你背标题，而是让你抓住：BOE 用热值把 gas 或其他能源折成 oil equivalent，常用 6 Mcf per BOE 近似。 |
| Worked examples | 这一节不是让你背标题，而是让你抓住：例题展示 API、density、barrels、tonnes、BTU 和 BOE 的转换路径。 |
| A caution on precision | 这一节不是让你背标题，而是让你抓住：学习和交易可用近似因子，结算和工程要用合同、温度和密度表。 |

## 现实推演

两种 crude 都是一百万 barrels，但 API 不同，换成 tonnes 会不同。天然气用 6 Mcf = 1 BOE 只是财务近似，实际价格和热值都可能偏离。做商业结算时必须回到合同规定的 conversion table。

## 概念怎么串起来

- `API from SG`：API = 141.5 / SG - 131.5。 读的时候要防止这个误区或抓住这个 cue：API 越高越轻。
- `SG from API`：SG = 141.5 / (API + 131.5)。 读的时候要防止这个误区或抓住这个 cue：参考温度要一致。
- `Barrels per tonne`：Approx = 1000 / (density kg/m3 * 0.158987)。 读的时候要防止这个误区或抓住这个 cue：密度不同导致 factor 变化。
- `HHV vs LHV`：HHV 包含水凝结热，LHV 不包含。 读的时候要防止这个误区或抓住这个 cue：跨燃料比较必须统一口径。
- `BOE`：Barrel of oil equivalent，约 5.8-6.0 MMBtu。 读的时候要防止这个误区或抓住这个 cue：财务口径不等于价格等值。
- `Mcf to BOE`：常用 6 Mcf gas = 1 BOE。 读的时候要防止这个误区或抓住这个 cue：实际热值和价格比会变。
- `Precision rule`：商业结算应使用合同规定 conversion。 读的时候要防止这个误区或抓住这个 cue：不要用教材近似做结算。

## 读完必须会解释

- API/SG/density 如何互转
- 为什么 barrels per tonne 会随 crude grade 变化
- HHV/LHV 和 BOE 为什么容易造成误读

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/appendices/conversion-factors
