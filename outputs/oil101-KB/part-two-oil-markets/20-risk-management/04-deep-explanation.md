# Chapter 20 - Managing Oil Price Risk: 深度讲解

## 先给你结论

这一章把衍生品从交易工具拉回公司治理。Risk management 的目标不是猜对油价，而是让公司在坏情景下活下来，在正常情景下能融资、投资和运营。好的 hedge policy 服务现金流，不服务炫技。

## 脑内模型

先识别 exposure，再选 instrument，再管理 basis、roll、liquidity、counterparty、accounting 和 governance。Producer、refiner、airline、marketer 的风险方向不同，所以没有统一 hedge ratio。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| Why Commodities Are Volatile | 这一节不是让你背标题，而是让你抓住：Oil volatility 来自低短期弹性、库存限制、地缘政治和金融杠杆。 |
| The Case for Hedging | 这一节不是让你背标题，而是让你抓住：Hedging 用可接受成本降低现金流波动，让公司能投资、借款和运营。 |
| Corporate Hedging Objectives by Firm Type | 这一节不是让你背标题，而是让你抓住：Producers、refiners、airlines、marketers 的风险暴露和目标不同。 |
| Hedging Instruments | 这一节不是让你背标题，而是让你抓住：Futures、swaps、options、collars 和 physical contracts 各有成本和风险。 |
| Basis Risk | 这一节不是让你背标题，而是让你抓住：Hedge index 与实际实货价格不完全一致，留下 basis exposure。 |
| Roll Risk: The Metallgesellschaft Lesson | 这一节不是让你背标题，而是让你抓住：短期 hedge 长期 exposure 需要连续 roll，曲线结构可产生巨大现金流压力。 |
| Value at Risk and Expected Shortfall | 这一节不是让你背标题，而是让你抓住：VaR 和 ES 衡量在置信水平下的潜在损失，但依赖模型假设。 |
| Stress Testing | 这一节不是让你背标题，而是让你抓住：Stress tests 检查极端但 plausible 场景下的 liquidity 和 solvency。 |
| Counterparty Risk and the ISDA Framework | 这一节不是让你背标题，而是让你抓住：OTC hedges 依赖 collateral、netting 和 legal documentation 管理信用风险。 |
| Hedge Accounting | 这一节不是让你背标题，而是让你抓住：会计规则决定 hedge gains/losses 如何进入 earnings。 |
| Historical Corporate Hedging Blowups and One Famous Gain | 这一节不是让你背标题，而是让你抓住：历史案例说明 hedge 可以保护公司，也可能因结构和 governance 出错而放大风险。 |
| Portfolio Theory and the Efficient Frontier | 这一节不是让你背标题，而是让你抓住：风险管理要看 portfolio covariance，而非孤立单笔交易。 |
| Peer Benchmarking: What Other Producers Are Doing | 这一节不是让你背标题，而是让你抓住：同行 hedge ratios 和 tenors 可作为参考，但不能替代自身风险目标。 |
| Why Some Companies Do Not Hedge | 这一节不是让你背标题，而是让你抓住：不 hedge 可能源于股东偏好、成本、会计、流动性或对价格的观点。 |
| Operational Reality | 这一节不是让你背标题，而是让你抓住：有效 hedge 需要 policy、limits、reporting、systems 和董事会治理。 |

## 现实推演

Metallgesellschaft 的教训是 roll risk 和 liquidity risk 可以击穿看似合理的 hedge。用短期期货滚动长期固定价格销售，曲线结构和保证金现金流可能让公司在经济上对、现金上先死。

## 概念怎么串起来

- `Hedge ratio`：Hedged volume / exposed volume。 读的时候要防止这个误区或抓住这个 cue：100% hedge 不一定最优。
- `Basis risk`：Local physical price - hedge index price 的不确定性。 读的时候要防止这个误区或抓住这个 cue：Flat price hedge 不能消除 location/quality risk。
- `Roll risk`：到期合约换月至远月时面临价差和现金流风险。 读的时候要防止这个误区或抓住这个 cue：长期暴露不宜机械短期期货滚动。
- `VaR`：给定置信水平和期限的最大预期损失阈值。 读的时候要防止这个误区或抓住这个 cue：尾部之外损失看不到。
- `Expected shortfall`：超过 VaR 后的平均损失。 读的时候要防止这个误区或抓住这个 cue：比 VaR 更关注尾部严重性。
- `Stress test`：假设极端价格、basis、liquidity 和 counterparty 情景。 读的时候要防止这个误区或抓住这个 cue：不是概率预测，而是生存测试。
- `ISDA netting`：OTC 衍生品主协议和净额结算安排。 读的时候要防止这个误区或抓住这个 cue：法律可执行性很关键。
- `Collar hedge`：买保护性 option 同时卖另一侧 option 降低成本。 读的时候要防止这个误区或抓住这个 cue：会限制收益空间。

## 读完必须会解释

- basis risk 为什么无法靠 flat price hedge 消除
- VaR 和 expected shortfall 各自看什么
- 为什么 hedge accounting 和 board policy 很现实

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/chapters/risk-management
