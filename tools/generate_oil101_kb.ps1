param(
  [string]$OutputRoot = "outputs/oil101-KB"
)

$ErrorActionPreference = "Stop"

function Parse-PipedRows {
  param(
    [string]$Text,
    [int]$MinFields
  )

  $rows = @()
  foreach ($line in ($Text -split "`n")) {
    $trimmed = $line.Trim()
    if (-not $trimmed) { continue }
    $parts = $trimmed -split "\|", $MinFields
    if ($parts.Count -lt $MinFields) { throw "Bad row: $trimmed" }
    $rows += ,($parts | ForEach-Object { $_.Trim() })
  }
  return $rows
}

function New-MarkdownTableRow {
  param([string[]]$Cells)
  return "| " + (($Cells | ForEach-Object { ($_ -replace "\|", "/") }) -join " | ") + " |"
}

function Write-Utf8File {
  param(
    [string]$Path,
    [string]$Content
  )
  $parent = Split-Path -Parent $Path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $parent).Path + "\" + (Split-Path -Leaf $Path), $Content, [System.Text.UTF8Encoding]::new($false))
}

$chapters = @(
@{
  Label = "Chapter 1"
  Title = "A Brief History of Oil"
  Url = "https://oil101.morgandowney.com/chapters/history"
  Dir = "part-one-oil-fundamentals/01-history"
  Bank = "concept"
  Sections = @'
1859 to 1911: A New Industry|现代油业从照明燃料替代开始，Drake 井和 Standard Oil 把零散 seep use 变成可投资、可运输、可垄断的产业。
International Origins: Baku, Persia, and Sumatra|美国不是唯一源头，Baku、Persia 和 Sumatra 共同奠定了后来的 BP、Shell 和国际石油版图。
World War I and the Navy Switch to Oil|海军由 coal 转 oil 使石油从民用品升级为战略物资，运输燃料成为需求核心。
The Texas Railroad Commission and Achnacarry|过剩供给催生了配额和卡特尔逻辑，TRC 用 spare capacity 管理价格，Achnacarry 是国际版雏形。
The Seven Sisters and OPEC's Founding|Seven Sisters 控制 concessions 和 posted prices，OPEC 则是资源国争夺定价权的制度化回应。
Mossadegh, the Abadan Crisis, and the 1953 Coup|伊朗国有化展示了资源主权与外部能源安全之间的冲突，也重塑了美伊关系。
Enrico Mattei and the 25/75 Break|Mattei 打破 50/50 分成惯例，证明合同分配是政治经济结果而非自然法则。
1971: The Tehran Agreement and the Nixon Gold Standard|Tehran Agreement 和美元脱金把 posted price、汇率和资源国购买力绑在一起。
The Oil Shocks and Demand Destruction|1970s shocks 说明 oil share of GDP 超过承受阈值时，价格冲击会通过衰退摧毁需求。
NYMEX, Formula Pricing, and the 1986 Counter-Shock|期货、spot market 和 formula pricing 把油价从官方 posted price 推向透明的基准加差价体系。
1990 to 2008: Low Prices, Asian Crisis, and the Supercycle|冷战后低价、亚洲危机和中国需求超级周期展示了油价受宏观增长与投资周期共同驱动。
2009 to 2026: The Shale Revolution, OPEC+, and Negative Oil|页岩、OPEC+ 和 2020 负油价构成现代市场三件事：短周期供给、供应管理和基础设施约束。
Timeline: Key Events in Oil History|时间线把技术、战争、金融市场和资源民族主义串成油价制度演化史。
'@
  Concepts = @'
Kerosene replacement|煤油最初替代 whale oil，说明能源转型常由成本和供给瓶颈触发。|不要把油业起源直接理解成汽车需求。
Standard Oil|垂直整合和运输折扣让 Standard Oil 控制炼油，1911 拆分又生成现代 majors 的根系。|反垄断改变公司形态但不消灭规模经济。
Texas Railroad Commission|TRC 通过限制 Texas production 管理 spare capacity，是 OPEC 后来模式的先例。|它不是铁路故事，而是早期全球油价管理者。
Seven Sisters|西方 majors 通过 concessions 和 posted prices 管理国际油流和分成。|公司控制不是永恒，资源国后来重新夺权。
OPEC|OPEC 是资源国协调产量和定价权的联盟。|早期 OPEC 权力弱，真正转折来自 US spare capacity 消失。
Demand destruction|高油价通过压缩收入和利润让经济活动下降，从而反过来压低需求。|不是每次涨价都会毁灭需求，阈值和宏观环境重要。
Formula pricing|实货原油常用 benchmark 加减质量和地点 differential 定价。|它不是固定价格合同，而是浮动参考价机制。
Shale and OPEC+ era|页岩缩短供给周期，OPEC+ 扩大供应管理联盟，2020 负油价暴露交割和库容约束。|现代油价不能只用传统 OPEC 视角解释。
'@
}
@{
  Label = "Chapter 2"
  Title = "A Crude Oil Assay"
  Url = "https://oil101.morgandowney.com/chapters/crude-oil-assay"
  Dir = "part-one-oil-fundamentals/02-crude-oil-assay"
  Bank = "formula"
  SkipWrite = $true
  Sections = @'
What Is a Crude Oil Assay?|Assay 是 crude grade 或 cargo 的质量说明书，决定炼厂能产什么、要付多少处理成本、是否会 off spec。
Fields, Streams, and Blends|Field 是地质来源，stream 是物理流，blend 和 grade 是商业规格，marker crude 才能承担定价参照。
Density: The Most Important Property|API gravity、specific gravity 和 metric density 共同描述轻重，API 越高表示油越轻。
Sweet versus Sour: Sulfur Content|Sulfur 提高腐蚀、环保和脱硫成本，因此 sweet crude 通常更容易加工。
The Crude Quality Matrix|API 和 sulfur 形成 light-sweet 到 heavy-sour 的质量矩阵，炼厂复杂度决定可承受质量范围。
Acidity, Metals, and the Rest of the Assay Sheet|TAN、metals、viscosity、pour point、RVP、carbon residue、salt、BS&W 等会改变加工风险和折价。
Why the Assay Matters for Prices|炼厂价值等于产品收入减去处理成本和操作风险，assay 把质量转化成价差。
'@
  Concepts = @'
API gravity|API = 141.5 / SG - 131.5，越高表示密度越低。|不要把 API 当成普通密度指标。
Specific gravity|SG 是原油密度与水密度之比，SG = 141.5 / (API + 131.5)。|参考温度会影响读数。
Sulfur class|Sweet 通常低于 0.5%，sour 需要更强脱硫和腐蚀控制。|阈值要看具体合同和 assay。
TAN|Total Acid Number 衡量酸性，常用 mg KOH/g crude 表示。|高 TAN 往往需要防腐和折价。
'@
}
@{
  Label = "Chapter 3"
  Title = "Components of Oil Liquids"
  Url = "https://oil101.morgandowney.com/chapters/components"
  Dir = "part-one-oil-fundamentals/03-components"
  Bank = "concept"
  Sections = @'
What Makes Up "Oil Liquids"?|Total oil liquids 不等于 conventional crude，而是 crude、tight oil、condensates、NGLs、unconventional、biofuels 和 refinery gain 的合计。
What Is Actually In a Barrel|42-gallon barrel 经炼厂加工后体积通常略增，产品 slate 取决于 crude slate、refinery configuration 和地区需求。
Conventional Crude Oil|Conventional crude 能自然流动或通过 artificial lift 生产，2005 后增长主要被 tight oil 和 NGLs 取代。
Streams, Blends, and Grades|Stream 是物理流，blend 是混合，grade 是市场可交易规格。
Condensates|Condensate 介于 crude 和 NGL 之间，极轻、价值高，lease 与 plant condensate 在统计和监管上不同。
Natural Gas Liquids In Detail|NGLs 经 gas processing 和 fractionation 分成 ethane、propane、butanes、natural gasoline 等 purity products。
Fractionation and Ethane Rejection|Ethane recovery 取决于作为 petchem feedstock 与留在 gas stream 中燃烧的相对价值。
Naphtha: The Other Petchem Feed|Naphtha 是炼厂轻馏分，也是全球 steam cracker 的关键 feedstock。
Unconventional Crude Oil|Oil sands bitumen 等需要 upgrading 或 diluent 才能像普通 crude 一样运输。
Refinery Gain|Cracking 让同重量重分子变成更大体积的轻分子，形成约 2% volume gain。
2nd Edition Update: The Shale and NGL Revolution|US tight oil 和伴生气 NGLs 是 2008 后全球 liquids 增量的核心来源。
'@
  Concepts = @'
Total liquids|总供给口径包含多种液体而非只含 conventional crude。|看 supply balance 时先确认口径。
Refinery gain|炼厂输出液体体积大于输入 crude 体积，但质量守恒。|这不是凭空创造能量。
Lease condensate|井口分离出的轻质液体，在统计上常归入 crude。|不要和 plant condensate 混同。
NGL purity products|Y-grade 经 fractionation 分成 ethane、propane、normal butane、iso-butane、natural gasoline。|每种产品有独立价格和需求。
Ethane rejection|当 ethane 液体价值低于 gas BTU 价值时，处理厂会把它留在 gas stream。|这是日度经济决策。
Dilbit|Bitumen 与 diluent 混合后才能通过管线流动。|高 API diluent 不是最终产品需求，而是运输条件。
Tight oil|页岩水平井和压裂生产的 light sweet oil。|不要和 kerogen oil shale 混淆。
'@
}
@{
  Label = "Chapter 4"
  Title = "Chemistry of Oil"
  Url = "https://oil101.morgandowney.com/chapters/chemistry"
  Dir = "part-one-oil-fundamentals/04-chemistry"
  Bank = "formula"
  Sections = @'
The Building Blocks: Carbon and Hydrogen|石油化学的核心是 carbon 能形成稳定链和环，hydrogen 决定饱和度与燃烧性质。
Carbon Count, Boiling Point, and Physical State|Carbon count 越高，boiling point 和分子量通常越高，常温状态从 gas 到 liquid 再到 wax/solid。
The Four Molecular Structures: PONA|Paraffins、olefins、naphthenes、aromatics 解释了燃料质量、refining behavior 和 petchem feedstock 差异。
Typical PONA by Crude Grade|不同 crude grade 的 PONA composition 影响汽油、柴油、沥青、petchem feed 的潜力。
Saturated vs Unsaturated|Saturated molecules 更稳定，unsaturated molecules 更活泼，常是 petrochemical building blocks。
Heteroatoms: Sulfur, Nitrogen, Oxygen, Metals|非 C/H 元素带来腐蚀、污染、catalyst poisoning 和脱除成本。
Combustion Chemistry|Hydrocarbon oxidation 释放热量，缺氧或低温燃烧会生成 CO、soot、unburnt hydrocarbons、NOx 和 SOx。
Octane and Cetane: Measuring Fuel Quality|汽油需要抗 knock 的高 octane，柴油需要易自燃的高 cetane，两者偏好的分子结构相反。
Cracking and Combining|Refining 用 cracking、alkylation、reforming 等改变 carbon count 和分子结构。
Why Chemistry Drives Pricing|化学组成决定产品 slate、处理成本和合规负担，因此最终决定 crude differential。
'@
  Concepts = @'
Methane combustion|CH4 + 2 O2 -> CO2 + 2 H2O + heat。|完全燃烧假设充足氧气和足够温度。
Iso-octane combustion|C8H18 + 12.5 O2 -> 8 CO2 + 9 H2O + heat。|用于理解 gasoline stoichiometry。
Stoichiometric air-fuel ratio|Iso-octane 接近 14.7:1 by weight。|真实发动机因温度、负荷和排放控制而偏离。
PONA|Paraffins、Olefins、Naphthenes、Aromatics 是油品结构分类。|不是产品名称，而是分子家族。
Octane number|衡量汽油抗 knock 能力，branched paraffins 和 aromatics 通常高。|高 octane 不代表高 energy density。
Cetane number|衡量柴油压燃速度，straight-chain paraffins 通常高。|汽油好分子常常不是柴油好分子。
Cracking reaction|长链分子可裂化为较短 paraffin 和 olefin。|质量守恒但产品价值变化。
Alkylation|Isobutane 与 olefin 结合生成高 octane alkylate。|这是 combining，不是 cracking。
'@
}
@{
  Label = "Chapter 5"
  Title = "Industry Overview"
  Url = "https://oil101.morgandowney.com/chapters/industry-overview"
  Dir = "part-one-oil-fundamentals/05-industry-overview"
  Bank = "concept"
  Sections = @'
An Industry in Three Segments|Upstream 找油产油，midstream 运输处理储存，downstream 炼制销售，交接点也是定价和风险转移点。
National Oil Companies Versus International Oil Companies|NOCs 控制多数储量和产量，IOCs 与 independents 更依赖资本市场和项目组合。
The NOC League Table|Aramco、NIOC、CNPC、Rosneft 等 NOCs 是供给权重核心，但披露透明度差异很大。
US Independents: The Shale Cohort|US independents 是页岩革命主力，后来又被 Majors 通过并购整合。
Oilfield Services: The Contractors Who Actually Drill|多数 operator 不自有全部 rigs 和 crews，而依赖 SLB、Halliburton、Baker Hughes 等服务公司。
Pure-Play Refiners|独立炼厂没有 upstream hedge，利润主要由 crack spread 和地区产品供需决定。
Physical Trading Houses|Vitol、Trafigura 等 trading houses 通过物流、质量、时间和地点套利连接全球 barrels。
Engineering, Procurement, and Construction|EPC firms 建造 refineries、LNG trains 和 petrochemical plants，但通常不拥有资产。
Vertical Integration and the Disaggregation Trend|传统 major 纵向整合，近几十年资本市场推动专业化拆分，NOCs 反而向 downstream 延伸。
OPEC and OPEC+|OPEC+ 把俄罗斯等非 OPEC 产油国纳入供给管理，覆盖全球重要产量份额。
The Downstream Footprint|炼厂数量和新增产能向 Middle East、India、China 转移，复杂度持续提高。
Key Market Institutions|EIA、IEA、CFTC、Platts、Argus 等机构生产数据、库存、仓位和价格评估。
'@
  Concepts = @'
Upstream|勘探、开发和生产 crude oil 与 natural gas。|风险和回报最高，周期长。
Midstream|管线、船运、储存和气体处理等物流资产。|常见 fee-based toll-road economics。
Downstream|炼油、石化、成品油分销和零售。|利润看 margin 而非单纯油价。
NOC|国家石油公司，通常控制本国资源和政策目标。|商业目标可能服从财政和外交目标。
IOC|国际上市油公司，靠资本纪律、技术和全球组合竞争。|产量占比小于公众想象。
Oilfield services|为 operator 提供 drilling、completion、seismic、pressure pumping 等服务。|周期性比 operator 更强。
Crack spread|成品油价值与 crude input 成本之间的炼厂毛利 proxy。|不是净利润，未扣运营和运输成本。
Price reporting agency|Platts 和 Argus 评估 spot prices，支撑 formula pricing。|许多实货价格来自 assessment 而非交易所成交。
'@
}
@{
  Label = "Chapter 6"
  Title = "Exploration and Production"
  Url = "https://oil101.morgandowney.com/chapters/exploration-production"
  Dir = "part-one-oil-fundamentals/06-exploration-production"
  Bank = "concept"
  Sections = @'
The Upstream Sector|Upstream 把地质不确定性转化为可生产 reserves，核心风险在 subsurface、cost 和 commodity price。
Obtaining Rights to Explore and Drill|勘探前必须取得 mineral rights、leases、licenses 或 concessions，权利结构决定经济分成。
Types of E&P Agreements|Concession、PSC、service contract 等合同在 ownership、cost recovery 和 profit split 上不同。
How Oil Forms: Source Rock, Reservoir Rock, and Cap Rock|Source rock 生成 hydrocarbons，reservoir rock 储存并传导，cap rock 封闭形成 trap。
Reservoir Mechanics: Pressure Is Everything|Reservoir pressure 推动流体向井筒流动，随生产下降后需要人工举升或注入维压。
Exploration: Seismic Surveys|Seismic 用声波成像地下结构，降低但不能消除 drilling risk。
Drilling|Drilling 把地质目标转成井筒，casing、cementing 和 mud control 负责安全和井壁稳定。
Production Phases|Primary、secondary、tertiary recovery 分别靠天然能量、注水/注气和 enhanced recovery。
Decline Curves and Field Life|产量通常随时间递减，decline curve 决定 reserves booking、现金流和再投资需求。
Offshore Production|Offshore 项目资本密集、周期长，平台、subsea 和 FPSO 选择取决于水深和规模。
The Shale Revolution|Shale 用 horizontal drilling 和 hydraulic fracturing 把低渗透源岩变成短周期制造型资产。
'@
  Concepts = @'
Mineral rights|地下资源开采权，决定谁能授权 drilling。|美国私有矿权与许多国家国有资源差异巨大。
Production sharing contract|公司先回收成本，再与国家分配 profit oil。|名义所有权通常仍在国家。
Source-reservoir-cap system|生、储、盖缺一不可，trap 才能累积油气。|有油源不等于有商业油田。
Porosity and permeability|Porosity 是储存空间，permeability 是流动能力。|高孔隙不一定高渗透。
Reservoir drive|溶解气、水驱、气顶等天然能量驱动生产。|drive mechanism 决定 decline shape。
Seismic risk|Seismic 看结构和属性，不能保证流体类型和商业流量。|漂亮构造也可能 dry hole。
Decline curve|用历史产量估计未来产量和 EUR。|页岩初期 decline 特别快。
Enhanced oil recovery|用 steam、CO2、chemical 等提高采收率。|技术可行不等于经济可行。
'@
}
@{
  Label = "Chapter 7"
  Title = "Refining"
  Url = "https://oil101.morgandowney.com/chapters/refining"
  Dir = "part-one-oil-fundamentals/07-refining"
  Bank = "concept"
  Sections = @'
Feedstock, Slate, and Refinery Gain|炼厂利润来自 crude slate 与 product slate 的匹配，cracking 还会带来 volume gain。
The Four Stages of Refining|Separation、conversion、treatment、blending 构成炼厂主逻辑。
Separation: The Crude Distillation Unit|CDU 按 boiling range 分离 crude，但不改变分子结构。
Conversion: Where Margin Is Made|FCC、coker、hydrocracker 把低价值重馏分转成更高价值轻产品。
Combining: Alkylation and Polymerization|Combining units 把小分子合成为高 octane gasoline blendstock。
Modifying: Catalytic Reforming, Isomerization, Ethers|Reforming 和 isomerization 改变分子结构，提高汽油 octane 和 hydrogen supply。
Treatment: Hydroprocessing, Amine, Merox, Claus|Treatment 去除 sulfur、nitrogen、metals 等 impurities，使产品达标。
Bitumen, Lubricants, Waxes, and Grease|重端和 specialty products 依赖特定原油与复杂加工。
Blending: Where Finished Product Is Born|Finished product 是多股 blendstocks 按规格调和，不是单一装置产物。
Refinery Types and the Nelson Complexity Index|复杂度越高，越能处理 heavy/sour crude 并提升 light product yield。
US Refining Geography and the PADDs|PADD 反映美国成品油物流、库存和炼厂区域结构。
Turnaround Season|Turnaround 是计划检修，降低短期 runs 并影响 seasonal supply。
'@
  Concepts = @'
CDU|常压蒸馏按 boiling point 切分 crude。|它只分离，不升级。
Vacuum distillation|在低压下分离重馏分，避免高温裂解。|常接 coker、FCC、lube units。
FCC|催化裂化把 gasoil 转成 gasoline-range molecules 和 LPG。|催化剂会受 metals 和 coke 影响。
Coker|热裂化重渣油，产 light products 和 petroleum coke。|重质油加工能力的关键。
Hydrocracker|用 hydrogen 和催化剂裂化并脱硫，柴油质量好。|氢气成本和压力要求高。
Alkylation|把 isobutane 和 olefins 合成高 octane alkylate。|常与 FCC 产 olefins 配套。
Hydrotreating|用 hydrogen 去除 sulfur/nitrogen 等杂质。|环保规格越严越重要。
Nelson Complexity Index|衡量炼厂相对复杂度和升级能力。|高复杂度不是自动高利润，还要看 crude/product spreads。
'@
}
@{
  Label = "Chapter 8"
  Title = "Standards"
  Url = "https://oil101.morgandowney.com/chapters/standards"
  Dir = "part-one-oil-fundamentals/08-standards"
  Bank = "concept"
  Sections = @'
Why Standards Matter|Standards 把质量、交割和安全要求写成可测量规则，降低交易争议。
Standards-Setting Organizations|ASTM、API、ISO、EPA、CARB 等组织分别覆盖测试方法、行业规范和监管限值。
Crude Oil Tests|Crude specs 包括 API gravity、sulfur、TAN、metals、salt、BS&W、distillation 等。
Octane: RON, MON, and AKI|RON、MON 和 AKI 衡量汽油抗 knock 能力，美国 pump octane 是 RON/MON 平均。
Gasoline Specifications|Gasoline specs 管控 octane、RVP、sulfur、benzene、oxygenate 和 distillation curve。
Diesel Specifications|Diesel specs 关注 sulfur、cetane、cloud point、lubricity 和 cold flow。
Jet Fuel Specifications|Jet fuel 对 freezing point、flash point、thermal stability 和 contamination 极敏感。
Residual and Bunker Fuel|Bunker fuel specs 受 sulfur、viscosity、metals 和 IMO 规则影响。
'@
  Concepts = @'
ASTM methods|标准化实验方法，使不同实验室结果可比。|标准是测量语言，不是价格本身。
API gravity test|用密度推断原油轻重。|测试温度和校正必须一致。
RON|Research Octane Number，较温和工况下的抗 knock 指标。|欧洲常用 RON 标示。
MON|Motor Octane Number，更高负荷工况下的抗 knock 指标。|通常低于 RON。
AKI|Anti-Knock Index = (RON + MON) / 2，美国泵上标示。|不要直接拿美国 87 与欧洲 95 比。
RVP|Reid Vapor Pressure 衡量汽油挥发性。|夏季 RVP 限制更严格。
ULSD|Ultra-low sulfur diesel，低硫让后处理催化器可用。|低硫不等于高 cetane。
IMO 2020|全球船燃 sulfur cap 改变 bunker fuel demand 和 refinery economics。|合规路径可用低硫油或 scrubber。
'@
}
@{
  Label = "Chapter 9"
  Title = "Finished Products"
  Url = "https://oil101.morgandowney.com/chapters/finished-products"
  Dir = "part-one-oil-fundamentals/09-finished-products"
  Bank = "concept"
  Sections = @'
The 19 Products of Crude Oil|Crude 价值来自多产品组合，从 gasoline、diesel 到 asphalt、petcoke 和 sulfur。
Gasoline: A Cocktail, Not a Single Product|Gasoline 是多种 blendstocks 按 octane、RVP、sulfur 和地区规格调和。
Jet Fuel and the Arrival of SAF|Jet fuel 规格严格，SAF 是 decarbonization 路径但受 feedstock 和 certification 约束。
Diesel: On-Road, Off-Road, Marine, and Home Heat|Diesel family 需求广，规格因 sulfur、税制和用途差异而变。
Residual Fuel and the Bunker Market After IMO 2020|IMO 2020 改变高硫残渣油出口和升级价值。
LPG|Propane 和 butane 服务取暖、烹饪、石化和汽油调和。
Lubricant Base Oils and the Group I to V Classification|Base oil groups 反映 sulfur、saturates、viscosity index 和合成程度。
Waxes|Waxes 是重质 paraffinic streams 的 specialty product。
Petroleum Coke|Petcoke 是 coking 副产物，价值取决于 sulfur、metals 和用途。
Bitumen and Asphalt|Asphalt 需求与道路建设和季节相关，偏好特定重质原油。
Kerosene and Niche Products|Kerosene 仍用于加热、照明和 jet fuel blending。
Carbon Black and Sulfur|部分副产品来自炼厂和 gas treating，对橡胶、化工和农业有用。
Global Refined Product Trade Flows|产品贸易由地区炼厂配置、需求结构和规格差异驱动。
'@
  Concepts = @'
Blendstock|可调入最终产品的中间流。|成品油不是单装置直出物。
Gasoline pool|汽油池用 octane、RVP、benzene、sulfur 等约束最优化。|高 octane 组分也可能受环保限值约束。
SAF|Sustainable aviation fuel 可 drop-in 调入 jet pool。|供应量和成本仍是主要约束。
ULSD|低硫柴油支撑现代排放后处理。|低硫化增加炼厂氢耗。
Bunker fuel|船燃从 high sulfur fuel oil 转向 VLSFO/MGO/scrubber 路径。|区域合规和船队设备决定需求。
LPG|Propane/butane 用于取暖、烹饪、石化和调和。|NGL 价格不总跟 crude 同步。
Base oil groups|Group I-V 表示润滑基础油质量和工艺路线。|Group 编号不是品牌等级。
Petcoke|Coker 产出的碳质副产物。|高 sulfur petcoke 市场受环保限制。
'@
}
@{
  Label = "Chapter 10"
  Title = "Petrochemicals"
  Url = "https://oil101.morgandowney.com/chapters/petrochemicals"
  Dir = "part-one-oil-fundamentals/10-petrochemicals"
  Bank = "concept"
  Sections = @'
Chemicals from Oil and Gas|Petrochemicals 把 hydrocarbons 转成 plastics、fibers、solvents、fertilizers 等材料需求。
Two Feedstock Routes|Ethane/LPG route 成本低但 slate 窄，naphtha route 更贵但产物更均衡。
The Six Basic Building Blocks|Ethylene、propylene、butadiene、benzene、toluene、xylene 是主要 building blocks。
The Ethylene Value Chain|Ethylene 主要进入 polyethylene、ethylene oxide、PVC intermediates 等。
The Propylene Value Chain|Propylene 来自 steam cracking、FCC 和 PDH，进入 polypropylene、propylene oxide 等。
The Aromatics Value Chain|BTX 支撑 polyester、nylon、solvents 和 high-octane blendstocks。
Methanol, Ammonia, and Urea|Gas-based molecules 连接能源、化肥和化工市场。
The US Shale Advantage|低价 ethane 给 US polyethylene 出口带来结构性成本优势。
Plastics in Context and the China Overbuild|塑料需求仍增长，但中国大规模产能改变全球 margins。
2nd Edition Update: The Petrochemical Demand Driver|在 transport fuel 增长放缓时，petchem 是 oil demand 的关键增量部门。
'@
  Concepts = @'
Steam cracking|高温裂解 ethane、LPG 或 naphtha 生成 olefins。|Feedstock 决定 product slate。
Ethane advantage|US shale ethane 低价使 polyethylene 成本低。|优势集中在 ethylene derivatives。
Naphtha cracking|亚洲和欧洲常用 naphtha，产 olefins 与 aromatics 更均衡。|成本更受 crude 价格影响。
Ethylene|最大 olefin，主要做 polyethylene。|不能直接运输很远，常就地转化。
Propylene|用于 polypropylene 和化学中间体。|来源分散，FCC/PDH 也重要。
BTX|Benzene、toluene、xylenes 是 aromatics 基础。|Aromatics 与 gasoline octane 和 petchem 同时相关。
Methanol|可由 natural gas 或 coal 制成，进入化工和燃料链。|区域 feedstock 决定成本。
China overbuild|新增化工产能压低全球 margins 并改变贸易流。|需求增长不等于所有 producers 盈利。
'@
}
@{
  Label = "Chapter 11"
  Title = "Transporting Oil"
  Url = "https://oil101.morgandowney.com/chapters/transporting-oil"
  Dir = "part-one-oil-fundamentals/11-transporting-oil"
  Bank = "concept"
  Sections = @'
Five Methods of Moving Oil|Oil 可通过 tanker、pipeline、rail、truck 和 barge/river 系统移动，各自成本与灵活性不同。
Tanker Ships|Tankers 连接跨洋 crude/product flows，船型和航线决定 freight economics。
Chartering and Worldscale|Worldscale 提供标准化运费基准，实际租船按百分比或 dollars per ton 交易。
Pipelines|Pipelines 是陆上大批量低成本运输方式，但路径固定且受监管和 permitting 约束。
Crude by Rail and the Bakken Boom|Rail 提供速度和弹性，Bakken boom 时弥补管线不足，但安全和成本压力高。
Trucking: The Last Mile|Trucking 负责 wellhead、terminal 和零售配送中的短距离灵活移动。
IMO 2020 and the Transformation of Bunker Fuel|船燃 sulfur rules 改变航运燃料和 refinery residual economics。
Shipping Chokepoints|Strait of Hormuz、Suez、Panama 等 chokepoints 影响全球风险溢价。
LNG Carriers in Brief|LNG 运输要求低温专用船，与 crude tanker 逻辑不同。
Trading Hubs|Cushing、Houston、ARA、Singapore 等 hubs 集中储存、定价和交割。
Incoterms and Delivery Pricing|FOB、CIF、DAP 等条款决定 freight、insurance、risk transfer 和价格比较。
'@
  Concepts = @'
Tanker freight|海运成本随船型、航线、港口延迟和燃料成本变化。|远距离不一定贵，规模经济重要。
Worldscale|标准航线运费表，实际报价常为 WS 百分比。|WS100 不是固定美元价格。
Pipeline tariff|管线按费率收取运输费，容量可通过 commitments 分配。|低成本但缺少灵活性。
Rail optionality|铁路可快速改向，适合管线瓶颈期。|成本和事故风险较高。
Trucking|短距离、低规模、高灵活性运输。|不适合替代长距离主干运输。
Chokepoint risk|关键海峡或运河中断会改变 freight、保险和可达供应。|价格反应取决于替代通道和库存。
Trading hub|有管线、储罐、价格发现和交割功能的节点。|不是所有港口都是 benchmark hub。
Incoterms|定义买卖双方在运输和保险上的责任边界。|价格比较必须统一交货条件。
'@
}
@{
  Label = "Chapter 12"
  Title = "Storage"
  Url = "https://oil101.morgandowney.com/chapters/storage"
  Dir = "part-one-oil-fundamentals/12-storage"
  Bank = "formula"
  Sections = @'
Why Store Oil?|Storage 平衡时间错配，支持 refinery operations、strategic reserves、trading optionality 和 emergency response。
Categories of Storage|Commercial、operational、strategic 和 floating storage 功能不同。
Tank Types|Fixed roof、floating roof、pressurized tanks 和 refrigerated tanks 对应不同挥发性和安全要求。
Cushing, Oklahoma: The Pipeline Crossroads|Cushing 是 WTI 交割地，库容和管线方向可直接影响 futures pricing。
Salt Caverns|Salt caverns 适合大规模储存 crude、NGLs 和 strategic reserves。
The US Strategic Petroleum Reserve|SPR 是政策库存，释放和补库会影响市场但不是商业库存。
International Strategic Reserves|IEA/OECD 体系要求成员保持一定净进口覆盖天数。
Iran's Floating Shadow Storage|Sanctions 可能把 tankers 变成 floating storage，改变可见供应。
The Contango Storage Play|当 forward price 足以覆盖 storage、financing 和 losses 时，持有库存可套利。
Inventory Reports and the Five-Year Range|EIA weekly stocks 和 five-year range 是市场判断松紧的核心参照。
AI and the 30 Percent Inventory Reduction|更好的预测和优化可降低 working inventory，但也可能降低系统缓冲。
Where Storage Sits in the Value Chain|Storage 不是被动仓库，而是连接时间、地点和质量套利的资产。
'@
  Concepts = @'
Contango storage value|Forward price - spot price - storage cost - financing cost - losses。|正 contango 不一定足够套利。
Backwardation|近月价格高于远月，持有库存的机会成本高。|库存通常被释放而非囤积。
Days of cover|Inventory / daily demand，用于衡量库存可支撑天数。|不同产品和地区不可简单相加。
Working capacity|可正常运营使用的库容，不等于名义总容量。|Tank bottoms 和安全限制会降低可用空间。
SPR release|政府释放战略库存缓解短期供应冲击。|不是长期供给来源。
Five-year range|用历史库存范围判断当前库存偏高或偏低。|结构变化会让历史区间失真。
Floating storage|油轮被用作库存资产。|可能代表 contango，也可能代表制裁或物流堵塞。
'@
}
@{
  Label = "Chapter 13"
  Title = "Seasonality"
  Url = "https://oil101.morgandowney.com/chapters/seasonality"
  Dir = "part-one-oil-fundamentals/13-seasonality"
  Bank = "formula"
  Sections = @'
Four Overlapping Calendars|Oil seasonality 来自驾驶季、取暖季、炼厂检修季和天气/物流季的叠加。
Gasoline: Memorial Day to Labor Day|美国 summer driving season 推高 gasoline demand 和调油约束。
Summer Grade and Winter Grade: The RVP Calendar|夏季汽油 RVP 限制更严格，冬季可提高挥发性和低成本 butane blending。
Heating Oil, Propane, and the HDD Framework|Heating demand 与 HDD 紧密相关，影响 distillate、propane 和 natural gas。
Natural Gas Storage: Inject and Withdraw|气库春夏注入、冬季提取，影响 gas 和 NGL economics。
The Refinery Turnaround Calendar|春秋检修降低 runs，影响 crude demand 和 product supply。
Atlantic Hurricanes|飓风会冲击 Gulf Coast offshore、refining、ports 和 pipelines。
North Sea Storms and Baltic Ice|区域天气会影响北海产量、航运和港口效率。
Rivers and Canals: Low Water Bottlenecks|河流水位和 canal restrictions 可能限制 barges 和 tankers。
Why Crude Oil Itself Is Less Seasonal Than Its Products|Crude demand 是炼厂运行派生需求，产品季节性更直接。
'@
  Concepts = @'
Heating degree days|HDD = max(0, 65F - average temperature)，用于估算取暖需求。|基准温度因地区和模型可不同。
Cooling degree days|CDD = max(0, average temperature - 65F)，用于估算制冷负荷。|对油品影响小于对电力和 gas。
RVP seasonality|夏季降低 RVP 以减少蒸发排放，冬季允许较高 RVP。|同一汽油在不同季节可能不合规。
Turnaround|计划检修期降低 refinery runs。|会减少 crude demand 但也收紧 product supply。
Hurricane risk premium|风暴威胁可推高 freight、product cracks 或 regional basis。|实际影响取决于路径和停产时长。
Inventory build/draw|旺季前 build，旺季中 draw 是常见模式。|异常库存路径比绝对水平更有信息。
'@
}
@{
  Label = "Chapter 14"
  Title = "Reserves"
  Url = "https://oil101.morgandowney.com/chapters/reserves"
  Dir = "part-one-oil-fundamentals/14-reserves"
  Bank = "formula"
  Sections = @'
What Are Oil Reserves?|Reserves 是在当前技术、价格和合同条件下可商业开采的资源子集。
The Three Ps|Proved、probable、possible 表示不同置信度，不能混作同一风险等级。
PDP, PDNP, PUD: The Development Status Categories|Proved reserves 还要按已开发生产、已开发未生产、未开发分类。
Reserve Recategorization ("Re-Catting")|价格、井表现、开发计划和规则变化会导致 reserves 在类别间移动。
Reserve Estimation Methods|Volumetric、decline curve、material balance 和 reservoir simulation 各有适用阶段。
Peak Oil and Hubbert's Curve|Hubbert curve 描述成熟盆地产量先升后降，但全球 peak 受技术和需求共同影响。
OPEC's 1982-1988 Reserve Revisions|OPEC reserve jumps 展示了配额激励如何污染储量数据。
Reserves to Production Ratio by Country|R/P ratio 是静态寿命指标，不等于真实枯竭日期。
Reserve Replacement Ratio|RRR 衡量公司新增 reserves 能否替代当年产量。
SEC PV-10 and Reserve-Based Lending|PV-10 和 reserve-based lending 把 reserves 转化为金融抵押和估值。
EUR and Drilling Inventory|EUR 和可钻 inventory 决定 shale 公司长期价值。
Giant Fields Still Dominate Global Reserves|少数 giant fields 贡献全球大部分 reserves 和低成本产量。
'@
  Concepts = @'
R/P ratio|Reserves / annual production。|静态指标，不包含新发现、价格和 decline changes。
Reserve replacement ratio|Reserve additions / production。|超过 100% 表示储量账面扩张。
PV-10|未来净现金流按 10% 折现，税前口径常用于 US reserves。|对价格假设高度敏感。
EUR|Estimated ultimate recovery，单井或资产生命周期总产量估计。|页岩 EUR 依赖 decline assumptions。
PDP|Proved developed producing，已开发且正在生产。|风险最低但 decline 已开始。
PUD|Proved undeveloped，需要未来资本开发。|SEC 对开发时限有要求。
Recovery factor|Recoverable oil / oil in place。|技术和经济条件会改变采收率。
Re-catting|储量在不同类别间重新分类。|不是新发现，也可能只是规则或价格变化。
'@
}
@{
  Label = "Chapter 15"
  Title = "Environmental Regulations"
  Url = "https://oil101.morgandowney.com/chapters/environmental"
  Dir = "part-one-oil-fundamentals/15-environmental"
  Bank = "concept"
  Sections = @'
Three Categories of Environmental Regulation|环境监管覆盖产品质量、设施运行安全和温室气体/气候政策。
The US Clean Air Act|Clean Air Act 是美国燃料和排放规则的核心法律框架。
NAAQS: The Six Criteria Pollutants|NAAQS 管控 ozone、PM、CO、NO2、SO2、lead 等标准污染物。
California, CARB, and the Section 209 Waiver|California 可通过 waiver 设定更严格车辆排放规则，影响全国汽车和燃料市场。
Gasoline: From Leaded to Tier 3|汽油规则从去铅到低硫，推动炼厂 hydrotreating 和车辆催化器协同。
Diesel: ULSD and the Catalyst Link|ULSD 使柴油颗粒过滤器和 SCR 等后处理系统可行。
Operational Safety: Spills, Pipelines, and Tanks|Spill prevention、pipeline integrity 和 tank rules 管控事故风险。
Greenhouse Gas Regulation|GHG rules 通过 tailpipe、power、industrial 和 carbon policy 影响 oil demand。
Methane: The Other Oil and Gas Greenhouse Gas|Methane leaks 对 climate impact 强，监测和减排成为 upstream 重点。
Vehicle Fuel Economy and Tailpipe GHG Rules|CAFE 和 tailpipe GHG standards 直接影响 gasoline demand trajectory。
'@
  Concepts = @'
NAAQS|美国标准污染物环境空气质量标准。|它管环境浓度，不只是单个工厂排放。
CARB waiver|California 获准设定更严格车辆排放标准。|会通过汽车市场外溢到其他州。
Tier 3 gasoline|更低 sulfur 支持更高效催化器。|产品规则和车辆技术一起变化。
ULSD|15 ppm sulfur diesel standard 支持 diesel aftertreatment。|炼厂需要更多 hydrotreating。
NOx|高温燃烧生成的氮氧化物，推动臭氧和 smog。|与燃料 sulfur 不是同一污染物。
SOx|含硫燃料燃烧生成，导致酸雨和颗粒物。|脱硫可在燃料端或烟气端实现。
Methane leak|天然气系统泄漏具有高短期 warming impact。|少量泄漏也有气候意义。
CAFE|车辆燃油经济性规则，减少每英里燃料消耗。|总需求还取决于行驶里程。
'@
}
@{
  Label = "Chapter 16"
  Title = "New Engine Technologies"
  Url = "https://oil101.morgandowney.com/chapters/engine-technologies"
  Dir = "part-one-oil-fundamentals/16-engine-technologies"
  Bank = "formula"
  Sections = @'
Why Engine Technology Matters for Oil|发动机效率和动力系统替代决定 transport fuel demand 的长期弹性。
The Four-Stroke Cycle|Intake、compression、power、exhaust 是 spark ignition 和 compression ignition 的基本循环。
Compression Ratio and Octane|更高 compression ratio 提高效率，但需要更高 octane 避免 knock。
Efficiency Breakthroughs Since 2009|Turbocharging、direct injection、variable valve timing 等提高 ICE efficiency。
The 30 / 30 / 30 / 10 Heat Balance|燃料能量大致分配给 useful work、exhaust heat、cooling losses 和 friction/accessories。
Hybrid Electric Vehicles|HEV 用电机和电池回收制动能量并优化 engine operating point。
Battery Electric Vehicles|BEV 直接替代燃油需求，但 adoption 受成本、充电和电网影响。
Hydrogen Fuel Cell Vehicles|FCEV 适合部分重载场景，但基础设施和 hydrogen 成本是核心障碍。
Heavy Duty and Off-Road|重卡、矿山、农业和船舶更难电动化，燃料替代速度较慢。
The Peak ICE Question|ICE peak 取决于 fleet turnover、政策、消费者选择和非 OECD 增长。
'@
  Concepts = @'
Thermal efficiency|Useful work / fuel energy input。|提升效率不一定按比例降低总需求，行驶里程会变。
Compression ratio|Cylinder maximum volume / minimum volume。|高压缩比提高效率但增加 knock 风险。
Octane requirement|发动机越激进，越需要高 octane fuel。|高 octane 允许技术，不直接保证低耗。
Four-stroke cycle|Intake、compression、power、exhaust 完成一次动力循环。|每两圈曲轴一次做功。
Hybrid regeneration|回收制动能量并减少低效率工况。|不是完全脱离 liquid fuels。
BEV efficiency|电驱动从电池到车轮效率高。|上游电力来源决定生命周期排放。
Hydrogen fuel cell|氢与氧反应发电驱动电机。|hydrogen production 和 distribution 是瓶颈。
Fleet turnover|车辆存量更新慢，使燃料需求滞后于新车销售变化。|EV sales share 不等于 fleet share。
'@
}
@{
  Label = "Chapter 17"
  Title = "Oil Prices"
  Url = "https://oil101.morgandowney.com/chapters/oil-prices"
  Dir = "part-two-oil-markets/17-oil-prices"
  Bank = "formula"
  Sections = @'
Physical Oil Trading|实货交易处理真实 barrels 的质量、地点、时间和信用风险。
Benchmark Pricing|WTI、Brent、Dubai 等 benchmarks 给不同 crudes 提供可观察参考价。
The Delivery-Chain Price Ladder|从 wellhead 到 retail，价格逐层加入 transport、storage、tax、margin 和 quality adjustments。
Unit Conversions|Barrel、metric tonne、gallon、BTU 等单位转换是价格比较基础。
Formula Pricing: A Worked Example|Formula price = benchmark price plus/minus quality and location differential。
Freight Netback Pricing|Netback 从目的地产品或 crude value 倒推产地可支付价格。
Pricing Windows and the Platts MOC|Price reporting agencies 用窗口和 MOC process 评估 physical market。
Oil and the US Dollar|国际 oil pricing 以美元为核心，FX 和利率影响生产国购买力和投资者需求。
Retail Price Differences|Retail fuel price 差异来自 taxes、logistics、specs、competition 和 crude/product markets。
'@
  Concepts = @'
Formula price|Benchmark +/- differential。|Differential 同时包含质量、地点和物流。
Netback|Destination value - freight - handling - quality costs。|用于比较不同买家或出口路径。
Crack spread|Product value - crude cost。|炼厂 margin proxy，不是完整利润。
Barrel-tonne conversion|Tonnes depend on density, so factor varies by crude/API。|不能用固定数比较所有 grades。
Benchmark liquidity|交易量、透明度和可交割性支撑 benchmark。|名字知名不等于适合作 benchmark。
MOC assessment|Platts Market on Close 通过收盘窗口评估 spot price。|是评估机制，不一定等于交易所结算价。
Retail price build-up|Crude/product wholesale + distribution + taxes + retail margin。|油价涨跌不会一比一进入泵价。
'@
}
@{
  Label = "Chapter 18"
  Title = "Forward Oil Markets: Futures and Swaps"
  Url = "https://oil101.morgandowney.com/chapters/futures-swaps"
  Dir = "part-two-oil-markets/18-futures-swaps"
  Bank = "formula"
  Sections = @'
Paper Barrels and Wet Barrels|Paper markets 用期货和 swaps 转移价格风险，wet barrels 是实际交割物流。
The Forward Curve and Its Two Shapes|Contango 表示远月高于近月，backwardation 表示近月高于远月。
April 20, 2020: The Day Oil Went Negative|WTI negative price 是交割、库容、合约滚动和需求崩塌的叠加。
Marginal Finding and Development Cost at the Back of the Curve|远端曲线常反映市场对长期边际供给成本的判断。
Spreads: How Oil Traders Actually Trade|Traders 更多交易 time、location、quality 和 product spreads，而非单纯 flat price。
The 3:2:1 and 2:1:1 Crack Spreads|Crack spreads 用成品油组合近似炼厂毛利。
The Spreads Family Tree|Calendar、quality、location、inter-product spreads 共同构成交易语言。
Exchange-Traded Futures|Futures 标准化、每日结算、集中清算，降低 counterparty risk。
Over-the-Counter (OTC) Swap Contracts|Swaps 可定制标的、期限和结算指数，但有信用和 documentation 风险。
EFP, EFS, and Block Trades|这些机制连接期货、实货和 OTC markets。
The Live Curve Today|实时曲线用于判断库存、风险溢价和市场预期。
'@
  Concepts = @'
Contango|Futures deferred price > nearby price。|可能支持 storage trade。
Backwardation|Nearby price > deferred price。|通常表示现货紧张或库存价值高。
Calendar spread|不同月份合约价差。|比 flat price 更直接反映时间结构。
3:2:1 crack|3 crude futures versus 2 gasoline plus 1 diesel/heating oil。|只是简化炼厂 slate。
Swap settlement|OTC 合约按参考指数现金结算。|没有实货交割但有 index risk。
Variation margin|Futures 每日 mark-to-market 的现金流。|盈利合约也可能有短期流动性需求。
EFP|Exchange for Physical，把 futures position 与 physical trade 互换。|连接 paper 和 wet barrels。
Negative price|当持有合约的交割负担超过油本身价值时可出现。|不是油没有能源价值，而是即时处置成本极高。
'@
}
@{
  Label = "Chapter 19"
  Title = "Forward Oil Markets: Options"
  Url = "https://oil101.morgandowney.com/chapters/options"
  Dir = "part-two-oil-markets/19-options"
  Bank = "formula"
  Sections = @'
Options as Insurance|Options 用 premium 买非线性保护，限制 downside 或保留 upside。
Intrinsic Value, Time Value, and Moneyness|Option value 分为立即行权价值和未来不确定性的时间价值。
Option Styles|American、European、Asian 等风格决定行权和结算方式。
Pricing: Black-76 and Implied Volatility|Commodity options 常用 Black-76 在 futures price 上定价，implied volatility 是市场反推的波动率。
The Greeks|Delta、gamma、theta、vega、rho 描述 option 对价格、时间和波动的敏感度。
Volatility Skew, Smile, and Surface|不同 strikes 和 maturities 的 implied vol 不同，形成 skew/smile/surface。
Daily Breakeven and Gamma Trading|Gamma positions 需要动态 hedging，盈亏取决于 realized volatility 与 implied volatility。
Common Option Structures|Collars、three-ways、swaptions、spreads 等结构服务 producer 和 consumer hedging。
'@
  Concepts = @'
Call option|买方有权以 strike 买入标的。|权利不是义务。
Put option|买方有权以 strike 卖出标的。|producer 常用 put 保护下行。
Intrinsic value|Option 若立即行权的价值。|Out-of-the-money option intrinsic value 为零。
Time value|Option price - intrinsic value。|随到期临近通常衰减。
Delta|Option value 对 futures price 的一阶敏感度。|Delta 会随价格变化。
Gamma|Delta 对价格变化的敏感度。|高 gamma 需要更频繁 hedging。
Vega|Option value 对 implied volatility 的敏感度。|Long options 通常 long vega。
Collar|买 put 卖 call，降低 premium 并锁定区间。|卖 call 放弃上行。
'@
}
@{
  Label = "Chapter 20"
  Title = "Managing Oil Price Risk"
  Url = "https://oil101.morgandowney.com/chapters/risk-management"
  Dir = "part-two-oil-markets/20-risk-management"
  Bank = "formula"
  Sections = @'
Why Commodities Are Volatile|Oil volatility 来自低短期弹性、库存限制、地缘政治和金融杠杆。
The Case for Hedging|Hedging 用可接受成本降低现金流波动，让公司能投资、借款和运营。
Corporate Hedging Objectives by Firm Type|Producers、refiners、airlines、marketers 的风险暴露和目标不同。
Hedging Instruments|Futures、swaps、options、collars 和 physical contracts 各有成本和风险。
Basis Risk|Hedge index 与实际实货价格不完全一致，留下 basis exposure。
Roll Risk: The Metallgesellschaft Lesson|短期 hedge 长期 exposure 需要连续 roll，曲线结构可产生巨大现金流压力。
Value at Risk and Expected Shortfall|VaR 和 ES 衡量在置信水平下的潜在损失，但依赖模型假设。
Stress Testing|Stress tests 检查极端但 plausible 场景下的 liquidity 和 solvency。
Counterparty Risk and the ISDA Framework|OTC hedges 依赖 collateral、netting 和 legal documentation 管理信用风险。
Hedge Accounting|会计规则决定 hedge gains/losses 如何进入 earnings。
Historical Corporate Hedging Blowups and One Famous Gain|历史案例说明 hedge 可以保护公司，也可能因结构和 governance 出错而放大风险。
Portfolio Theory and the Efficient Frontier|风险管理要看 portfolio covariance，而非孤立单笔交易。
Peer Benchmarking: What Other Producers Are Doing|同行 hedge ratios 和 tenors 可作为参考，但不能替代自身风险目标。
Why Some Companies Do Not Hedge|不 hedge 可能源于股东偏好、成本、会计、流动性或对价格的观点。
Operational Reality|有效 hedge 需要 policy、limits、reporting、systems 和董事会治理。
'@
  Concepts = @'
Hedge ratio|Hedged volume / exposed volume。|100% hedge 不一定最优。
Basis risk|Local physical price - hedge index price 的不确定性。|Flat price hedge 不能消除 location/quality risk。
Roll risk|到期合约换月至远月时面临价差和现金流风险。|长期暴露不宜机械短期期货滚动。
VaR|给定置信水平和期限的最大预期损失阈值。|尾部之外损失看不到。
Expected shortfall|超过 VaR 后的平均损失。|比 VaR 更关注尾部严重性。
Stress test|假设极端价格、basis、liquidity 和 counterparty 情景。|不是概率预测，而是生存测试。
ISDA netting|OTC 衍生品主协议和净额结算安排。|法律可执行性很关键。
Collar hedge|买保护性 option 同时卖另一侧 option 降低成本。|会限制收益空间。
'@
}
@{
  Label = "Chapter 21"
  Title = "The Shale Revolution"
  Url = "https://oil101.morgandowney.com/chapters/shale-revolution"
  Dir = "part-three-modern-era/21-shale-revolution"
  Bank = "concept"
  Sections = @'
The Technology Behind Shale|Horizontal drilling、hydraulic fracturing 和 geosteering 把低渗透岩石变成可重复开发资源。
Inside a Frac Job|Frac job 用水、砂和化学剂打开裂缝，proppant 保持导流通道。
George Mitchell and the Barnett Shale|Mitchell Energy 的试验把 shale gas 商业化，为 tight oil 铺路。
Tight Oil and the Permian Basin|Permian 通过 stacked pay、基础设施和低 breakevens 成为 US tight oil 核心。
The Basins|Bakken、Eagle Ford、Permian、Niobrara 等盆地在液体含量、地质和物流上不同。
The 2014 Price Collapse|OPEC 不减产与 shale 增长触发价格下跌，迫使 shale 提高资本纪律。
The Shale Treadmill|页岩井初期产量高、decline 快，需要持续 drilling 维持总产。
Laterals, Parent-Child Wells, and Drilling Efficiency|Longer laterals 和 pad drilling 提效，但 parent-child interference 限制密集开发。
Tight Oil Breakevens and the Global Marginal Cost of Supply|Shale 成为全球边际供给的一部分，但 breakeven 随服务成本和高分级库存变化。
Lifting the Crude Export Ban|2015 美国解除 crude export ban，让 light sweet tight oil 进入全球市场。
Consolidation and the Chevron-Hess Deal|Majors 并购 independents，说明 shale 从 growth story 走向 inventory control 和 scale efficiency。
'@
  Concepts = @'
Hydraulic fracturing|高压流体造缝并用 proppant 保持通道。|不是只靠爆破，而是工程化导流。
Horizontal drilling|沿储层横向钻进，增加接触面积。|shale 成功依赖横井和压裂组合。
Type curve|代表性井产量曲线，用于估算 EUR 和经济性。|过度乐观会高估资产价值。
Shale treadmill|快速 decline 要求不断钻新井维持产量。|高增长需要持续资本投入。
Parent-child wells|新井与旧井裂缝干扰降低回收或压力。|井距过密会伤害经济性。
Breakeven|覆盖 drilling、completion、operating 和资本成本所需油价。|公司口径差异很大。
Export ban repeal|解除禁令使 US light crude 可外销，缓解 domestic discount。|物流和质量仍影响 differential。
Inventory depth|可经济钻井地点的数量和质量。|不是所有 acreage 同样值钱。
'@
}
@{
  Label = "Chapter 22"
  Title = "OPEC+"
  Url = "https://oil101.morgandowney.com/chapters/opec-plus"
  Dir = "part-three-modern-era/22-opec-plus"
  Bank = "concept"
  Sections = @'
From OPEC to OPEC+|OPEC+ 是 OPEC 与俄罗斯等非 OPEC 产油国的供给协调机制。
Who Is in the Room|成员国差异巨大，Saudi Arabia 和 Russia 是最关键决策者。
Spare Capacity as the Swing Variable|真正的定价权来自可快速增减的 spare capacity，而不是名义 reserves。
Quotas, Baselines, and Compliance|Quotas 取决于 baselines，compliance 和 cheating 决定协议可信度。
Key Moments of OPEC+|2016 合作、2020 price war、pandemic cuts 和后续纪律构成 OPEC+ 历史主线。
The 2020 Price War|Saudi-Russia 冲突叠加疫情需求崩塌，使价格和库存系统承压。
Saudi Arabia, Aramco, and Ghawar|Saudi spare capacity、Aramco 和 Ghawar 仍是全球供给稳定器核心。
Russia After the Invasion|制裁、price cap、shadow fleet 和重定向出口改变 Russia 在 OPEC+ 中的约束。
The Strategic Calculus|OPEC+ 在价格、市场份额、财政需求和 shale response 之间权衡。
'@
  Concepts = @'
Spare capacity|可在短期内上线并维持的闲置产能。|名义产能不等于可用 swing supply。
Quota baseline|配额计算起点，决定各国可生产份额。|baseline 谈判常比 headline cuts 更重要。
Compliance|实际减产与承诺减产的比例。|协议执行比公告更重要。
Saudi swing role|Saudi Arabia 通过产量调整影响市场平衡。|也受财政和地缘政治约束。
Russia constraint|制裁和物流改变 Russia 出口路径和 price realization。|产量数据和出口数据可能背离。
Market share strategy|增产压价可惩罚 competitors，但损害短期 revenue。|2020 是典型案例。
Fiscal breakeven|政府预算平衡所需油价。|不同于油田生产成本。
'@
}
@{
  Label = "Chapter 23"
  Title = "When Oil Went Negative"
  Url = "https://oil101.morgandowney.com/chapters/negative-prices"
  Dir = "part-three-modern-era/23-negative-prices"
  Bank = "concept"
  Sections = @'
The Unthinkable Happens|2020 WTI 负价展示了金融合约到期、实货交割和库容约束的极端耦合。
The WTI Delivery Mechanism|NYMEX WTI 是 Cushing 实物交割合约，不能忽略 delivery obligation。
Cushing: The Pipeline Crossroads With a Ceiling|Cushing 物流重要但库容有限，接近满库时 storage optionality 价值暴涨。
The Pandemic Demand Shock|COVID demand collapse 让产品需求骤降，炼厂降 runs，crude 无处可去。
USO and the Crowded Front Month|ETF 和投资者集中滚动近月合约，加剧 front month pressure。
A Small Rule Change at the Clearing House|交易系统允许负价格结算是负价能够表现出来的技术条件。
TAS and the Afternoon of April 20|TAS liquidity 和到期日交易结构放大尾盘价格运动。
Aftermath, Lawsuits, and Reforms|事件后市场调整规则、风险模型和产品设计。
Negative Prices Elsewhere: Power Markets|电力市场负价说明不可储存或储存受限资产可出现负价格。
What Negative Prices Taught the Market|价格可以低于零，当接受实物的成本超过商品价值。
'@
  Concepts = @'
Delivery obligation|期货到期后可能需要接收或交付实货。|金融投资者必须在到期前管理退出。
Cushing capacity|可用储罐和管线决定 WTI 交割弹性。|名义库存未满也可能无可用容量。
Storage optionality|拥有储存权在 contango 或压力市场中具有期权价值。|库容紧张时价值非线性上升。
Demand shock|终端需求暴跌向上游传导为 refinery runs 下降和 crude backlog。|不是单纯供应过剩。
ETF roll risk|被动产品集中换月会影响 futures spreads。|指数设计会改变市场行为。
Negative price|卖方付钱让买方接收商品。|可能是处置成本和约束的价格。
TAS|Trade-at-settlement 允许按结算价交易。|流动性集中也会放大结算风险。
'@
}
@{
  Label = "Chapter 24"
  Title = "US LNG Exports"
  Url = "https://oil101.morgandowney.com/chapters/us-lng"
  Dir = "part-three-modern-era/24-us-lng"
  Bank = "formula"
  Sections = @'
From Net Importer to Largest Exporter|美国 shale gas 把 LNG 基础设施从进口逻辑转为出口逻辑。
The Operating US LNG Fleet|Gulf Coast 和 Atlantic facilities 把 Henry Hub gas 转化为全球 LNG supply。
The Second Wave Under Construction|新项目扩大出口能力，但受融资、合同、监管和建设周期约束。
The Biden Pause and the Trump Reversal|出口许可政策会影响长期项目 timing 和 buyer confidence。
Where the Cargoes Go|欧洲和亚洲需求、价格和地缘政治决定 cargo destination。
Henry Hub, TTF and JKM|US LNG 连接 Henry Hub feedgas、欧洲 TTF 和亚洲 JKM 价格。
LNG Pricing Contracts|合同可用 Henry Hub plus liquefaction fee、oil-indexed 或 spot formulas。
LNG Carriers|LNG ships 是低温专用资产，航程、boil-off 和运河限制影响 delivered cost。
Shipping Bottlenecks: Panama and the Red Sea|运河拥堵和安全风险会改变 voyage distance 与 arbitrage。
FSRUs and Europe's 2022 Scramble|Floating regasification 让欧洲快速替代 Russian pipeline gas。
Henry Hub Globalization|LNG exports 把美国 domestic gas price 与全球 gas markets 更紧密连接。
'@
  Concepts = @'
LNG netback|Destination LNG price - shipping - regas - liquefaction/feedgas costs。|正 netback 支持出口套利。
Henry Hub linkage|US LNG 常按 Henry Hub gas plus fixed/liquefaction fee 定价。|买方承担 feedgas price exposure。
TTF|欧洲天然气基准。|不是 LNG 专用价格，但影响欧洲 cargo bids。
JKM|东北亚 spot LNG benchmark。|季节、天气和核电影响强。
Liquefaction toll|液化项目收取 capacity fee 或 tolling fee。|即使不装货也可能有固定费用。
Boil-off gas|运输中部分 LNG 蒸发，可作船用燃料。|长航线影响可交付量和成本。
FSRU|Floating Storage and Regasification Unit，快速建设进口能力。|速度快但长期成本可能高于陆上终端。
'@
}
@{
  Label = "Chapter 25"
  Title = "The Energy Transition"
  Url = "https://oil101.morgandowney.com/chapters/energy-transition"
  Dir = "part-three-modern-era/25-energy-transition"
  Bank = "concept"
  Sections = @'
The Peak Demand Debate|Peak oil demand 取决于运输、石化、政策和非 OECD 增长，而非单一技术。
OECD and Non-OECD Divergence|OECD oil demand 偏成熟或下降，non-OECD 仍受收入、城市化和工业化推动。
Electric Vehicles|EVs 直接替代 gasoline/diesel vehicle miles，但 fleet turnover 和充电基础设施限制速度。
The Cost Collapse in Solar and Wind|可再生电力成本下降改变电力市场和长期 fossil demand expectations。
Renewable Additions and the Gas Paradox|Renewables 增长可能增加对 gas flexibility 的需求，至少在储能不足时如此。
Carbon Markets and the EU ETS|Carbon prices 把排放成本显性化，影响 fuel switching 和工业竞争力。
The IRA and the 2025 Rollback|政策支持和回撤都会改变 clean energy investment economics。
Carbon Capture and Hydrogen|CCS 与 hydrogen 是难减排行业的选项，但成本、规模和基础设施仍有挑战。
The Investment Paradox|若 fossil investment 下降快于需求下降，可能导致价格高企和转型反弹。
Peak Demand or Peak Fossil Fuel?|判断转型需区分 oil demand、total fossil demand 和 emissions peak。
'@
  Concepts = @'
Peak demand|需求达到最高点后长期下降。|不是 supply exhaustion。
Fleet turnover|车辆存量更新速度慢，延迟 EV 对燃料需求影响。|新车销售不能代表存量。
Carbon price|每吨 CO2e 的成本信号。|覆盖范围和免费配额影响实际效果。
EU ETS|欧洲排放交易体系。|价格信号会传导到电力和工业。
CCS|捕集、运输并封存 CO2。|适用场景多在工业和 gas processing。
Hydrogen color|灰、蓝、绿 hydrogen 取决于生产路径和排放。|颜色不是物理属性。
Investment paradox|低碳投资不足和油气投资不足可能同时存在。|需求下降前削供会推高价格。
Non-OECD demand|新兴市场收入增长支撑 transport 和 petrochemical demand。|转型路径不均衡。
'@
}
@{
  Label = "Chapter 26"
  Title = "Iran Blocks the Strait"
  Url = "https://oil101.morgandowney.com/chapters/iran-strait"
  Dir = "part-three-modern-era/26-iran-strait"
  Bank = "concept"
  Sections = @'
The Chokepoint|Strait of Hormuz 是全球 crude、condensate 和 LNG flows 的关键瓶颈。
Anatomy of a Closure|封锁可通过 mines、missiles、harassment、insurance shock 和 port disruption 发生。
The Price Shock|价格反应取决于中断规模、持续时间、库存、SPR 和 spare capacity。
Forced Shut-Ins|出口受阻会迫使 Gulf producers shut in production，影响全球 supply。
The Bypass Pipelines and Their Ceiling|Saudi、UAE 等绕行管线提供缓冲但容量有限。
A Two-Tier Market|可绕开海峡的 barrels 可能溢价，受困 barrels 折价或无法成交。
Who Is Most Exposed|亚洲进口国、Gulf producers、LNG buyers 和 shipping/insurance markets 暴露最大。
Why Oil Hasn't Broken $200|SPR、库存、需求弹性、替代流向和政策反应限制极端上行。
Anatomy of a Reopening|扫雷、护航、保险恢复和港口重启决定恢复节奏。
The 2026 Crisis: A Timeline|时间线用于把事件、价格和政策响应组织起来。
The Standing Lessons|Chokepoint risk 是物流、军事、保险和库存共同作用的系统风险。
'@
  Concepts = @'
Chokepoint|运输通道集中且替代路径有限的瓶颈。|风险不只在产油国，也在航道。
Bypass capacity|绕开 chokepoint 的管线和港口能力。|通常小于受威胁流量。
War risk premium|冲突增加 insurance、freight 和库存需求。|不一定等于实际供应损失。
Forced shut-in|因无法出口或储存而停产。|恢复可能损害 reservoir management。
SPR response|战略库存释放可缓冲短期供给冲击。|只能买时间，不能永久替代流量。
Two-tier market|不同可达性 barrels 形成分化价格。|全球 benchmark 可能掩盖区域断裂。
Reopening lag|军事清理和商业保险恢复都需要时间。|航道宣布开放不等于贸易立即正常。
'@
}
@{
  Label = "Appendix 1"
  Title = "More on the Two Most Important Forward Markets"
  Url = "https://oil101.morgandowney.com/appendices/forward-markets-mechanics"
  Dir = "appendices/A1-forward-markets-mechanics"
  Bank = "formula"
  Sections = @'
NYMEX WTI Crude Oil Futures (CL)|CL 是 Cushing 交割的 light sweet crude futures，标准化了美国内陆 benchmark。
ICE Brent Crude Oil Futures|Brent futures 是全球 seaborne crude 关键 benchmark，现金结算和实货 assessment 连接紧密。
BFOETM: the basket, the 2018 and 2023 reforms|Brent basket 扩展到 BFOETM 以维持可交割流动性。
Dated Brent and the Platts Market on Close|Dated Brent 是实货评估，MOC process 是形成 benchmark 的核心机制。
Contracts for Differences (CFDs)|CFDs 交易 Dated Brent 与 futures/forward 之间的差。
Exchange for Physical (EFP)|EFP 在 futures 与 physical positions 之间转换。
Exchange for Swap (EFS)|EFS 在 futures 与 OTC swap exposure 之间转换。
Contract spec reference|Contract specs 定义交割、质量、计量、结算和最后交易日。
'@
  Concepts = @'
CL contract|NYMEX WTI futures，Cushing physical delivery。|持有到期有交割义务。
Brent futures|ICE Brent futures，全球 seaborne crude 参考。|与 Dated Brent 不是同一物。
BFOETM|Brent、Forties、Oseberg、Ekofisk、Troll、Midland basket。|加入 Midland 是为维持流动性。
Dated Brent|短期实货 Brent cargo assessment。|很多 physical crude formulas 参考它。
CFD|Dated Brent 与 forward/futures 之间的差价合约。|用于管理 physical pricing window risk。
EFP|Exchange for Physical。|连接实货和期货账本。
EFS|Exchange for Swap。|连接期货和 OTC swaps。
Contract spec|合约的法律和操作说明书。|交易前必须看质量、地点和到期规则。
'@
}
@{
  Label = "Appendix 2"
  Title = "Conversion Factors"
  Url = "https://oil101.morgandowney.com/appendices/conversion-factors"
  Dir = "appendices/A2-conversion-factors"
  Bank = "formula"
  Sections = @'
Density, API gravity, and why the barrel-to-tonne factor moves|Barrel-to-tonne conversion 取决于 density/API，不同 crude 不能用同一个精确因子。
Standard oil-industry conversion factors|常用单位包括 barrel、gallon、metric tonne、BTU、BOE、MWh 等。
High heating value versus low heating value|HHV 包含水蒸气凝结热，LHV 不包含，比较燃料时必须统一口径。
Barrel of oil equivalent accounting|BOE 用热值把 gas 或其他能源折成 oil equivalent，常用 6 Mcf per BOE 近似。
Worked examples|例题展示 API、density、barrels、tonnes、BTU 和 BOE 的转换路径。
A caution on precision|学习和交易可用近似因子，结算和工程要用合同、温度和密度表。
'@
  Concepts = @'
API from SG|API = 141.5 / SG - 131.5。|API 越高越轻。
SG from API|SG = 141.5 / (API + 131.5)。|参考温度要一致。
Barrels per tonne|Approx = 1000 / (density kg/m3 * 0.158987)。|密度不同导致 factor 变化。
HHV vs LHV|HHV 包含水凝结热，LHV 不包含。|跨燃料比较必须统一口径。
BOE|Barrel of oil equivalent，约 5.8-6.0 MMBtu。|财务口径不等于价格等值。
Mcf to BOE|常用 6 Mcf gas = 1 BOE。|实际热值和价格比会变。
Precision rule|商业结算应使用合同规定 conversion。|不要用教材近似做结算。
'@
}
@{
  Label = "Appendix 3"
  Title = "Perpetual Futures and the 24/7 Oil Market"
  Url = "https://oil101.morgandowney.com/appendices/perpetual-futures"
  Dir = "appendices/A3-perpetual-futures"
  Bank = "formula"
  Sections = @'
What a Perpetual Is|Perpetual futures 没有固定到期日，通过 funding rate 锚定现货或指数。
How Oil Perps Reached the Market|Crypto-style perps 被引入 oil price exposure，但和 regulated commodity futures 有本质差异。
Why the Clock Is the Real Attraction|24/7 trading 满足周末和非交易时段风险表达需求。
The Institutional Response|传统机构更重视 clearing、market integrity、reference price 和监管框架。
Why Oil Has Not Gone Perpetual, and the Skeptic's View|Oil 是实物、交割、库存和监管市场，perp 不能替代 futures curve。
The Borrowed Price|Perps 借用外部 benchmark/index，价格发现仍依赖 underlying oil market。
'@
  Concepts = @'
Perpetual future|无到期合约，通过 funding payments 维持与指数接近。|没有自然交割收敛。
Funding rate|Longs 与 shorts 定期支付的锚定机制。|funding 可以成为主要成本。
Index price|Perp 用外部价格源作为锚。|若 index 薄弱，perp 价格也不稳。
24/7 risk transfer|周末和夜间可交易是主要卖点。|流动性质量不等于交易时间长度。
Delivery convergence|传统 futures 到期通过实物或现金结算收敛。|perp 缺少到期收敛机制。
Regulatory gap|Perps 常处在不同监管框架下。|机构采用受合规和 clearing 限制。
Borrowed price discovery|Perp 依赖原油 benchmark，而非独立发现实货价格。|不能用衍生报价替代 physical assessment。
'@
}
)

