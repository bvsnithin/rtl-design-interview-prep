# Low-Power RTL Design

## Quick Historical Context on Why Low-Power RTL Design Became Important

The semiconductor industry benefited from two important scaling trends during the late 20th century (1970s to early 2000s):

1. **Moore's Law** – Every 18–24 months, transistor count doubles.
2. **Dennard Scaling** – Power density remains constant even as the number of transistors increases.

Hence, during this era, we saw a steep increase in clock frequencies without much impact from overheating.

However, around the **90nm to 65nm technology nodes**, ideal Dennard scaling stopped working because the supply voltage stopped scaling proportionally. This meant the voltage could no longer keep decreasing.

Around the mid-2000s, processors hit something called the **Power Wall**. Simply increasing clock frequency was no longer practical, which is why CPUs did not continue climbing from **3 GHz to 10 GHz**.

The industry instead shifted towards multi-core processors and low-power (power-aware) design techniques.

## Why Low-Power RTL Design is Important

Before this shift, RTL design was mostly focused on:

1. Functionality
2. Timing
3. Area

Power was primarily addressed during physical design and other downstream processes. However, after the end of Dennard scaling, power became an important design constraint at the RTL stage.

Three significant areas that can be influenced through RTL are:

1. **Switching Activity:** Avoiding unnecessary signal transitions.
2. **Effective Capacitance:** Reducing unnecessary registers, buses, and logic that toggle.
3. **Clock Network:** One of the largest consumers of dynamic power.

RTL has a significant influence on these, and controlling them can reduce unnecessary power consumption.

This led to RTL coding techniques that reduce unnecessary signal and state transitions, along with techniques such as **clock gating** and **power gating**.

## Common Interview Questions

<details>
<summary>Latch vs FF for clock gating. Which is preferred and why?</summary>
Latch is preferred over a flip flop for building the enable logic inside an ICG cell

#### Why?
- Because, a latch is level sensitive and not edge sensitive, wherease, Flip-Flops are edge sensitive. A negatigve level sensitive latch captures the enable signal during the clock's inactive (low) phase and lock it during the active (high) phase preventing clock glitches.
- This means the enable signal is only allowed to change while the clock is low. 
- Once the clock goes high, the latch closes and holds the enable value steady for the entire high phase of the clock. 
- Whereas, an FF only changes on the the active edge of the clock. So enable signal will only be sampled once per clock cycle. 
- More importantly, an FF's output can still glitch or its setup and hold timing can align badly with the clock edge that is also feeding the AND gate, since both are driven by the same clock. 
</details>

<details>
<summary>How would you implement power-saving in your design?</summary>

Some of the power saving techniques include:
- Power Gating
- Clock Gating
- Low Power Memory Modes
- Improved RTL code that avoids unnecessary toggling in general.
</details>

<details>
<summary>How do you handle signals going from an ON to OFF domain and vice versa? How do you manage isolation, does it matter?</summary>

- When a block is powered off, its output pins no longer have a driven, known value. They can float or settle to an unpredictable voltage somewhere between 0 and the supply level.
- A floating input into an always-ON block can corrupt logic (X propagation).
- To fix this, Isolation cells are used. Isolation cells clamp the OFF domain's outputs to a safe fixed value (0 or 1) while it's powered down. 
</details>

<details>
<summary>Static and dynamic power, what are some ways to reduce both?</summary>

**1. Dynamic Power:** It is consumed when switching happens. 
- $P_d = \alpha \times C \times V_{dd}^2 \times f$
- $\alpha$ (Alpha): Switching activity factor (average number of transitions per clock cycle).
- $C$: Load capacitance of output gates and interconnect wires.
- $V_{dd}$: Supply voltage.
- $f$: Clock frequency.

**Ways to reduce Dynamic Power:**
- **Clock Gating:** Disables the clock to registers when they are idle, reducing both $\alpha$ (switching activity of registers) and clock tree toggling.
- **Voltage Scaling:** Since dynamic power scales quadratically with voltage ($V_{dd}^2$), reducing voltage or using multiple voltage domains yields the highest savings.
- **Frequency Scaling:** Lowering $f$ linearly reduces dynamic power when peak performance is not required.
- **RTL Optimization (Reducing $\alpha$):**
  - Avoid glitches/hazards by balancing path delays.
  - Use Gray coding for state machines or counters to ensure only one bit changes per transition.
  - Operand Isolation: Freeze inputs to execution units (e.g., multipliers) when their outputs are not being used.
- **Physical Layout & Sizing (Reducing $C$):** Gate sizing (using smaller transistors where performance allows) and wire routing optimization.

**2. Static Power:** It is consumed even when the circuit is idle (leakage current). 
- $P_{stat} = I_{leak} \times V$

**Ways to reduce Static Power:**
- **Power Gating:** Disconnects the power supply (using sleep transistors) from blocks that are idle, reducing $I_{leak}$ to near zero.
</details>