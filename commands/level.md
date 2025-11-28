---
description: View learning progress and current level status
---

## Initialization

First, check if `.claude/tutor/state.json` exists in the current project.

If it does NOT exist, initialize the tutor structure:

1. **Handle CLAUDE.md with version checking:**
   - Check if `CLAUDE.md` exists in project root
   - If it EXISTS:
     - Read the file and search for marker: `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->`
     - If marker with version `1.0.4` found: Skip CLAUDE.md update (already current)
     - If marker with older version found (e.g., `v1.0.0`): Remove old tutor section (everything between `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v*` and `<!-- END RUST TUTOR PLUGIN INSTRUCTIONS -->`), then append new version
     - If NO marker found: Append tutor instructions to the end with markers
   - If it DOES NOT exist: Copy `${CLAUDE_PLUGIN_ROOT}/config/CLAUDE.md` → `./CLAUDE.md` and add version marker at the top

   **When appending or updating, use this format:**
   ```markdown

   <!-- ========================================= -->
   <!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->
   <!-- Auto-added by tutor plugin -->
   <!-- ========================================= -->

   [Full contents of ${CLAUDE_PLUGIN_ROOT}/config/CLAUDE.md]

   <!-- END RUST TUTOR PLUGIN INSTRUCTIONS -->
   <!-- ========================================= -->
   ```

2. **Create directories and copy template files:**
   - Create directories: `.claude/tutor/` and `.claude/tutor/logs/`
   - Copy template files from the plugin to the user's project:
     - `${CLAUDE_PLUGIN_ROOT}/config/state.template.json` → `.claude/tutor/state.json`
     - `${CLAUDE_PLUGIN_ROOT}/config/levels.yaml` → `.claude/tutor/levels.yaml`
     - `${CLAUDE_PLUGIN_ROOT}/config/complexity-map.yaml` → `.claude/tutor/complexity-map.yaml`
   - Create log directory placeholder: `.claude/tutor/logs/.gitkeep` (empty file)

3. **Inform the user:**
   - If CLAUDE.md was created fresh: "PASS: Tutor initialized! Learning state created at `.claude/tutor/` and CLAUDE.md installed."
   - If CLAUDE.md was appended/updated: "PASS: Tutor initialized! Learning state created at `.claude/tutor/` and tutor instructions added to your existing CLAUDE.md."
   - If CLAUDE.md was skipped (already current): "PASS: Tutor initialized! Learning state created at `.claude/tutor/`. Your CLAUDE.md already has current tutor instructions."

If state.json DOES exist, proceed directly to displaying progress.

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
