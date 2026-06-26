param(
  [string]$KbRoot = "outputs/oil101-KB"
)

$ErrorActionPreference = "Stop"

function Write-Utf8File {
  param(
    [string]$Path,
    [string]$Content
  )
  $parent = Split-Path -Parent $Path
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  [System.IO.File]::WriteAllText((Resolve-Path -LiteralPath $parent).Path + "\" + (Split-Path -Leaf $Path), $Content, [System.Text.UTF8Encoding]::new($false))
}

function New-TableRow {
  param([string[]]$Cells)
  return "| " + (($Cells | ForEach-Object { ($_ -replace "\|", "/").Trim() }) -join " | ") + " |"
}

function Get-IndexUnits {
  param([string]$IndexPath)
  $units = @()
  foreach ($line in ([System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $IndexPath), [System.Text.Encoding]::UTF8) -split "`r?`n")) {
    if ($line -notmatch '^\|\s*(Chapter|Appendix)\s+') { continue }
    $cells = $line.Trim().Trim("|") -split '\|'
    if ($cells.Count -lt 5) { continue }
    $units += [pscustomobject]@{
      Label = $cells[0].Trim()
      Title = $cells[1].Trim()
      Dir = $cells[2].Trim()
      Source = $cells[3].Trim()
    }
  }
  return $units
}

function Get-Sections {
  param([string]$NotesPath)
  $text = [System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $NotesPath), [System.Text.Encoding]::UTF8)
  $sections = @()
  $currentTitle = $null
  $buffer = New-Object System.Collections.Generic.List[string]
  foreach ($line in ($text -split "`r?`n")) {
    if ($line -match '^###\s+(.+)$') {
      if ($currentTitle) {
        $summary = (($buffer | Where-Object { $_.Trim() }) -join " ").Trim()
        $sections += [pscustomobject]@{ Title = $currentTitle; Summary = $summary }
      }
      $currentTitle = $Matches[1].Trim()
      $buffer.Clear()
      continue
    }
    if ($currentTitle) {
      if ($line -match '^##\s+') {
        $summary = (($buffer | Where-Object { $_.Trim() }) -join " ").Trim()
        $sections += [pscustomobject]@{ Title = $currentTitle; Summary = $summary }
        $currentTitle = $null
        $buffer.Clear()
      } else {
        $buffer.Add($line)
      }
    }
  }
  if ($currentTitle) {
    $summary = (($buffer | Where-Object { $_.Trim() }) -join " ").Trim()
    $sections += [pscustomobject]@{ Title = $currentTitle; Summary = $summary }
  }
  return $sections
}

function Get-Concepts {
  param([string]$UnitDir)
  $bankPath = Join-Path $UnitDir "02-concept-bank.md"
  if (!(Test-Path -LiteralPath $bankPath)) { $bankPath = Join-Path $UnitDir "02-formula-bank.md" }
  if (!(Test-Path -LiteralPath $bankPath)) { return @() }
  $concepts = @()
  foreach ($line in ([System.IO.File]::ReadAllText((Resolve-Path -LiteralPath $bankPath), [System.Text.Encoding]::UTF8) -split "`r?`n")) {
    if ($line -notmatch '^\|\s*[^|]+\s*\|') { continue }
    if ($line -match '^\|\s*(Item|---)') { continue }
    $cells = $line.Trim().Trim("|") -split '\|'
    if ($cells.Count -lt 3) { continue }
    $concepts += [pscustomobject]@{
      Item = $cells[0].Trim()
      Meaning = $cells[1].Trim()
      Cue = $cells[2].Trim()
    }
  }
  return $concepts
}

$deepData = @{}

$deepData["part-one-oil-fundamentals/01-history"] = @{
  BigIdea = @'
这一章不是让你背石油史年份，而是让你看懂一个反复出现的循环：新用途或新技术创造需求，资本蜂拥进入导致供给过剩，价格崩塌逼出整合或卡特尔，随后战争、货币、地缘政治和金融市场又把价格机制重新写一遍。你以后看到 OPEC、页岩、负油价、战略储备，都可以回到这个循环里理解。
'@
  MentalModel = @'
把油价史想成三根绳子拧在一起：第一根是物理供给，谁能钻、炼、运、存；第二根是权力结构，谁控制储量、产量和通道；第三根是价格制度，posted price、futures、formula pricing、spreads 怎么把实货世界翻译成价格。某一根绳子突然断裂，市场就会进入新制度。
'@
  Case = @'
如果只用“供需”解释 1973 年油价冲击，会漏掉一半。真正的链条是：美国 spare capacity 消失，OPEC 有了产量调节权，美元脱离黄金后资源国购买力下降，中东战争提供政治触发点，于是油价从商品价格变成了宏观和地缘政治变量。这个框架也能解释 2020 年：需求崩塌、库容受限、期货到期共同制造了负油价。
'@
  Must = @("为什么石油最早不是汽车故事，而是照明燃料替代故事", "为什么 Texas Railroad Commission 是理解 OPEC 的先例", "为什么现代油价同时是商品价格、货币价格和政治价格")
}

