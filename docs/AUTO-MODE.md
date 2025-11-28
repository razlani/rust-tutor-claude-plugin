# Auto-Mode: Learn While Building

Auto-mode transforms the Rust tutor from a standalone learning tool into a **continuous learning companion during real development work**.

## Overview

### Manual Mode (Command-Based)
- Run `/slice` to get practice exercises
- Implement synthetic challenges
- Run `/gate` to validate
- Repeat

**Good for**: Dedicated practice sessions, learning new concepts in isolation

### Auto Mode (Continuous Learning)
- Enable with `/auto-on`
- Claude pauses before writing Rust functions
- Challenges you to implement **the actual code needed** for your current task
- Reviews your code, makes corrections if needed
- Continues with validated code
- Logs everything to your learning journal

**Good for**: Learning while building real projects, applying concepts in context

## How It Works

### The Automatic Learning Flow

```
You: "Build me a CSV processing CLI"

Claude: [starts building... after 8 tool calls...]

Claude: AUTO-CHALLENGE [Level 2]

        I need to implement: `parse_row(line: &str) -> Result<Record, ParseError>`

        Context: Parsing CSV rows for the CLI tool

        Implement the function at `src/parser.rs:42`
        Run `cargo test` locally to verify
        Type "done" when tests pass (or "skip")

You: [implements the function, runs cargo test in editor]

You: done

Claude: [reads your code]

        PASS: Review - Approved with improvements

        Your implementation works, but I made 2 improvements:

        1. Replaced manual string splitting with iterator chain
           - Before: `let parts: Vec<&str> = line.split(',').collect();`
           - After: `line.split(',').map(...)`
           - Why: Avoids allocation, more idiomatic

        2. Changed .unwrap() to proper error handling
           - Before: `parts[0].parse().unwrap()`
           - After: `parts[0].parse().map_err(ParseError::InvalidNumber)?`
           - Why: Level 2 requires no unwrap in library code

        See updated code at src/parser.rs:42-56

        Streak: 2/3 -> 3/3 -> LEVEL UP to 3!

        Logged to .claude/tutor/logs/level-2.md

        Continuing with the CSV CLI tool...

[Claude continues building with your corrected code]
```

## Key Features

### 1. Context-Aware Challenges

Unlike manual mode's synthetic exercises, auto-mode presents **real code you actually need**:

- Building a CLI? Implement the actual argument parser
- Processing audio? Implement the actual DSP function
- Handling config? Implement the actual file loader

**You're not practicing in isolation—you're building and learning simultaneously.**

### 2. Complexity Checking

Claude analyzes each function before presenting it:

```
Function needs: async/await (Level 5) + trait objects (Level 5)
Your level: 2
→ Claude writes it for you: "I wrote this (Level 5). You'll learn it after leveling up!"
```

**You only get challenges that match your skill level.** Advanced code doesn't block you.

### 3. Code Review by Inspection

Tests passing ≠ good code. Claude reviews your implementation for:

**Level 1**: Correctness, basic idioms
**Level 2**: No unwrap/expect, proper Result usage
**Level 3**: In-place operations, iterator chains, zero allocations
**Level 4**: Generics, abstractions, edge cases
**Level 5**: User-friendly errors, CLI UX, production quality

**Claude fixes issues and explains why**, so you learn from corrections.

### 4. Learning Journals

Every challenge is logged to `.claude/tutor/logs/level-N.md`:

```markdown
## 2025-11-22 14:30 - Auto-Challenge #5

### Challenge
Function: `parse_row(line: &str) -> Result<Record, ParseError>`
Required for: CSV CLI tool row parsing
Location: src/parser.rs:42

### Review Result
PASS: Approved with corrections

Improvements made:
1. Replaced manual split+collect with iterator chain (avoid allocation)
2. Changed .unwrap() to proper error propagation (Level 2 requirement)

### Outcome
Status: Approved with corrections | Streak: 2/3 -> 3/3 -> LEVEL UP to 3!
```

**Review your journey**: See all challenges, corrections, and learning points by level.

## Getting Started

### 1. Install the Plugin

```bash
# In your Rust project
claude /plugin install rust-tutor
```

### 2. Enable Auto-Mode

```bash
/auto-on
```

### 3. Start Building

Ask Claude to build something:

```
"Build me a CLI tool that processes audio files"
"Create a web server with authentication"
"Implement a parser for custom config format"
```

Claude will pause every ~8 tool calls with challenges.

### 4. Implement & Verify

When challenged:
1. Write the function in your editor
2. Run `cargo test` locally to verify
3. Type `done` when ready

Claude reviews, corrects if needed, and continues.

### 5. Track Progress

```bash
/level        # Overall progress
/auto-status  # Auto-mode specific stats
```

## Commands

| Command | Description |
|---------|-------------|
| `/auto-on` | Enable auto-mode |
| `/auto-off` | Disable auto-mode |
| `/auto-status` | View stats (completions, corrections, etc.) |
| `/level` | View overall progress (includes auto stats) |
| `done` | Submit your implementation for review (during challenge) |
| `skip` | Skip current challenge (Claude writes it, no penalty) |

## Configuration

Auto-mode settings are stored in `.claude/tutor/state.json`:

```json
{
  "auto_mode": {
    "enabled": false,
    "trigger_frequency": 8
  }
}
```

To adjust trigger frequency, edit `state.json` and change `trigger_frequency` (default: 8).

## Progression System

Auto-mode shares the same 5-level progression as manual mode:

