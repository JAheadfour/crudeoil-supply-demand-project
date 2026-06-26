# Chapter 17 - Oil Prices: 深度讲解

## 先给你结论

这一章讲价格怎么从实货世界生成。Oil price 不是一个数字，而是一串阶梯：wellhead、pipeline、hub、seaborne cargo、refinery gate、wholesale、retail，每一层都加上质量、地点、时间、运输、税和 margin。

## 脑内模型

用公式记：physical crude price = benchmark +/- quality differential +/- location differential +/- timing/freight adjustments。Benchmark 提供共同语言，differential 才把具体货物的质量和物流翻译出来。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| Physical Oil Trading | 这一节不是让你背标题，而是让你抓住：实货交易处理真实 barrels 的质量、地点、时间和信用风险。 |
| Benchmark Pricing | 这一节不是让你背标题，而是让你抓住：WTI、Brent、Dubai 等 benchmarks 给不同 crudes 提供可观察参考价。 |
| The Delivery-Chain Price Ladder | 这一节不是让你背标题，而是让你抓住：从 wellhead 到 retail，价格逐层加入 transport、storage、tax、margin 和 quality adjustments。 |
| Unit Conversions | 这一节不是让你背标题，而是让你抓住：Barrel、metric tonne、gallon、BTU 等单位转换是价格比较基础。 |
| Formula Pricing: A Worked Example | 这一节不是让你背标题，而是让你抓住：Formula price = benchmark price plus/minus quality and location differential。 |
| Freight Netback Pricing | 这一节不是让你背标题，而是让你抓住：Netback 从目的地产品或 crude value 倒推产地可支付价格。 |
| Pricing Windows and the Platts MOC | 这一节不是让你背标题，而是让你抓住：Price reporting agencies 用窗口和 MOC process 评估 physical market。 |
| Oil and the US Dollar | 这一节不是让你背标题，而是让你抓住：国际 oil pricing 以美元为核心，FX 和利率影响生产国购买力和投资者需求。 |
| Retail Price Differences | 这一节不是让你背标题，而是让你抓住：Retail fuel price 差异来自 taxes、logistics、specs、competition 和 crude/product markets。 |

## 现实推演

一桶重质高硫原油卖到远方复杂炼厂，价格可能按 Brent 减质量折价，再减 freight，再考虑目的地炼厂可承受的 netback。你看到新闻里的 Brent/WTI 只是起点，真正成交价还要通过 formula pricing 落地。

## 概念怎么串起来

- `Formula price`：Benchmark +/- differential。 读的时候要防止这个误区或抓住这个 cue：Differential 同时包含质量、地点和物流。
- `Netback`：Destination value - freight - handling - quality costs。 读的时候要防止这个误区或抓住这个 cue：用于比较不同买家或出口路径。
- `Crack spread`：Product value - crude cost。 读的时候要防止这个误区或抓住这个 cue：炼厂 margin proxy，不是完整利润。
- `Barrel-tonne conversion`：Tonnes depend on density, so factor varies by crude/API。 读的时候要防止这个误区或抓住这个 cue：不能用固定数比较所有 grades。
- `Benchmark liquidity`：交易量、透明度和可交割性支撑 benchmark。 读的时候要防止这个误区或抓住这个 cue：名字知名不等于适合作 benchmark。
- `MOC assessment`：Platts Market on Close 通过收盘窗口评估 spot price。 读的时候要防止这个误区或抓住这个 cue：是评估机制，不一定等于交易所结算价。
- `Retail price build-up`：Crude/product wholesale + distribution + taxes + retail margin。 读的时候要防止这个误区或抓住这个 cue：油价涨跌不会一比一进入泵价。

## 读完必须会解释

- benchmark 和 differential 的关系
- freight netback 如何倒推产地价值
- 为什么 retail gasoline price 不会一比一跟 crude price 同步

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/chapters/oil-prices