$deepData["part-one-oil-fundamentals/02-crude-oil-assay"] = @{
  BigIdea = @'
这一章的核心是：原油不是一种商品，而是一张质量表。API gravity、sulfur、TAN、metals、viscosity、salt、BS&W 等指标共同决定炼厂愿意付多少钱。你看到 WTI、Brent、Maya、Dubai 这些名字时，真正要问的是：这桶油能炼出什么，处理它要花多少钱，谁有能力接收它。
'@
  MentalModel = @'
把 crude assay 当成炼厂的入场体检。轻质低硫原油像容易处理的原料，能多产 gasoline、diesel、jet fuel；重质高硫原油像需要特殊厨房和厨师的原料，便宜但只有复杂炼厂能吃下。价格差就是“产品收入 - 处理成本 - 操作风险”的结果。
'@
  Case = @'
假设两桶油都叫 crude：一桶 40 API、0.3% sulfur，另一桶 20 API、3% sulfur、TAN 高。前者很多炼厂都能接收，产品 slate 好；后者可能需要 coker、hydrocracker、hydrotreating 和防腐能力。后者不是“没价值”，而是必须折价到复杂炼厂觉得值得冒险。
'@
  Must = @("为什么 API 越高反而越轻", "为什么 sweet/sour 不只是环保标签，而是炼厂成本标签", "为什么 heavy-sour crude 可以便宜但仍然很重要")
}

$deepData["part-one-oil-fundamentals/03-components"] = @{
  BigIdea = @'
这一章帮你纠正一个大口径误区：世界说的 oil liquids 不等于 conventional crude。它包含 conventional crude、tight oil、condensate、NGLs、unconventional heavy oil、biofuels 和 refinery gain。很多供需新闻之所以让人看糊涂，就是因为口径没分清。
'@
  MentalModel = @'
把 “oil liquids” 想成一个家族，不是一个人。家族成员都可以按 barrel 计量，但来源、价格、用途和基础设施完全不同。NGLs 更像 gas processing 的副产品，condensate 介于 gas 和 crude 之间，refinery gain 是体积口径结果，biofuels 又来自农业和政策系统。
'@
  Case = @'
如果报告说全球 liquids 增长，但 conventional crude 没怎么增长，这并不矛盾。2008 后的增量主要来自 US tight oil 和 NGLs。一个 shale well 生产 light oil 的同时，也产 associated gas，gas plant 再分出 ethane、propane、butanes、natural gasoline。这就是为什么 shale 和 NGL 要放在一起理解。
'@
  Must = @("为什么 total liquids 不能直接等同 crude oil", "lease condensate 和 plant condensate 为什么会被统计到不同篮子", "为什么 refinery gain 是体积增加而不是能量凭空增加")
}

$deepData["part-one-oil-fundamentals/04-chemistry"] = @{
  BigIdea = @'
这一章把石油从“黑色液体”拆成分子。炼厂赚钱不是因为油神秘，而是因为不同碳数和分子结构会变成不同产品。Paraffins、olefins、naphthenes、aromatics，以及 sulfur、nitrogen、oxygen、metals 这些杂质，决定了燃料质量、污染成本和炼厂工艺。
'@
  MentalModel = @'
把炼油看成分子重排。蒸馏只是按 boiling point 分开，cracking 是把长链打短，alkylation 是把小分子拼成高价值汽油组分，reforming/isomerization 是把形状改得更适合汽油发动机。化学结构决定产品命运。
'@
  Case = @'
汽油和柴油想要的分子几乎相反：汽油发动机怕 knock，所以喜欢 branched paraffins 和 aromatics 的高 octane；柴油发动机要压燃，所以喜欢 straight-chain paraffins 的高 cetane。你不能简单把一个流倒进另一个产品池，因为发动机需求不同。
'@
  Must = @("PONA 四类分子各自意味着什么", "为什么高 octane 分子不一定适合 diesel", "为什么 sulfur/metals 是价格折扣而不只是化学杂质")
}

$deepData["part-one-oil-fundamentals/05-industry-overview"] = @{
  BigIdea = @'
这一章是在给你画产业地图。油不是某一家公司的故事，而是 upstream、midstream、downstream、trading、services、EPC、NOC、IOC、independents 共同完成的系统。每个角色赚的钱不同，承担的风险也不同。
'@
  MentalModel = @'
沿着一桶油走：地下储层到井口是 upstream，管线、船、储罐和气体处理是 midstream，炼厂和产品销售是 downstream。每次换手都会发生计量、质量确认、定价和风险转移。所以学油要按 value chain 看，而不是只记公司名字。
'@
  Case = @'
一个 shale producer 可能只负责钻井生产，把原油交给 midstream 管线，最终卖给 Gulf Coast refiner；refiner 又把汽油、柴油通过产品管线卖到终端。SLB 或 Halliburton 可能实际完成钻完井服务，Vitol 或 Trafigura 可能负责跨区调货。新闻里说“oil company”时，先判断它处在哪一段。
'@
  Must = @("upstream/midstream/downstream 的经济模式差别", "NOC 和 IOC 为什么目标函数不同", "为什么 trading houses 和 service companies 不是边角角色")
}