| Level | Name | Concepts |
|-------|------|----------|
| 1 | Foundations | Basics, iterators, borrowing |
| 2 | Errors & Traits | Result, thiserror, From/Into |
| 3 | DSP Basics | In-place ops, buffers, zero-alloc |
| 4 | Pitch & Properties | Generics, algorithms, proptest |
| 5 | CLI & DX | async, clap, tracing, anyhow |

**Advancement**: 3 successful challenges (manual or auto) → level up

**Shared streak**: Manual `/slice` completions and auto-challenges both count toward the same streak.

**Mix modes**: Use `/slice` for practice, `/auto-on` during development. Progress combines.

## Learning Journal

Auto-mode maintains a detailed learning journal organized by level:

```
.claude/tutor/logs/
├── level-1.md    # All Level 1 challenges
├── level-2.md    # All Level 2 challenges
├── level-3.md    # All Level 3 challenges
├── level-4.md    # All Level 4 challenges
└── level-5.md    # All Level 5 challenges
```

Each entry shows:
- The challenge and context
- Your implementation approach
- Corrections made (with before/after)
- Learning points
- Progression updates (streak, level-ups)

**Review anytime** to reinforce concepts and see your growth.

## When to Use Auto-Mode

### Perfect For:
- Building real Rust projects
- Learning by doing
- Applying concepts in context
- Seeing how patterns fit together
- Getting immediate code review

### Not Ideal For:
- Quick prototyping (disable with `/auto-off`)
- Exploring unfamiliar domains (might get too many advanced challenges)
- Pair programming sessions (might interrupt flow)

**Toggle it on/off as needed!** Use `/auto-on` when learning, `/auto-off` when focused on delivery.

## Tips for Success

### 1. Run Tests Locally First

Before typing `done`, verify your implementation:
- Run `cargo test` in your editor
- Check for compilation errors
- Review your code for obvious issues

Claude will still review, but you'll learn more by self-checking first.

### 2. Don't Skip Too Much

Skipping occasionally is fine (you're blocked, time pressure, etc.), but:
- **Skips don't hurt your streak** (no penalty)
- **But they don't help you learn** (no review, no corrections)

Use skip when necessary, but try to implement most challenges.

### 3. Review Your Logs

Periodically review `.claude/tutor/logs/level-N.md`:
- See patterns in corrections (am I always forgetting to avoid allocations?)
- Reinforce learning points
- Track growth over time

### 4. Ask Questions

If Claude's correction doesn't make sense:
- Ask "Why did you change X to Y?"
- Request deeper explanation
- Claude can teach concepts without giving solutions

### 5. Mix Manual and Auto

Use both modes strategically:
- **Manual `/slice`**: Practice specific concepts, warm up, targeted drills
- **Auto mode**: Apply in real projects, holistic learning, integration

They share progression, so use whichever fits your current need.

## Troubleshooting

### "Too many challenges, can't get work done"

Increase trigger frequency:
```json
{
  "trigger_frequency": 20  // Challenge less often
}
```

Or temporarily disable: `/auto-off`

### "Challenges are too easy/hard"

Difficulty matches your level. If too easy, you're about to level up! If too hard:
- Use `skip` for now
- Practice with `/slice` to strengthen fundamentals
- Level up, then retry similar challenges

### "I want to review a past challenge"

Check your learning journal:
```bash
cat .claude/tutor/logs/level-2.md
```

All challenges, corrections, and learning points are logged.

### "Auto-mode not triggering"

Check status:
```bash
/auto-status
```

Verify:
- `enabled: true`
- You're writing new Rust functions (not editing existing)
- Tool call counter is incrementing

## Comparison: Manual vs Auto Mode

| Feature | Manual Mode | Auto Mode |
|---------|-------------|-----------|
| **Challenges** | Synthetic practice | Real code for current task |
| **Trigger** | User runs `/slice` | Automatic (every N tool calls) |
| **Context** | Isolated exercises | Part of larger project |
| **Learning style** | Deliberate practice | Learning by building |
| **Workflow** | Dedicated sessions | Integrated into development |
| **Progression** | `/slice` → implement → `/gate` | Automatic (pause, implement, review, continue) |
| **Code review** | Quality gates only | Inspection + corrections + explanation |
| **Journal** | No logs | Detailed logs per level |
| **Use case** | Focused skill building | Practical application |

**Both are valuable!** Use manual for fundamentals, auto for application.

## Advanced: Complexity Map

Claude uses `.claude/tutor/complexity-map.yaml` to determine if a function matches your level:

```yaml
patterns:
  simple_function: 1
  result_type: 2
  in_place_operations: 3
  generics_advanced: 4
  async_await: 5
```

If you want to customize (e.g., introduce async earlier), edit this file.

## Privacy & Logs

Learning journals are stored locally in `.claude/tutor/logs/`.

**Recommendation**: Add to `.gitignore`:
```gitignore
.claude/tutor/logs/*.md
tests/challenge_test.rs
```

Your learning journey stays private unless you choose to share.

## Examples

See [examples/auto-mode-walkthrough.md](../examples/auto-mode-walkthrough.md) for a complete example session showing auto-mode in action.

## Summary

Auto-mode is **learning by building**:
- Real challenges from actual development work
- Automatic code review with corrections
- Complexity-aware (only challenges at your level)
- Detailed learning journals
- Same progression as manual mode

Enable it, start building, and level up while creating real Rust projects.

```bash
/auto-on
# Let's build something!
```
