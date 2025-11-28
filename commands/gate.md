---
description: Run Rust quality gates and update learning progress
---

## Initialization

**Step 1: Check if initialization is needed**

Run: `test -f .claude/tutor/state.json && echo "SKIP_INIT" || echo "NEED_INIT"`

If output is "SKIP_INIT", proceed directly to running quality gates.

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