$deepData["part-one-oil-fundamentals/06-exploration-production"] = @{
  BigIdea = @'
这一章解释油从地下变成可卖 barrels 的全过程。Upstream 的本质是把地下不确定性变成 reserves 和 production：先拿权利，再找结构，再钻井，再用压力和工程把流体带上来，最后面对 decline。
'@
  MentalModel = @'
商业油田必须同时满足 source rock、reservoir rock、cap rock、trap、pressure 和 market access。任何一个环节断掉，都可能从“地质上有油”变成“商业上没油”。E&P 的风险不是单点风险，而是一串条件同时成立。
'@
  Case = @'
一个漂亮的 seismic structure 不等于赚钱油田。它可能没有成熟 source rock，reservoir permeability 太差，pressure 不够，或者离管线太远。Shale 革命的特殊之处在于，它把传统“找大油藏”的模式，部分改成了“在已知源岩里重复制造井”的模式。
'@
  Must = @("source-reservoir-cap system 为什么缺一不可", "primary/secondary/tertiary recovery 的区别", "为什么 decline curve 是公司估值和现金流的核心")
}

$deepData["part-one-oil-fundamentals/07-refining"] = @{
  BigIdea = @'
这一章是理解炼厂利润的钥匙。炼厂不是把 crude 简单煮一下，而是在不同装置之间做分子优化：把便宜、重、脏的分子尽量变成贵、轻、干净、合规的产品。
'@
  MentalModel = @'
用四步记炼厂：separation 分开，conversion 升级，treatment 清洁，blending 达标。CDU 只按沸点切分；FCC、coker、hydrocracker 才是价值转换；hydrotreating 去硫；最后 blending 才把各股 blendstock 调成能卖的 gasoline、diesel、jet fuel。
'@
  Case = @'
同样买 Maya heavy-sour crude，简单炼厂可能被残渣和硫卡住，只能要求大折价；复杂 Gulf Coast refinery 有 coker、hydrocracker、hydrotreaters，可以把低价原油转成高价值产品。复杂度就是把“别人不想要的原油”变成 margin 的能力。
'@
  Must = @("CDU 和 conversion units 的本质区别", "Nelson Complexity Index 为什么影响原油选择", "为什么 finished product 是 blending 结果而不是单一装置直出")
}

$deepData["part-one-oil-fundamentals/08-standards"] = @{
  BigIdea = @'
这一章解释为什么油品市场必须有标准。没有 ASTM、API、EPA、CARB、ISO 等规则，交易双方无法确认同一桶油、同一批汽油、同一种柴油到底是否合格。标准就是把质量争议变成可测量条款。
'@
  MentalModel = @'
把 standards 看成市场语言。API gravity、sulfur、octane、RVP、cetane、flash point、freezing point、viscosity 都不是孤立数字，而是合同、监管和发动机安全之间的接口。能不能卖，很多时候不是“有没有需求”，而是“是否符合规格”。
'@
  Case = @'
夏季汽油不能简单用冬季配方，因为 RVP 太高会增加蒸发排放；jet fuel 比汽油更看重 freezing point 和 thermal stability，因为飞机在高空低温环境运行。规格差异会制造区域价差，也会影响炼厂调和策略。
'@
  Must = @("RON、MON、AKI 为什么不能混着比", "RVP 为什么有季节性", "为什么低硫燃料和发动机排放后处理是一套系统")
}

$deepData["part-one-oil-fundamentals/09-finished-products"] = @{
  BigIdea = @'
这一章把 crude 的价值拆成产品。原油本身不是终点，gasoline、diesel、jet fuel、LPG、asphalt、petcoke、lubes、sulfur 等产品才连接真实需求。炼厂买 crude，本质是在买一组未来产品 slate。
'@
  MentalModel = @'
把一桶油想成可拆分的产品组合。不同地区的 demand pull 不同：美国重 gasoline，欧洲偏 distillate，航空看 jet fuel，航运受 bunker specs 影响，石化看 naphtha/LPG。产品价格变了，crude 的相对价值也会变。
'@
  Case = @'
IMO 2020 降低船燃 sulfur cap 后，高硫 residual fuel oil 的市场被重写。能脱硫或把残渣进一步加工的炼厂更有优势；没有升级能力的炼厂会面对更差的 residue economics。这说明产品标准会反向改变原油和炼厂价值。
'@
  Must = @("为什么 gasoline 是 cocktail 而不是单一产品", "diesel、jet、bunker 的需求和规格差别", "为什么 petcoke/asphalt/sulfur 这些副产品也会影响炼厂经济")
}

