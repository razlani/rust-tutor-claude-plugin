# Auto-Mode Walkthrough

This walkthrough demonstrates a complete auto-mode session where a user builds a real Rust CLI tool while learning.

## Scenario

**User Goal**: Build a CLI tool that calculates audio file properties (RMS, peak levels, duration)

**User Level**: 2 (Errors & Traits)

**Starting State**:
- Auto-mode: Disabled
- Completed: 1 slice at Level 2
- Streak: 1/3

---

## Session Transcript

### Enabling Auto-Mode

```
User: /auto-on
```

```markdown
Claude: PASS **Auto-Mode Enabled**

From now on, I'll pause every **8** tool calls and challenge you to implement
actual Rust functions needed for the current task.

**How it works:**
- I analyze the function I need to write
- If it matches your skill level (Level 2), you implement it
- If it's too advanced, I'll write it and you'll learn it later
- Type "done" after implementing, or "skip" to continue

**Current settings:**
- Trigger frequency: 8 tool calls
- Current level: 2
- Allow skip: true

Use `/auto-off` to disable or `/auto-status` to view progress.

Ready to start your next task!
```

---

### Starting the Project

```
User: Build me a CLI tool called `audioinfo` that reads audio files and
displays their properties (RMS, peak level, duration). Start with WAV file support.
```

```markdown
Claude: I'll help you build an audio info CLI tool. Let me start by setting up the project structure.

[Creates Cargo.toml, directory structure, adds dependencies: clap, hound]
[Tool calls: 1 (Write), 2 (Write), 3 (Write), 4 (Write), 5 (Bash: cargo add)]
[Creates src/main.rs stub, src/lib.rs]
[Tool calls: 6 (Write), 7 (Write), 8 (Write)]
```

---

### First Auto-Challenge

```markdown
Claude:  **Auto-Challenge** [Level 2]

I need to implement: `read_wav(path: &Path) -> Result<Vec<f32>, AudioError>`

**Context**: Reading WAV file samples for the audioinfo CLI tool

**Your task:**
- Implement the function at `src/lib.rs:15`
- Run `cargo test` locally in your editor to verify
- Type "done" when tests pass (or "skip" to have me write it)

**Test file**: `tests/challenge_test.rs`

**Concepts covered**: result_type, custom_error_type, from_trait

---

I've created the test and function stub. Here's what I need:

**src/lib.rs:15-20**:
```rust
pub fn read_wav(path: &Path) -> Result<Vec<f32>, AudioError> {
    todo!()  // Implement: read WAV, convert to f32 samples in [-1.0, 1.0]
}
```

**Test** (in `.claude/tutor/challenge_test.rs`):
```rust
#[test]
fn test_read_wav_basic() {
    let samples = read_wav(Path::new("tests/fixtures/sine_440hz.wav")).unwrap();
    assert!(samples.len() > 0);
    assert!(samples.iter().all(|&s| s >= -1.0 && s <= 1.0));
}

#[test]
fn test_read_wav_missing_file() {
    let result = read_wav(Path::new("nonexistent.wav"));
    assert!(matches!(result, Err(AudioError::Io(_))));
}
```

Implement the function using the `hound` crate we added. Remember:
- Level 2 requirement: No `.unwrap()` or `.expect()` in library code
- Use `?` for error propagation
- Map hound errors to AudioError
```

---

### User Implements

```
User: [Opens src/lib.rs in editor]
      [Implements the function]
      [Runs cargo test in terminal - sees tests pass]
      [Types in Claude Code...]

User: done
```

---

### Code Review

```markdown
Claude: [Reading src/lib.rs:15-28...]

PASS **Review: Approved with improvements**

Your implementation works, but I made 2 improvements:

1. **Replaced .unwrap() with proper error handling**
   - Before (line 21):
     ```rust
     let reader = hound::WavReader::open(path).unwrap();
     ```
   - After:
     ```rust
     let reader = hound::WavReader::open(path)
         .map_err(AudioError::from)?;
     ```
   - Why: Level 2 requires no unwrap/expect in library code. We have a From<hound::Error>
     impl, so this propagates errors properly.

2. **Used iterator chain instead of manual loop**
   - Before (lines 23-27):
     ```rust
     let mut samples = Vec::new();
     for s in reader.samples::<i16>() {
         samples.push(s.unwrap() as f32 / 32768.0);
     }
     ```
   - After:
     ```rust
     let samples: Result<Vec<f32>, _> = reader
         .samples::<i16>()
         .map(|s| s.map(|v| v as f32 / 32768.0))
         .collect();
     let samples = samples.map_err(AudioError::from)?;
     ```
   - Why: More idiomatic Rust. Handles errors properly and avoids the unwrap in the loop.

See the updated code at `src/lib.rs:15-28`

**Streak: 1/3 → 2/3**

Logged to `.claude/tutor/logs/level-2.md`

Great work! One more successful challenge and you'll level up to Level 3.

Continuing with the audioinfo CLI tool...

---

Now I'll implement the RMS calculation function...

[Continues building: adds calculate_rms, calculate_peak functions]
[Tool calls: 9 (Edit), 10 (Write), 11 (Write), 12 (Write), 13 (Edit), 14 (Write), 15 (Write), 16 (Write)]
```

