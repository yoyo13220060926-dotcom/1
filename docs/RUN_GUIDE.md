# CS300 FVP Ubuntu Image：一步一步跑起來（實作版）

> 這份就是「照做就能跑」的版本，不講場面話。

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

## 4) 想固定版本（避免每次結果飄掉）

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


---

## 9) Mac 使用者：從 0 建立可繳交的 GitHub 專案（照著做）

這段是給你現在這種情況：你在 mac，要把這份 CS300FVP 專案交到 GitHub。

### Step A：先安裝必要工具（只要做一次）

1. 安裝 Homebrew（如果你還沒有）：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. 安裝 Git（通常 mac 有，但保險起見）：

```bash
brew install git
```

3. 安裝 Docker Desktop（mac 版）：
- 到 Docker 官網下載 Docker Desktop for Mac 並安裝。
- 安裝後打開 Docker Desktop，等它右上角變成 Running。

4. 驗證工具有沒有好：

```bash
git --version
docker --version
```

### Step B：把專案抓到你的 Mac

如果你是從 GitHub 下載這個 repo：

```bash
cd ~/Desktop
git clone <你的-repo-url>
cd <repo-folder>
```

如果你是把檔案手動放在某個資料夾，就直接 `cd` 到那個資料夾。

確認位置：

```bash
pwd
ls
```

要看得到：`Dockerfile`、`README.md`、`scripts/`、`docs/`。

### Step C：在 Mac 先本地測一次（避免交上去才爆）

```bash
docker build -t cs300fvp-ubuntu-builder .
./scripts/run_cs300_demo_with_logs.sh
```

跑完後看：

```bash
ls out
ls demo-logs
```

### Step D：在 GitHub 建「可繳交」新 repo

1. 登入 GitHub。
2. 右上角 `+` → **New repository**。
3. Repository name 例如：`cs300fvp-assignment`。
4. 選 Public 或 Private（看課程要求）。
5. **不要勾** `Add a README`、`.gitignore`、`license`（避免衝突）。
6. 按 **Create repository**。

建立後會看到 repo URL（HTTPS 像 `https://github.com/你帳號/你repo.git`）。

### Step E：把你本機專案推上去

先設定你的 Git 身分（只要做一次）：

```bash
git config --global user.name "你的名字"
git config --global user.email "你的GitHub信箱"
```

然後在專案根目錄執行：

```bash
git remote -v
git branch --show-current
```

如果還沒有 remote，加入：

```bash
git remote add origin <你的-github-repo-url>
```

推送目前分支（假設你在 `work`）：

```bash
git push -u origin work
```

### Step F：如果 push 卡住，照這個排除

1. `remote origin already exists`

```bash
git remote set-url origin <你的-github-repo-url>
```

2. GitHub 認證失敗（密碼不行）
- 改用 Personal Access Token (PAT) 當密碼。
- GitHub: Settings → Developer settings → Personal access tokens → Generate token（勾 `repo` 權限）。

3. `src refspec main does not match any`
- 你現在不是 main，改推你當前分支（例如 `work`）：

```bash
git push -u origin work
```

### Step G：交作業建議附這些

- GitHub repo 連結
- `demo-logs/<timestamp>/run.log`
- `demo-logs/<timestamp>/host-environment.txt`
- `demo-logs/<timestamp>/output-files.txt`
- `out/` 產物清單
