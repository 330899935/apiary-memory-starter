#!/bin/bash
# 一键建仓 + 推送 —— 触角准备好，最后这一按留老铁。
# 用法：cd 本目录 && ./publish.sh
# 前置：gh auth login 已完成（当前账号 330899935）。
set -euo pipefail

cd "$(dirname "$0")"
REPO="330899935/apiary-memory-starter"
URL="https://github.com/${REPO}.git"

echo "1/3 再跑一次自检"
./check.sh

echo "2/3 确认仓库状态"
git status --short

echo "3/3 建仓并推送"
if gh repo view "$REPO" >/dev/null 2>&1; then
    echo "仓库已存在 → 只推送"
    git remote get-url origin >/dev/null 2>&1 || git remote add origin "$URL"
    git push -u origin main
else
    gh repo create "$REPO" \
        --public \
        --description "Clone this, 30 seconds to see approve before/after. MIT MCP layer, fake data only." \
        --source=. \
        --remote=origin \
        --push
fi

echo ""
echo "已上线：https://github.com/${REPO}"
echo "下一步：官网 /start 加尝试链接（?src=gh），并记录 GitHub traffic 基线（只留 14 天）。"