---

### Second Auto-Challenge

```markdown
Claude:  **Auto-Challenge** [Level 2]

I need to implement: `format_duration(samples: usize, sample_rate: u32) -> String`

**Context**: Formatting audio duration for user-friendly display in CLI output

**Your task:**
- Implement the function at `src/lib.rs:58`
- Run `cargo test` locally to verify
- Type "done" when tests pass (or "skip")

**Test file**: `tests/challenge_test.rs`

**Concepts covered**: simple_function, option_advanced

---

**src/lib.rs:58-60**:
```rust
pub fn format_duration(samples: usize, sample_rate: u32) -> String {
    todo!()  // Implement: convert samples to "MM:SS.mmm" format
}
```

**Test**:
```rust
#[test]
fn test_format_duration() {
    assert_eq!(format_duration(44100, 44100), "00:01.000");
    assert_eq!(format_duration(132300, 44100), "00:03.000");
    assert_eq!(format_duration(2646000, 44100), "01:00.000");
}
```
```

---

### User Implements (Perfect This Time)

```
User: [Implements the function cleanly]
User: done
```

```markdown
Claude: [Reading src/lib.rs:58-65...]

PASS **Review: Perfect!**

Your implementation of `format_duration()` is clean and idiomatic.
No corrections needed!

**Streak: 2/3 → 3/3 → SUCCESS LEVEL UP!** SUCCESS

You've advanced from Level 2 (Errors & Traits) to Level 3 (DSP Basics)!

**New concepts unlocked:**
- In-place buffer operations
- Iterator advanced patterns
- DSP windowing functions
- Zero-allocation hot paths
- f32/f64 numerical stability

**New constraints:**
- Prefer in-place operations where possible
- Avoid unnecessary allocations in DSP code
- All Level 1-2 constraints still apply

Logged to `.claude/tutor/logs/level-2.md`

Keep up the great work!

---

Continuing with the audioinfo CLI tool...

[Implements main() CLI argument parsing, file reading, output formatting]
[Tool calls: 17 (Write), 18 (Edit), 19 (Edit), 20 (Write), 21 (Bash: cargo build), 22 (Bash: cargo run), 23 (Read), 24 (Edit)]
```

---

### Third Auto-Challenge (Now at Level 3!)

```markdown
Claude:  **Auto-Challenge** [Level 3]

I need to implement: `calculate_rms_windowed(samples: &[f32], window_size: usize) -> Vec<f32>`

**Context**: Computing RMS over sliding windows for the CLI's detailed analysis mode

**Your task:**
- Implement the function at `src/lib.rs:82`
- Run `cargo test` locally to verify
- Type "done" when tests pass (or "skip")

**Test file**: `tests/challenge_test.rs`

**Concepts covered**: in_place_operations, iterator_advanced, zero_allocation_hotpath

---

**Level 3 requirement**: Prefer in-place operations. Try to minimize allocations.

**src/lib.rs:82-84**:
```rust
pub fn calculate_rms_windowed(samples: &[f32], window_size: usize) -> Vec<f32> {
    todo!()  // Implement: sliding window RMS calculation
}
```

**Test**:
```rust
#[test]
fn test_rms_windowed() {
    let samples = vec![0.5, -0.5, 0.5, -0.5, 0.8, -0.8];
    let rms_values = calculate_rms_windowed(&samples, 2);
    assert_eq!(rms_values.len(), 5);  // n - window_size + 1
    assert!((rms_values[0] - 0.5).abs() < 0.01);
}
```
```

---

### User Skips (Time Pressure)

```
User: skip
```

```markdown
Claude: No problem! I'll implement `calculate_rms_windowed()` for you.

TIP: I wrote `calculate_rms_windowed()` for you (you chose to skip).

**Note**: Skipping doesn't hurt your streak, but you won't get the learning
opportunity. You can review the implementation I wrote and ask questions if you'd like.

Continuing with the audioinfo CLI tool...

[Implements the windowed RMS function]
[Continues building: adds --detailed flag, final polish]
[Tool calls: 25 (Write), 26 (Edit), 27 (Bash: cargo test), 28 (Bash: cargo build)]

---

PASS **CLI tool complete!**

I've built `audioinfo` with:
- WAV file reading
- RMS and peak level calculation
- Duration formatting
- Basic and detailed analysis modes
- Proper error handling

Try it:
```bash
cargo run -- tests/fixtures/sine_440hz.wav
cargo run -- tests/fixtures/sine_440hz.wav --detailed
```

Great session! You completed 2 auto-challenges, leveled up to 3, and built a real tool.
```

---

### Checking Progress

```
User: /level
```