$deepData["part-one-oil-fundamentals/10-petrochemicals"] = @{
  BigIdea = @'
这一章说明 oil demand 不只来自燃料，也来自材料。Petrochemicals 把 oil and gas 分子变成塑料、纤维、溶剂、肥料和工业材料。交通燃料增长放慢后，石化是长期需求里最重要的增量之一。
'@
  MentalModel = @'
石化有两条大路线：ethane/LPG route 便宜但产品窄，naphtha route 成本高但产物更均衡。Ethylene、propylene、butadiene、BTX、methanol、ammonia 是中间积木，下游才是 polyethylene、polypropylene、polyester、nylon、fertilizer 等产品。
'@
  Case = @'
美国 shale 给了低价 ethane，所以 US polyethylene 有成本优势；亚洲 naphtha crackers 能同时产 olefins 和 aromatics，更适合覆盖多样化石化链。于是同样是“石化需求”，不同地区的 feedstock advantage 和产品 slate 完全不同。
'@
  Must = @("ethylene 和 propylene 为什么是核心 building blocks", "ethane cracker 和 naphtha cracker 的产品结构差别", "为什么中国化工过剩会压低全球 margins")
}

$deepData["part-one-oil-fundamentals/11-transporting-oil"] = @{
  BigIdea = @'
这一章讲的是物流如何创造价格。油不是只要有就能用，它必须用 tanker、pipeline、rail、truck、barge 等方式从产地到炼厂，再到产品市场。运输路径、瓶颈和交货条款会直接变成 basis 和 differential。
'@
  MentalModel = @'
把全球油市想成一张有容量限制的网络。管线便宜但固定，船灵活但受运费和 chokepoint 影响，铁路和卡车灵活但贵。一个地区原油折价，常常不是质量差，而是“出不去”。
'@
  Case = @'
Bakken boom 早期管线不足，crude by rail 变得重要；Cushing 管线方向变化也曾让 WTI 与 Brent 出现巨大差价。运输不是后台 plumbing，它会改变 benchmark、套利和炼厂采购。
'@
  Must = @("为什么 pipeline 低成本但不灵活", "Worldscale 和 tanker freight 如何影响 delivered cost", "FOB/CIF 等 Incoterms 为什么会改变谁承担风险")
}

$deepData["part-one-oil-fundamentals/12-storage"] = @{
  BigIdea = @'
这一章讲时间价值。Storage 让市场把今天的 barrels 移到未来，也让供应冲击有缓冲。库存不是静态数字，而是炼厂运行、贸易套利、战略安全和期货曲线共同作用的结果。
'@
  MentalModel = @'
如果 forward price 足够高，能覆盖仓储、融资、损耗和操作成本，contango storage trade 就可能成立；如果 near-term price 高于远月，backwardation 会鼓励释放库存。库存是时间套利的工具，也是物理系统的保险。
'@
  Case = @'
2020 年 WTI 负价说明 storage optionality 可以突然变得极贵。当 Cushing 接近可用容量上限时，不能接收实物的人必须付钱退出。这里的价格不是“油没价值”，而是“马上接油的义务很昂贵”。
'@
  Must = @("contango storage play 的成本项有哪些", "commercial/operational/strategic storage 的区别", "为什么库存报告会立刻影响价格")
}

$deepData["part-one-oil-fundamentals/13-seasonality"] = @{
  BigIdea = @'
这一章讲油市的日历。油价和产品价差会受驾驶季、取暖季、RVP 规则、炼厂检修、飓风、河流水位、冰情等多重季节因素影响。不是所有季节性都作用在 crude 上，很多更直接作用在 products。
'@
  MentalModel = @'
把一年拆成多个重叠日历：summer driving 提 gasoline demand；winter heating 提 distillate/propane/gas demand；spring/fall turnaround 降低 refinery runs；hurricane season 影响 Gulf Coast 生产、炼厂和港口。价格反应来自这些日历叠加后的库存路径。
'@
  Case = @'
夏季 gasoline demand 强，但夏季汽油 RVP 限制也更严格，调和成本上升；秋季炼厂检修会减少 crude runs，但也可能收紧产品供应。看库存时，不要只看绝对水平，要看是否偏离正常季节性 build/draw。
'@
  Must = @("HDD/CDD 如何帮助理解能源需求", "为什么 summer/winter gasoline specs 不同", "为什么 crude 本身通常没有产品那么季节性")
}

