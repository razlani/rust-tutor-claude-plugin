# Claude Rust Tutor Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Plugin-5A67D8)](https://code.claude.com)
[![Rust](https://img.shields.io/badge/Rust-Learning-orange)](https://www.rust-lang.org)

**Learn Rust while building real projects - Claude challenges you to implement the actual code you need, then reviews and improves it**

This plugin turns every Rust project into a structured learning experience. Build what you want, and Claude will pause to challenge you with the actual functions your project needs - at your skill level. Get immediate code review, corrections, and explanations. Level up while creating real software.

---

## TL;DR - Quick Install & Auto-Mode

**Step 1: Add to your project's `.claude/settings.json`:**
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

**Step 2: Install the plugin via Claude Code UI:**

1. Run `/plugin` in Claude Code
2. Select **"Browse and install plugins"**
3. Select **"rust-tutor [learning]"** and press Space to enable
4. Press Enter to install

**Step 3: Enable auto-mode and start building:**

```bash
/rust-tutor:auto-on      # Enable continuous learning

# Then build anything:
# "Create a CLI tool that processes CSV files"
# "Build an audio file analyzer"

# Claude will pause and challenge you to implement functions
# at your skill level, review your code, and teach you
```

**That's it!** Learn while building real projects.

## Features

- **Auto-Mode Learning**: Claude pauses before writing Rust and challenges you to implement the actual code your project needs
- **Intelligent Code Review**: Get corrections and explanations, not just pass/fail - learn from every implementation
- **Context-Aware Challenges**: Implement real functions for your project, not synthetic exercises
- **Learning Journal**: Every challenge logged with before/after code, corrections, and explanations
- **Complexity Matching**: Only get challenges at your skill level - advanced code doesn't block you
- **5 Progressive Levels**: From basics (iterators, borrowing) to production CLI development
- **Strict Quality Gates**: fmt, clippy, tests, and policy enforcement on every challenge
- **Streak System**: Build momentum, level up after 3 consecutive successes
- **Manual Practice Mode**: Also available for focused drilling on specific concepts
- **Cross-Platform**: Works on Windows, macOS, and Linux

---

## Quick Start

### Prerequisites

- [Rust](https://rustup.rs/) installed (`cargo`, `rustc`, `clippy`, `rustfmt`)
- [Claude Code](https://claude.com/code) installed

### Installation

This plugin is designed for project-level use since it creates learning state in `.claude/tutor/` within your project.

**Step 1: Add marketplace configuration**

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

**Step 2: Install via Claude Code UI**

1. Run `/plugin` in Claude Code
2. Select **"Browse and install plugins"**
3. Select **"rust-tutor [learning]"** and press Space to enable
4. Press Enter to install

The marketplace is now available and the plugin is enabled for this project.

**Step 3: Using the commands**

All plugin commands are namespaced with `/rust-tutor:` prefix:

```bash
/rust-tutor:slice        # Plan next learning task
/rust-tutor:gate         # Run quality gates
/rust-tutor:level        # View progress
/rust-tutor:auto-on      # Enable auto-mode
/rust-tutor:auto-off     # Disable auto-mode
/rust-tutor:auto-status  # View auto-mode stats
```

**Tip:** You can tab-complete the commands - just type `/rust-tutor:` and press Tab.

**Why project-level?** The plugin tracks your learning progress in `.claude/tutor/state.json` within each project. When you commit `.claude/settings.json` to your repository, team members will automatically get the plugin when they trust the folder.

### Recommended: Start with Auto-Mode

Start Claude Code in your Rust project:

```bash
claude
```

Enable auto-mode and start building:

```bash
/rust-tutor:auto-on      # Enable continuous learning
```

Then ask Claude to build something real:

```
"Build me a CLI tool that processes CSV files"
"Create an audio file analyzer"
"Implement a configuration file parser"
```

Claude will:
1. Plan the project architecture
2. Pause before writing Rust functions
3. Challenge you to implement them (at your skill level)
4. Review your code with corrections and explanations
5. Continue building with your validated code
6. Log everything to `.claude/tutor/logs/level-N.md`

**Alternative: Manual Practice Mode**

For focused drilling on specific concepts:

```bash
/rust-tutor:slice        # Get a practice exercise with failing test
                         # ... implement the function ...
/rust-tutor:gate         # Validate with quality checks
/rust-tutor:level        # View your progress
```

The first time you run any tutor command, it automatically initializes the learning structure in `.claude/tutor/` with state and config files.

---

## How It Works

### Auto-Mode: Learn While Building

```
You: "Build me a CLI that processes CSV files"

Claude: [planning architecture...]

AUTO-CHALLENGE [Level 2]

I need: parse_row(line: &str) -> Result<Record, ParseError>
Context: Parsing CSV rows for your CLI tool
Location: src/parser.rs:42

You: [implements function, runs cargo test]
You: done

Claude: PASS - Approved with 2 improvements:

1. Replaced .unwrap() with proper error handling
   - Before: parts[0].parse().unwrap()
   - After: parts[0].parse().map_err(ParseError::InvalidNumber)?
   - Why: Level 2 requires no unwrap in library code

2. Changed manual split+collect to iterator chain
   - Before: let parts: Vec<&str> = line.split(',').collect();
   - After: line.split(',').map(...)
   - Why: Avoids allocation, more idiomatic

Streak: 2/3 -> 3/3 -> LEVEL UP to 3!
Logged to .claude/tutor/logs/level-2.md

[Claude continues building your CSV CLI...]
```

**How it works:**
1. Plugin hooks inject auto-mode awareness into every message
2. Claude sees your level and auto-mode status automatically
3. Before writing Rust functions, Claude checks complexity vs. your skill level
4. If it matches → pauses and challenges you
5. If too advanced → writes it for you ("You'll learn this after leveling up!")
6. You implement the actual code needed for your project
7. Claude reviews, corrects if needed, explains why
8. Everything logged to your learning journal

### Manual Mode: The Learning Cycle

For focused practice sessions:

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

| Gate           | Command                          | Purpose                             |
|----------------|----------------------------------|-------------------------------------|
| **Formatting** | `cargo fmt --check`              | Consistent code style               |
| **Lints**      | `cargo clippy -D warnings`       | Catch common mistakes, learn idioms |
| **Tests**      | `cargo test --no-fail-fast`      | Verify correctness                  |
| **Policy**     | No `unwrap()`/`expect()` in libs | Proper error handling               |

All gates must pass to advance. Failures reset your streak but don't drop your level.

### Learning Levels

| Level | Name               | LOC Limit | Topics                        | Constraints          |
|-------|--------------------|-----------|-------------------------------|----------------------|
| **1** | Foundations        | 50        | Basics, iterators, borrowing  | Tests first          |
| **2** | Errors & Traits    | 90        | Result, thiserror, From/Into  | + No unwrap in libs  |
| **3** | DSP Basics         | 120       | Gain, mix, windows            | + Prefer in-place    |
| **4** | Pitch & Properties | 150       | ACF, peak detection, proptest | + Property tests     |
| **5** | CLI & DX           | 160       | clap, tracing, anyhow         | + Help text required |

**Progression**: Complete 3 slices in a row (streak of 3) to level up.

---

## Learning Modes

### Primary: Auto-Mode (Learn While Building)

**The recommended way to learn Rust with this plugin.**

Learn while building real projects - Claude challenges you with the actual functions your project needs:

```bash
/rust-tutor:auto-on    # Enable continuous learning

# Then ask Claude to build something:
"Build me a CLI tool that processes CSV files"
"Create an audio file analyzer"
```

**What happens:**
1. Plugin hooks inject auto-mode awareness into every user message
2. Claude sees your current level and auto-mode status automatically
3. Claude starts planning and building your project
4. Before writing Rust functions, Claude checks complexity vs. your skill level
5. If it matches your level → **Claude pauses and challenges you**
6. You implement the actual code needed for your project
7. Claude reviews your code with corrections and explanations
8. Claude continues building with your validated code
9. Everything logged to `.claude/tutor/logs/level-N.md`

**Why auto-mode is powerful:**
- **Real context**: You're not solving toy problems - you're building actual software
- **Code review**: Get corrections and explanations, not just pass/fail
- **Learning journal**: Review all challenges, corrections, and patterns later
- **Complexity-aware**: Advanced functions don't block you - Claude writes them and explains "You'll learn this at Level 5"
- **Progressive**: Same 5-level system, same quality gates, but applied to real work

**Commands**:
- `/rust-tutor:auto-on` - Enable auto-mode
- `/rust-tutor:auto-off` - Disable auto-mode
- `/rust-tutor:auto-status` - View auto-mode stats and learning journal location

See [docs/AUTO-MODE.md](docs/AUTO-MODE.md) for complete documentation.

### Secondary: Manual Mode (Focused Practice)

For deliberate practice on specific concepts:

```bash
/rust-tutor:slice      # Get a practice exercise
# ... implement the function ...
/rust-tutor:gate       # Validate with quality checks
/rust-tutor:level      # View progress
```

**Best for**: Warming up, drilling specific concepts, focused skill building when you're not actively building a project.

**Key differences**:

| Feature        | Manual Mode                  | Auto-Mode ⭐                                  |
|----------------|------------------------------|----------------------------------------------|
| **Challenges** | Synthetic practice exercises | Real code for your current project           |
| **Trigger**    | You run `/slice`             | Automatic (every ~8 tool calls)              |
| **Context**    | Isolated learning            | Part of larger project you're building       |
| **Review**     | Quality gates only           | Code inspection + corrections + explanations |
| **Logging**    | No detailed logs             | Full learning journal with before/after      |
| **Learning**   | Deliberate practice          | Learning by building real things             |

**Both modes share the same progression system** - you can mix them! Practice with `/slice`, then apply with `/auto-on` during development. All progress counts toward the same streak and level-up system.

---

## Commands

### Auto-Mode Commands

**`/rust-tutor:auto-on`** - Enable continuous learning
- Start learning while building real projects
- Claude will pause and challenge you before writing Rust functions
- All challenges logged to `.claude/tutor/logs/level-N.md`

**`/rust-tutor:auto-off`** - Disable auto-mode
- Return to normal Claude behavior
- Use when you need to prototype quickly or focus on delivery

**`/rust-tutor:auto-status`** - View auto-mode statistics
- See total challenges completed
- View correction rate and learning patterns
- Find your learning journal location

### Manual Practice Commands

**`/rust-tutor:slice`** - Get a practice exercise
- Proposes a learning task based on your current level
- Provides failing test, stub, and acceptance criteria
- For focused drilling on specific concepts

**`/rust-tutor:gate`** - Validate your practice work
- Runs all 4 quality gates (fmt, clippy, tests, policy)
- Updates streak and level on success
- Resets streak on failure (but keeps your level)

### Progress Tracking

**`/rust-tutor:level`** - View overall progress
- Shows current level, streak, and recent history
- Displays progress toward next level
- Includes both auto-mode and manual mode stats

**Example**:
```bash
> /rust-tutor:level

Learning Progress

Current Level: 2 - Errors & Traits
Topics: Result, thiserror, From/Into
Completed: 5 slices at this level (2 auto, 3 manual)
Streak: 2 consecutive passes
Next Level: 3 - DSP Basics (unlock after 1 more pass)

Auto-Mode Stats:
- Challenges completed: 2
- Corrections made: 4 improvements
- Learning journal: .claude/tutor/logs/level-2.md

Recent History:
- 2025-11-28 14:30: PASS (auto) - parse_row() with corrections
- 2025-11-28 10:15: PASS (manual) - error handling exercise

Progress to Next Level:
[▓▓░] 2/3
```

---

## Learning Journal

One of auto-mode's most powerful features is the **learning journal** - a detailed log of every challenge, correction, and learning point.

### What Gets Logged

Every auto-mode challenge is logged to `.claude/tutor/logs/level-N.md`:

```markdown
## 2025-11-28 14:30 - Auto-Challenge #5

### Challenge
Function: parse_row(line: &str) -> Result<Record, ParseError>
Required for: CSV CLI tool row parsing
Location: src/parser.rs:42

### Review Result
PASS: Approved with corrections

Improvements made:
1. Replaced manual split+collect with iterator chain
   - Before: let parts: Vec<&str> = line.split(',').collect();
   - After: line.split(',').map(...)
   - Why: Avoids allocation, more idiomatic

2. Changed .unwrap() to proper error propagation
   - Before: parts[0].parse().unwrap()
   - After: parts[0].parse().map_err(ParseError::InvalidNumber)?
   - Why: Level 2 requires no unwrap in library code

### Outcome
Status: Approved with corrections | Streak: 2/3 → 3/3 → LEVEL UP to 3!
```

### Why the Journal Matters

- **Reinforce learning**: Review to see patterns in your corrections
- **Track progress**: Compare early vs. recent challenges
- **Study guide**: Refresh concepts before leveling up
- **Portfolio**: Real implementations from actual projects
- **Learn from mistakes**: See what you commonly miss (allocations? error handling?)

### Privacy Note

Logs may contain project code. Add to `.gitignore` if needed:
```gitignore
.claude/tutor/logs/*.md
```

## How It Works (Technical)

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

See the **Learning Journal** section above for details on what's logged and why it matters.

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

### Should I use auto-mode or manual mode?

**Start with auto-mode** if you want to learn while building real projects. It's the most powerful way to learn because you get real context, code review, and a learning journal.

Use **manual mode** for:
- Warming up before a coding session
- Drilling specific concepts you're struggling with
- Focused practice when you're not building a project

**Pro tip**: Mix both! Use `/slice` to practice a concept, then `/auto-on` to apply it in a real project.

### Can Claude give me hints if I'm stuck during a challenge?

Yes! Ask Claude questions about concepts without asking for the full solution:
- "How do I use .iter().max_by()?"
- "What's the difference between &T and &mut T here?"
- "Why does the borrow checker complain about this?"

Claude will explain concepts and point you in the right direction without implementing the code for you.

### Can I skip an auto-mode challenge?

Yes! Type `skip` and Claude will write the function for you and continue. No penalty to your streak, but you won't get the learning benefit or code review.

**Use skip when**: You're blocked, under time pressure, or the challenge doesn't match your learning goal at the moment.

### How do I review my past challenges and corrections?

Check your learning journal at `.claude/tutor/logs/level-N.md`. All auto-mode challenges, corrections, and explanations are logged there.

### Can I customize the learning path?

Yes! Edit `.claude/tutor/levels.yaml` to change topics, constraints, or add your own levels. You can also adjust auto-mode trigger frequency in `state.json`.

### What if state.json gets corrupted?

Delete `.claude/tutor/state.json` and run any tutor command to reinitialize, or manually reset it to:
```json
{"level": 1, "completed": 0, "streak": 0, "auto_mode": {"enabled": false, "trigger_frequency": 8}}
```

### Does this work with existing Rust projects?

Yes! Install the plugin in any Rust project (workspace or single crate). It detects your project structure automatically.

### What happens after Level 5?

You stay at Level 5 and can continue practicing. You can also:
- Edit `levels.yaml` to add custom Level 6+
- Build your own projects with auto-mode enabled
- Contribute to open source Rust projects
- Use the learning journal to review and solidify advanced concepts

---


---

## License

MIT License - see LICENSE file for details.