```markdown
Claude:  **Learning Progress**

**Current Level**: 3 - DSP Basics
**Description**: Audio processing fundamentals
**Topics**: in_place_ops, iterators_advanced, dsp_windowing, zero_alloc
**Completed**: 0 slices at this level
**Streak**:  0 consecutive passes
**Next Level**: 4 - Pitch & Properties (unlock after 3 more passes)

**Constraints for This Level**:
- Maximum LOC per slice: 120
- Tests first: PASS
- No unwrap/expect in libs: PASS
- Prefer in-place operations: PASS

**Recent History** (last 5 slices):
- 2025-11-22 15:42: PASS Pass (auto) - format_duration (perfect!)
- 2025-11-22 15:30: PASS Pass (auto) - read_wav (2 corrections)
- 2025-11-21 10:15: PASS Pass (manual) - Custom error types

**Progress to Next Level**:
[░░░] 0/3

**Total Slices Completed at This Level**: 0

**Auto-Mode Stats**:
Status: PASS Enabled
- Auto-completions: 2
- Corrections made: 2
- Tool calls until next: 4

TIP: Tip: Auto-mode challenges count toward your streak! Run `/auto-status` for details.

You just leveled up! Ready for DSP-focused challenges at Level 3.
```

---

### Viewing Auto Stats

```
User: /auto-status
```

```markdown
Claude:  **Auto-Mode Status**

**Status**: PASS Enabled

**Configuration:**
- Trigger frequency: Every 8 tool calls
- Tool calls since last challenge: 4/8
- Allow skip: Yes
- Log to files: Yes
- Log directory: `.claude/tutor/logs`

**Progress:**
- Auto-completions: 2
- Total corrections made: 2
- Current streak: 0/3
- Current level: 3

**Active Challenge:**
- None (ready for next challenge)

**Learning Journal:**
- `.claude/tutor/logs/level-1.md` (not started)
- `.claude/tutor/logs/level-2.md` (2 entries)
- `.claude/tutor/logs/level-3.md` (not started)
- `.claude/tutor/logs/level-4.md` (not started)
- `.claude/tutor/logs/level-5.md` (not started)

**Commands:**
- `/auto-on` - Enable auto-mode
- `/auto-off` - Disable auto-mode
- `/level` - View overall progress

TIP: **Tip**: Next challenge coming in ~4 tool calls!
```

---

### Reviewing Learning Journal

```
User: Can you show me my Level 2 log?
```

```markdown
Claude: Here's your Level 2 learning journal:

[Reading .claude/tutor/logs/level-2.md]

# Level 2 Learning Log

This file tracks all your Level 2 auto-challenges, implementations, and corrections.

---

## 2025-11-22 15:30:00 - Auto-Challenge #1

### Challenge
**Function**: `read_wav(path: &Path) -> Result<Vec<f32>, AudioError>`
**Required for**: Reading WAV file samples for audioinfo CLI tool
**Location**: `src/lib.rs:15`
**Complexity**: Level 2
**Concepts**: result_type, custom_error_type, from_trait

### Your Implementation
You successfully read WAV files using hound, but had two areas for improvement.

### Review Result
PASS Approved with corrections

WARNING: **Improvements made**:
1. Replaced .unwrap() with proper error handling using .map_err() and ?
   - Level 2 requires no unwrap/expect in library code

2. Changed manual loop to iterator chain with .map() and .collect()
   - More idiomatic Rust, handles errors properly

### Outcome
**Status**: Approved with corrections
**Streak**: 1/3 → 2/3

---

## 2025-11-22 15:42:00 - Auto-Challenge #2

### Challenge
**Function**: `format_duration(samples: usize, sample_rate: u32) -> String`
**Required for**: Formatting audio duration for CLI output
**Location**: `src/lib.rs:58`
**Complexity**: Level 2
**Concepts**: simple_function, option_advanced

### Your Implementation
Perfect implementation! No corrections needed.

### Review Result
PASS Perfect

### Outcome
**Status**: Perfect
**Streak**: 2/3 → 3/3 → **SUCCESS LEVEL UP to 3!**

---

You completed 2 challenges at Level 2, learned about error handling patterns,
and advanced to Level 3. Great progress!
```

---

## Summary

In this session, the user:

1. **Enabled auto-mode** with `/auto-on`
2. **Built a real CLI tool** (audioinfo) while learning
3. **Completed 2 auto-challenges**:
   - `read_wav()` - Approved with 2 corrections (learned error handling patterns)
   - `format_duration()` - Perfect implementation
4. **Leveled up** from Level 2 → Level 3
5. **Skipped 1 challenge** (no penalty, Claude implemented it)
6. **Learned from corrections**:
   - No unwrap in library code (use ? instead)
   - Prefer iterator chains over manual loops
7. **Has a detailed learning journal** tracking all challenges and corrections

The user now has:
- A working audioinfo CLI tool
- Practical experience with Result, error handling, and iterators
- A learning journal for future review
- Level 3 status with new concepts to learn

**Next steps**: Continue building projects with auto-mode, tackle Level 3 challenges
(in-place operations, DSP patterns), and work toward Level 4.
