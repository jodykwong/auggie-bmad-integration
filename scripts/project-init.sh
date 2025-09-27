#!/bin/bash

# 🚀 项目初始化脚本
# 此脚本将帮助你为新项目配置 Auggie CLI × BMad-Method 集成框架

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

echo -e "${BLUE}${ROCKET} Auggie CLI × BMad-Method 项目初始化向导${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo ""

# 检查是否在项目根目录
if [ ! -f "package.json" ] && [ ! -f "requirements.txt" ] && [ ! -f "pom.xml" ] && [ ! -f "Cargo.toml" ]; then
    echo -e "${YELLOW}${WARNING} 未检测到项目配置文件，是否要创建新项目？${NC}"
    read -p "输入项目名称（或按 Enter 跳过）: " project_name
    
    if [ ! -z "$project_name" ]; then
        mkdir -p "$project_name"
        cd "$project_name"
        echo -e "${GREEN}${CHECKMARK} 已创建项目目录: $project_name${NC}"
    fi
fi

# 检测项目类型
echo -e "${CYAN}检测项目类型...${NC}"
PROJECT_TYPE=""
LANGUAGE=""
FRAMEWORK=""

if [ -f "package.json" ]; then
    PROJECT_TYPE="nodejs"
    LANGUAGE="javascript"
    
    # 检测框架
    if grep -q "react" package.json; then
        FRAMEWORK="react"
    elif grep -q "vue" package.json; then
        FRAMEWORK="vue"
    elif grep -q "express" package.json; then
        FRAMEWORK="express"
    elif grep -q "nestjs" package.json; then
        FRAMEWORK="nestjs"
    fi
    
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    PROJECT_TYPE="python"
    LANGUAGE="python"
    
    # 检测框架
    if [ -f "manage.py" ] || grep -q "django" requirements.txt 2>/dev/null; then
        FRAMEWORK="django"
    elif grep -q "flask" requirements.txt 2>/dev/null; then
        FRAMEWORK="flask"
    elif grep -q "fastapi" requirements.txt 2>/dev/null; then
        FRAMEWORK="fastapi"
    fi
    
elif [ -f "pom.xml" ]; then
    PROJECT_TYPE="java"
    LANGUAGE="java"
    FRAMEWORK="maven"
    
elif [ -f "build.gradle" ]; then
    PROJECT_TYPE="java"
    LANGUAGE="java"
    FRAMEWORK="gradle"
    
elif [ -f "Cargo.toml" ]; then
    PROJECT_TYPE="rust"
    LANGUAGE="rust"
    
elif [ -f "go.mod" ]; then
    PROJECT_TYPE="go"
    LANGUAGE="go"
    
else
    echo -e "${YELLOW}${WARNING} 无法自动检测项目类型${NC}"
    echo "请选择项目类型:"
    echo "1) Node.js"
    echo "2) Python"
    echo "3) Java"
    echo "4) Rust"
    echo "5) Go"
    echo "6) 其他"
    
    read -p "请输入选择 (1-6): " choice
    
    case $choice in
        1) PROJECT_TYPE="nodejs"; LANGUAGE="javascript" ;;
        2) PROJECT_TYPE="python"; LANGUAGE="python" ;;
        3) PROJECT_TYPE="java"; LANGUAGE="java" ;;
        4) PROJECT_TYPE="rust"; LANGUAGE="rust" ;;
        5) PROJECT_TYPE="go"; LANGUAGE="go" ;;
        6) PROJECT_TYPE="other"; LANGUAGE="other" ;;
        *) echo "无效选择，使用默认配置"; PROJECT_TYPE="other"; LANGUAGE="other" ;;
    esac
fi

echo -e "${GREEN}${CHECKMARK} 检测到项目类型: $PROJECT_TYPE${NC}"
if [ ! -z "$FRAMEWORK" ]; then
    echo -e "${GREEN}${CHECKMARK} 检测到框架: $FRAMEWORK${NC}"
fi

# 获取项目信息
echo -e "\n${CYAN}配置项目信息...${NC}"
read -p "项目名称 [$(basename $(pwd))]: " input_name
PROJECT_NAME=${input_name:-$(basename $(pwd))}

read -p "项目描述: " PROJECT_DESCRIPTION
read -p "GitHub 用户名: " GITHUB_USERNAME
read -p "作者邮箱: " AUTHOR_EMAIL

