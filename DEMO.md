# 🎬 Auggie CLI × BMad-Method 集成演示

这个演示将展示如何使用我们提供的集成方案。

## 📋 演示步骤

### 1. 准备演示环境

```bash
# 创建一个测试项目
mkdir demo-project
cd demo-project

# 初始化 npm 项目
npm init -y

# 创建一些示例代码文件
mkdir src
echo "console.log('Hello World');" > src/index.js
echo "# Demo Project" > README.md
```

### 2. 安装集成配置

```bash
# 从 auggie-bmad-integration 目录运行安装脚本
cd ../auggie-bmad-integration
./setup.sh ../demo-project

# 或者在 Windows 上
# setup.bat "..\demo-project"
```

### 3. 验证安装结果

安装完成后，你的项目结构应该如下：

```
demo-project/
├── package.json
├── README.md
├── src/
│   └── index.js
├── bmad-config.js                              # ✅ 已安装
├── .augment/
│   ├── rules/
│   │   ├── bmad-integration.md                 # ✅ 已安装
│   │   ├── security-rules.md                   # ✅ 已安装
│   │   └── performance-rules.md                # ✅ 已安装
│   └── config/
│       └── rule-config.json                    # ✅ 已安装
├── .github/
│   └── workflows/
│       └── bmad-auggie-integration.yml         # ✅ 已安装
└── scripts/
    └── generate-integrated-report.js           # ✅ 已安装
```

### 4. 安装必要的依赖

```bash
cd ../demo-project

# 安装 Auggie CLI
npm install -g @augmentcode/auggie

# 安装 BMad-Method
npx bmad-method install

# 验证安装
auggie --version
bmad-method --version
```

### 5. 测试配置

```bash
# 测试 Auggie CLI 规则
auggie --rules .augment/rules --dry-run

# 测试 BMad-Method 验证
bmad-method validate

# 查看配置文件
cat bmad-config.js
```

### 6. 模拟 CI/CD 流程

```bash
# 创建一个 Git 仓库
git init
git add .
git commit -m "feat: initial commit with Auggie-BMad integration"

# 推送到 GitHub（需要先创建远程仓库）
# git remote add origin https://github.com/username/demo-project.git
# git push -u origin main
```

### 7. 查看 GitHub Actions

推送代码后，GitHub Actions 将自动运行集成工作流：

1. **环境准备** - 安装 Node.js、Auggie CLI、BMad-Method
2. **代码质量检查** - 运行 lint、测试、构建
3. **BMad 验证** - 验证项目符合 BMad-Method 标准
4. **Auggie 审查** - AI 驱动的代码审查
5. **集成报告** - 生成综合报告和 PR 评论

## 🎯 预期结果

### 成功的集成应该显示：

- ✅ 所有配置文件正确安装
- ✅ Auggie CLI 和 BMad-Method 正常工作
- ✅ GitHub Actions 工作流成功运行
- ✅ 生成详细的代码审查报告
- ✅ PR 中自动添加审查评论

### 可能的问题和解决方案：

#### 问题 1: Node.js 版本不兼容
```bash
# 解决方案：升级到 Node.js 22+
nvm install 22
nvm use 22
```

#### 问题 2: Auggie CLI 安装失败
```bash
# 解决方案：检查网络连接和权限
npm install -g @augmentcode/auggie --verbose
```

#### 问题 3: GitHub Actions 权限不足
```bash
# 解决方案：在 GitHub 仓库设置中添加必要的 Secrets
# AUGGIE_API_KEY
# BMAD_LICENSE_KEY
```

## 📊 演示指标

成功的演示应该达到以下指标：

- **安装时间**: < 2 分钟
- **配置验证**: 无错误
- **CI/CD 运行**: < 5 分钟
- **报告生成**: 包含详细的分析结果

## 🎉 演示完成

恭喜！你已经成功演示了 Auggie CLI 与 BMad-Method 的集成。

这个集成方案为你的项目提供了：
- 🤖 AI 驱动的智能代码审查
- 🧠 结构化的开发方法论支持
- 🔄 完全自动化的 CI/CD 集成
- 📊 详细的质量报告和建议

## 📞 获取帮助

如果在演示过程中遇到问题：

1. 查看 `auggie-bmad-integration-guide.html` 详细文档
2. 检查 GitHub Actions 日志
3. 验证环境变量和配置文件
4. 确保所有依赖正确安装

---

**Happy Coding! 🚀**
