# Corstone-1000 FVP Ubuntu Image：一步一步跑起來（實作版）


## 0) 你最後會拿到什麼

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

## 2) 找到專案資料夾

先看你現在在哪：

```bash
pwd
ls
```

常見路徑是：

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

## 3) 一鍵跑完整流程

```bash
./scripts/run_demo_with_logs.sh
```

它會自動做這些：

1. 記錄主機資訊
2. `docker build` 建 image
3. 啟動容器跑 build
4. 收集 `out/` 內容清單
5. 做基本輸出檢查

---

## 4) 想固定版本

```bash
CS1000FVP_REF=<commit-or-tag> ./scripts/run_demo_with_logs.sh
```

例如：

```bash
CS1000FVP_REF=abc1234 ./scripts/run_demo_with_logs.sh
```

---

## 5) 網路不能連 GitHub 時（本地 source 模式）

先把 source 放在：`./local-cs1000fvp`

然後跑：

```bash
docker build -t cs1000fvp-ubuntu-builder .
docker run --rm -it \
  -v "$(pwd)/local-cs1000fvp:/input-src" \
  -v "$(pwd)/out:/work/out" \
  -e CS1000FVP_LOCAL_SRC=/input-src \
  cs1000fvp-ubuntu-builder
```

---

## 6) 確認有跑成功

看這三個檔：

- `demo-logs/<timestamp>/run.log`
- `demo-logs/<timestamp>/host-environment.txt`
- `demo-logs/<timestamp>/output-files.txt`

再看 `out/` 有沒有產物。

---

## 7) 

```bash
script -f demo-logs/manual-terminal.typescript
# 在這裡輸入你的 demo 指令
# 完成後輸入 exit
```

---

## 8) 

```bash
git add .
git commit -m "Add reproducible Corstone-1000 run guide"
git push origin <你的分支>
```

開 PR

```bash
gh pr create --fill
```
