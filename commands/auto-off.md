---
description: Disable auto-mode learning challenges
---

Disable auto-mode learning.

Auto-mode will stop triggering challenges. You can still use manual commands like `/slice` and `/gate` for practice.

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
   - If CLAUDE.md was created fresh: "Tutor initialized! Learning state created at `.claude/tutor/` and CLAUDE.md installed."
   - If CLAUDE.md was appended/updated: "Tutor initialized! Learning state created at `.claude/tutor/` and tutor instructions added to your existing CLAUDE.md."
   - If CLAUDE.md was skipped (already current): "Tutor initialized! Learning state created at `.claude/tutor/`. Your CLAUDE.md already has current tutor instructions."

If state.json DOES exist, proceed to disabling auto-mode.

## Disable Auto-Mode

**Steps:**

1. Read `.claude/tutor/state.json`
2. Set `auto_mode.enabled = false`
3. If there's a `current_challenge` active, clear it
4. Write state back to file
5. Confirm to user with:

```markdown
Auto-Mode Disabled

Auto-challenges are now off. I'll write Rust functions normally without pausing.

**Your progress is saved:**
- Auto-completions: {auto_completions}
- Total corrections: {total_corrections}
- Current streak: {streak}/3

You can still:
- Use `/slice` for manual practice exercises
- Use `/gate` to validate your work
- Use `/level` to view progress
- Use `/auto-on` to re-enable auto-mode anytime

Ready to continue!
```