$deepData["part-one-oil-fundamentals/14-reserves"] = @{
  BigIdea = @'
这一章让你分清 resources 和 reserves。Reserves 不是地下有多少油，而是在当前价格、技术、合同和开发计划下能商业开采多少。储量是地质、工程、经济和会计规则共同定义的数字。
'@
  MentalModel = @'
用风险阶梯理解：proved、probable、possible 是置信度；PDP、PDNP、PUD 是开发状态；PV-10、RBL、RRR、EUR 是金融和经营指标。储量不是永远固定，会随价格、井表现、规则和投资计划 re-cat。
'@
  Case = @'
油价上涨时，一部分原来不经济的资源可能变成 reserves；油价下跌或开发计划推迟时，PUD 可能被降级。OPEC 1980s 储量上调则提醒你：当配额和储量挂钩，储量数字也可能被政治激励污染。
'@
  Must = @("proved/probable/possible 不能混为一谈", "R/P ratio 为什么不是真实枯竭日期", "PV-10 和 reserve-based lending 为什么会受油价假设影响")
}

$deepData["part-one-oil-fundamentals/15-environmental"] = @{
  BigIdea = @'
这一章讲监管如何反向塑造燃料和炼厂。环境规则不是油市外部噪音，它会改变 gasoline、diesel、bunker、vehicle technology、methane control 和 refinery investment 的经济性。
'@
  MentalModel = @'
把环境监管分成三类：产品规格，比如 gasoline sulfur/RVP、ULSD；设施和运营安全，比如 spills、pipelines、tanks；气候监管，比如 CO2、methane、fuel economy。每类规则都会把成本加到不同环节。
'@
  Case = @'
ULSD 不是单独的柴油故事。低硫 diesel 让 particulate filters、SCR 等后处理系统可以工作，所以燃料规则和发动机技术是一套系统。汽油去铅、降硫、Tier 3 也类似：燃料变干净，车辆催化器才有效。
'@
  Must = @("NAAQS 管的是环境空气质量而不是单一工厂价格", "CARB waiver 为什么会影响全国车辆市场", "methane 为什么是 upstream 的气候监管重点")
}

$deepData["part-one-oil-fundamentals/16-engine-technologies"] = @{
  BigIdea = @'
这一章连接发动机技术和油品需求。Oil demand 的长期路径不只由 GDP 决定，还由每英里耗油量、车辆存量更新、EV penetration、hybrids、heavy-duty replacement 和燃料质量共同决定。
'@
  MentalModel = @'
车辆需求要分三层：新车销售、车队存量、实际行驶里程。EV 新车占比上升不会立刻让 gasoline demand 同比例下降，因为旧车还在路上；hybrids 降低油耗但仍用油；重卡、航空、船舶和 off-road 更难替代。
'@
  Case = @'
提高 compression ratio 可以提高内燃机效率，但会增加 knock 风险，所以需要更高 octane fuel。这样发动机技术、炼厂调和、标准和消费者油耗其实连成一条链。不是“车变好”这么简单。
'@
  Must = @("four-stroke cycle 和 compression ratio 的基本逻辑", "为什么 fleet turnover 让需求变化滞后", "BEV、HEV、FCEV 对油品需求的影响差别")
}

$deepData["part-two-oil-markets/17-oil-prices"] = @{
  BigIdea = @'
这一章讲价格怎么从实货世界生成。Oil price 不是一个数字，而是一串阶梯：wellhead、pipeline、hub、seaborne cargo、refinery gate、wholesale、retail，每一层都加上质量、地点、时间、运输、税和 margin。
'@
  MentalModel = @'
用公式记：physical crude price = benchmark +/- quality differential +/- location differential +/- timing/freight adjustments。Benchmark 提供共同语言，differential 才把具体货物的质量和物流翻译出来。
'@
  Case = @'
一桶重质高硫原油卖到远方复杂炼厂，价格可能按 Brent 减质量折价，再减 freight，再考虑目的地炼厂可承受的 netback。你看到新闻里的 Brent/WTI 只是起点，真正成交价还要通过 formula pricing 落地。
'@
  Must = @("benchmark 和 differential 的关系", "freight netback 如何倒推产地价值", "为什么 retail gasoline price 不会一比一跟 crude price 同步")
}

$deepData["part-two-oil-markets/18-futures-swaps"] = @{
  BigIdea = @'
这一章讲 forward markets 如何把未来价格拿到今天交易。Futures 和 swaps 不是赌场附属品，而是 producer、refiner、airline、trader 管理风险和表达库存/时间结构观点的工具。
'@
  MentalModel = @'
先看 curve shape：contango 鼓励买现货、存起来、卖远月；backwardation 鼓励释放库存。再看 spreads：calendar spread 看时间，crack spread 看炼厂 margin，location/quality spread 看物流和品级差异。专业交易者往往更看 spread than flat price。
'@
  Case = @'
3:2:1 crack spread 用 3 桶 crude 对 2 桶 gasoline 和 1 桶 diesel/heating oil，粗略模拟炼厂毛利。它不等于真实炼厂利润，但能快速告诉你产品相对 crude 是否变贵。
'@
  Must = @("paper barrels 和 wet barrels 的区别", "contango/backwardation 与库存行为的关系", "为什么 2020 负价是 futures delivery 和 storage 的共同结果")
}

