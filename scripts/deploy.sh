#!/usr/bin/env bash
# =============================================================================
#  toddherrbach.com — Deploy Script
# =============================================================================
#
#  WHAT THIS DOES (in plain language)
#  ----------------------------------
#  It copies the portfolio site files from THIS Mac up to the DreamHost
#  server, so the live site matches what is in this repo. It uses "rsync"
#  over an SSH connection that logs in with a key (no password needed).
#
#  THE INTENDED WORKFLOW (do this in two steps)
#  --------------------------------------------
#    STEP 1 — preview first:
#        ./scripts/deploy.sh --dry-run
#      Uploads NOTHING. It just prints the list of files that WOULD be sent.
#      Read that list and make sure it looks right. Works even mid-edit.
#
#    STEP 2 — when the preview looks right, deploy for real:
#        ./scripts/deploy.sh
#      Checks git first: if you have uncommitted changes it stops and tells
#      you to commit, so what goes live always matches a real commit. If the
#      tree is clean it asks you to type "y", then uploads once.
#
#  It is SAFE by design:
#    * The real deploy refuses to run if you have uncommitted changes.
#    * It NEVER deletes anything on the server (no --delete).
#    * Each mode does exactly ONE rsync pass, so you see one clear file list.
#
#  You (the human) always run this yourself and confirm. It never runs on
#  its own.
# =============================================================================

set -euo pipefail

# --- Connection and paths ----------------------------------------------------
SSH_TARGET="dotbacher@iad1-shared-b7-08.dreamhost.com"
REMOTE_ROOT="/home/dotbacher/toddherrbach.com/"
LOCAL_ROOT="/Users/hitodd/toddherrbach/toddherrbach-com"

# --- Always work from the project root ---------------------------------------
# (so git status is accurate and the source path below is correct)
cd "$LOCAL_ROOT"

# --- rsync settings ----------------------------------------------------------
#  -a  archive mode (preserves structure, timestamps, etc.)
#  -z  compress data during transfer
#  -i  itemize: print one line per file so you SEE exactly what changes
#  --chmod=D755,F644  force web-safe permissions on the server (dirs 755,
#       files 644) REGARDLESS of the local Mac perms. Without this, -a copies
#       the local folder's permissions up; if the Mac repo is private (700/600)
#       the server docroot becomes unreadable to Apache and the site 403s.
#  We deliberately DO NOT use --delete, so nothing on the server is removed.
RSYNC_FLAGS=(-a -z -i --chmod=D755,F644)

# Things that must never be uploaded.
RSYNC_EXCLUDES=(
  --exclude='.git'
  --exclude='.DS_Store'
  --exclude='CLAUDE.md'
  --exclude='SESSION_LOG.md'
  --exclude='scripts/'
  --exclude='.dh-diag/'
)

# Single source of truth for what gets synced. Everything in this repo is sent
# (the whole site) MINUS the excludes above. Pass --dry-run for a preview.
run_rsync() {
  rsync "${RSYNC_FLAGS[@]}" "$@" \
    "${RSYNC_EXCLUDES[@]}" \
    ./ \
    "${SSH_TARGET}:${REMOTE_ROOT}"
}

# =============================================================================
#  MODE 1 — PREVIEW (./scripts/deploy.sh --dry-run)
#  One rsync pass, uploads nothing, works even with a dirty tree.
# =============================================================================
if [[ "${1:-}" == "--dry-run" ]]; then
  echo ""
  echo "  PREVIEW ONLY — nothing will be uploaded."
  echo "  Showing exactly what WOULD transfer to:"
  echo "      ${SSH_TARGET}:${REMOTE_ROOT}"
  echo "  -------------------------------------------------------------------"
  run_rsync --dry-run
  echo "  -------------------------------------------------------------------"
  echo "  (Lines above are the files that would be sent. Empty = nothing to do.)"
  echo "  When this looks right, run './scripts/deploy.sh' to deploy for real."
  echo ""
  exit 0
fi

# =============================================================================
#  MODE 2 — REAL DEPLOY (./scripts/deploy.sh, no argument)
#  Guardrail first, then confirm, then ONE real rsync pass. No auto-preview.
# =============================================================================

# 1) GUARDRAIL: refuse to deploy with a dirty working tree.
if [[ -n "$(git status --porcelain)" ]]; then
  echo ""
  echo "  You have uncommitted changes. Commit them before deploying so git"
  echo "  matches what goes live."
  echo ""
  echo "  (Run 'git status' to see what is uncommitted. To preview without"
  echo "   committing, use './scripts/deploy.sh --dry-run'.)"
  echo ""
  exit 1
fi

# 2) Ask for explicit confirmation before uploading anything.
read -r -p "  Proceed with the REAL deploy? Type y to continue: " answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
  echo "  Cancelled. Nothing was uploaded."
  echo ""
  exit 0
fi

# 3) Real transfer — a single itemized rsync pass.
echo ""
echo "  DEPLOYING — uploading now."
echo "  -------------------------------------------------------------------"
run_rsync
echo "  -------------------------------------------------------------------"
echo "  Deploy complete."
echo ""
