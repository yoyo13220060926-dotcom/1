# Corstone-1000 Armv9-A FVP Ubuntu Image Build (Docker)

你問「照著做能不能跑出正確結果」：

- **可以提高成功率，但我不會宣稱 100% 保證**。
- 真正是否「正確」，要以你實際跑出的 artifact 與上游專案說明比對。
- 這份流程提供：固定化容器環境、可指定 commit/ref、以及最基本的輸出驗證。

## 功能重點

- 用 Docker 建立可重現建置環境。
- 自動抓取 `https://github.com/heslabs/cs1000fvp`（或使用本地 source）。
- 在容器中嘗試常見建置入口：
  1. `./build.sh ubuntu`
  2. `./build.sh`
  3. `make ubuntu`
  4. `make`
- 將常見輸出目錄（`build/`、`output/`、`out/`）收集到 `/work/out`。
- 若沒有任何輸出目錄，腳本會 **直接失敗**（非僅警告）。

## 使用方式

### 1) 建立 Docker image

```bash
docker build -t cs1000fvp-ubuntu-builder .
```

### 2) 執行建置

```bash
docker run --rm -it \
  -v "$(pwd)/out:/work/out" \
  cs1000fvp-ubuntu-builder
```

## 參數

- `CS1000FVP_REPO`：預設 `https://github.com/heslabs/cs1000fvp`
- `CS1000FVP_BRANCH`：預設 `main`
- `CS1000FVP_REF`：可指定 tag/commit（建議用來固定結果）
- `CS1000FVP_LOCAL_SRC`：使用本地原始碼路徑（離線或內網環境建議）
- `VERIFY_ONLY=1`：僅做輸出結構驗證，不執行 build

### 範例：固定到特定 commit

```bash
docker run --rm -it \
  -e CS1000FVP_REF=<commit-or-tag> \
  -v "$(pwd)/out:/work/out" \
  cs1000fvp-ubuntu-builder
```

### 範例：使用本地 source

先把 source mount 進容器：

```bash
docker run --rm -it \
  -v "$(pwd)/local-cs1000fvp:/input-src" \
  -v "$(pwd)/out:/work/out" \
  -e CS1000FVP_LOCAL_SRC=/input-src \
  cs1000fvp-ubuntu-builder
```

## 注意事項

- 若上游專案更動建置入口或產物路徑，你仍需調整 `scripts/build_corstone1000_ubuntu.sh`。
- 若你要「跟某次 git 結果完全一致」，請一定要固定 `CS1000FVP_REF`，不要只用 branch。


## 一步一步跑起來（新手版）

請參考：`docs/RUN_GUIDE.md`。

若你要一次產生「環境資訊 + 操作紀錄 + 產物清單」，可直接執行：

```bash
./scripts/run_demo_with_logs.sh
```

## 卡在「資料夾在哪裡」的超新手版

如果你看到我寫 `cd <repo-folder>` 卻不知道要填什麼，請照這個順序做：

1. 先確認你目前在哪：

```bash
pwd
```

2. 看目前位置有哪些資料夾：

```bash
ls
```

3. 如果你有看到 `1` 這個資料夾（本作業常見在 `/workspace/1`），就進去：

```bash
cd /workspace/1
```

4. 再確認一次你真的進去了：

```bash
pwd
```

你應該會看到：

```text
/workspace/1
```

5. 確認這裡就是專案根目錄（要看到這些檔案）：

```bash
ls
```

至少要有：`Dockerfile`、`README.md`、`scripts/`、`docs/`。

6. 然後就可以開始做 GitHub 設定（remote / push）。
