# Oil 101 全课程新手可读重写计划

## 目标

把模块 2-9 的 58 节旧式分析笔记全部改写为模块 1 已签收的教学形式。目标读者懂经济与金融，但没有石油行业知识。事实输入必须回到 Morgan Downey 的 Oil 101 原始章节；旧 JSON 只用于保留 ID、来源映射、图片、案例和产品接口，不作为事实依据。

## 金标准

- 签收样例：`_workflow/exemplars/golden-exemplar-module-01.json`
- 质量 rubric：`_workflow/exemplars/excellence-rubric.md`
- 产品 schema：模块 1 当前 JSON 字段与 `tests/oil101-platform.test.mjs` 的 beginner-first contract
- 渲染器：`renderTeachingLesson()`

每节必须按以下认知顺序写作：

1. 读者困惑
2. 真实物理场景
3. 一句话白话答案
4. 逐步机制
5. 有角色、已知条件、单位、运算和经济解释的数字例子
6. 原文信息图及阅读提示（适用时）
7. 市场或经营含义
8. 语境化术语
9. 常见误读与适用边界
10. 可折叠深入阅读

## 生产批次

### Batch A：平衡、短缺与价格

- Module 02：供需平衡
- Module 03：局部短缺
- Module 04：一桶油为什么没有唯一价格

这三个模块先建立物理平衡、地点约束与价格形成，是后续库存曲线和风险管理的前提。

### Batch B：库存、风险与供给者

- Module 05：库存与期限结构
- Module 06：风险管理
- Module 07：上游投资、页岩与 OPEC+

数字例子需要明确区分物理量、价格、现金流和合约敞口。涉及外部时效性资料时保留来源日期，不把 2026 年状态写成永恒规律。

### Batch C：产品、转型与综合推演

- Module 08：燃料、石化与能源转型
- Module 09：产业链综合实验

模块 9 不重复前八章摘要，而要教读者如何从新闻冲击逐层推出物理流、库存、价差、现金流和下一项验证数据。

## 每模块工作流

1. 直接阅读该模块列出的作者原始页面；外部 EIA/IEA/OPEC/CFTC/IRENA 来源只用于原模块已承载的事实。
2. 建立概念依赖顺序和原文 H2 覆盖表。
3. 重写模块级导读和全部 lessons。
4. 保留 lesson ID、source coverage、figure/reference、self-check 等产品接口。
5. 同步 canonical 与 docs mirror。
6. 运行模块 validator 和全局 beginner-first contract。
7. 由未参与写作的盲判官与 Module 01 并排审稿，并复算至少两个数字例子。
8. 定向修复后再审，Critical/Important 清零才进入下一状态。

## 集成闸门

- 9 个 canonical/docs 模块逐字节一致。
- 所有 lessons 均使用 beginner-first schema。
- 原有 source coverage 数量不减少，映射语义正确。
- 所有原图非空、可读、有阅读提示和 Reference。
- Node、validator、语法和 Playwright 9 模块桌面/手机测试全部通过。
- 390px 无横向溢出，长术语、表格、算例和引用不遮挡。
- Service Worker 缓存版本升级，线上验证读取到新数据。

## 发布

按批次提交，全部模块通过盲审后统一推送 `main`。发布后逐个检查 GitHub Pages 数据、教学渲染器和缓存版本，再将完整课程交给用户阅读。
