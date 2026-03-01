# CS300 FVP Ubuntu Image

## 0) 最終結果

1. 可重現的建置流程（Docker）
2. 建置輸出資料夾：`out/`
3. 執行紀錄：
   - `demo-logs/<timestamp>/run.log`
   - `demo-logs/<timestamp>/host-environment.txt`
   - `demo-logs/<timestamp>/output-files.txt`

---

## 1) 先確認環境

需要：

- Linux（Ubuntu 22.04 附近版本最穩）
- Docker 可用

先跑：

```bash
docker --version
```

如果這行失敗，先把 Docker 裝好再繼續。

---

## 2) 找到專案資料夾（最容易卡在這）

先看你現在在哪：

```bash
pwd
ls
```

這份作業常見路徑是：

```text
/workspace/1
```

直接進去：

```bash
cd /workspace/1
ls
```

看到下面這些就對了：

- `Dockerfile`
- `README.md`
- `scripts/`
- `docs/`

---

## 3) 一鍵跑完整流程（推薦）

```bash
./scripts/run_cs300_demo_with_logs.sh
```

它會自動做這些：

1. 記錄主機資訊
2. `docker build` 建 image
3. 啟動容器跑 build
4. 收集 `out/` 內容清單
5. 做基本輸出檢查

---

## 4) 固定版本

```bash
CS300FVP_REF=<commit-or-tag> ./scripts/run_cs300_demo_with_logs.sh
```

例如：

```bash
CS300FVP_REF=abc1234 ./scripts/run_cs300_demo_with_logs.sh
```

---

## 5) 網路不能連 GitHub 時（本地 source 模式）

先把 source 放在：`./local-cs300fvp`

然後跑：

```bash
docker build -t cs300fvp-ubuntu-builder .
docker run --rm -it \
  -v "$(pwd)/local-cs300fvp:/input-src" \
  -v "$(pwd)/out:/work/out" \
  -e CS300FVP_LOCAL_SRC=/input-src \
  cs300fvp-ubuntu-builder
```

---

## 6) 怎麼確認有跑成功

看這三個檔：

- `demo-logs/<timestamp>/run.log`（完整過程）
- `demo-logs/<timestamp>/host-environment.txt`（環境資訊）
- `demo-logs/<timestamp>/output-files.txt`（輸出清單）

再看 `out/` 有沒有產物。

---

## 7) 想錄 demo（終端版）

```bash
script -f demo-logs/manual-terminal.typescript
# 在這裡輸入你的 demo 指令
# 完成後輸入 exit
```

---

## 8) 上傳到 GitHub

```bash
git add .
git commit -m "Add reproducible CS300 run guide"
git push origin <你的分支>
```

要開 PR（可選）：

```bash
gh pr create --fill
```