$deepData["part-two-oil-markets/19-options"] = @{
  BigIdea = @'
这一章讲非线性风险管理。Futures 锁定价格，options 买的是权利和凸性：你可以限制下行、保留上行，或者用结构化组合换取更低 premium。代价是时间价值、波动率和 Greeks。
'@
  MentalModel = @'
Option price = intrinsic value + time value。Delta 告诉你价格动一点 option 变多少，gamma 告诉你 delta 怎么变，theta 是时间衰减，vega 是波动率敏感度。Producer 买 put 像买保险，consumer 买 call 像锁住最高成本。
'@
  Case = @'
一个 shale producer 担心油价跌，可以买 put 保护现金流；如果觉得 premium 太贵，可以卖 call 组成 collar。但卖 call 意味着油价大涨时上行被封顶。便宜的 hedge 通常不是免费的，只是把风险换了形状。
'@
  Must = @("call/put、intrinsic/time value、moneyness 的关系", "为什么 implied volatility 是 option market 的核心价格", "collar 和 three-way 等结构的隐藏代价")
}

$deepData["part-two-oil-markets/20-risk-management"] = @{
  BigIdea = @'
这一章把衍生品从交易工具拉回公司治理。Risk management 的目标不是猜对油价，而是让公司在坏情景下活下来，在正常情景下能融资、投资和运营。好的 hedge policy 服务现金流，不服务炫技。
'@
  MentalModel = @'
先识别 exposure，再选 instrument，再管理 basis、roll、liquidity、counterparty、accounting 和 governance。Producer、refiner、airline、marketer 的风险方向不同，所以没有统一 hedge ratio。
'@
  Case = @'
Metallgesellschaft 的教训是 roll risk 和 liquidity risk 可以击穿看似合理的 hedge。用短期期货滚动长期固定价格销售，曲线结构和保证金现金流可能让公司在经济上对、现金上先死。
'@
  Must = @("basis risk 为什么无法靠 flat price hedge 消除", "VaR 和 expected shortfall 各自看什么", "为什么 hedge accounting 和 board policy 很现实")
}

$deepData["part-three-modern-era/21-shale-revolution"] = @{
  BigIdea = @'
这一章讲页岩如何改变全球油市。Shale 的革命不是只多了一种油，而是把 upstream 从少数大型长周期项目，部分变成可重复、短周期、制造业式的 drilling inventory 管理。
'@
  MentalModel = @'
页岩成功靠 horizontal drilling、hydraulic fracturing、proppant、pad drilling、data learning 和服务产业链。它的弱点是 decline 快，需要持续钻井；它的优势是响应周期短，比 offshore megaproject 更像可调节的 supply source。
'@
  Case = @'
2014 年油价崩盘后，页岩没有完全死掉，而是通过更长 laterals、更好 completion、成本压缩和资本纪律存活下来。后来 Majors 收购 shale independents，说明市场从“增长故事”转向“谁掌握高质量 inventory”。
'@
  Must = @("shale treadmill 为什么要求持续资本投入", "parent-child wells 为什么限制过密开发", "为什么解除 crude export ban 改变 US light crude differential")
}

$deepData["part-three-modern-era/22-opec-plus"] = @{
  BigIdea = @'
这一章讲现代供应管理。OPEC+ 不是简单“几个国家开会”，它是用 quotas、baselines、spare capacity 和 compliance 管理全球供给预期的机制。真正的权力来自可用闲置产能。
'@
  MentalModel = @'
看 OPEC+ 不要只看 headline cut，要看三个问题：谁真的有 spare capacity，谁的 baseline 被高估或低估，谁有财政压力和作弊动机。Saudi Arabia 是核心 swing producer，Russia 则让联盟变成更复杂的地缘政治交易。
'@
  Case = @'
2020 Saudi-Russia price war 展示了 market share strategy 的危险：增产可以惩罚对手，但在疫情需求崩塌时会把整个市场推入库存危机。OPEC+ 的纪律后来变得更重要，因为 shale、sanctions 和 demand uncertainty 都在改变边界。
'@
  Must = @("spare capacity 和 reserves 不是一回事", "quota baseline 为什么比 headline cuts 更关键", "Saudi fiscal needs、market share 和 price stability 如何冲突")
}

