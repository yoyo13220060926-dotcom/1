#!/usr/bin/env bash
set -euo pipefail

CS1000FVP_REPO="${CS1000FVP_REPO:-https://github.com/heslabs/cs1000fvp}"
CS1000FVP_BRANCH="${CS1000FVP_BRANCH:-main}"
CS1000FVP_REF="${CS1000FVP_REF:-}"
CS1000FVP_LOCAL_SRC="${CS1000FVP_LOCAL_SRC:-}"
VERIFY_ONLY="${VERIFY_ONLY:-0}"

SRC_DIR="/work/src/cs1000fvp"
OUT_DIR="/work/out"

mkdir -p /work/src "$OUT_DIR"

copy_or_clone_source() {
  if [[ -n "$CS1000FVP_LOCAL_SRC" ]]; then
    echo "[INFO] Using local source from: $CS1000FVP_LOCAL_SRC"
    rm -rf "$SRC_DIR"
    cp -a "$CS1000FVP_LOCAL_SRC" "$SRC_DIR"
    return
  fi

  if [[ ! -d "$SRC_DIR/.git" ]]; then
    echo "[INFO] Cloning $CS1000FVP_REPO (branch: $CS1000FVP_BRANCH)"
    git clone --depth 1 --branch "$CS1000FVP_BRANCH" "$CS1000FVP_REPO" "$SRC_DIR"
  else
    echo "[INFO] Reusing existing source: $SRC_DIR"
    git -C "$SRC_DIR" fetch --depth 1 origin "$CS1000FVP_BRANCH"
    git -C "$SRC_DIR" checkout -f "$CS1000FVP_BRANCH"
    git -C "$SRC_DIR" reset --hard "origin/$CS1000FVP_BRANCH"
  fi

  if [[ -n "$CS1000FVP_REF" ]]; then
    echo "[INFO] Checking out ref: $CS1000FVP_REF"
    git -C "$SRC_DIR" fetch --depth 1 origin "$CS1000FVP_REF" || true
    git -C "$SRC_DIR" checkout -f "$CS1000FVP_REF"
  fi
}

run_build() {
  cd "$SRC_DIR"

  if [[ "$VERIFY_ONLY" == "1" ]]; then
    echo "[INFO] VERIFY_ONLY=1, skipping build and only verifying output layout."
    return
  fi

  if [[ -x ./build.sh ]]; then
    echo "[INFO] Detected build.sh"
    if ./build.sh ubuntu; then
      echo "[INFO] build.sh ubuntu succeeded"
    else
      echo "[WARN] build.sh ubuntu failed, retrying ./build.sh"
      ./build.sh
    fi
  elif [[ -f Makefile || -f makefile ]]; then
    echo "[INFO] Detected Makefile"
    if make ubuntu; then
      echo "[INFO] make ubuntu succeeded"
    else
      echo "[WARN] make ubuntu failed, retrying make"
      make
    fi
  else
    echo "[ERROR] No known build entrypoint found (build.sh / Makefile)."
    echo "[ERROR] Please update scripts/build_corstone1000_ubuntu.sh to match upstream layout."
    exit 1
  fi
}

collect_outputs() {
  local copied=false
  for d in build output out; do
    if [[ -d "$SRC_DIR/$d" ]]; then
      echo "[INFO] Copying $SRC_DIR/$d -> $OUT_DIR/$d"
      rm -rf "$OUT_DIR/$d"
      cp -a "$SRC_DIR/$d" "$OUT_DIR/$d"
      copied=true
    fi
  done

  if [[ "$copied" == "false" ]]; then
    echo "[ERROR] Build finished, but no standard output directory found (build/output/out)."
    echo "[ERROR] This likely means the build did not produce expected artifacts."
    exit 1
  fi
}

verify_artifacts() {
  local required_paths=(
    "$OUT_DIR/build"
    "$OUT_DIR/output"
    "$OUT_DIR/out"
  )

  local any_found=false
  for p in "${required_paths[@]}"; do
    if [[ -d "$p" ]]; then
      any_found=true
      echo "[INFO] Found artifact directory: $p"
    fi
  done

  if [[ "$any_found" != "true" ]]; then
    echo "[ERROR] Verification failed: no artifact directory found under /work/out."
    exit 1
  fi

  echo "[INFO] Verification passed. Outputs are under $OUT_DIR"
}

copy_or_clone_source
run_build
collect_outputs
verify_artifacts
