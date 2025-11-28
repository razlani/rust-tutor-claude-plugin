---
description: View auto-mode statistics and configuration
---

Show auto-mode statistics and configuration.

## Initialization

**Step 1: Check if initialization is needed**

Run: `test -f .claude/tutor/state.json && echo "SKIP_INIT" || echo "NEED_INIT"`

If output is "SKIP_INIT", proceed to showing auto-mode status.

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