$root = Join-Path (Get-Location) $OutputRoot
New-Item -ItemType Directory -Force -Path $root | Out-Null

$indexRows = @()

foreach ($chapter in $chapters) {
  $targetDir = Join-Path $root $chapter.Dir
  New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
  $sections = Parse-PipedRows -Text $chapter.Sections -MinFields 2
  $concepts = Parse-PipedRows -Text $chapter.Concepts -MinFields 3

  $bankFile = if ($chapter.Bank -eq "formula") { "02-formula-bank.md" } else { "02-concept-bank.md" }
  $indexRows += [pscustomobject]@{
    Label = $chapter.Label
    Title = $chapter.Title
    Url = $chapter.Url
    Dir = $chapter.Dir
    BankFile = $bankFile
    Written = if ($chapter.SkipWrite) { "existing detailed trial run preserved" } else { "generated" }
  }

  if ($chapter.SkipWrite) { continue }

  $source = New-Object System.Text.StringBuilder
  [void]$source.AppendLine("# Oil 101 KB - $($chapter.Label) Source Layer")
  [void]$source.AppendLine()
  [void]$source.AppendLine("## Scope")
  [void]$source.AppendLine()
  [void]$source.AppendLine("- Book/course: Oil 101, 2nd edition web version.")
  [void]$source.AppendLine("- Unit: $($chapter.Label), $($chapter.Title).")
  [void]$source.AppendLine("- Capture date: 2026-06-25.")
  [void]$source.AppendLine("- Processing mode: public web chapter, transformed notes only.")
  [void]$source.AppendLine()
  [void]$source.AppendLine("## Source Inventory")
  [void]$source.AppendLine()
  [void]$source.AppendLine("| Source ID | Source | URL | Coverage |")
  [void]$source.AppendLine("|---|---|---|---|")
  [void]$source.AppendLine((New-MarkdownTableRow @("S1", "Oil 101 web page", $chapter.Url, "Chapter body, tables, figure captions, and navigation cues")))
  [void]$source.AppendLine((New-MarkdownTableRow @("S2", "Oil 101 table of contents", "https://oil101.morgandowney.com/chapters", "Book sequence and unit placement")))
  [void]$source.AppendLine()
  [void]$source.AppendLine("## Section Map")
  [void]$source.AppendLine()
  [void]$source.AppendLine("| Section | Source reference | Captured study focus |")
  [void]$source.AppendLine("|---|---|---|")
  foreach ($s in $sections) {
    [void]$source.AppendLine((New-MarkdownTableRow @($s[0], "S1:web heading", $s[1])))
  }
  [void]$source.AppendLine()
  [void]$source.AppendLine("## Coverage Checklist")
  [void]$source.AppendLine()
  [void]$source.AppendLine("- Processed every major H2 section visible on the public web page.")
  [void]$source.AppendLine("- Rewrote key ideas as study notes and concept/formula entries.")
  [void]$source.AppendLine("- Kept source traceability to URL and section heading rather than reproducing chapter text.")
  [void]$source.AppendLine("- Did not copy figure assets; figure-level ideas are folded into the relevant section notes when needed.")
  [void]$source.AppendLine("- The original 2009 PDF link was not used because it redirected to login during the trial run.")
  Write-Utf8File -Path (Join-Path $targetDir "00-source-layer.md") -Content $source.ToString()

  $notes = New-Object System.Text.StringBuilder
  [void]$notes.AppendLine("# $($chapter.Label) - $($chapter.Title): Structured Notes")
  [void]$notes.AppendLine()
  [void]$notes.AppendLine("## 学习目标")
  [void]$notes.AppendLine()
  [void]$notes.AppendLine("- 说清本章的核心机制、市场角色或技术逻辑。")
  [void]$notes.AppendLine("- 能把主要英文术语和中文解释对应起来。")
  [void]$notes.AppendLine("- 能用本章概念解释价格、物流、炼厂、政策或风险管理中的实际问题。")
  [void]$notes.AppendLine()
  [void]$notes.AppendLine("## Section Notes")
  foreach ($s in $sections) {
    [void]$notes.AppendLine()
    [void]$notes.AppendLine("### $($s[0])")
    [void]$notes.AppendLine()
    [void]$notes.AppendLine($s[1])
  }
  [void]$notes.AppendLine()
  [void]$notes.AppendLine("## Exam Traps And Interpretation Notes")
  [void]$notes.AppendLine()
  [void]$notes.AppendLine("- 先确认口径：crude、total liquids、products、financial contracts 和 physical barrels 不能混用。")
  [void]$notes.AppendLine("- 先看约束：quality、location、time、storage、regulation 和 contract terms 通常比单一 headline price 更重要。")
  [void]$notes.AppendLine("- 先问谁承担风险：producer、refiner、trader、shipper、consumer 和 government 的目标函数不同。")
  Write-Utf8File -Path (Join-Path $targetDir "01-structured-notes.md") -Content $notes.ToString()

  $bank = New-Object System.Text.StringBuilder
  $bankTitle = if ($chapter.Bank -eq "formula") { "Formula And Concept Bank" } else { "Concept Bank" }
  [void]$bank.AppendLine("# $($chapter.Label) - $($chapter.Title): $bankTitle")
  [void]$bank.AppendLine()
  [void]$bank.AppendLine("| Item | Definition / Formula | Common Confusion / Decision Cue |")
  [void]$bank.AppendLine("|---|---|---|")
  foreach ($c in $concepts) {
    [void]$bank.AppendLine((New-MarkdownTableRow @($c[0], $c[1], $c[2])))
  }
  [void]$bank.AppendLine()
  [void]$bank.AppendLine("## How To Use This Bank")
  [void]$bank.AppendLine()
  [void]$bank.AppendLine("- 用 `Item` 作为主动回忆提示。")
  [void]$bank.AppendLine("- 先复述 definition/formula，再说明 common confusion 或 decision cue。")
  [void]$bank.AppendLine("- 遇到价格或操作题时，把概念放回 quality、location、time、contract 和 regulation 五个约束中。")
  Write-Utf8File -Path (Join-Path $targetDir $bankFile) -Content $bank.ToString()

  $review = New-Object System.Text.StringBuilder
  [void]$review.AppendLine("# $($chapter.Label) - $($chapter.Title): Review Tools")
  [void]$review.AppendLine()
  [void]$review.AppendLine("## Active Recall")
  [void]$review.AppendLine()
  $q = 1
  foreach ($c in ($concepts | Select-Object -First 8)) {
    [void]$review.AppendLine("$q. 什么是 $($c[0])？")
    [void]$review.AppendLine("   - $($c[1])")
    [void]$review.AppendLine()
    $q++
  }
  [void]$review.AppendLine("## Mini Quiz")
  [void]$review.AppendLine()
  $q = 1
  foreach ($s in ($sections | Select-Object -First 6)) {
    [void]$review.AppendLine("$q. 用两句话解释 ``$($s[0])`` 为什么对本章重要。")
    $q++
  }
  [void]$review.AppendLine("$q. 选两个概念，说明它们如何共同影响 price differential、margin 或 risk。")
  [void]$review.AppendLine()
  [void]$review.AppendLine("## Answer Key")
  [void]$review.AppendLine()
  [void]$review.AppendLine("- 前 6 题应覆盖对应 section 的机制、参与者和约束。")
  [void]$review.AppendLine("- 最后一题的好答案要同时提到至少两个维度，例如 quality + location、time + storage、policy + demand。")
  [void]$review.AppendLine()
  [void]$review.AppendLine("## Can I Explain This?")
  [void]$review.AppendLine()
  foreach ($c in $concepts) {
    [void]$review.AppendLine("- I can explain ``$($c[0])`` and avoid its common confusion.")
  }
  [void]$review.AppendLine()
  [void]$review.AppendLine("## Common Error Log")
  [void]$review.AppendLine()
  [void]$review.AppendLine("| Error | Correction |")
  [void]$review.AppendLine("|---|---|")
  [void]$review.AppendLine("| 只背术语，不看约束 | 每个概念都要放回质量、地点、时间、合同或监管背景中 |")
  [void]$review.AppendLine("| 把 financial price 当成 physical reality | 先确认是否有交割、库容、物流或规格限制 |")
  [void]$review.AppendLine("| 忽略区域差异 | Oil markets 是全球连接但局部受限的网络 |")
  Write-Utf8File -Path (Join-Path $targetDir "03-review-tools.md") -Content $review.ToString()

  $mapRows = foreach ($s in $sections) {
    [pscustomobject]@{
      source_id = "S1"
      source_type = "web page"
      title = $chapter.Title
      url_or_path = $chapter.Url
      chapter_section = $s[0]
      coverage = "processed"
      notes = "Major section summarized in structured notes"
    }
  }
  $mapRows += [pscustomobject]@{
    source_id = "S2"
    source_type = "web table of contents"
    title = "Oil 101 Table of Contents"
    url_or_path = "https://oil101.morgandowney.com/chapters"
    chapter_section = "book navigation"
    coverage = "processed"
    notes = "Used for chapter sequence and directory placement"
  }
  $csv = ($mapRows | ConvertTo-Csv -NoTypeInformation) -join "`r`n"
  Write-Utf8File -Path (Join-Path $targetDir "source-map.csv") -Content ($csv + "`r`n")
}

$index = New-Object System.Text.StringBuilder
[void]$index.AppendLine("# Oil 101 Knowledge Base")
[void]$index.AppendLine()
[void]$index.AppendLine("- Source: https://oil101.morgandowney.com/chapters")
[void]$index.AppendLine("- Capture date: 2026-06-25")
[void]$index.AppendLine("- Structure: each unit has a source layer, structured notes, a concept/formula bank, review tools, and source-map.csv.")
[void]$index.AppendLine("- Copyright posture: transformed study notes only; no full chapter reconstruction.")
[void]$index.AppendLine()
[void]$index.AppendLine("| Unit | Title | Local directory | Source | Status |")
[void]$index.AppendLine("|---|---|---|---|---|")
foreach ($r in $indexRows) {
  [void]$index.AppendLine((New-MarkdownTableRow @($r.Label, $r.Title, $r.Dir, $r.Url, $r.Written)))
}
Write-Utf8File -Path (Join-Path $root "index.md") -Content $index.ToString()

"Generated $($indexRows.Count) KB index rows under $root"
