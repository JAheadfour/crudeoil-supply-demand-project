# Chapter 2 - Formula And Concept Bank

## 1. API Gravity From Specific Gravity

```text
API gravity = 141.5 / SG - 131.5
```

- Variables:
  - API gravity: American Petroleum Institute gravity, in degrees API.
  - SG: specific gravity, the density of the crude divided by the density of water at the reference condition.
- Use when: converting a measured or reported specific gravity into the oil market's common light/heavy indicator.
- Interpretation: higher API gravity means lower density and usually lighter crude.
- Edge case: API below 10 means the liquid is denser than water.

Minimal example:

```text
If SG = 0.850:
API = 141.5 / 0.850 - 131.5 = 34.97 degrees API
```

## 2. Specific Gravity From API Gravity

```text
SG = 141.5 / (API gravity + 131.5)
```

- Use when: converting a quoted API gravity into density logic.
- Assumption: values are reported at the standard reference condition, commonly 60 degrees F and 1 atmosphere.

Minimal example:

```text
If API = 39.6:
SG = 141.5 / (39.6 + 131.5) = 0.827
```

## 3. Metric Density Approximation

```text
Density in kg/m3 ≈ SG * 1000
```

- Variables:
  - SG: specific gravity.
  - 1000 kg/m3: approximate density of water under the relevant reference convention.
- Use when: translating oil-market API/SG language into engineering density.
- Edge case: real commercial calculations use precise reference tables and temperature correction; this is a study-level approximation.

Minimal example:

```text
If SG = 0.827:
Density ≈ 0.827 * 1000 = 827 kg/m3
```

## 4. Barrel Mass Estimate

```text
Mass per barrel ≈ density * 0.158987
```

- Variables:
  - Mass is in kg per 42-US-gallon barrel.
  - Density is in kg/m3.
  - 0.158987 m3 is approximately one oil barrel.
- Use when: estimating why lighter crude weighs less than an equal volume of water.

Minimal example:

```text
WTI density ≈ 827 kg/m3
Mass ≈ 827 * 0.158987 = 131.5 kg per barrel
```

## 5. API Density Classes

| Class | API gravity cue | Decision cue |
|---|---:|---|
| Light | >31 degrees API | Easier high-value product yield |
| Medium | 22-31 degrees API | Broad refinery compatibility |
| Heavy | 10-22 degrees API | More residue; complex conversion units matter |
| Extra-heavy | <10 degrees API | Denser than water; transport often needs diluent or heat |

Common confusion: API is inverted. Moving from 20 degrees API to 40 degrees API means moving to lighter, not heavier, crude.

## 6. Sulfur Classes

| Class | Sulfur by weight | Decision cue |
|---|---:|---|
| Sweet | <0.5% | Lower corrosion and desulfurization burden |
| Medium-sour | roughly 0.5%-2.0% | Requires sulfur-aware refinery economics |
| Sour | around/above 2.0% | Hydrotreating and corrosion controls become central |

Edge case: the 2.0% boundary is often rounded in market examples. Contracts and assay sheets define the exact commercial threshold.

## 7. Total Acid Number Rule Of Thumb

```text
TAN = mg KOH needed to neutralize 1 gram crude
```

- Low concern: commonly under 0.5.
- High-acidity flag: roughly 0.7 and above.
- Use when: screening for naphthenic acid corrosion risk.
- Related concept: high TAN crude is often heavy because biodegradation tends to remove lighter hydrocarbons first.

Minimal example:

```text
TAN = 1.2 means 1.2 mg KOH is needed per gram of crude,
which is above the usual high-acidity warning zone.
```

## 8. Viscosity And Temperature

- Viscosity measures resistance to flow, often in centistokes (cSt).
- It is commonly reported at 40 degrees C and 100 degrees C because crude flows much more easily when warm.
- Use when: judging transport, pumping, heating, and diluent needs.

Decision cue: high viscosity plus low API usually points to transportation constraints and a need for specialized handling.

## 9. Reid Vapor Pressure

- RVP measures volatility of light ends, commonly in psi.
- High RVP can signal valuable light material, but finished fuel volatility is constrained by environmental rules.
- Use when: thinking about light-end value, vapor handling, and gasoline blending constraints.

## 10. BS&W Intake Cue

```text
BS&W = Basic Sediment and Water
```

- Meaning: water, sediment, and unwanted material in crude.
- Common refinery intake cue: below 1% by weight.
- Use when: screening whether a crude cargo is physically clean enough for routine handling.

## 11. Refinery Value Logic

```text
Crude value to refinery
≈ expected product revenue - processing cost - operational/quality risk
```

- Product revenue: driven by gasoline, diesel, jet fuel, fuel oil, and other product yields.
- Processing cost: driven by sulfur, TAN, metals, salt, water, carbon residue, viscosity, and refinery configuration.
- Operational risk: delays, corrosion, catalyst poisoning, off-spec delivery, and inability to run the crude in available units.
