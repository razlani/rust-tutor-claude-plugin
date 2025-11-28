---
description: Plan next Rust learning task based on current level
---

## Initialization

**Step 1: Check if initialization is needed**

Run: `test -f .claude/tutor/state.json && echo "SKIP_INIT" || echo "NEED_INIT"`

If output is "SKIP_INIT", proceed directly to planning the next slice.

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
3. Tell user: "Tutor initialized! Learning state created at `.claude/tutor/` and CLAUDE.md installed. Let's start your first learning task!"

**If output is "EXISTS":**
1. Read `./CLAUDE.md`
2. Search for: `<!-- RUST TUTOR PLUGIN INSTRUCTIONS v1.0.4 -->`

   **If found:** Tell user: "Tutor initialized! Learning state created at `.claude/tutor/`. Your CLAUDE.md already has current tutor instructions. Let's start your first learning task!"

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
   3. Tell user: "Tutor initialized! Learning state created at `.claude/tutor/` and tutor instructions added to your existing CLAUDE.md. Let's start your first learning task!"

## Plan Next Slice

Read `.claude/tutor/state.json` to determine the user's current level, completed slices, and streak.

Read `.claude/tutor/levels.yaml` to get the topics, constraints, and examples for the current level.

Read `CLAUDE.md` for the full workflow, Rust best practices, and tutoring methodology.

## Your Task

Propose a learning task that:
1. Chooses ONE topic from the current level's topic list
2. Respects the `max_loc` constraint from levels.yaml
3. Teaches a practical Rust pattern (not a toy example)
4. Builds on previously completed slices (check history if available)

## Output Format

```markdown
Level {level} ({level_name}) - Slice {completed + 1}

**Goal**: {Clear, one-sentence description of what to implement}

**Topic**: {Which learning topic(s) this covers}

**File**: {Exact path where code should go, e.g., `crates/core/src/lib.rs` or `src/lib.rs`}

**Test** (add to {test_file_path}):
```rust
{Comprehensive failing test code - include multiple test cases covering happy path and edge cases}
```

**Stub** (add to {implementation_file_path}):
```rust
// Function signature with doc comment + placeholder return value
// The stub MUST compile but WILL fail the tests
```

**Acceptance Criteria**:
- {Criterion 1, e.g., "All tests pass"}
- {Criterion 2, e.g., "No allocations (use iterators)"}
- {Criterion 3, e.g., "Handles empty slice gracefully"}
- {...}

**Resources**: {Links to relevant Rust documentation or blog posts, if helpful}

---

Now implement the function. When done, run `/gate` to verify your work.
```

## Important Constraints

- **DO NOT implement the function body** - only provide the signature and placeholder
- **The stub must compile** - correct types, correct signature
- **Tests must be comprehensive** - happy path + at least 2 edge cases
- **Be encouraging** - this is a learning exercise, not a test to fail

## Workspace Detection

- If `crates/` directory exists: assume workspace, suggest `crates/core/src/lib.rs` or similar
- If only `src/` exists: assume single crate, suggest `src/lib.rs` or `src/main.rs`
- If neither exists: warn user to initialize a Rust project first

## Examples

See `.claude/tutor/levels.yaml` for example tasks per level. Draw inspiration but create variations to keep learning fresh.
