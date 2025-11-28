---
description: Run Rust quality gates and update learning progress
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

If state.json DOES exist, proceed directly to running quality gates.

## Run Quality Gates

Read `CLAUDE.md` for quality gate requirements and state update logic.

Read `.claude/tutor/state.json` to get current level, completed count, and streak.

## Quality Gates (Run in Sequence)

Use the Bash tool to run these checks. Stop at first failure (fail-fast) for faster feedback.

### Gate 1: Formatting
```bash
cargo fmt --all -- --check
```
- **Success**: Exit code 0, no output
- **Failure**: Shows which files need formatting
- **Fix hint**: Run `cargo fmt --all`

### Gate 2: Lints (Clippy)
```bash
cargo clippy --workspace --all-targets --all-features -- -D warnings
```
- **Success**: Exit code 0
- **Failure**: Lists warnings with file:line:column and suggestions
- **Fix hint**: Address each warning (sometimes requires refactoring)
- **Note**: `-D warnings` treats warnings as errors (strict mode)

### Gate 3: Tests
```bash
cargo test --workspace --all-targets --no-fail-fast
```
- **Success**: All tests pass
- **Failure**: Shows failing test output with assertion details
- **Fix hint**: Debug failing tests, verify implementation logic
- **Note**: `--no-fail-fast` shows ALL failures, not just the first

### Gate 4: Policy (No unwrap/expect in libs)
```bash
grep -r "unwrap\(\\|expect\(" crates/ || echo "POLICY_OK"
```
- **Success**: Output contains "POLICY_OK" (grep found nothing)
- **Failure**: Shows file:line for each unwrap/expect usage
- **Fix hint**: Return `Result<T, E>` instead of panicking
- **Note**: This gate only checks `crates/` directory (libraries). It's OK to use unwrap/expect in `bins/` (binaries) and test code.

## Reporting Results

### If ALL Gates Pass

```markdown
SUCCESS: **Quality Gates: ALL PASS**

PASS: **Formatting**: Passed (cargo fmt)
PASS: **Lints**: Passed (cargo clippy)
PASS: **Tests**: Passed ({count} tests)
PASS: **Policy**: Passed (no unwrap/expect in libs)

Progress: **Progress Updated**:
- Level: {level} ({level_name})
- Completed: {completed + 1} slices
- Streak: {streak + 1} consecutive passes
{If streak + 1 >= 3: "\nSUCCESS: **LEVEL UP!** You've advanced to Level {level + 1} ({next_level_name})!"}

Great work! Ready for the next slice? Run `/slice` to continue.
```

### If ANY Gate Fails

```markdown
FAIL: **Quality Gates: FAILED**

{For each gate, show result with details:}
{If passed: "PASS: **{Gate Name}**: Passed"}
{If failed: "FAIL: **{Gate Name}**: Failed\n   {error details with file:line pointers}"}

**Streak reset to 0** (was {streak})

{Actionable advice based on failures, e.g.:}
Fix the {failed_gate_names} issues and run `/gate` again.

TIP: Tip: {Context-specific hint, e.g., "Run `cargo clippy` locally to see full error messages and suggested fixes."}
```

## State Update Logic

After running all gates, update `.claude/tutor/state.json`:

### On Success (all gates pass)
```javascript
const state = JSON.parse(readFile('.claude/tutor/state.json'));

state.completed += 1;
state.streak += 1;

// Check for level up
if (state.streak >= 3 && state.level < 5) {
  state.level += 1;
  state.completed = 0;
  state.streak = 0;
}

// Append to history
state.history.push({
  ts: new Date().toISOString(),
  ok: true,
  fmt: true,
  clippy: true,
  test: true,
  policy: true
});

writeFile('.claude/tutor/state.json', JSON.stringify(state, null, 2));
```

### On Failure (any gate fails)
```javascript
const state = JSON.parse(readFile('.claude/tutor/state.json'));

state.streak = 0; // Reset streak, keep level and completed

// Append to history with failure details
state.history.push({
  ts: new Date().toISOString(),
  ok: false,
  fmt: {fmt_result},
  clippy: {clippy_result},
  test: {test_result},
  policy: {policy_result},
  notes: "Brief summary of what failed"
});

writeFile('.claude/tutor/state.json', JSON.stringify(state, null, 2));
```

## Important Notes

- Use Read and Write tools (not bash/jq) to update state.json - this ensures cross-platform compatibility
- Be specific with error messages - include file:line pointers so user knows exactly what to fix
- Celebrate successes - learning is hard, acknowledgment helps motivation
- On failures, be encouraging but clear about what needs fixing
