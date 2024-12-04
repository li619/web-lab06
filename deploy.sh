#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

echo "开始部署..."

# 删除旧的 dist 目录
rm -rf dist

# 构建
npm run build

# 进入构建输出目录
cd dist

# 初始化 git 仓库
git init

# 配置 Git（使用你的 GitHub 用户名和邮箱）
git config user.name "li619"
git config user.email "你的GitHub邮箱"

# 添加所有文件
git add -A

# 提交更改
git commit -m "deploy to gh-pages"

# 推送到 gh-pages 分支
git push -f https://github.com/li619/web-lab06.git master:gh-pages

cd -

echo "部署完成!"