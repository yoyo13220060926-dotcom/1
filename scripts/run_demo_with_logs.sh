#!/usr/bin/env bash
set -euo pipefail

# This script records environment + build steps into logs for submission/demo proof.
# It does NOT require modifying project source tree during runtime.

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="${LOG_DIR:-$ROOT_DIR/demo-logs}"
IMAGE_NAME="${IMAGE_NAME:-cs1000fvp-ubuntu-builder}"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/out}"
DEMO_TS="$(date +%Y%m%d-%H%M%S)"
SESSION_DIR="$LOG_DIR/$DEMO_TS"
mkdir -p "$SESSION_DIR" "$OUT_DIR"

exec > >(tee "$SESSION_DIR/run.log") 2>&1

echo "[INFO] Demo session: $DEMO_TS"
echo "[INFO] Root: $ROOT_DIR"
echo "[INFO] Session logs: $SESSION_DIR"

echo "\n===== 1) Host environment ====="
uname -a || true
cat /etc/os-release || true
command -v docker && docker --version

# Save detailed host environment report
{
  echo "# Host environment"
  date -Is
  uname -a || true
  echo
  echo "## /etc/os-release"
  cat /etc/os-release || true
  echo
  echo "## docker version"
  docker version || true
  echo
  echo "## docker info"
  docker info || true
} > "$SESSION_DIR/host-environment.txt"

echo "\n===== 2) Build container image ====="
docker build -t "$IMAGE_NAME" "$ROOT_DIR"

echo "\n===== 3) Run build container ====="
# You may pin ref for deterministic output by setting CS1000FVP_REF env before running this script.
docker run --rm -it \
  -e CS1000FVP_REPO="${CS1000FVP_REPO:-https://github.com/heslabs/cs1000fvp}" \
  -e CS1000FVP_BRANCH="${CS1000FVP_BRANCH:-main}" \
  -e CS1000FVP_REF="${CS1000FVP_REF:-}" \
  -v "$OUT_DIR:/work/out" \
  "$IMAGE_NAME"

echo "\n===== 4) Capture output tree ====="
find "$OUT_DIR" -maxdepth 4 -type f | sort | tee "$SESSION_DIR/output-files.txt"

echo "\n===== 5) Build success checklist ====="
if [ -d "$OUT_DIR/build" ] || [ -d "$OUT_DIR/output" ] || [ -d "$OUT_DIR/out" ]; then
  echo "[PASS] Found expected output directory under $OUT_DIR"
else
  echo "[FAIL] No expected output directory under $OUT_DIR"
  exit 1
fi

echo "[INFO] Demo completed successfully."
echo "[INFO] Use these files for submission evidence:"
echo "  - $SESSION_DIR/run.log"
echo "  - $SESSION_DIR/host-environment.txt"
echo "  - $SESSION_DIR/output-files.txt"

echo "\n===== Optional terminal recording ====="
echo "If you need a replayable terminal record, run manually:"
echo "  script -f $SESSION_DIR/terminal.typescript"
echo "  # then execute the same commands and type 'exit'"
