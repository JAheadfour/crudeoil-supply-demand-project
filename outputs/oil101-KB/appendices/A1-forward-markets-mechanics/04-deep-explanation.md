# Appendix 1 - More on the Two Most Important Forward Markets: 深度讲解

## 先给你结论

这个 appendix 是第 18 章的技术补充，帮你分清 NYMEX WTI、ICE Brent、Dated Brent、BFOETM、CFD、EFP、EFS 这些名词。它们都和 forward markets 有关，但连接的实货、现金结算和风险窗口不一样。

## 脑内模型

把 forward market 分成三层：exchange futures 提供标准化合约，physical assessments 提供实货价格锚，OTC/CFD/EFP/EFS 把两者连接起来。专业市场不是一个价格，而是一套桥梁。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| NYMEX WTI Crude Oil Futures (CL) | 这一节不是让你背标题，而是让你抓住：CL 是 Cushing 交割的 light sweet crude futures，标准化了美国内陆 benchmark。 |
| ICE Brent Crude Oil Futures | 这一节不是让你背标题，而是让你抓住：Brent futures 是全球 seaborne crude 关键 benchmark，现金结算和实货 assessment 连接紧密。 |
| BFOETM: the basket, the 2018 and 2023 reforms | 这一节不是让你背标题，而是让你抓住：Brent basket 扩展到 BFOETM 以维持可交割流动性。 |
| Dated Brent and the Platts Market on Close | 这一节不是让你背标题，而是让你抓住：Dated Brent 是实货评估，MOC process 是形成 benchmark 的核心机制。 |
| Contracts for Differences (CFDs) | 这一节不是让你背标题，而是让你抓住：CFDs 交易 Dated Brent 与 futures/forward 之间的差。 |
| Exchange for Physical (EFP) | 这一节不是让你背标题，而是让你抓住：EFP 在 futures 与 physical positions 之间转换。 |
| Exchange for Swap (EFS) | 这一节不是让你背标题，而是让你抓住：EFS 在 futures 与 OTC swap exposure 之间转换。 |
| Contract spec reference | 这一节不是让你背标题，而是让你抓住：Contract specs 定义交割、质量、计量、结算和最后交易日。 |

## 现实推演

一个 physical Brent cargo 可能用 Dated Brent 定价，但 trader 又用 ICE Brent futures 管理风险，中间用 CFD 管理 Dated 与 forward 的差。看似都叫 Brent，其实 reference、timing 和 settlement 都不同。

## 概念怎么串起来

- `CL contract`：NYMEX WTI futures，Cushing physical delivery。 读的时候要防止这个误区或抓住这个 cue：持有到期有交割义务。
- `Brent futures`：ICE Brent futures，全球 seaborne crude 参考。 读的时候要防止这个误区或抓住这个 cue：与 Dated Brent 不是同一物。
- `BFOETM`：Brent、Forties、Oseberg、Ekofisk、Troll、Midland basket。 读的时候要防止这个误区或抓住这个 cue：加入 Midland 是为维持流动性。
- `Dated Brent`：短期实货 Brent cargo assessment。 读的时候要防止这个误区或抓住这个 cue：很多 physical crude formulas 参考它。
- `CFD`：Dated Brent 与 forward/futures 之间的差价合约。 读的时候要防止这个误区或抓住这个 cue：用于管理 physical pricing window risk。
- `EFP`：Exchange for Physical。 读的时候要防止这个误区或抓住这个 cue：连接实货和期货账本。
- `EFS`：Exchange for Swap。 读的时候要防止这个误区或抓住这个 cue：连接期货和 OTC swaps。
- `Contract spec`：合约的法律和操作说明书。 读的时候要防止这个误区或抓住这个 cue：交易前必须看质量、地点和到期规则。

## 读完必须会解释

- CL 和 Brent futures 的交割/结算差异
- Dated Brent 和 Brent futures 为什么不是同一物
- EFP/EFS 如何连接 futures、physical 和 swaps

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/appendices/forward-markets-mechanics
