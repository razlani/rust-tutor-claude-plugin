#!/usr/bin/env bash
# Auto-mode reminder hook for Claude Rust Tutor Plugin
# This script runs on every UserPromptSubmit event and injects
# auto-mode awareness into Claude's context if enabled.

set -e

STATE_FILE="${CLAUDE_PROJECT_DIR}/.claude/tutor/state.json"

# Check if state file exists (tutor is initialized)
if [[ ! -f "$STATE_FILE" ]]; then
  # Not initialized yet, silently exit
  exit 0
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
  # Fall back to grep if jq is not available
  if grep -q '"enabled": *true' "$STATE_FILE" 2>/dev/null; then
    echo "<auto-mode-reminder>"
    echo "Rust Tutor Auto-mode is enabled. Before writing Rust functions, check if they match the user's skill level and challenge them to implement it themselves."
    echo "</auto-mode-reminder>"
  fi
  exit 0
fi

# Read auto_mode status using jq
AUTO_MODE_ENABLED=$(jq -r '.auto_mode.enabled // false' "$STATE_FILE" 2>/dev/null || echo "false")
LEVEL=$(jq -r '.level // 1' "$STATE_FILE" 2>/dev/null || echo "1")
STREAK=$(jq -r '.streak // 0' "$STATE_FILE" 2>/dev/null || echo "0")
TRIGGER_FREQ=$(jq -r '.auto_mode.trigger_frequency // 8' "$STATE_FILE" 2>/dev/null || echo "8")
TOOL_CALLS=$(jq -r '.auto_mode.tool_call_counter // 0' "$STATE_FILE" 2>/dev/null || echo "0")

# Only inject reminder if auto-mode is enabled
if [[ "$AUTO_MODE_ENABLED" == "true" ]]; then
  REMAINING=$((TRIGGER_FREQ - TOOL_CALLS))

  echo "<auto-mode-reminder>"
  echo "Rust Tutor Auto-Mode Active"
  echo ""
  echo "Current Status:"
  echo "- Level: $LEVEL | Streak: $STREAK/3"
  echo "- Tool calls since last challenge: $TOOL_CALLS/$TRIGGER_FREQ"
  if [[ $REMAINING -le 2 ]]; then
    echo "- WARNING: Next challenge trigger in $REMAINING tool call(s)!"
  fi
  echo ""
  echo "Before writing Rust functions:"
  echo "1. Analyze the complexity and learning value"
  echo "2. If it matches the user's Level $LEVEL skill, pause and challenge them to implement it"
  echo "3. If it's too advanced or trivial, write it yourself"
  echo ""
  echo "Remember: Learning opportunities should be practical, aligned with current level topics, and build on completed slices."
  echo "</auto-mode-reminder>"
fi

exit 0
