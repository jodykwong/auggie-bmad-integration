# 🚀 Auggie CLI × BMad-Method 快速参考

## 📋 快速开始清单

### ✅ 新项目集成步骤

```bash
# 1. 克隆集成框架
git clone https://github.com/jodykwong/auggie-bmad-integration.git
cd auggie-bmad-integration

# 2. 运行项目初始化向导
./scripts/project-init.sh

# 3. 安装到你的项目
./setup.sh /path/to/your/project

# 4. 验证安装
cd /path/to/your/project
./verify-setup.sh
```

---

## 🔧 常用命令

### 安装和验证
```bash
# 安装核心工具
npm install -g @augmentcode/auggie
npx bmad-method install

# 验证安装
auggie --version
bmad-method --version

# 验证项目配置
./verify-setup.sh
```

### 代码审查
```bash
# 运行 Auggie CLI 审查
auggie --rules .augment/rules

# 只检查安全规则
auggie --rules .augment/rules/security-rules.md

# 干运行（不实际执行）
auggie --rules .augment/rules --dry-run

# 详细输出
auggie --rules .augment/rules --verbose
```

### BMad-Method 验证
```bash
# 验证项目结构
bmad-method validate

# 使用特定配置文件
bmad-method validate --config bmad-config.js

# 更新知识库
bmad-method update-kb

# 生成报告
bmad-method report --format=json
```

### 集成报告
```bash
# 生成综合报告
node scripts/generate-integrated-report.js \
  --bmad-report bmad-report.json \
  --auggie-reports ./reports/ \
  --output integrated-report.md
```

---

## ⚙️ 配置文件快速参考

### bmad-config.js 关键配置

```javascript
module.exports = {
  project: {
    name: 'your-project-name',
    type: 'nodejs|python|java|rust|go',
    language: 'javascript|python|java|rust|go'
  },
  
  integrations: {
    auggie: {
      enabled: true,
      rules: [
        '.augment/rules/bmad-integration.md',
        '.augment/rules/security-rules.md',
        '.augment/rules/performance-rules.md'
      ],
      
      triggers: {
        'pre-commit': { enabled: true, failOnError: true },
        'pre-push': { enabled: true, failOnError: true },
        'pr-review': { enabled: true, failOnError: false }
      },
      
      options: {
        contextEngine: true,
        autoFix: false,
        reportFormat: 'markdown',
        verbose: false,
        concurrency: 4
      }
    }
  }
};
```

### 环境变量 (.env)

```bash
# 必需的 API 密钥
AUGGIE_API_KEY=your_auggie_api_key_here
BMAD_LICENSE_KEY=your_bmad_license_key_here

# 可选配置
NODE_ENV=development
AUGGIE_CACHE_DIR=.augment/cache
BMAD_CONFIG_PATH=bmad-config.js
```

---

## 📁 目录结构

```
your-project/
├── bmad-config.js                    # 主配置文件
├── .env                             # 环境变量（不要提交）
├── .env.example                     # 环境变量模板
├── .augment/
│   ├── rules/
│   │   ├── bmad-integration.md      # BMad 集成规则
│   │   ├── security-rules.md        # 安全规则
│   │   ├── performance-rules.md     # 性能规则
│   │   └── [project-type]-rules.md  # 项目特定规则
│   ├── config/
│   │   └── rule-config.json         # 规则配置
│   └── cache/                       # 缓存目录
├── .github/
│   └── workflows/
│       └── bmad-auggie-integration.yml  # CI/CD 工作流
├── scripts/
│   └── generate-integrated-report.js   # 报告生成脚本
└── verify-setup.sh                     # 验证脚本
```

---

## 🎯 项目类型特定配置

### Node.js 项目

```javascript
// bmad-config.js 中的特定配置
project: {
  type: 'nodejs',
  language: 'javascript',
  framework: 'express|nestjs|react|vue'
},

options: {
  excludePatterns: [
    'node_modules/**',
    'dist/**',
    'build/**',
    '*.min.js'
  ],
  includePatterns: [
    'src/**/*.js',
    'src/**/*.ts',
    'lib/**/*.js'
  ]
}
```

```json
// package.json 中添加的脚本
{
  "scripts": {
    "auggie:check": "auggie --rules .augment/rules --quiet",
    "bmad:validate": "bmad-method validate",
    "quality:check": "npm run auggie:check && npm run bmad:validate"
  }
}
```

### Python 项目

