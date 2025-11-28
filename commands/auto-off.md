---
description: Disable auto-mode learning challenges
---

Disable auto-mode learning.

Auto-mode will stop triggering challenges. You can still use manual commands like `/slice` and `/gate` for practice.

## Initialization

**Step 1: Check if initialization is needed**

Run: `test -f .claude/tutor/state.json && echo "SKIP_INIT" || echo "NEED_INIT"`

If output is "SKIP_INIT", proceed to disabling auto-mode.

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
