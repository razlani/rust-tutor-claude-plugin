# Claude Rust Tutor Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-5A67D8)](https://code.claude.com)
[![Rust](https://img.shields.io/badge/Rust-Learning-orange)](https://www.rust-lang.org)

**Interactive Rust learning through progressive difficulty, quality gates, and test-driven development**

Learn Rust by doing, not by watching. This Claude Code plugin provides a structured, disciplined learning path where you write the code and Claude guides you through progressively harder challenges.

---

## TL;DR - Quick Install

```bash
# In Claude Code, add the marketplace and install the plugin:
/plugin marketplace add razlani/rust-tutor-claude-plugin
/plugin install rust-tutor@rust-tutor-claude-plugin

# Start learning:
/slice        # Get your first challenge
# ... implement the function ...
/gate         # Validate your work
```

**That's it!** The plugin automatically initializes on first use.

## Features

- **5 Progressive Levels**: From basics to CLI development
- **Strict Quality Gates**: fmt, clippy, tests, and policy enforcement
- **Failing-Test-First**: You implement functions to pass comprehensive tests
- **Streak System**: Build momentum, level up after 3 consecutive successes
- **Focused Slices**: Small tasks (≤10 min) with clear acceptance criteria
- **Cross-Platform**: Works on Windows, macOS, and Linux
- **Progress Tracking**: See your level, streak, and history
- **Auto-Mode**: Learn while building real projects with continuous challenges

---

## Quick Start

### Prerequisites

- [Rust](https://rustup.rs/) installed (`cargo`, `rustc`, `clippy`, `rustfmt`)
- [Claude Code](https://claude.com/code) installed

### Installation

**Project-Level Installation (Recommended for Teams)**

Add to your project's `.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "rust-tutor-claude-plugin": {
      "source": {
        "source": "github",
        "repo": "razlani/rust-tutor-claude-plugin"
      }
    }
  },
  "enabledPlugins": {
    "rust-tutor@rust-tutor-claude-plugin": true
  }
}
```

When you commit this to your repository, team members will automatically get the plugin when they trust the folder.

**User-Level Installation (Personal Use)**

```bash
# In Claude Code:
/plugin marketplace add razlani/rust-tutor-claude-plugin
/plugin install rust-tutor@rust-tutor-claude-plugin
```

This installs the plugin globally for you across all projects.

### First Learning Slice

Start Claude Code in your Rust project:

```bash
claude
```

Then run your first task:

```
/slice        # Get a practice exercise with failing test
              # ... implement the function ...
/gate         # Validate with quality checks
/level        # View your progress
```

The first time you run any tutor command, it automatically initializes the learning structure in `.claude/tutor/` with state and config files.

---

## How It Works

### The Learning Cycle

```
1. /slice  - Claude proposes a task + failing test
2. You implement the function
3. /gate   - Claude runs quality checks
4. Pass?   - Streak++, maybe level up!
   Fail?   - Streak resets, try again
5. Repeat!
```

### Quality Gates

Every slice must pass 4 gates:

| Gate | Command | Purpose |
|------|---------|---------|
| **Formatting** | `cargo fmt --check` | Consistent code style |
| **Lints** | `cargo clippy -D warnings` | Catch common mistakes, learn idioms |
| **Tests** | `cargo test --no-fail-fast` | Verify correctness |
| **Policy** | No `unwrap()`/`expect()` in libs | Proper error handling |

All gates must pass to advance. Failures reset your streak but don't drop your level.

### Learning Levels

| Level | Name | LOC Limit | Topics | Constraints |
|-------|------|-----------|--------|-------------|
| **1** | Foundations | 50 | Basics, iterators, borrowing | Tests first |
| **2** | Errors & Traits | 90 | Result, thiserror, From/Into | + No unwrap in libs |
| **3** | DSP Basics | 120 | Gain, mix, windows | + Prefer in-place |
| **4** | Pitch & Properties | 150 | ACF, peak detection, proptest | + Property tests |
| **5** | CLI & DX | 160 | clap, tracing, anyhow | + Help text required |

**Progression**: Complete 3 slices in a row (streak of 3) to level up.

---

## Session Demo

Here's what a real learning session looks like:

```text
> /slice

Level 1 (Foundations) - Slice 1

Goal: Implement root-mean-square (RMS) calculation

Topic: iterators, f32/f64 precision

File: crates/core/src/lib.rs

Test (add to crates/core/tests/lib.rs):
#[test]
fn test_rms() {
    assert_eq!(rms(&[]), 0.0);
    assert_eq!(rms(&[2.0]), 2.0);
    assert!((rms(&[1.0, 2.0, 3.0]) - 2.160).abs() < 0.01);
}

Stub (add to crates/core/src/lib.rs):
pub fn rms(samples: &[f32]) -> f32 {
    0.0  // TODO: implement
}

Acceptance Criteria:
- All tests pass
- No allocations (use iterator methods)
- Use f64 for intermediate calculations to avoid precision loss

Resources:
- https://doc.rust-lang.org/std/iter/trait.Iterator.html#method.map

Now implement the function. When done, run /gate to verify your work.

# ... developer implements the function ...

> /gate

SUCCESS: Quality Gates: ALL PASS

PASS: Formatting: Passed (cargo fmt)
PASS: Lints: Passed (cargo clippy)
PASS: Tests: Passed (3 tests)
PASS: Policy: Passed (no unwrap/expect in libs)

Progress: Progress Updated:
- Level: 1 (Foundations)
- Completed: 1 slice
- Streak: 1 consecutive passes

Great work! Ready for the next slice? Run /slice to continue.

> /level

Progress: Learning Progress

Current Level: 1 - Foundations
Description: Learn Rust fundamentals
Topics: rust_basics, iterators, borrowing, slices
Completed: 1 slice at this level
Streak: 1 consecutive passes
Next Level: 2 - Errors & Traits (unlock after 2 more passes)

Constraints for This Level:
- Maximum LOC per slice: 50
- Tests first: Yes

Recent History (last 5 slices):
- 2025-11-28 14:30: PASS

Progress to Next Level:
[▓░░] 1/3

Total Slices Completed at This Level: 1
```

---

## Learning Modes

The tutor supports two complementary learning modes:

### Manual Mode (Command-Based)

The default approach for deliberate practice:

```bash
/slice      # Get a practice exercise
# ... implement the function ...
/gate       # Validate with quality checks
# Repeat
```

**Best for**: Focused skill building, learning new concepts in isolation, dedicated practice sessions.

### Auto Mode (Continuous Learning)

Learn while building real projects:

```bash
/auto-on    # Enable auto-mode

# Then ask Claude to build something:
# "Build me a CLI tool that processes CSV files"

# Claude will pause before writing Rust functions and challenge you
# to implement the ACTUAL CODE needed for your project
```

**How it works**:
1. Plugin hooks inject auto-mode awareness into every user message
2. Claude sees your current level and auto-mode status automatically
3. Before writing Rust functions, Claude checks if they match your skill level
4. If complexity matches your level → pauses and challenges you
5. You implement the actual code needed
6. Claude reviews your code, makes corrections, explains why
7. Continues building with your validated code
8. Everything logged to `.claude/tutor/logs/level-N.md`

**Technical note**: Auto-mode uses a `UserPromptSubmit` hook that runs before Claude processes each message. This hook reads your tutor state and injects a reminder about your learning level, making Claude naturally aware of learning opportunities without requiring manual checks.

**Best for**: Learning by doing, applying concepts in context, seeing how patterns fit together, getting code review on real implementations.

**Key differences**:

| Feature | Manual Mode | Auto Mode |
|---------|-------------|-----------|
| Challenges | Synthetic practice exercises | Real code for current task |
| Trigger | You run `/slice` | Automatic (every ~8 tool calls) |
| Context | Isolated learning | Part of larger project |
| Review | Quality gates only | Code inspection + corrections |
| Logging | No detailed logs | Full learning journal |

**Both modes share the same progression system** - you can mix them! Practice with `/slice`, then apply with `/auto-on` during development.

**Commands**:
- `/auto-on` - Enable auto-mode
- `/auto-off` - Disable auto-mode
- `/auto-status` - View auto-mode stats

See [docs/AUTO-MODE.md](docs/AUTO-MODE.md) for complete documentation and [examples/auto-mode-walkthrough.md](examples/auto-mode-walkthrough.md) for a full example session.

---

## Commands

### `/slice` - Plan Next Task

Proposes a learning task based on your current level.

**Output**:
- Goal and topic
- Failing test code
- Function stub
- Acceptance criteria
- Resources (links to docs)

**Example**:
```bash
> /slice

Level 1 (Foundations) - Slice 1

Goal: Implement root-mean-square (RMS) function
Topic: rust_basics, iterators
File: crates/core/src/lib.rs

Test:
[comprehensive test code]

Stub:
pub fn rms(samples: &[f32]) -> f32 { 0.0 }

Acceptance:
- All tests pass
- No allocations
- Use f64 for intermediate calculations

Now implement the function. When done, run /gate.
```

### `/gate` - Run Quality Checks

Runs all 4 quality gates and updates your progress.

**On success**:
- Increments completed count and streak
- Levels you up after 3 consecutive passes
- Appends result to history

**On failure**:
- Resets streak to 0
- Shows exact errors with file:line pointers
- Keeps your level (you can retry)

**Example**:
```bash
> /gate

PASS: Quality Gates

PASS: Formatting
PASS: Lints
PASS: Tests (3/3)
PASS: Policy

Progress Updated:
- Level: 1 (Foundations)
- Completed: 1 slice
- Streak: 1 (need 2 more for level up)

Great work! Run /slice to continue.
```

### `/level` - View Progress

Shows your current level, streak, and recent history.

**Example**:
```bash
> /level

Learning Progress

Current Level: 1 - Foundations
Topics: rust_basics, iterators, borrowing, slices
Completed: 1 slice at this level
Streak: 1 consecutive passes
Next Level: 2 - Errors & Traits (unlock after 2 more passes)

Recent History:
- 2025-11-22 10:30: PASS - Implemented rms()

Progress to Next Level:
[=>  ] 1/3
```

---

## How It Works (Technical)

The plugin uses a **hook system** to make Claude aware of your learning progress without you having to mention it:

### The Hook Mechanism

`hooks/auto-mode-reminder.sh` runs automatically on every user message via the `UserPromptSubmit` hook. It:
1. Reads `.claude/tutor/state.json` to get your current level, streak, and tool call count
2. Injects a context message into Claude's prompt when auto-mode is enabled
3. Makes Claude aware of learning opportunities without interrupting your workflow

**Example injected context**:
```
Rust Tutor Auto-Mode Active

Current Status:
- Level: 2 | Streak: 1/3
- Tool calls since last challenge: 6/8

Before writing Rust functions:
1. Analyze the complexity and learning value
2. If it matches the user's Level 2 skill, pause and challenge them to implement it
3. If it's too advanced or trivial, write it yourself
```

This is why Claude automatically knows when to challenge you - it sees your learning state in context.

### State Management

All state is stored in `.claude/tutor/state.json`:
- No databases or external services
- Human-readable JSON you can edit manually
- Commands (slash commands in `commands/`) read/write this file using Claude's Read/Write tools

### No External Dependencies

Everything runs using Claude Code's built-in capabilities:
- Slash commands are markdown files Claude reads
- Hooks are shell scripts Claude executes
- State is JSON Claude reads/writes
- No Python, Node.js, or other runtimes required

**Want to extend it?** Fork the repo, modify the commands or add new ones, adjust `levels.yaml` to create your own learning path.

---

## Configuration

All tutor settings are stored in `.claude/tutor/` and can be customized:

### `.claude/tutor/state.json` - Learning Progress

Tracks your progress and can be edited to adjust settings:
```json
{
  "level": 1,
  "completed": 0,
  "streak": 0,
  "auto_mode": {
    "enabled": false,
    "trigger_frequency": 8
  }
}
```

**Customizable settings**:
- `level` - Current learning level (1-5)
- `completed` - Slices completed at this level
- `streak` - Consecutive successful slices
- `auto_mode.enabled` - Enable/disable auto-mode
- `auto_mode.trigger_frequency` - Tool calls between auto-challenges (default: 8)

**Safe to edit**: Manually adjust your level, reset progress, or change auto-mode settings anytime.

### `.claude/tutor/levels.yaml` - Learning Path

Customize the learning progression:
- `max_loc` - Maximum lines of code per level
- `topics` - Learning topics for each level
- `constraints` - Requirements (tests_first, no_unwrap_in_libs, etc.)
- `examples` - Task examples per level

**Add custom levels**: Create Level 6+ by extending the levels array.

### `.claude/tutor/complexity-map.yaml` - Auto-Mode Difficulty

Maps Rust patterns to minimum required level. Edit to customize when concepts are introduced.

### `.claude/tutor/logs/` - Learning Journal

When using auto-mode, Claude logs every challenge to level-specific files:
- `level-1.md` through `level-5.md` - Created automatically as you progress

**What's logged**: Each entry includes:
- Function name and why it was needed
- Your implementation (if corrections were made)
- Before/after comparisons with explanations
- Streak updates and level-up announcements

**Why logs matter**:
- **Reinforce learning** - Review to see patterns in your corrections
- **Track progress** - Compare early vs. recent challenges
- **Study guide** - Refresh concepts before leveling up
- **Portfolio** - Real implementations from actual projects

**Privacy note**: Logs may contain project code. Add to `.gitignore` if needed:
```gitignore
.claude/tutor/logs/*.md
```

### Example Customizations

**Adjust auto-mode trigger frequency**:
```json
{
  "auto_mode": {
    "trigger_frequency": 15
  }
}
```

**Lower difficulty for Level 1**:
```yaml
levels:
  1:
    max_loc: 30  # Reduce from 50
```

**Reset progress**:
Delete `.claude/tutor/state.json` and run `/slice` to reinitialize.

---

## Methodology

### Failing-Test-First

Unlike traditional tutorials where you watch code being written, this plugin forces you to write the code yourself:

1. Claude writes a **failing test** (the specification)
2. Claude provides a **stub** (function signature + placeholder)
3. **You implement** the function to make tests pass
4. Claude **enforces quality** via gates

This builds **muscle memory** and **problem-solving skills**, not just copy-paste ability.

### Why Strict Gates?

- **Format**: Learn clean code from day one
- **Clippy**: Internalize Rust idioms (borrow checker, lifetimes, etc.)
- **Tests**: Ensure correctness, enable confident refactoring
- **Policy**: Force thoughtful error handling (core Rust skill)

Strictness teaches discipline. You can always soften later, but starting strict builds better habits.

### Progressive Difficulty

- **Level 1**: Small functions (50 LOC), basic syntax
- **Level 2**: Add error handling, no panics allowed
- **Level 3**: Real signal processing, performance considerations
- **Level 4**: Non-trivial algorithms, property-based testing
- **Level 5**: User-facing CLIs, logging, error ergonomics

Each level builds on the previous, gradually increasing complexity and introducing new concepts.

---

## FAQ

### Can Claude give me hints if I'm stuck?

Yes! Ask Claude questions about concepts without asking for the full solution. For example:
- "How do I use .iter().max_by()?"
- "What's the difference between &T and &mut T here?"
- "Why does the borrow checker complain about this?"

Claude will explain concepts and point you in the right direction without implementing the code for you.

### What if I want to skip a slice?

Just run `/slice` again to get a new task. The old task won't be tracked (no penalty for skipping).

### Can I customize the learning path?

Yes! Edit `.claude/tutor/levels.yaml` to change topics, constraints, or add your own levels.

### What if state.json gets corrupted?

Delete `.claude/tutor/state.json` and reinstall the plugin, or manually reset it to:
```json
{"level": 1, "completed": 0, "streak": 0, "last_task": null, "history": []}
```

### Does this work with existing Rust projects?

Yes! Install the plugin in any Rust project (workspace or single crate). It detects your project structure automatically.

### What happens after Level 5?

You stay at Level 5 and can continue practicing. You can also:
- Edit `levels.yaml` to add custom levels
- Create your own DSP/CLI projects
- Contribute to open source Rust projects

---


---

## License

MIT License - see LICENSE file for details.
