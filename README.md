# Arm FVP Docker Run & Output（

> cs1000fvp（Corstone-1000 / Armv9-A）建立 Ubuntu Linux image 並可在 FVP 相關流程中使用

## 1. 環境
- OS：Windows 11
- Docker：Docker Desktop（建議已啟用 WSL2 backend）
- 其他：Git

## 2. 一鍵重現
```bash
git clone https://github.com/yoyo13220060926-dotcom/1.git
cd 1

# 如果你是用 Dockerfile 建 image：
docker build -t fvp-lab .

# 依 repo 提供的腳本跑（以你的實際腳本為準）
bash scripts/run_demo_with_logs.sh
