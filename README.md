# 🛠️ Auggie CLI × BMad-Method 集成指南

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/jodykwong/auggie-bmad-integration/releases)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)](https://github.com/jodykwong/auggie-bmad-integration)
[![Node.js](https://img.shields.io/badge/node-%3E%3D22.0.0-brightgreen.svg)](https://nodejs.org/)

这个项目提供了 **Auggie CLI** 与 **BMad-Method** 集成的完整解决方案，包括详细的操作指南和配置文件示例。通过这个集成方案，你可以在项目中同时享受 AI 驱动的智能代码审查和结构化开发方法论的双重保障。

## ✨ 特性

- 🤖 **AI 驱动的代码审查** - 集成 Auggie CLI 的智能分析能力
- 🧠 **结构化开发方法论** - 遵循 BMad-Method 最佳实践
- 🚀 **一键安装** - 跨平台自动化安装脚本
- 🔄 **CI/CD 集成** - 完整的 GitHub Actions 工作流
- 📊 **智能报告** - 自动生成详细的分析报告
- 🎨 **美观文档** - 交互式 HTML 文档界面
- 🔧 **高度可配置** - 灵活的配置选项适应不同需求
- 📱 **跨平台支持** - Linux、macOS、Windows 全平台支持

## 📋 项目结构

```
auggie-bmad-integration/
├── README.md                                   # 项目说明文档
├── setup.sh                                   # 自动安装脚本 (Linux/macOS)
├── setup.bat                                  # 自动安装脚本 (Windows)
├── auggie-bmad-integration-guide.html          # 详细的集成操作指南（HTML 页面）
├── auggie-bmad-integration-report.html         # 集成可行性调研报告（HTML 页面）
└── bmad-integration-config-examples/           # 配置文件示例
    ├── bmad-config.js                          # 主配置文件
    ├── .augment/
    │   └── rules/
    │       └── bmad-integration.md             # 集成规则文件
    ├── .github/
    │   └── workflows/
    │       └── bmad-auggie-integration.yml     # GitHub Actions 工作流
    └── scripts/
        └── generate-integrated-report.js       # 报告生成脚本
```

## 🚀 快速开始

### 方法一：使用自动安装脚本（推荐）

#### Linux/macOS 用户
```bash
# 进入 auggie-bmad-integration 目录
cd auggie-bmad-integration

# 运行安装脚本（将配置文件复制到上级目录）
./setup.sh

# 或者指定目标目录
./setup.sh /path/to/your/project
```

#### Windows 用户
```cmd
# 进入 auggie-bmad-integration 目录
cd auggie-bmad-integration

# 运行安装脚本
setup.bat

# 或者指定目标目录
setup.bat "C:\path\to\your\project"
```

### 方法二：手动复制配置文件

#### 1. 查看集成指南

打开 `auggie-bmad-integration-guide.html` 文件，这是一个美观的 HTML 页面，包含了三个关键步骤的详细操作方法：

- **步骤 2**: 配置集成规则
- **步骤 3**: 工作流配置
- **步骤 4**: CI/CD 集成

#### 2. 使用配置文件示例

`bmad-integration-config-examples/` 目录包含了所有必要的配置文件：

```bash
# 复制主配置文件
cp bmad-integration-config-examples/bmad-config.js ./

# 复制规则文件
mkdir -p .augment/rules
cp bmad-integration-config-examples/.augment/rules/bmad-integration.md .augment/rules/

# 复制 GitHub Actions 工作流
mkdir -p .github/workflows
cp bmad-integration-config-examples/.github/workflows/bmad-auggie-integration.yml .github/workflows/

# 复制脚本文件
mkdir -p scripts
cp bmad-integration-config-examples/scripts/generate-integrated-report.js scripts/
```

### 3. 安装依赖

```bash
# 安装 Node.js 22+
node --version  # 确保 >= 22.0.0

# 安装 Auggie CLI
npm install -g @augmentcode/auggie

# 安装 BMad-Method
npx bmad-method install

# 验证安装
auggie --version
bmad-method --version
```

### 4. 配置环境变量

在 GitHub 仓库设置中添加以下 Secrets：

```bash
AUGGIE_API_KEY=your_auggie_api_key_here
BMAD_LICENSE_KEY=your_bmad_license_key_here

# 可选的通知配置
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASS=your_app_password
```

## 📖 详细文档

### 集成可行性报告
打开 `auggie-bmad-integration-report.html` 查看完整的集成可行性调研报告，包括：
- 工具概述
- 技术架构兼容性分析
- 集成方式说明
- 潜在问题和解决方案
- 实施建议

### 操作指南
打开 `auggie-bmad-integration-guide.html` 查看详细的操作指南，包括：
- 配置集成规则的具体步骤
- 工作流配置的详细说明
- CI/CD 集成的完整实现
- 常见问题和解决方案

## 🔧 配置说明

### bmad-config.js
主配置文件，包含：
- 项目基本信息
- 集成配置选项
- 触发器设置
- 环境特定配置
- 通知配置

### .augment/rules/bmad-integration.md
集成规则文件，定义：
- 代码审查标准
- BMad-Method 特定规则
- 安全和性能要求
- 检查清单

### .github/workflows/bmad-auggie-integration.yml
GitHub Actions 工作流，实现：
- 自动化环境准备
- 代码质量检查
- BMad-Method 验证
- Auggie CLI 审查
- 集成报告生成

## 🎯 功能特性

### ✅ 已实现功能
- [x] 完整的配置文件模板
- [x] 详细的操作指南
- [x] GitHub Actions 工作流
- [x] 自动化报告生成
- [x] 多环境支持
- [x] 错误处理和恢复
- [x] 美观的 HTML 文档

### 🔄 集成优势
- **AI 驱动**: Auggie CLI 提供智能代码审查
- **方法论支持**: BMad-Method 确保架构合规
- **自动化**: 完全自动化的 CI/CD 集成
- **可定制**: 灵活的配置选项
- **多环境**: 支持开发、测试、生产环境
- **报告生成**: 自动生成详细的审查报告

## 🚨 注意事项

1. **Node.js 版本**: 确保使用 Node.js 22+ 版本
2. **API 密钥**: 正确配置 Auggie CLI 和 BMad-Method 的 API 密钥
3. **权限设置**: 确保 GitHub Actions 有足够的权限
4. **超时配置**: 根据项目大小调整超时设置
5. **缓存策略**: 合理配置缓存以提高性能

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个集成方案。

## 📄 许可证

MIT License

## 🤝 贡献

我们欢迎社区贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何参与项目开发。

### 贡献方式
- 🐛 报告 Bug
- ✨ 提出新功能
- 📖 改进文档
- 🧪 添加测试
- 🔧 优化代码

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)。

## 📞 支持

如果在使用过程中遇到问题，请：

1. 📖 查看详细的 HTML 文档
2. 🔍 搜索 [现有 Issues](https://github.com/jodykwong/auggie-bmad-integration/issues)
3. 🆕 创建新的 [Issue](https://github.com/jodykwong/auggie-bmad-integration/issues/new)
4. 📧 查看 [FAQ 和故障排除](DEMO.md#常见问题和解决方案)

## 📊 项目统计

- ⭐ **GitHub Stars**: 欢迎 Star 支持项目
- 🍴 **Forks**: 欢迎 Fork 和贡献
- 📥 **Downloads**: 查看 [Releases](https://github.com/jodykwong/auggie-bmad-integration/releases)
- 🐛 **Issues**: 查看 [Issues](https://github.com/jodykwong/auggie-bmad-integration/issues)

## 🔗 相关链接

- [Auggie CLI 官方文档](https://docs.augmentcode.com/cli)
- [BMad-Method 项目](https://github.com/bmad-code-org/BMAD-METHOD)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

---

**🎉 祝你使用愉快！这个集成方案将为你的项目带来 AI 驱动的代码质量保证和结构化的开发方法论支持。**

<div align="center">
  <strong>如果这个项目对你有帮助，请给我们一个 ⭐ Star！</strong>
</div>