```javascript
// bmad-config.js 中的特定配置
project: {
  type: 'python',
  language: 'python',
  framework: 'django|flask|fastapi'
},

options: {
  excludePatterns: [
    'venv/**',
    '__pycache__/**',
    '*.pyc',
    'dist/**'
  ],
  includePatterns: [
    'src/**/*.py',
    'app/**/*.py',
    'tests/**/*.py'
  ]
}
```

### Java 项目

```javascript
// bmad-config.js 中的特定配置
project: {
  type: 'java',
  language: 'java',
  framework: 'maven|gradle'
},

options: {
  excludePatterns: [
    'target/**',
    'build/**',
    '*.class',
    '.gradle/**'
  ],
  includePatterns: [
    'src/**/*.java',
    'test/**/*.java'
  ]
}
```

---

## 🔄 GitHub Actions 工作流

### 触发条件
- Pull Request 到 main/develop 分支
- Push 到 main/develop 分支
- 手动触发

### 主要阶段
1. **环境准备** - 安装 Node.js、Auggie CLI、BMad-Method
2. **代码质量检查** - Lint、格式检查、构建、测试
3. **BMad 验证** - 项目结构和方法论验证
4. **Auggie 审查** - AI 驱动的代码审查
5. **集成报告** - 生成综合报告和 PR 评论

### 必需的 GitHub Secrets
```bash
AUGGIE_API_KEY=your_auggie_api_key_here
BMAD_LICENSE_KEY=your_bmad_license_key_here
```

---

## 🐛 故障排除

### 常见问题

#### 1. Node.js 版本不兼容
```bash
# 错误: Auggie CLI requires Node.js >= 22.0.0
nvm install 22
nvm use 22
```

#### 2. Auggie CLI 安装失败
```bash
# 清除缓存重试
npm cache clean --force
npm install -g @augmentcode/auggie --verbose
```

#### 3. API 密钥未配置
```bash
# 设置环境变量
export AUGGIE_API_KEY=your_key_here
export BMAD_LICENSE_KEY=your_key_here

# 或在 .env 文件中配置
echo "AUGGIE_API_KEY=your_key_here" >> .env
```

#### 4. 权限问题
```bash
# 给脚本添加执行权限
chmod +x setup.sh
chmod +x verify-setup.sh
```

#### 5. 配置文件语法错误
```bash
# 验证 JavaScript 语法
node -c bmad-config.js

# 验证 JSON 语法
node -e "JSON.parse(require('fs').readFileSync('.augment/config/rule-config.json', 'utf8'))"
```

---

## 📊 验证和测试

### 基本验证
```bash
# 运行完整验证
./verify-setup.sh

# 检查工具版本
node --version    # >= 22.0.0
auggie --version
bmad-method --version
```

### 功能测试
```bash
# 测试 Auggie CLI
echo "console.log('test');" > test.js
auggie --rules .augment/rules/security-rules.md test.js
rm test.js

# 测试 BMad-Method
bmad-method validate --dry-run

# 测试配置加载
node -e "console.log(require('./bmad-config.js'))"
```

---

## 🎨 自定义规则

### 创建自定义规则文件
```bash
# 创建新规则文件
cat > .augment/rules/custom-rules.md << 'EOF'
# 自定义规则

## 代码风格
- 使用一致的缩进
- 添加有意义的注释

## 业务逻辑
- 验证业务规则
- 确保数据一致性
EOF
```

### 在配置中启用自定义规则
```javascript
// bmad-config.js
integrations: {
  auggie: {
    rules: [
      '.augment/rules/bmad-integration.md',
      '.augment/rules/security-rules.md',
      '.augment/rules/custom-rules.md'  // 添加自定义规则
    ]
  }
}
```

---

## 📞 获取帮助

### 文档资源
- 📖 [完整实施指南](PROJECT_IMPLEMENTATION_GUIDE.md)
- 🎬 [演示教程](DEMO.md)
- 🤝 [贡献指南](CONTRIBUTING.md)

### 命令帮助
```bash
auggie --help
bmad-method --help
node scripts/generate-integrated-report.js --help
```

### 在线资源
- [Auggie CLI 文档](https://docs.augmentcode.com/cli)
- [BMad-Method 项目](https://github.com/bmad-code-org/BMAD-METHOD)
- [GitHub Issues](https://github.com/jodykwong/auggie-bmad-integration/issues)

---

**💡 提示**: 将此文件保存为书签，随时查阅常用命令和配置！
