# 🚀 Auggie CLI × BMad-Method 集成框架实施指南

这个指南将帮助你在新的软件开发项目中正确应用 Auggie CLI × BMad-Method 集成框架。

## 📋 目录

1. [项目初始化阶段](#1-项目初始化阶段)
2. [依赖工具和软件包安装](#2-依赖工具和软件包安装)
3. [配置 bmad-config.js](#3-配置-bmad-configjs)
4. [设置规则文件](#4-设置规则文件)
5. [配置 GitHub Actions](#5-配置-github-actions)
6. [不同项目类型的特殊考虑](#6-不同项目类型的特殊考虑)
7. [验证安装和配置](#7-验证安装和配置)
8. [故障排除](#8-故障排除)

---

## 1. 项目初始化阶段

### 1.1 创建新项目

```bash
# 创建项目目录
mkdir my-new-project
cd my-new-project

# 初始化项目（根据项目类型选择）
# Node.js 项目
npm init -y

# Python 项目
python -m venv venv
source venv/bin/activate  # Linux/macOS
# venv\Scripts\activate   # Windows

# Java 项目
mvn archetype:generate -DgroupId=com.example -DartifactId=my-project

# 初始化 Git 仓库
git init
```

### 1.2 应用集成框架

```bash
# 方法一：从 GitHub 克隆集成框架
git clone https://github.com/jodykwong/auggie-bmad-integration.git temp-integration
cd temp-integration

# 运行安装脚本到你的项目
./setup.sh ../my-new-project

# 清理临时文件
cd ..
rm -rf temp-integration

# 方法二：手动下载并解压
# 下载 Release 包并解压到项目目录
```

### 1.3 验证初始安装

```bash
cd my-new-project

# 检查文件结构
ls -la
# 应该看到：
# - bmad-config.js
# - .augment/ 目录
# - .github/workflows/ 目录
# - scripts/ 目录
```

---

## 2. 依赖工具和软件包安装

### 2.1 系统要求

```bash
# 检查 Node.js 版本（必须 >= 22.0.0）
node --version

# 如果版本不够，安装最新版本
# 使用 nvm（推荐）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 22
nvm use 22

# 或直接从官网下载：https://nodejs.org/
```

### 2.2 安装核心工具

```bash
# 安装 Auggie CLI
npm install -g @augmentcode/auggie

# 验证安装
auggie --version
# 预期输出：Auggie CLI version x.x.x

# 安装 BMad-Method
npx bmad-method install

# 验证安装
bmad-method --version
# 预期输出：BMad-Method version x.x.x
```

### 2.3 安装项目依赖

```bash
# 安装报告生成依赖
npm install --save-dev commander

# 如果是 TypeScript 项目
npm install --save-dev typescript @types/node

# 如果需要代码格式化
npm install --save-dev prettier eslint
```

### 2.4 配置环境变量

```bash
# 创建 .env 文件（不要提交到 Git）
cat > .env << 'EOF'
# Auggie CLI 配置
AUGGIE_API_KEY=your_auggie_api_key_here
AUGGIE_CACHE_DIR=.augment/cache

# BMad-Method 配置
BMAD_LICENSE_KEY=your_bmad_license_key_here
BMAD_CONFIG_PATH=bmad-config.js

# 环境配置
NODE_ENV=development
EOF

# 添加到 .gitignore
echo ".env" >> .gitignore
```

---

## 3. 配置 bmad-config.js

### 3.1 基础配置模板

```javascript
// bmad-config.js - 根据你的项目需求定制
module.exports = {
  // 项目基本信息
  project: {
    name: 'my-new-project',                    // 替换为你的项目名
    version: '1.0.0',
    description: '项目描述',                   // 替换为你的项目描述
    repository: 'https://github.com/username/my-new-project',  // 替换为你的仓库
    type: 'nodejs',                           // 项目类型：nodejs, python, java, react, vue 等
    language: 'javascript'                    // 主要编程语言
  },

  // 集成配置
  integrations: {
    auggie: {
      enabled: true,
      
      // 根据项目类型调整规则
      rules: [
        '.augment/rules/bmad-integration.md',
        '.augment/rules/security-rules.md',
        '.augment/rules/performance-rules.md',
        // 根据项目类型添加特定规则
        // '.augment/rules/nodejs-rules.md',     // Node.js 项目
        // '.augment/rules/python-rules.md',     // Python 项目
        // '.augment/rules/java-rules.md',       // Java 项目
      ],
      
      // 触发器配置 - 根据团队需求调整
      triggers: {
        'pre-commit': {
          enabled: true,
          rules: ['security-rules'],           // 提交前只检查安全问题
          failOnError: true,
          timeout: 30000
        },
        'pre-push': {
          enabled: true,
          rules: ['bmad-integration', 'security-rules'],
          failOnError: true,
          timeout: 60000
        },
        'pr-review': {
          enabled: true,
          rules: ['bmad-integration', 'security-rules', 'performance-rules'],
          failOnError: false,                  // PR 不阻塞，仅提供建议
          timeout: 120000
        }
      },
      
      // Auggie CLI 选项 - 根据项目规模调整
      options: {
        contextEngine: true,
        autoFix: false,                       // 生产项目建议设为 false
        reportFormat: 'markdown',
        verbose: process.env.NODE_ENV === 'development',
        concurrency: 4,                       // 根据 CI 环境调整
        
        cache: {
          enabled: true,
          ttl: 3600000,                       // 1小时缓存
          directory: '.augment/cache'
        }
      }
    }
  },

  // 工作流配置 - 根据开发流程定制
  workflows: {
    codeReview: {
      name: '代码审查工作流',
      steps: [
        {
          name: 'BMad 验证',
          command: 'bmad-method validate',
          required: true
        },
        {
          name: 'Auggie 审查',
          command: 'auggie --print "根据项目标准审查此代码"',
          required: true
        },
        {
          name: '更新知识库',
          command: 'bmad-method update-kb',
          required: false
        }
      ]
    }
  },

  // 环境特定配置
  environments: {
    development: {
      auggie: {
        options: {
          verbose: true,
          reportFormat: 'console',
          autoFix: false
        }
      }
    },
    staging: {
      auggie: {
        options: {
          verbose: false,
          reportFormat: 'json',
          autoFix: false
        }
      }
    },
    production: {
      auggie: {
        options: {
          verbose: false,
          reportFormat: 'json',
          onlyErrors: true,
          autoFix: false
        }
      }
    }
  }
};
```

### 3.2 项目类型特定配置

#### Node.js 项目配置
```javascript
// 在 bmad-config.js 中添加 Node.js 特定配置
module.exports = {
  // ... 基础配置
  
  project: {
    type: 'nodejs',
    language: 'javascript',
    framework: 'express',  // 或 'nestjs', 'koa', 'fastify' 等
    packageManager: 'npm'  // 或 'yarn', 'pnpm'
  },
  
  integrations: {
    auggie: {
      rules: [
        '.augment/rules/bmad-integration.md',
        '.augment/rules/nodejs-rules.md',
        '.augment/rules/security-rules.md',
        '.augment/rules/performance-rules.md'
      ],
      
      options: {
        // Node.js 特定选项
        excludePatterns: [
          'node_modules/**',
          'dist/**',
          'build/**',
          '*.min.js'
        ],
        includePatterns: [
          'src/**/*.js',
          'src/**/*.ts',
          'lib/**/*.js',
          'test/**/*.js'
        ]
      }
    }
  }
};
```

#### Python 项目配置
```javascript
module.exports = {
  project: {
    type: 'python',
    language: 'python',
    framework: 'django',  // 或 'flask', 'fastapi' 等
    packageManager: 'pip'  // 或 'poetry', 'conda'
  },
  
  integrations: {
    auggie: {
      rules: [
        '.augment/rules/bmad-integration.md',
        '.augment/rules/python-rules.md',
        '.augment/rules/security-rules.md'
      ],
      
      options: {
        excludePatterns: [
          'venv/**',
          '__pycache__/**',
          '*.pyc',
          'dist/**',
          'build/**'
        ],
        includePatterns: [
          'src/**/*.py',
          'app/**/*.py',
          'tests/**/*.py'
        ]
      }
    }
  }
};
```

---

## 4. 设置规则文件

### 4.1 创建项目特定规则

#### Node.js 规则文件
```bash
# 创建 Node.js 特定规则
cat > .augment/rules/nodejs-rules.md << 'EOF'
# Node.js 项目规则

## 代码结构
- 使用 ES6+ 语法
- 遵循 CommonJS 或 ES Modules 规范
- 正确使用 async/await 而不是回调

## 依赖管理
- 使用 package-lock.json 锁定依赖版本
- 定期更新依赖包
- 避免使用已废弃的包

## 安全规则
- 验证所有用户输入
- 使用环境变量存储敏感信息
- 实施适当的错误处理

## 性能规则
- 避免阻塞事件循环
- 使用流处理大文件
- 实施适当的缓存策略

## 测试要求
- 单元测试覆盖率 > 80%
- 集成测试覆盖关键路径
- 使用 Jest 或 Mocha 测试框架
EOF
```

#### Python 规则文件
```bash
cat > .augment/rules/python-rules.md << 'EOF'
# Python 项目规则

## 代码风格
- 遵循 PEP 8 编码规范
- 使用类型提示（Type Hints）
- 文档字符串使用 Google 或 NumPy 风格

## 依赖管理
- 使用 requirements.txt 或 pyproject.toml
- 固定依赖版本
- 使用虚拟环境

## 安全规则
- 验证用户输入
- 使用参数化查询防止 SQL 注入
- 正确处理异常

## 性能规则
- 使用生成器处理大数据集
- 避免不必要的循环
- 使用适当的数据结构

## 测试要求
- 使用 pytest 测试框架
- 测试覆盖率 > 85%
- 包含单元测试和集成测试
EOF
```

### 4.2 自定义安全规则

```bash
# 更新安全规则以适应你的项目
cat > .augment/rules/security-rules.md << 'EOF'
# 项目安全规则

## 认证和授权
- 实施强密码策略
- 使用 JWT 或 OAuth 2.0
- 实施角色基础访问控制（RBAC）

## 数据保护
- 加密敏感数据
- 使用 HTTPS 传输
- 实施数据备份策略

## 输入验证
- 验证所有用户输入
- 防止 XSS 攻击
- 防止 CSRF 攻击

## 依赖安全
- 定期扫描依赖漏洞
- 及时更新安全补丁
- 使用可信的包源

## 日志和监控
- 记录安全事件
- 实施异常检测
- 保护日志文件
EOF
```

### 4.3 配置规则权重

```bash
# 更新规则配置
cat > .augment/config/rule-config.json << 'EOF'
{
  "rules": {
    "bmad-integration": {
      "enabled": true,
      "priority": "high",
      "weight": 1.0,
      "categories": ["architecture", "quality", "testing"]
    },
    "security-rules": {
      "enabled": true,
      "priority": "critical",
      "weight": 2.0,
      "categories": ["security"]
    },
    "performance-rules": {
      "enabled": true,
      "priority": "medium",
      "weight": 0.8,
      "categories": ["performance"]
    },
    "nodejs-rules": {
      "enabled": true,
      "priority": "high",
      "weight": 1.2,
      "categories": ["language-specific"]
    }
  },
  "thresholds": {
    "critical": 0,
    "high": 2,
    "medium": 5,
    "low": 10
  },
  "reporting": {
    "format": "markdown",
    "includeContext": true,
    "showSuggestions": true,
    "groupByCategory": true
  }
}
EOF
```

---

## 5. 配置 GitHub Actions

### 5.1 更新工作流文件

```yaml
# .github/workflows/bmad-auggie-integration.yml
name: 🔄 Code Quality & Integration

on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main, develop]
  workflow_dispatch:

env:
  NODE_VERSION: '22'
  # 根据项目类型添加环境变量
  # PYTHON_VERSION: '3.11'  # Python 项目
  # JAVA_VERSION: '17'      # Java 项目

jobs:
  # 环境准备
  setup:
    name: 🚀 Setup Environment
    runs-on: ubuntu-latest
    outputs:
      cache-key: ${{ steps.cache.outputs.cache-hit }}
    
    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: 🟢 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      # 根据项目类型添加相应的环境设置
      # Python 项目示例
      # - name: 🐍 Setup Python
      #   uses: actions/setup-python@v4
      #   with:
      #     python-version: ${{ env.PYTHON_VERSION }}
      #     cache: 'pip'
      
      - name: 📦 Cache Dependencies
        id: cache
        uses: actions/cache@v3
        with:
          path: |
            ~/.npm
            node_modules
            .augment/cache
          key: ${{ runner.os }}-deps-${{ hashFiles('**/package-lock.json') }}
      
      - name: 🔧 Install Tools
        run: |
          npm install -g @augmentcode/auggie
          npx bmad-method install
      
      - name: ✅ Verify Installation
        run: |
          node --version
          npm --version
          auggie --version
          bmad-method --version

  # 代码质量检查
  code-quality:
    name: 🔍 Code Quality
    runs-on: ubuntu-latest
    needs: setup
    
    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v4
      
      - name: 🟢 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: 📦 Install Dependencies
        run: |
          npm ci
          npm install -g @augmentcode/auggie
          npx bmad-method install
      
      # 根据项目类型添加相应的质量检查
      - name: 🧹 Lint Code
        run: |
          # Node.js 项目
          npm run lint || echo "No lint script found"
          
          # Python 项目示例
          # flake8 . || echo "flake8 not configured"
          # black --check . || echo "black not configured"
          
          # Java 项目示例
          # mvn checkstyle:check || echo "checkstyle not configured"
      
      - name: 🏗️ Build Project
        run: |
          # Node.js 项目
          npm run build || echo "No build script found"
          
          # Python 项目示例
          # python -m pip install -e .
          
          # Java 项目示例
          # mvn compile
      
      - name: 🧪 Run Tests
        run: |
          # Node.js 项目
          npm test || echo "No test script found"
          
          # Python 项目示例
          # pytest --cov=src --cov-report=xml
          
          # Java 项目示例
          # mvn test

  # BMad-Method 验证
  bmad-validation:
    name: 🧠 BMad Validation
    runs-on: ubuntu-latest
    needs: setup
    
    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v4
      
      - name: 🔧 Install BMad-Method
        run: npx bmad-method install
      
      - name: ✅ Validate Project
        run: bmad-method validate --config bmad-config.js
      
      - name: 📚 Update Knowledge Base
        run: bmad-method update-kb --auto-commit=false
      
      - name: 📋 Generate Report
        run: bmad-method report --format=json --output=bmad-report.json
      
      - name: 📤 Upload Report
        uses: actions/upload-artifact@v3
        with:
          name: bmad-report
          path: bmad-report.json

  # Auggie CLI 审查
  auggie-review:
    name: 🤖 AI Code Review
    runs-on: ubuntu-latest
    needs: setup
    
    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v4
      
      - name: 🔧 Install Auggie CLI
        run: npm install -g @augmentcode/auggie
        env:
          AUGGIE_API_KEY: ${{ secrets.AUGGIE_API_KEY }}
      
      - name: 🔍 Security Review
        run: |
          auggie --rules .augment/rules/security-rules.md \
                 --format json \
                 --output security-report.json \
                 --fail-on-error
        continue-on-error: true
      
      - name: ⚡ Performance Review
        run: |
          auggie --rules .augment/rules/performance-rules.md \
                 --format json \
                 --output performance-report.json \
                 --no-fail-on-error
      
      - name: 🏗️ Integration Review
        run: |
          auggie --rules .augment/rules/bmad-integration.md \
                 --format json \
                 --output integration-report.json \
                 --context-engine \
                 --fail-on-error
        continue-on-error: true
      
      - name: 📤 Upload Reports
        uses: actions/upload-artifact@v3
        with:
          name: auggie-reports
          path: |
            security-report.json
            performance-report.json
            integration-report.json

  # 集成报告
  integration-report:
    name: 📊 Integration Report
    runs-on: ubuntu-latest
    needs: [bmad-validation, auggie-review]
    if: always()
    
    steps:
      - name: 📥 Checkout Code
        uses: actions/checkout@v4
      
      - name: 🟢 Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
      
      - name: 📥 Download Reports
        uses: actions/download-artifact@v3
        with:
          path: ./reports/
      
      - name: 📊 Generate Integrated Report
        run: |
          node scripts/generate-integrated-report.js \
            --bmad-report ./reports/bmad-report/bmad-report.json \
            --auggie-reports ./reports/auggie-reports/ \
            --output ./reports/integrated-report.md
        continue-on-error: true
      
      - name: 💬 Comment on PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const path = './reports/integrated-report.md';
            
            if (fs.existsSync(path)) {
              const report = fs.readFileSync(path, 'utf8');
              
              github.rest.issues.createComment({
                issue_number: context.issue.number,
                owner: context.repo.owner,
                repo: context.repo.repo,
                body: `## 🔍 代码质量报告\n\n${report}`
              });
            } else {
              github.rest.issues.createComment({
                issue_number: context.issue.number,
                owner: context.repo.owner,
                repo: context.repo.repo,
                body: '## ⚠️ 报告生成失败\n\n无法生成集成报告，请检查工作流日志。'
              });
            }
      
      - name: 📤 Upload Final Report
        uses: actions/upload-artifact@v3
        with:
          name: integrated-report
          path: ./reports/integrated-report.md
```

### 5.2 配置 GitHub Secrets

在 GitHub 仓库设置中添加以下 Secrets：

```bash
# 必需的 Secrets
AUGGIE_API_KEY=your_auggie_api_key_here
BMAD_LICENSE_KEY=your_bmad_license_key_here

# 可选的通知 Secrets
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/...
```

---

## 6. 不同项目类型的特殊考虑

### 6.1 Node.js 项目

#### 特殊配置
```bash
# 安装 Node.js 特定工具
npm install --save-dev eslint prettier husky lint-staged

# 配置 package.json scripts
cat >> package.json << 'EOF'
{
  "scripts": {
    "lint": "eslint src/**/*.js",
    "format": "prettier --write src/**/*.js",
    "test": "jest",
    "test:coverage": "jest --coverage",
    "auggie:check": "auggie --rules .augment/rules --quiet",
    "bmad:validate": "bmad-method validate"
  },
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged && npm run auggie:check"
    }
  },
  "lint-staged": {
    "*.js": ["eslint --fix", "prettier --write"]
  }
}
EOF
```

#### 特殊规则
```markdown
# .augment/rules/nodejs-rules.md 补充
## Express.js 特定规则
- 使用中间件进行错误处理
- 实施请求速率限制
- 使用 helmet 增强安全性

## 异步处理
- 优先使用 async/await
- 正确处理 Promise 拒绝
- 避免回调地狱
```

### 6.2 Python 项目

#### 特殊配置
```bash
# 创建 Python 特定配置
cat > pyproject.toml << 'EOF'
[tool.black]
line-length = 88
target-version = ['py311']

[tool.isort]
profile = "black"

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]

[tool.coverage.run]
source = ["src"]
omit = ["*/tests/*", "*/venv/*"]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError"
]
EOF

# 更新 requirements.txt
cat > requirements-dev.txt << 'EOF'
black>=23.0.0
flake8>=6.0.0
isort>=5.12.0
pytest>=7.0.0
pytest-cov>=4.0.0
mypy>=1.0.0
EOF
```

#### GitHub Actions 补充
```yaml
# 在 .github/workflows/bmad-auggie-integration.yml 中添加
- name: 🐍 Setup Python
  uses: actions/setup-python@v4
  with:
    python-version: '3.11'
    cache: 'pip'

- name: 📦 Install Python Dependencies
  run: |
    pip install -r requirements.txt
    pip install -r requirements-dev.txt

- name: 🧹 Python Code Quality
  run: |
    black --check .
    isort --check-only .
    flake8 .
    mypy src/

- name: 🧪 Python Tests
  run: |
    pytest --cov=src --cov-report=xml --cov-report=html
```

### 6.3 Java 项目

#### 特殊配置
```xml
<!-- pom.xml 中添加插件 -->
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-checkstyle-plugin</artifactId>
      <version>3.3.0</version>
      <configuration>
        <configLocation>checkstyle.xml</configLocation>
        <encoding>UTF-8</encoding>
        <consoleOutput>true</consoleOutput>
        <failsOnError>true</failsOnError>
      </configuration>
    </plugin>
    
    <plugin>
      <groupId>org.jacoco</groupId>
      <artifactId>jacoco-maven-plugin</artifactId>
      <version>0.8.10</version>
      <executions>
        <execution>
          <goals>
            <goal>prepare-agent</goal>
          </goals>
        </execution>
        <execution>
          <id>report</id>
          <phase>test</phase>
          <goals>
            <goal>report</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

#### GitHub Actions 补充
```yaml
- name: ☕ Setup Java
  uses: actions/setup-java@v3
  with:
    java-version: '17'
    distribution: 'temurin'
    cache: maven

- name: 🏗️ Build with Maven
  run: mvn clean compile

- name: 🧪 Run Tests
  run: mvn test

- name: 📊 Generate Test Report
  run: mvn jacoco:report

- name: 🧹 Code Style Check
  run: mvn checkstyle:check
```

### 6.4 React/Vue.js 前端项目

#### 特殊配置
```bash
# React 项目特殊依赖
npm install --save-dev @testing-library/react @testing-library/jest-dom
npm install --save-dev eslint-plugin-react eslint-plugin-react-hooks

# Vue 项目特殊依赖
npm install --save-dev @vue/test-utils @vue/cli-plugin-eslint
```

#### 特殊规则
```markdown
# .augment/rules/frontend-rules.md
## 组件规则
- 使用函数式组件优于类组件（React）
- 正确使用 hooks 规则
- 组件应该有 PropTypes 或 TypeScript 类型

## 性能规则
- 使用 React.memo 或 Vue 的 computed 优化渲染
- 避免在渲染函数中创建对象
- 正确使用 key 属性

## 可访问性
- 使用语义化 HTML
- 添加适当的 ARIA 属性
- 确保键盘导航支持
```

---

## 7. 验证安装和配置

### 7.1 基础验证脚本

```bash
#!/bin/bash
# verify-setup.sh - 验证集成框架安装

echo "🔍 验证 Auggie CLI × BMad-Method 集成框架安装..."

# 检查必需文件
echo "📁 检查文件结构..."
required_files=(
    "bmad-config.js"
    ".augment/rules/bmad-integration.md"
    ".augment/rules/security-rules.md"
    ".augment/config/rule-config.json"
    ".github/workflows/bmad-auggie-integration.yml"
    "scripts/generate-integrated-report.js"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - 缺失"
    fi
done

# 检查工具安装
echo -e "\n🔧 检查工具安装..."
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
else
    echo "❌ Node.js 未安装"
fi

if command -v auggie &> /dev/null; then
    echo "✅ Auggie CLI: $(auggie --version)"
else
    echo "❌ Auggie CLI 未安装"
fi

if command -v bmad-method &> /dev/null; then
    echo "✅ BMad-Method: $(bmad-method --version)"
else
    echo "❌ BMad-Method 未安装"
fi

# 验证配置文件
echo -e "\n⚙️ 验证配置文件..."
if node -c bmad-config.js 2>/dev/null; then
    echo "✅ bmad-config.js 语法正确"
else
    echo "❌ bmad-config.js 语法错误"
fi

if node -c scripts/generate-integrated-report.js 2>/dev/null; then
    echo "✅ generate-integrated-report.js 语法正确"
else
    echo "❌ generate-integrated-report.js 语法错误"
fi

# 测试基本功能
echo -e "\n🧪 测试基本功能..."
if auggie --rules .augment/rules --dry-run &> /dev/null; then
    echo "✅ Auggie CLI 规则验证通过"
else
    echo "❌ Auggie CLI 规则验证失败"
fi

if bmad-method validate --dry-run &> /dev/null; then
    echo "✅ BMad-Method 验证通过"
else
    echo "❌ BMad-Method 验证失败"
fi

echo -e "\n🎉 验证完成！"
```

### 7.2 运行验证

```bash
# 创建并运行验证脚本
chmod +x verify-setup.sh
./verify-setup.sh

# 预期输出示例：
# 🔍 验证 Auggie CLI × BMad-Method 集成框架安装...
# 📁 检查文件结构...
# ✅ bmad-config.js
# ✅ .augment/rules/bmad-integration.md
# ... 等等
```

### 7.3 功能测试

```bash
# 测试 Auggie CLI
echo "console.log('test');" > test-file.js
auggie --rules .augment/rules/security-rules.md test-file.js
rm test-file.js

# 测试 BMad-Method
bmad-method validate --config bmad-config.js

# 测试报告生成
node scripts/generate-integrated-report.js --help
```

---

## 8. 故障排除

### 8.1 常见安装问题

#### 问题 1: Node.js 版本不兼容
```bash
# 症状
Error: Auggie CLI requires Node.js >= 22.0.0

# 解决方案
nvm install 22
nvm use 22
npm install -g @augmentcode/auggie
```

#### 问题 2: Auggie CLI 安装失败
```bash
# 症状
npm ERR! 403 Forbidden - GET https://registry.npmjs.org/@augmentcode/auggie

# 解决方案
# 1. 检查网络连接
# 2. 验证 npm 配置
npm config get registry
npm config set registry https://registry.npmjs.org/

# 3. 清除 npm 缓存
npm cache clean --force

# 4. 使用详细日志重试
npm install -g @augmentcode/auggie --verbose
```

#### 问题 3: BMad-Method 许可证问题
```bash
# 症状
Error: BMad-Method license key required

# 解决方案
# 1. 设置环境变量
export BMAD_LICENSE_KEY=your_license_key_here

# 2. 或在 .env 文件中设置
echo "BMAD_LICENSE_KEY=your_license_key_here" >> .env

# 3. 验证设置
bmad-method --version
```

### 8.2 配置问题

#### 问题 1: bmad-config.js 语法错误
```bash
# 症状
SyntaxError: Unexpected token in bmad-config.js

# 诊断
node -c bmad-config.js

# 解决方案
# 1. 检查 JSON 语法（如果使用 JSON 格式）
# 2. 检查 JavaScript 语法
# 3. 验证所有括号和引号匹配
```

#### 问题 2: 规则文件路径错误
```bash
# 症状
Error: Rule file not found: .augment/rules/nonexistent-rules.md

# 解决方案
# 1. 检查文件是否存在
ls -la .augment/rules/

# 2. 验证 bmad-config.js 中的路径
grep -n "rules" bmad-config.js

# 3. 创建缺失的规则文件
touch .augment/rules/missing-rules.md
```

### 8.3 GitHub Actions 问题

#### 问题 1: Secrets 未配置
```bash
# 症状
Error: AUGGIE_API_KEY is not set

# 解决方案
# 1. 在 GitHub 仓库设置中添加 Secrets
# 2. 验证 Secret 名称拼写正确
# 3. 检查工作流文件中的引用
```

#### 问题 2: 工作流权限问题
```bash
# 症状
Error: Resource not accessible by integration

# 解决方案
# 在 .github/workflows/bmad-auggie-integration.yml 中添加：
permissions:
  contents: read
  issues: write
  pull-requests: write
```

### 8.4 运行时问题

#### 问题 1: 内存不足
```bash
# 症状
JavaScript heap out of memory

# 解决方案
# 1. 增加 Node.js 内存限制
export NODE_OPTIONS="--max-old-space-size=4096"

# 2. 在 bmad-config.js 中减少并发数
options: {
  concurrency: 2  // 从 4 减少到 2
}
```

#### 问题 2: 网络超时
```bash
# 症状
Error: Request timeout

# 解决方案
# 1. 增加超时时间
triggers: {
  'pr-review': {
    timeout: 300000  // 5分钟
  }
}

# 2. 检查网络连接
# 3. 使用代理（如果需要）
```

### 8.5 调试技巧

#### 启用详细日志
```bash
# 设置环境变量
export DEBUG=auggie:*,bmad:*
export VERBOSE=true

# 运行命令
auggie --rules .augment/rules --verbose
bmad-method validate --verbose
```

#### 检查配置
```bash
# 验证配置文件
node -e "console.log(JSON.stringify(require('./bmad-config.js'), null, 2))"

# 检查规则文件
find .augment/rules -name "*.md" -exec echo "=== {} ===" \; -exec head -5 {} \;
```

#### 测试单个组件
```bash
# 只测试 Auggie CLI
auggie --rules .augment/rules/security-rules.md --dry-run

# 只测试 BMad-Method
bmad-method validate --config bmad-config.js --dry-run

# 测试报告生成
node scripts/generate-integrated-report.js --help
```

---

## 🎉 总结

通过遵循这个详细的实施指南，你应该能够成功地在新项目中应用 Auggie CLI × BMad-Method 集成框架。记住：

1. **从简单开始**：先配置基本功能，然后逐步添加高级特性
2. **定期验证**：使用验证脚本确保配置正确
3. **根据项目调整**：不同类型的项目需要不同的配置
4. **持续改进**：根据团队反馈调整规则和配置

如果遇到问题，请参考故障排除部分，或查看项目的 GitHub Issues 页面获取帮助。

**祝你的项目集成成功！** 🚀
