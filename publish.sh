#!/bin/bash

# 🚀 GitHub 发布脚本
# 此脚本将帮助你快速发布项目到 GitHub

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 图标定义
CHECKMARK="✅"
CROSS="❌"
INFO="ℹ️"
WARNING="⚠️"
ROCKET="🚀"

echo -e "${BLUE}${ROCKET} Auggie CLI × BMad-Method Integration - GitHub 发布脚本${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# 检查是否在正确的目录中
if [ ! -f "README.md" ] || [ ! -f "package.json" ]; then
    echo -e "${RED}${CROSS} 错误: 请在 auggie-bmad-integration 目录中运行此脚本${NC}"
    exit 1
fi

# 检查 Git 是否已安装
if ! command -v git &> /dev/null; then
    echo -e "${RED}${CROSS} 错误: Git 未安装，请先安装 Git${NC}"
    exit 1
fi

echo -e "${INFO} 准备发布项目到 GitHub..."
echo ""

# 检查是否已经是 Git 仓库
if [ ! -d ".git" ]; then
    echo -e "${CYAN}初始化 Git 仓库...${NC}"
    git init
    echo -e "${GREEN}${CHECKMARK} Git 仓库已初始化${NC}"
else
    echo -e "${GREEN}${CHECKMARK} Git 仓库已存在${NC}"
fi

# 检查 Git 配置
echo -e "${CYAN}检查 Git 配置...${NC}"
if ! git config user.name &> /dev/null; then
    echo -e "${YELLOW}${WARNING} Git 用户名未配置${NC}"
    read -p "请输入你的 GitHub 用户名: " username
    git config --global user.name "$username"
fi

if ! git config user.email &> /dev/null; then
    echo -e "${YELLOW}${WARNING} Git 邮箱未配置${NC}"
    read -p "请输入你的邮箱地址: " email
    git config --global user.email "$email"
fi

echo -e "${GREEN}${CHECKMARK} Git 配置完成${NC}"
echo "  用户名: $(git config user.name)"
echo "  邮箱: $(git config user.email)"
echo ""

# 添加所有文件
echo -e "${CYAN}添加文件到 Git...${NC}"
git add .

# 检查是否有文件需要提交
if git diff --staged --quiet; then
    echo -e "${YELLOW}${WARNING} 没有新的文件需要提交${NC}"
else
    echo -e "${GREEN}${CHECKMARK} 文件已添加到暂存区${NC}"
fi

# 显示文件状态
echo -e "${INFO} 文件状态:"
git status --short

echo ""

# 创建提交
echo -e "${CYAN}创建提交...${NC}"
commit_message="feat: initial release of Auggie CLI × BMad-Method integration v1.0.0

🎉 Complete integration solution with automated setup
- Cross-platform installation scripts (Linux/macOS/Windows)
- Interactive HTML documentation and guides  
- GitHub Actions CI/CD workflow
- Comprehensive configuration files and examples
- Demo tutorial and troubleshooting guide

✨ Features:
- 🤖 AI-powered code review with Auggie CLI
- 🧠 Structured development methodology with BMad-Method
- 🚀 One-click automated setup
- 🔄 Complete CI/CD integration
- 📊 Intelligent reporting system
- 🎨 Beautiful interactive documentation
- 📱 Cross-platform support"

if git diff --staged --quiet; then
    echo -e "${YELLOW}${WARNING} 没有新的更改需要提交${NC}"
else
    git commit -m "$commit_message"
    echo -e "${GREEN}${CHECKMARK} 提交已创建${NC}"
fi

echo ""

# 检查远程仓库
if git remote get-url origin &> /dev/null; then
    echo -e "${GREEN}${CHECKMARK} 远程仓库已配置${NC}"
    echo "  远程仓库: $(git remote get-url origin)"
else
    echo -e "${YELLOW}${WARNING} 远程仓库未配置${NC}"
    echo -e "${INFO} 请先在 GitHub 上创建仓库: https://github.com/jodykwong"
    echo ""
    read -p "请输入你的 GitHub 仓库 URL (例: https://github.com/jodykwong/auggie-bmad-integration.git): " repo_url
    
    if [ -z "$repo_url" ]; then
        echo -e "${RED}${CROSS} 仓库 URL 不能为空${NC}"
        exit 1
    fi
    
    git remote add origin "$repo_url"
    echo -e "${GREEN}${CHECKMARK} 远程仓库已添加${NC}"
fi

echo ""

# 设置主分支
echo -e "${CYAN}设置主分支...${NC}"
git branch -M main
echo -e "${GREEN}${CHECKMARK} 主分支已设置为 main${NC}"

echo ""

# 推送到 GitHub
echo -e "${CYAN}推送到 GitHub...${NC}"
echo -e "${WARNING} 如果这是第一次推送，可能需要输入 GitHub 用户名和密码/token${NC}"
echo ""

if git push -u origin main; then
    echo ""
    echo -e "${GREEN}${CHECKMARK} 项目已成功推送到 GitHub！${NC}"
else
    echo ""
    echo -e "${RED}${CROSS} 推送失败${NC}"
    echo -e "${INFO} 可能的解决方案:"
    echo "  1. 检查网络连接"
    echo "  2. 确认 GitHub 仓库已创建"
    echo "  3. 检查 GitHub 用户名和密码/token"
    echo "  4. 如果使用 2FA，需要使用 Personal Access Token"
    exit 1
fi

echo ""
echo -e "${BLUE}================================================================${NC}"
echo -e "${GREEN}${ROCKET} 发布完成！${NC}"
echo ""
echo -e "${INFO} 接下来的步骤:"
echo "1. 访问你的 GitHub 仓库: https://github.com/jodykwong/auggie-bmad-integration"
echo "2. 创建第一个 Release (v1.0.0)"
echo "3. 添加仓库描述和标签"
echo "4. 启用 GitHub Pages (可选)"
echo "5. 分享你的项目！"
echo ""
echo -e "${YELLOW}💡 提示: 查看 PUBLISH_GUIDE.md 获取详细的发布后配置指南${NC}"
echo ""
echo -e "${GREEN}🎉 恭喜！你的项目现在已经在 GitHub 上了！${NC}"