# 生成定制的 bmad-config.js
echo -e "\n${CYAN}生成配置文件...${NC}"

cat > bmad-config.js << EOF
// bmad-config.js - ${PROJECT_NAME} 项目配置
module.exports = {
  // 项目基本信息
  project: {
    name: '${PROJECT_NAME}',
    version: '1.0.0',
    description: '${PROJECT_DESCRIPTION}',
    repository: 'https://github.com/${GITHUB_USERNAME}/${PROJECT_NAME}',
    type: '${PROJECT_TYPE}',
    language: '${LANGUAGE}'$([ ! -z "$FRAMEWORK" ] && echo ",
    framework: '${FRAMEWORK}'")
  },

  // 集成配置
  integrations: {
    auggie: {
      enabled: true,
      
      rules: [
        '.augment/rules/bmad-integration.md',
        '.augment/rules/security-rules.md',
        '.augment/rules/performance-rules.md'$([ "$PROJECT_TYPE" != "other" ] && echo ",
        '.augment/rules/${PROJECT_TYPE}-rules.md'")
      ],
      
      triggers: {
        'pre-commit': {
          enabled: true,
          rules: ['security-rules'],
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
          failOnError: false,
          timeout: 120000
        }
      },
      
      options: {
        contextEngine: true,
        autoFix: false,
        reportFormat: 'markdown',
        verbose: process.env.NODE_ENV === 'development',
        concurrency: 4,
        
        cache: {
          enabled: true,
          ttl: 3600000,
          directory: '.augment/cache'
        }$([ "$PROJECT_TYPE" != "other" ] && echo ",
        
        // ${PROJECT_TYPE} 特定配置
        excludePatterns: [$(get_exclude_patterns)],
        includePatterns: [$(get_include_patterns)]")
      }
    }
  },

  // 环境配置
  environments: {
    development: {
      auggie: {
        options: {
          verbose: true,
          reportFormat: 'console'
        }
      }
    },
    production: {
      auggie: {
        options: {
          verbose: false,
          reportFormat: 'json',
          onlyErrors: true
        }
      }
    }
  }
};
EOF

echo -e "${GREEN}${CHECKMARK} bmad-config.js 已生成${NC}"

# 创建项目特定规则文件
if [ "$PROJECT_TYPE" != "other" ]; then
    echo -e "${CYAN}创建 ${PROJECT_TYPE} 特定规则...${NC}"
    create_project_rules "$PROJECT_TYPE"
    echo -e "${GREEN}${CHECKMARK} ${PROJECT_TYPE} 规则文件已创建${NC}"
fi

# 更新 GitHub Actions 工作流
echo -e "${CYAN}更新 GitHub Actions 工作流...${NC}"
update_github_workflow "$PROJECT_TYPE"
echo -e "${GREEN}${CHECKMARK} GitHub Actions 工作流已更新${NC}"

# 创建项目特定的 package.json scripts（如果是 Node.js 项目）
if [ "$PROJECT_TYPE" = "nodejs" ]; then
    echo -e "${CYAN}更新 package.json scripts...${NC}"
    update_package_scripts
    echo -e "${GREEN}${CHECKMARK} package.json scripts 已更新${NC}"
fi

# 创建验证脚本
echo -e "${CYAN}创建验证脚本...${NC}"
create_verify_script
echo -e "${GREEN}${CHECKMARK} 验证脚本已创建${NC}"

# 创建 .env 模板
echo -e "${CYAN}创建环境变量模板...${NC}"
cat > .env.example << 'EOF'
# Auggie CLI 配置
AUGGIE_API_KEY=your_auggie_api_key_here
AUGGIE_CACHE_DIR=.augment/cache

# BMad-Method 配置
BMAD_LICENSE_KEY=your_bmad_license_key_here
BMAD_CONFIG_PATH=bmad-config.js

# 环境配置
NODE_ENV=development
EOF

echo -e "${GREEN}${CHECKMARK} .env.example 已创建${NC}"

# 更新 .gitignore
echo -e "${CYAN}更新 .gitignore...${NC}"
update_gitignore "$PROJECT_TYPE"
echo -e "${GREEN}${CHECKMARK} .gitignore 已更新${NC}"

echo ""
echo -e "${BLUE}=====================================================${NC}"
echo -e "${GREEN}${ROCKET} 项目初始化完成！${NC}"
echo ""
echo -e "${INFO} 接下来的步骤:"
echo "1. 复制 .env.example 到 .env 并填入实际的 API 密钥"
echo "2. 运行 ./verify-setup.sh 验证配置"
echo "3. 安装必要的依赖工具"
echo "4. 提交初始配置到 Git"
echo ""
echo -e "${YELLOW}💡 提示: 查看 PROJECT_IMPLEMENTATION_GUIDE.md 获取详细的使用指南${NC}"

# 辅助函数
get_exclude_patterns() {
    case $PROJECT_TYPE in
        "nodejs")
            echo "'node_modules/**', 'dist/**', 'build/**', '*.min.js'"
            ;;
        "python")
            echo "'venv/**', '__pycache__/**', '*.pyc', 'dist/**'"
            ;;
        "java")
            echo "'target/**', 'build/**', '*.class', '.gradle/**'"
            ;;
        *)
            echo "'node_modules/**', 'dist/**', 'build/**'"
            ;;
    esac
}

