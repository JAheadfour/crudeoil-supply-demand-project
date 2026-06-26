# Chapter 18 - Forward Oil Markets: Futures and Swaps: 深度讲解

## 先给你结论

这一章讲 forward markets 如何把未来价格拿到今天交易。Futures 和 swaps 不是赌场附属品，而是 producer、refiner、airline、trader 管理风险和表达库存/时间结构观点的工具。

## 脑内模型

先看 curve shape：contango 鼓励买现货、存起来、卖远月；backwardation 鼓励释放库存。再看 spreads：calendar spread 看时间，crack spread 看炼厂 margin，location/quality spread 看物流和品级差异。专业交易者往往更看 spread than flat price。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| Paper Barrels and Wet Barrels | 这一节不是让你背标题，而是让你抓住：Paper markets 用期货和 swaps 转移价格风险，wet barrels 是实际交割物流。 |
| The Forward Curve and Its Two Shapes | 这一节不是让你背标题，而是让你抓住：Contango 表示远月高于近月，backwardation 表示近月高于远月。 |
| April 20, 2020: The Day Oil Went Negative | 这一节不是让你背标题，而是让你抓住：WTI negative price 是交割、库容、合约滚动和需求崩塌的叠加。 |
| Marginal Finding and Development Cost at the Back of the Curve | 这一节不是让你背标题，而是让你抓住：远端曲线常反映市场对长期边际供给成本的判断。 |
| Spreads: How Oil Traders Actually Trade | 这一节不是让你背标题，而是让你抓住：Traders 更多交易 time、location、quality 和 product spreads，而非单纯 flat price。 |
| The 3:2:1 and 2:1:1 Crack Spreads | 这一节不是让你背标题，而是让你抓住：Crack spreads 用成品油组合近似炼厂毛利。 |
| The Spreads Family Tree | 这一节不是让你背标题，而是让你抓住：Calendar、quality、location、inter-product spreads 共同构成交易语言。 |
| Exchange-Traded Futures | 这一节不是让你背标题，而是让你抓住：Futures 标准化、每日结算、集中清算，降低 counterparty risk。 |
| Over-the-Counter (OTC) Swap Contracts | 这一节不是让你背标题，而是让你抓住：Swaps 可定制标的、期限和结算指数，但有信用和 documentation 风险。 |
| EFP, EFS, and Block Trades | 这一节不是让你背标题，而是让你抓住：这些机制连接期货、实货和 OTC markets。 |
| The Live Curve Today | 这一节不是让你背标题，而是让你抓住：实时曲线用于判断库存、风险溢价和市场预期。 |

## 现实推演

3:2:1 crack spread 用 3 桶 crude 对 2 桶 gasoline 和 1 桶 diesel/heating oil，粗略模拟炼厂毛利。它不等于真实炼厂利润，但能快速告诉你产品相对 crude 是否变贵。

## 概念怎么串起来

- `Contango`：Futures deferred price > nearby price。 读的时候要防止这个误区或抓住这个 cue：可能支持 storage trade。
- `Backwardation`：Nearby price > deferred price。 读的时候要防止这个误区或抓住这个 cue：通常表示现货紧张或库存价值高。
- `Calendar spread`：不同月份合约价差。 读的时候要防止这个误区或抓住这个 cue：比 flat price 更直接反映时间结构。
- `3:2:1 crack`：3 crude futures versus 2 gasoline plus 1 diesel/heating oil。 读的时候要防止这个误区或抓住这个 cue：只是简化炼厂 slate。
- `Swap settlement`：OTC 合约按参考指数现金结算。 读的时候要防止这个误区或抓住这个 cue：没有实货交割但有 index risk。
- `Variation margin`：Futures 每日 mark-to-market 的现金流。 读的时候要防止这个误区或抓住这个 cue：盈利合约也可能有短期流动性需求。
- `EFP`：Exchange for Physical，把 futures position 与 physical trade 互换。 读的时候要防止这个误区或抓住这个 cue：连接 paper 和 wet barrels。
- `Negative price`：当持有合约的交割负担超过油本身价值时可出现。 读的时候要防止这个误区或抓住这个 cue：不是油没有能源价值，而是即时处置成本极高。

## 读完必须会解释

- paper barrels 和 wet barrels 的区别
- contango/backwardation 与库存行为的关系
- 为什么 2020 负价是 futures delivery 和 storage 的共同结果

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/chapters/futures-swaps
