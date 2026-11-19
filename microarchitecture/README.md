# RTL & Microarchitecture Interview Questions

The questions below are the type commonly discussed in interviews in ASIC/SoC design teams.

---

# Question Index

| # | Question |
|---|----------|
| 1 | [Find Top-K Elements in a Stream](#1-find-top-k-elements-in-a-stream) |
| 2 | [Running Median](#2-running-median) |
| 3 | [Frequency Counter](#3-frequency-counter) |
| 4 | [Detect Duplicate Numbers](#4-detect-duplicate-numbers) |
| 5 | [Moving Average](#5-moving-average) |
| 6 | [Peak Detector](#6-peak-detector) |
| 7 | [First Non-Repeating Number](#7-first-non-repeating-number) |
| 8 | [Count Number of Ones (Popcount)](#8-count-number-of-ones-popcount) |
| 9 | [Maximum Consecutive Ones](#9-maximum-consecutive-ones) |
| 10 | [Design a Rate Limiter](#10-design-a-rate-limiter) |
| 11 | [Design a Debouncer](#11-design-a-debouncer) |
| 12 | [Find Missing Number](#12-find-missing-number) |
| 13 | [Traffic Light Controller](#13-traffic-light-controller) |
| 14 | [Elevator Controller](#14-elevator-controller) |
| 15 | [Priority Encoder](#15-priority-encoder) |
| 16 | [Largest Number in 1024 Values](#16-largest-number-in-1024-values) |
| 17 | [Design a Scoreboard](#17-design-a-scoreboard) |
| 18 | [Packet Reordering Buffer](#18-packet-reordering-buffer) |
| 19 | [Design a Free List](#19-design-a-free-list) |
| 20 | [Tournament Tree: Largest and Second Largest](#20-tournament-tree-largest-and-second-largest) |
| 21 | [Output Every 3rd Valid Transaction](#21-output-every-3rd-valid-transaction) |

---

# 1. Find Top-K Elements in a Stream

### Question
Given a stream of 32-bit inputs arriving one value per cycle, find the top K largest values.

### Follow-ups
- Top-3, Top-5, Top-10
- Number of FFs?
- Comparator count?
- Handling duplicates?
- Throughput and latency?

---

# 2. Running Median

### Question
Given a stream of values, continuously output the median after every input.

### Follow-ups
- Storage requirements
- Heap-based implementation
- Streaming architecture
- Area vs latency tradeoffs

---

# 3. Frequency Counter

### Question
Find the most frequently occurring value in a stream.

### Example
1, 2, 3, 2, 1, 2

Output: 2

### Follow-ups
- What if there are millions of unique values?
- RAM requirements?
- Hash table implementation?

---

# 4. Detect Duplicate Numbers

### Question
Detect the first duplicate value seen in a stream.

### Example
1, 5, 8, 2, 5

### Follow-ups
- How much memory is required?
- Bitmap solution?
- Bloom filter solution?

---

# 5. Moving Average

### Question
Design an 8-sample moving average calculator.

### Follow-ups
- Number of registers?
- Efficient update equation
- Sliding window implementation
- Throughput requirements

---

# 6. Peak Detector

### Question
Find local maxima in an incoming stream.

### Example
1, 5, 10, 8, 3

Output: 10

### Follow-ups
- Number of samples stored?
- Detection latency?

---

# 7. First Non-Repeating Number

### Question
Find the first value that appears exactly once.

### Example
2, 3, 2, 5, 3, 7

Output: 5

### Follow-ups
- Counting memory
- Streaming implementation

---

# 8. Count Number of Ones (Popcount)

### Question
Count the number of set bits in a 256-bit input every cycle.

### Follow-ups
- One-cycle implementation
- Adder tree architecture
- Pipeline stages
- Timing closure

---

# 9. Maximum Consecutive Ones

### Question
Given a bitstream, find the maximum run length of consecutive ones.

### Example
111011111011

Output: 5

### Follow-ups
- Streaming implementation
- Register requirements

---

# 10. Design a Rate Limiter

### Question
Allow only a fixed number of transactions within a fixed cycle window.

### Example
100 transactions per 1000 cycles.

### Follow-ups
- Counter width
- Burst handling
- Token bucket architecture

---

# 11. Design a Debouncer

### Question
Design hardware to debounce a noisy push-button signal.

### Follow-ups
- Metastability
- CDC concerns
- Counter sizing

---

# 12. Find Missing Number

### Question
Numbers 1..N are received, but one number is missing.
Find the missing value.

### Follow-ups
- XOR solution
- Area cost
- Streaming implementation

---

# 13. Traffic Light Controller

### Question
Design an FSM for a traffic light controller.

### Follow-ups
- Emergency vehicle support
- Pedestrian request
- Programmable timing

---

# 14. Elevator Controller

### Question
Design a controller for a 10-floor elevator.

### Follow-ups
- Multiple requests
- Prioritization
- Starvation prevention

---

# 15. Priority Encoder

### Question
Implement a 128-bit priority encoder.

### Follow-ups
- Timing bottlenecks
- Tree implementation
- Pipelining

---

# 16. Largest Number in 1024 Values

### Question
Find the maximum value among 1024 values.

### Follow-ups
- Sequential implementation
- Comparator tree implementation
- Area vs latency tradeoff

---

# 17. Design a Scoreboard

### Question
Track dependencies among 32 architectural registers.

### Follow-ups
- RAW hazards
- WAR hazards
- WAW hazards
- Ready bit tracking

---

# 18. Packet Reordering Buffer

### Question
Packets arrive out of order and must be sent in order.

### Example
5, 3, 4, 1, 2

Output:
1, 2, 3, 4, 5

### Follow-ups
- Buffer sizing
- Data structures
- Throughput

---

# 19. Design a Free List

### Question
Manage a pool of 256 resources that can be allocated and freed dynamically.

### Follow-ups
- FIFO-based free list
- Bitmap-based free list
- Allocation latency

---

# 20. Tournament Tree: Largest and Second Largest

### Question
Find both the largest and second-largest values among 1024 numbers using the fewest comparisons.

### Follow-ups
- Tournament tree architecture
- Storing losers
- O(log N) reduction tree
- Area versus performance

---

# 21. Output Every 3rd Valid Transaction

### Question
Given a valid-ready interface, output only every third transaction.

### Example
- Packet 1 → Drop
- Packet 2 → Drop
- Packet 3 → Send
- Packet 4 → Drop
- Packet 5 → Drop
- Packet 6 → Send

### Follow-ups
- Does count advance on valid or valid && ready?
- Backpressure handling
- State machine design
- Throughput impact
- Reset behavior
