# 作業提交與 Demo 操作指南（給老師）

> 目的：讓老師可以**一步一步重現**你在 Corstone-1000 Armv9-A FVP Ubuntu image 建置流程，並看見你「環境資訊、操作過程、結果證據」。

## 0. 你會交出去的內容

1. 原始碼（此 repo）
2. 自動化腳本：`scripts/run_demo_with_logs.sh`
3. 執行紀錄（執行後產生）：
   - `demo-logs/<timestamp>/run.log`
   - `demo-logs/<timestamp>/host-environment.txt`
   - `demo-logs/<timestamp>/output-files.txt`
4. 建置產物（執行後產生）：`out/`

---

## 1. 前置需求

- Linux 主機（建議 Ubuntu 22.04 或相近）
- Docker 已安裝且可執行：
  - `docker --version` 能成功
  - 使用者可執行 docker（可能需要在 `docker` 群組）
- 可連到 GitHub（若使用線上 clone 模式）

---

## 2. 取得原始碼（含你這次修改）

### 如果你不知道「資料夾在哪」

先在終端機輸入：

```bash
pwd
ls
```

本作業環境常見的專案路徑是：

```text
/workspace/1
```

可直接進去：

```bash
cd /workspace/1
ls
```

應該會看到 `Dockerfile`、`README.md`、`scripts/`、`docs/`。

如果老師要直接從 GitHub 取得：

```bash
git clone <你的-repo-url>
cd <repo-folder>
```

如果老師在你本機檢查，直接進入專案目錄即可。

---

## 3. 一鍵執行（推薦）

直接跑：

```bash
./scripts/run_demo_with_logs.sh
```

這個腳本會自動做：

1. 紀錄主機環境（OS、kernel、docker 版本）
2. 建立 Docker image
3. 啟動容器執行 build
4. 擷取 `out/` 底下輸出檔案清單
5. 檢查是否有 `build/`、`output/`、`out/` 任一輸出資料夾

---

## 4. 若要固定版本（保證可重現）

建議指定 commit/tag：

```bash
CS1000FVP_REF=<commit-or-tag> ./scripts/run_demo_with_logs.sh
```

這樣可避免上游 branch 更新造成結果漂移。

---

## 5. 若學校網路不能連 GitHub

可改用本地 source（先手動準備好 `local-cs1000fvp`）：

```bash
docker build -t cs1000fvp-ubuntu-builder .
docker run --rm -it \
  -v "$(pwd)/local-cs1000fvp:/input-src" \
  -v "$(pwd)/out:/work/out" \
  -e CS1000FVP_LOCAL_SRC=/input-src \
  cs1000fvp-ubuntu-builder
```

---

## 6. Demo 證據檔案怎麼看

執行完成後，請看：

- `demo-logs/<timestamp>/run.log`：完整終端輸出（最重要）
- `demo-logs/<timestamp>/host-environment.txt`：環境規格證明
- `demo-logs/<timestamp>/output-files.txt`：輸出檔案清單

---

## 7. 你要求的「錄影」怎麼做

此 repo 提供「文字版錄製」（完整命令與結果）。

若要螢幕錄影（mp4），可用你電腦原生錄影工具（OBS、Kazam 等）。

若要終端錄製檔（typescript）：

```bash
script -f demo-logs/manual-terminal.typescript
# 接著手動輸入你 demo 指令
# 結束時輸入 exit
```

---

## 8. 上傳到 GitHub（你要「直接存進 GitHub」）

> 我在這個執行環境無法替你使用個人憑證直接 push 到你的帳號，但你可以在本機執行以下命令立即上傳。

```bash
git add .
git commit -m "Add reproducible demo logging and teacher step-by-step submission guide"
git push origin <你的分支>
```

若要開 PR：

```bash
# GitHub CLI（可選）
gh pr create --fill
```
