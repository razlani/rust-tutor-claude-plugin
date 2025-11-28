---
description: View learning progress and current level status
---

## Initialization

**Step 1: Check if initialization is needed**

Run: `test -f .claude/tutor/state.json && echo "SKIP_INIT" || echo "NEED_INIT"`

If output is "SKIP_INIT", proceed directly to displaying progress.

If output is "NEED_INIT", continue with initialization:

**Step 2: Create directories**

Run: `mkdir -p .claude/tutor/logs`

**Step 3: Copy template files**

Run these commands:
```bash
cp ${CLAUDE_PLUGIN_ROOT}config/state.template.json .claude/tutor/state.json
cp ${CLAUDE_PLUGIN_ROOT}config/levels.yaml .claude/tutor/levels.yaml
cp ${CLAUDE_PLUGIN_ROOT}config/complexity-map.yaml .claude/tutor/complexity-map.yaml
```

Use Write tool to create: `.claude/tutor/logs/.gitkeep` (empty file)

**Step 4: Handle CLAUDE.md**

Run: `test -f CLAUDE.md && echo "EXISTS" || echo "MISSING"`

**If output is "MISSING":**
1. Read `${CLAUDE_PLUGIN_ROOT}config/CLAUDE.md`
2. Write it to `./CLAUDE.md` with this header prepended:
   ```markdown
   <!-- ========================================= -->
   <!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->
   <!-- Auto-added by tutor plugin -->
   <!-- ========================================= -->
   ```
3. Tell user: "Tutor initialized! Learning state created at `.claude/tutor/` and CLAUDE.md installed."

**If output is "EXISTS":**
1. Read `./CLAUDE.md`
2. Search for: `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->`

   **If found:** Tell user: "Tutor initialized! Learning state created at `.claude/tutor/`. Your CLAUDE.md already has current tutor instructions."

   **If not found:** Search for: `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v`

   - **If found (old version):** Remove everything from `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v` to `<!-- END RUST TUTOR PLUGIN INSTRUCTIONS -->`, then continue to append step below
   - **If not found (no marker):** Continue to append step below

   **Append step:**
   1. Read `${CLAUDE_PLUGIN_ROOT}config/CLAUDE.md`
   2. Append to `./CLAUDE.md`:
      ```markdown

      <!-- ========================================= -->
      <!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->
      <!-- Auto-added by tutor plugin -->
      <!-- ========================================= -->

      [Full contents of ${CLAUDE_PLUGIN_ROOT}config/CLAUDE.md]

      <!-- END RUST TUTOR PLUGIN INSTRUCTIONS -->
      <!-- ========================================= -->
      ```
   3. Tell user: "Tutor initialized! Learning state created at `.claude/tutor/` and tutor instructions added to your existing CLAUDE.md."

## Display Progress

Read `.claude/tutor/state.json` to get current level, completed slices, streak, and history.

Read `.claude/tutor/levels.yaml` to get level details (name, topics, constraints).

## Display Format

```markdown
Progress: **Learning Progress**

**Current Level**: {level} - {level_name}
**Description**: {level_description}
**Topics**: {comma-separated list of topics for this level}
**Completed**: {completed} slices at this level
**Streak**: Streak: {streak} consecutive passes
{If streak < 3: "**Next Level**: {next_level_name} (unlock after {3 - streak} more passes)"}
{If level < 5 && streak >= 3: "**Ready to level up!** Complete one more slice to advance."}
{If level == 5: "**Max Level Reached!** You've mastered all levels. Keep practicing or create custom challenges."}

**Constraints for This Level**:
- Maximum LOC per slice: {max_loc}
- Tests first: {tests_first ? "Yes" : "No"}
{If level >= 2: "- No unwrap/expect in libs: PASS:"}
{If level >= 3: "- Prefer in-place operations: PASS:"}
{If level >= 4: "- Property tests required: PASS:"}
{If level >= 5: "- Help text required for CLIs: PASS:"}

**Recent History** (last 5 slices):
{For each entry in history.slice(-5):}
- {timestamp in friendly format}: {ok ? "PASS" : "FAIL"} {If notes exist: "- {notes}"}

**Progress to Next Level**:
{ASCII progress bar based on streak}
{If streak == 0: "[░░░] 0/3"}
{If streak == 1: "[▓░░] 1/3"}
{If streak == 2: "[▓▓░] 2/3"}
{If streak >= 3: "[▓▓▓] 3/3 - Ready to level up!"}

{If completed > 0: "\n**Total Slices Completed at This Level**: {completed}"}

**Auto-Mode Stats**:
{If auto_mode.enabled: "Status: PASS: Enabled"}
{If !auto_mode.enabled: "Status: Disabled (use `/auto-on` to enable)"}
- Auto-completions: {auto_mode.auto_completions}
- Corrections made: {auto_mode.total_corrections}
- Tool calls until next: {auto_mode.trigger_frequency - auto_mode.tool_call_counter}
{If auto_mode.auto_completions > 0: "\nTIP: Tip: Auto-mode challenges count toward your streak! Run `/auto-status` for details."}
```

## Additional Context

- If `history` array is empty: "No slices completed yet. Run `/slice` to start your first learning task!"
- If user has a long streak at max level: "Impressive! You've completed {completed} slices at max level. Consider contributing to open source or creating custom learning challenges."
- Be encouraging based on progress:
  - Low completion: "You're just getting started—keep going!"
  - Mid-progress: "Great progress! You're {streak}/3 of the way to the next level."
  - High streak: "You're on fire! Streak: Keep this streak going!"

## Example Output

```markdown
Progress: **Learning Progress**

**Current Level**: 2 - Errors & Traits
**Description**: Proper error handling and trait implementation
**Topics**: Result, thiserror, From/Into, trait_basics
**Completed**: 2 slices at this level
**Streak**: Streak: 2 consecutive passes
**Next Level**: 3 - DSP Basics (unlock after 1 more pass)

**Constraints for This Level**:
- Maximum LOC per slice: 90
- Tests first: PASS:
- No unwrap/expect in libs: PASS:

**Recent History** (last 5 slices):
- 2025-11-22 14:30: PASS: Pass - Implemented custom AudioError type
- 2025-11-22 15:15: PASS: Pass - Implemented Sample trait with From<i16>
- 2025-11-21 10:00: FAIL - Clippy warnings on redundant clone
- 2025-11-21 09:30: PASS: Pass - Implemented Result-based WAV parser
- 2025-11-20 16:45: PASS: Pass - Added thiserror error types

**Progress to Next Level**:
[▓▓░] 2/3

**Total Slices Completed at This Level**: 2

Great progress! One more successful slice and you'll advance to Level 3.
```
