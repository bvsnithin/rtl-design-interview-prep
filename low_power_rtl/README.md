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
