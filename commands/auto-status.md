---
description: View auto-mode statistics and configuration
---

Show auto-mode statistics and configuration.

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

If state.json DOES exist, proceed to showing auto-mode status.

## Show Auto-Mode Status

**Steps:**

1. Read `.claude/tutor/state.json`
2. Display comprehensive auto-mode information:

```markdown
Progress: **Auto-Mode Status**

**Status**: {enabled ? "Enabled" : "Disabled"}

**Configuration:**
- Trigger frequency: Every {trigger_frequency} tool calls
- Tool calls since last challenge: {tool_call_counter}/{trigger_frequency}

**Progress:**
- Auto-completions: {auto_completions}
- Total corrections made: {total_corrections}
- Current streak: {streak}/3
- Current level: {level}

**Active Challenge:**
{If current_challenge:}
- Function: `{current_challenge.function_name}`
- Location: `{current_challenge.file_path}:{current_challenge.line_start}`
- Started: {current_challenge.timestamp}
{Else:}
- None (ready for next challenge)

**Learning Journal:**
{List log files that exist:}
- `.claude/tutor/logs/level-1.md` {exists ? "({num_entries} entries)" : "(not started)"}
- `.claude/tutor/logs/level-2.md` {exists ? "({num_entries} entries)" : "(not started)"}
...

**Commands:**
- `/auto-on` - Enable auto-mode
- `/auto-off` - Disable auto-mode
- `/level` - View overall progress
```

If auto-mode is enabled and tool_call_counter is close to trigger_frequency:
```markdown
TIP: **Tip**: Next challenge coming in ~{trigger_frequency - tool_call_counter} tool calls!
```