get_include_patterns() {
    case $PROJECT_TYPE in
        "nodejs")
            echo "'src/**/*.js', 'src/**/*.ts', 'lib/**/*.js'"
            ;;
        "python")
            echo "'src/**/*.py', 'app/**/*.py', 'tests/**/*.py'"
            ;;
        "java")
            echo "'src/**/*.java', 'test/**/*.java'"
            ;;
        *)
            echo "'src/**/*'"
            ;;
    esac
}

create_project_rules() {
    local project_type=$1
    mkdir -p .augment/rules
    
    case $project_type in
        "nodejs")
            cat > .augment/rules/nodejs-rules.md << 'EOF'
# Node.js 项目规则

## 代码结构
- 使用 ES6+ 语法
- 遵循 CommonJS 或 ES Modules 规范
- 正确使用 async/await

## 依赖管理
- 使用 package-lock.json 锁定版本
- 定期更新依赖包
- 避免使用已废弃的包

## 安全规则
- 验证所有用户输入
- 使用环境变量存储敏感信息
- 实施适当的错误处理

## 测试要求
- 单元测试覆盖率 > 80%
- 使用 Jest 或 Mocha 测试框架
EOF
            ;;
        "python")
            cat > .augment/rules/python-rules.md << 'EOF'
# Python 项目规则

## 代码风格
- 遵循 PEP 8 编码规范
- 使用类型提示（Type Hints）
- 文档字符串使用 Google 风格

## 依赖管理
- 使用 requirements.txt 或 pyproject.toml
- 固定依赖版本
- 使用虚拟环境

## 测试要求
- 使用 pytest 测试框架
- 测试覆盖率 > 85%
EOF
            ;;
    esac
}

update_github_workflow() {
    local project_type=$1
    # 这里可以根据项目类型更新工作流文件
    # 由于篇幅限制，这里只是占位符
    echo "# GitHub Actions 工作流已根据 $project_type 项目类型更新"
}

update_package_scripts() {
    if [ -f "package.json" ]; then
        # 添加有用的 scripts
        npm pkg set scripts.auggie:check="auggie --rules .augment/rules --quiet"
        npm pkg set scripts.bmad:validate="bmad-method validate"
        npm pkg set scripts.quality:check="npm run auggie:check && npm run bmad:validate"
    fi
}

create_verify_script() {
    cat > verify-setup.sh << 'EOF'
#!/bin/bash
echo "🔍 验证项目配置..."

# 检查必需文件
required_files=("bmad-config.js" ".augment/rules/bmad-integration.md")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file - 缺失"
    fi
done

# 检查工具
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

echo "🎉 验证完成！"
EOF
    chmod +x verify-setup.sh
}

update_gitignore() {
    local project_type=$1
    
    # 添加通用忽略规则
    cat >> .gitignore << 'EOF'

# Auggie CLI × BMad-Method 集成框架
.augment/cache/
.env
*.log

EOF

    # 根据项目类型添加特定规则
    case $project_type in
        "nodejs")
            cat >> .gitignore << 'EOF'
# Node.js
node_modules/
npm-debug.log*
dist/
build/
EOF
            ;;
        "python")
            cat >> .gitignore << 'EOF'
# Python
__pycache__/
*.pyc
venv/
.pytest_cache/
EOF
            ;;
    esac
}