$deepData["part-three-modern-era/23-negative-prices"] = @{
  BigIdea = @'
这一章让你真正相信：价格可以低于零。Negative WTI 不是经济学失灵，而是实物交割、库容、合约到期、被动资金滚动和需求崩塌同时发生时的理性结果。
'@
  MentalModel = @'
期货到期不是屏幕数字，WTI 合约背后是 Cushing 实物交割。如果你不能接油、不能存油、不能转卖，又必须在到期前退出，那么别人接手这个义务就要你付钱。负价是约束的价格。
'@
  Case = @'
2020 年 4 月，疫情让 refinery runs 暴跌，Cushing 可用库容紧张，USO 等产品集中滚动近月，市场流动性在到期日前变薄。结果不是所有 oil 都变成负价值，而是特定合约、特定地点、特定时间的接收义务变成负价值。
'@
  Must = @("WTI delivery mechanism 为什么重要", "库容接近上限时 storage optionality 为什么暴涨", "为什么 negative price 不等于能源本身没有价值")
}

$deepData["part-three-modern-era/24-us-lng"] = @{
  BigIdea = @'
这一章解释美国 LNG 如何把 Henry Hub 接到全球气价。Shale gas 让美国从 LNG importer 变成 exporter，LNG terminals、ships、contracts 和 destination prices 把本土 gas 变成全球可交易能源。
'@
  MentalModel = @'
US LNG 价值链可以写成：Henry Hub feedgas + liquefaction fee + shipping + regas = delivered gas。买方比较 TTF、JKM、oil-indexed contracts 和 spot cargo economics，决定 cargo flow。
'@
  Case = @'
2022 欧洲急着替代 Russian pipeline gas，FSRUs 快速增加进口能力，US LNG cargoes 被欧洲高价吸引。与此同时，Panama Canal、Red Sea、shipping distance 和 boil-off gas 又会改变运费和 netback。
'@
  Must = @("Henry Hub、TTF、JKM 分别代表什么", "tolling/liquefaction fee 如何改变合同风险", "为什么 LNG 让 US gas 更全球化")
}

$deepData["part-three-modern-era/25-energy-transition"] = @{
  BigIdea = @'
这一章让你用更严谨的方式看 energy transition。问题不是“油会不会消失”，而是不同地区、不同部门、不同时间尺度的需求怎么变；同时如果投资下降快于需求下降，价格反而可能更波动。
'@
  MentalModel = @'
把转型拆成四层：OECD vs non-OECD demand，transport fuel vs petrochemical demand，new sales vs fleet stock，policy ambition vs infrastructure reality。Peak demand 是需求峰值，不是资源枯竭。
'@
  Case = @'
EV 新车销售增长很快，但 gasoline demand 取决于整个车辆存量和行驶里程；petrochemical demand 可能继续增长；heavy-duty、aviation、shipping 更难替代。与此同时，低油气投资可能让供给变紧，形成 investment paradox。
'@
  Must = @("peak demand 和 peak supply 的区别", "fleet turnover 为什么让燃料需求滞后", "为什么低碳投资不足和油气投资不足可能同时存在")
}

$deepData["part-three-modern-era/26-iran-strait"] = @{
  BigIdea = @'
这一章用 Strait of Hormuz 教你看 chokepoint risk。油价风险不只来自产量，也来自航道、保险、港口、绕行管线、LNG flow、SPR 和军事恢复速度。供应链断点会把全球市场拆成可达与不可达两层。
'@
  MentalModel = @'
Chokepoint 事件要按流程看：威胁出现，保险和 freight 上升，船只延迟或改道，出口国可能 forced shut-in，买家寻找替代，SPR 和库存释放，最后 reopening 还要等扫雷、护航和保险恢复。每一步都影响价格。
'@
  Case = @'
如果 Hormuz 暂时关闭，Saudi 和 UAE 有 bypass pipelines，但容量有限；Asian importers 暴露最大；LNG cargoes 也受影响。油价不一定马上到极端数字，因为库存、SPR、需求弹性和政策反应会缓冲，但区域价差和 freight 会先动。
'@
  Must = @("chokepoint risk 为什么不是单纯军事风险", "bypass capacity 为什么有 ceiling", "two-tier market 如何形成")
}

$deepData["appendices/A1-forward-markets-mechanics"] = @{
  BigIdea = @'
这个 appendix 是第 18 章的技术补充，帮你分清 NYMEX WTI、ICE Brent、Dated Brent、BFOETM、CFD、EFP、EFS 这些名词。它们都和 forward markets 有关，但连接的实货、现金结算和风险窗口不一样。
'@
  MentalModel = @'
把 forward market 分成三层：exchange futures 提供标准化合约，physical assessments 提供实货价格锚，OTC/CFD/EFP/EFS 把两者连接起来。专业市场不是一个价格，而是一套桥梁。
'@
  Case = @'
一个 physical Brent cargo 可能用 Dated Brent 定价，但 trader 又用 ICE Brent futures 管理风险，中间用 CFD 管理 Dated 与 forward 的差。看似都叫 Brent，其实 reference、timing 和 settlement 都不同。
'@
  Must = @("CL 和 Brent futures 的交割/结算差异", "Dated Brent 和 Brent futures 为什么不是同一物", "EFP/EFS 如何连接 futures、physical 和 swaps")
}

