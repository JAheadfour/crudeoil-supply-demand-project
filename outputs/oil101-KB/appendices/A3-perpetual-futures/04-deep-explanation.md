# Appendix 3 - Perpetual Futures and the 24/7 Oil Market: 深度讲解

## 先给你结论

这个 appendix 讨论 crypto-style perpetual futures 能否进入 oil market。Perp 的吸引力是 24/7 和无到期，但 oil 是有实物交割、库存、监管和 benchmark assessment 的市场，所以 perp 很难替代传统 futures curve。

## 脑内模型

Perpetual futures 没有到期收敛，只能靠 funding rate 锚定外部 index。传统 commodity futures 有交割或现金结算机制，到期时会被实货世界拉回。两者最大差别是是否有 physical convergence。

## 按章节怎么读

| 小节 | 你要真正理解的点 |
|---|---|
| What a Perpetual Is | 这一节不是让你背标题，而是让你抓住：Perpetual futures 没有固定到期日，通过 funding rate 锚定现货或指数。 |
| How Oil Perps Reached the Market | 这一节不是让你背标题，而是让你抓住：Crypto-style perps 被引入 oil price exposure，但和 regulated commodity futures 有本质差异。 |
| Why the Clock Is the Real Attraction | 这一节不是让你背标题，而是让你抓住：24/7 trading 满足周末和非交易时段风险表达需求。 |
| The Institutional Response | 这一节不是让你背标题，而是让你抓住：传统机构更重视 clearing、market integrity、reference price 和监管框架。 |
| Why Oil Has Not Gone Perpetual, and the Skeptic's View | 这一节不是让你背标题，而是让你抓住：Oil 是实物、交割、库存和监管市场，perp 不能替代 futures curve。 |
| The Borrowed Price | 这一节不是让你背标题，而是让你抓住：Perps 借用外部 benchmark/index，价格发现仍依赖 underlying oil market。 |

## 现实推演

如果周末中东出现风险，oil perp 可以让投资者立刻表达价格观点；但它引用的 index 仍来自传统油价体系。真正的 physical barrels、freight、storage 和 refinery demand 不会因为 perp 24/7 交易而变成 24/7 实货市场。

## 概念怎么串起来

- `Perpetual future`：无到期合约，通过 funding payments 维持与指数接近。 读的时候要防止这个误区或抓住这个 cue：没有自然交割收敛。
- `Funding rate`：Longs 与 shorts 定期支付的锚定机制。 读的时候要防止这个误区或抓住这个 cue：funding 可以成为主要成本。
- `Index price`：Perp 用外部价格源作为锚。 读的时候要防止这个误区或抓住这个 cue：若 index 薄弱，perp 价格也不稳。
- `24/7 risk transfer`：周末和夜间可交易是主要卖点。 读的时候要防止这个误区或抓住这个 cue：流动性质量不等于交易时间长度。
- `Delivery convergence`：传统 futures 到期通过实物或现金结算收敛。 读的时候要防止这个误区或抓住这个 cue：perp 缺少到期收敛机制。
- `Regulatory gap`：Perps 常处在不同监管框架下。 读的时候要防止这个误区或抓住这个 cue：机构采用受合规和 clearing 限制。
- `Borrowed price discovery`：Perp 依赖原油 benchmark，而非独立发现实货价格。 读的时候要防止这个误区或抓住这个 cue：不能用衍生报价替代 physical assessment。

## 读完必须会解释

- funding rate 如何替代到期机制
- 为什么 borrowed price discovery 是 perp 的弱点
- 为什么 oil market 的实货约束比 crypto 更强

## 不看原书也能懂的检查

- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？
- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？
- 你能不能指出一个常见误解，并解释为什么它错？

Source reference: https://oil101.morgandowney.com/appendices/perpetual-futures