$deepData["appendices/A2-conversion-factors"] = @{
  BigIdea = @'
这个 appendix 是单位转换生存指南。Oil market 到处是 barrels、tonnes、gallons、BTU、BOE、Mcf、MWh，如果口径不统一，价格和数量比较会立刻错掉。
'@
  MentalModel = @'
转换不是背固定数字，而是先问物理属性和口径：barrel 是体积，tonne 是质量，barrel-to-tonne 取决于 density/API；HHV 和 LHV 的热值口径不同；BOE 是能量等价，不是价格等价。
'@
  Case = @'
两种 crude 都是一百万 barrels，但 API 不同，换成 tonnes 会不同。天然气用 6 Mcf = 1 BOE 只是财务近似，实际价格和热值都可能偏离。做商业结算时必须回到合同规定的 conversion table。
'@
  Must = @("API/SG/density 如何互转", "为什么 barrels per tonne 会随 crude grade 变化", "HHV/LHV 和 BOE 为什么容易造成误读")
}

$deepData["appendices/A3-perpetual-futures"] = @{
  BigIdea = @'
这个 appendix 讨论 crypto-style perpetual futures 能否进入 oil market。Perp 的吸引力是 24/7 和无到期，但 oil 是有实物交割、库存、监管和 benchmark assessment 的市场，所以 perp 很难替代传统 futures curve。
'@
  MentalModel = @'
Perpetual futures 没有到期收敛，只能靠 funding rate 锚定外部 index。传统 commodity futures 有交割或现金结算机制，到期时会被实货世界拉回。两者最大差别是是否有 physical convergence。
'@
  Case = @'
如果周末中东出现风险，oil perp 可以让投资者立刻表达价格观点；但它引用的 index 仍来自传统油价体系。真正的 physical barrels、freight、storage 和 refinery demand 不会因为 perp 24/7 交易而变成 24/7 实货市场。
'@
  Must = @("funding rate 如何替代到期机制", "为什么 borrowed price discovery 是 perp 的弱点", "为什么 oil market 的实货约束比 crypto 更强")
}

$kb = Resolve-Path -LiteralPath $KbRoot
$units = Get-IndexUnits -IndexPath (Join-Path $kb "index.md")

foreach ($unit in $units) {
  if (-not $deepData.ContainsKey($unit.Dir)) {
    throw "Missing deep data for $($unit.Dir)"
  }
  $unitDir = Join-Path $kb $unit.Dir
  $sections = Get-Sections -NotesPath (Join-Path $unitDir "01-structured-notes.md")
  $concepts = Get-Concepts -UnitDir $unitDir
  $data = $deepData[$unit.Dir]

  $md = New-Object System.Text.StringBuilder
  [void]$md.AppendLine("# $($unit.Label) - $($unit.Title): 深度讲解")
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 先给你结论")
  [void]$md.AppendLine()
  [void]$md.AppendLine($data.BigIdea.Trim())
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 脑内模型")
  [void]$md.AppendLine()
  [void]$md.AppendLine($data.MentalModel.Trim())
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 按章节怎么读")
  [void]$md.AppendLine()
  [void]$md.AppendLine("| 小节 | 你要真正理解的点 |")
  [void]$md.AppendLine("|---|---|")
  foreach ($s in $sections) {
    [void]$md.AppendLine((New-TableRow @($s.Title, "这一节不是让你背标题，而是让你抓住：$($s.Summary)")))
  }
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 现实推演")
  [void]$md.AppendLine()
  [void]$md.AppendLine($data.Case.Trim())
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 概念怎么串起来")
  [void]$md.AppendLine()
  foreach ($c in ($concepts | Select-Object -First 10)) {
    $item = $c.Item
    $meaning = $c.Meaning
    $cue = $c.Cue
    [void]$md.AppendLine("- ``$item``：$meaning 读的时候要防止这个误区或抓住这个 cue：$cue")
  }
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 读完必须会解释")
  [void]$md.AppendLine()
  foreach ($m in $data.Must) {
    [void]$md.AppendLine("- $m")
  }
  [void]$md.AppendLine()
  [void]$md.AppendLine("## 不看原书也能懂的检查")
  [void]$md.AppendLine()
  [void]$md.AppendLine("- 你能不能用自己的话说出本章的核心因果链，而不是只复述术语？")
  [void]$md.AppendLine("- 你能不能把本章至少两个概念连到价格、物流、炼厂、政策或风险管理中的一个真实问题？")
  [void]$md.AppendLine("- 你能不能指出一个常见误解，并解释为什么它错？")
  [void]$md.AppendLine()
  [void]$md.AppendLine("Source reference: $($unit.Source)")

  Write-Utf8File -Path (Join-Path $unitDir "04-deep-explanation.md") -Content $md.ToString()
}

"Generated deep explanations for $($units.Count) units."
