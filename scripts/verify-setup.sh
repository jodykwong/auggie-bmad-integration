#!/bin/bash

# 🔍 验证 Auggie CLI × BMad-Method 集成框架安装脚本
# 此脚本将检查所有必要的文件、工具和配置是否正确安装

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
MAGNIFYING_GLASS="🔍"

# 计数器
PASSED=0
FAILED=0
WARNINGS=0

echo -e "${BLUE}${MAGNIFYING_GLASS} Auggie CLI × BMad-Method 集成框架验证${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 检查函数
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}${CHECKMARK} $description${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}${CROSS} $description - 文件不存在: $file${NC}"
        ((FAILED++))
        return 1
    fi
}

check_directory() {
    local dir=$1
    local description=$2
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}${CHECKMARK} $description${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}${CROSS} $description - 目录不存在: $dir${NC}"
        ((FAILED++))
        return 1
    fi
}

check_command() {
    local cmd=$1
    local description=$2
    
    if command -v "$cmd" &> /dev/null; then
        local version=$($cmd --version 2>/dev/null || echo "未知版本")
        echo -e "${GREEN}${CHECKMARK} $description: $version${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}${CROSS} $description - 命令未找到: $cmd${NC}"
        ((FAILED++))
        return 1
    fi
}

check_syntax() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        if node -c "$file" 2>/dev/null; then
            echo -e "${GREEN}${CHECKMARK} $description - 语法正确${NC}"
            ((PASSED++))
            return 0
        else
            echo -e "${RED}${CROSS} $description - 语法错误${NC}"
            ((FAILED++))
            return 1
        fi
    else
        echo -e "${YELLOW}${WARNING} $description - 文件不存在，跳过语法检查${NC}"
        ((WARNINGS++))
        return 1
    fi
}

check_json_syntax() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        if python -m json.tool "$file" > /dev/null 2>&1 || node -e "JSON.parse(require('fs').readFileSync('$file', 'utf8'))" 2>/dev/null; then
            echo -e "${GREEN}${CHECKMARK} $description - JSON 语法正确${NC}"
            ((PASSED++))
            return 0
        else
            echo -e "${RED}${CROSS} $description - JSON 语法错误${NC}"
            ((FAILED++))
            return 1
        fi
    else
        echo -e "${YELLOW}${WARNING} $description - 文件不存在，跳过语法检查${NC}"
        ((WARNINGS++))
        return 1
    fi
}

# 1. 检查核心文件结构
echo -e "${CYAN}📁 检查文件结构...${NC}"
check_file "bmad-config.js" "主配置文件"
check_file "README.md" "项目说明文档"
check_file "LICENSE" "许可证文件"
check_file ".gitignore" "Git 忽略文件"

echo ""

# 2. 检查 .augment 目录结构
echo -e "${CYAN}📂 检查 .augment 目录结构...${NC}"
check_directory ".augment" ".augment 主目录"
check_directory ".augment/rules" "规则目录"
check_directory ".augment/config" "配置目录"

check_file ".augment/rules/bmad-integration.md" "BMad 集成规则"
check_file ".augment/rules/security-rules.md" "安全规则"
check_file ".augment/rules/performance-rules.md" "性能规则"
check_file ".augment/config/rule-config.json" "规则配置文件"

echo ""

# 3. 检查 GitHub Actions 工作流
echo -e "${CYAN}🔄 检查 GitHub Actions 工作流...${NC}"
check_directory ".github" ".github 目录"
check_directory ".github/workflows" "工作流目录"
check_file ".github/workflows/bmad-auggie-integration.yml" "集成工作流文件"

echo ""

# 4. 检查脚本文件
echo -e "${CYAN}📜 检查脚本文件...${NC}"
check_directory "scripts" "脚本目录"
check_file "scripts/generate-integrated-report.js" "报告生成脚本"

# 检查安装脚本
if [ -f "setup.sh" ]; then
    check_file "setup.sh" "Linux/macOS 安装脚本"
    if [ -x "setup.sh" ]; then
        echo -e "${GREEN}${CHECKMARK} setup.sh 具有执行权限${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} setup.sh 缺少执行权限${NC}"
        ((WARNINGS++))
    fi
fi

if [ -f "setup.bat" ]; then
    check_file "setup.bat" "Windows 安装脚本"
fi

echo ""

# 5. 检查工具安装
echo -e "${CYAN}🔧 检查工具安装...${NC}"
check_command "node" "Node.js"
check_command "npm" "npm"
check_command "git" "Git"

# 检查 Node.js 版本
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version | sed 's/v//')
    REQUIRED_VERSION="22.0.0"
    
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$NODE_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
        echo -e "${GREEN}${CHECKMARK} Node.js 版本满足要求 (>= $REQUIRED_VERSION)${NC}"
        ((PASSED++))
    else
        echo -e "${RED}${CROSS} Node.js 版本不满足要求 (当前: $NODE_VERSION, 需要: >= $REQUIRED_VERSION)${NC}"
        ((FAILED++))
    fi
fi

# 检查 Auggie CLI
if check_command "auggie" "Auggie CLI"; then
    # 测试 Auggie CLI 基本功能
    if auggie --help &> /dev/null; then
        echo -e "${GREEN}${CHECKMARK} Auggie CLI 基本功能正常${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} Auggie CLI 可能配置不正确${NC}"
        ((WARNINGS++))
    fi
fi

# 检查 BMad-Method
if check_command "bmad-method" "BMad-Method"; then
    # 测试 BMad-Method 基本功能
    if bmad-method --help &> /dev/null; then
        echo -e "${GREEN}${CHECKMARK} BMad-Method 基本功能正常${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} BMad-Method 可能配置不正确${NC}"
        ((WARNINGS++))
    fi
fi

echo ""

# 6. 检查配置文件语法
echo -e "${CYAN}⚙️ 检查配置文件语法...${NC}"
check_syntax "bmad-config.js" "主配置文件"
check_syntax "scripts/generate-integrated-report.js" "报告生成脚本"
check_json_syntax ".augment/config/rule-config.json" "规则配置文件"

echo ""

# 7. 检查环境变量配置
echo -e "${CYAN}🌍 检查环境变量配置...${NC}"
if [ -f ".env.example" ]; then
    check_file ".env.example" "环境变量模板"
else
    echo -e "${YELLOW}${WARNING} .env.example 文件不存在${NC}"
    ((WARNINGS++))
fi

if [ -f ".env" ]; then
    echo -e "${GREEN}${CHECKMARK} .env 文件存在${NC}"
    ((PASSED++))
    
    # 检查关键环境变量
    if grep -q "AUGGIE_API_KEY" .env; then
        echo -e "${GREEN}${CHECKMARK} AUGGIE_API_KEY 已配置${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} AUGGIE_API_KEY 未在 .env 中配置${NC}"
        ((WARNINGS++))
    fi
    
    if grep -q "BMAD_LICENSE_KEY" .env; then
        echo -e "${GREEN}${CHECKMARK} BMAD_LICENSE_KEY 已配置${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} BMAD_LICENSE_KEY 未在 .env 中配置${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}${WARNING} .env 文件不存在，请从 .env.example 复制并配置${NC}"
    ((WARNINGS++))
fi

echo ""

# 8. 功能测试
echo -e "${CYAN}🧪 功能测试...${NC}"

# 测试配置文件加载
if [ -f "bmad-config.js" ]; then
    if node -e "const config = require('./bmad-config.js'); console.log('配置加载成功');" 2>/dev/null; then
        echo -e "${GREEN}${CHECKMARK} bmad-config.js 可以正确加载${NC}"
        ((PASSED++))
    else
        echo -e "${RED}${CROSS} bmad-config.js 加载失败${NC}"
        ((FAILED++))
    fi
fi

# 测试 Auggie CLI 规则验证
if command -v auggie &> /dev/null && [ -d ".augment/rules" ]; then
    if auggie --rules .augment/rules --dry-run &> /dev/null; then
        echo -e "${GREEN}${CHECKMARK} Auggie CLI 规则验证通过${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} Auggie CLI 规则验证失败（可能需要 API 密钥）${NC}"
        ((WARNINGS++))
    fi
fi

# 测试 BMad-Method 验证
if command -v bmad-method &> /dev/null && [ -f "bmad-config.js" ]; then
    if bmad-method validate --dry-run &> /dev/null; then
        echo -e "${GREEN}${CHECKMARK} BMad-Method 验证通过${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} BMad-Method 验证失败（可能需要许可证密钥）${NC}"
        ((WARNINGS++))
    fi
fi

echo ""

# 9. 项目特定检查
echo -e "${CYAN}📦 项目特定检查...${NC}"

# 检查 package.json（Node.js 项目）
if [ -f "package.json" ]; then
    echo -e "${GREEN}${CHECKMARK} 检测到 Node.js 项目${NC}"
    ((PASSED++))
    
    # 检查有用的 scripts
    if grep -q "auggie:check" package.json; then
        echo -e "${GREEN}${CHECKMARK} package.json 包含 auggie:check 脚本${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} 建议在 package.json 中添加 auggie:check 脚本${NC}"
        ((WARNINGS++))
    fi
    
    if grep -q "bmad:validate" package.json; then
        echo -e "${GREEN}${CHECKMARK} package.json 包含 bmad:validate 脚本${NC}"
        ((PASSED++))
    else
        echo -e "${YELLOW}${WARNING} 建议在 package.json 中添加 bmad:validate 脚本${NC}"
        ((WARNINGS++))
    fi
fi

# 检查 requirements.txt（Python 项目）
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo -e "${GREEN}${CHECKMARK} 检测到 Python 项目${NC}"
    ((PASSED++))
fi

# 检查 pom.xml（Java 项目）
if [ -f "pom.xml" ]; then
    echo -e "${GREEN}${CHECKMARK} 检测到 Java Maven 项目${NC}"
    ((PASSED++))
fi

echo ""

# 10. 生成报告
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}📊 验证报告${NC}"
echo -e "${BLUE}================================================${NC}"

TOTAL=$((PASSED + FAILED + WARNINGS))
PASS_RATE=$((PASSED * 100 / TOTAL))

echo -e "${GREEN}✅ 通过: $PASSED${NC}"
echo -e "${RED}❌ 失败: $FAILED${NC}"
echo -e "${YELLOW}⚠️  警告: $WARNINGS${NC}"
echo -e "${BLUE}📊 总计: $TOTAL${NC}"
echo -e "${PURPLE}📈 通过率: $PASS_RATE%${NC}"

echo ""

# 根据结果给出建议
if [ $FAILED -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}🎉 恭喜！所有检查都通过了，你的集成框架配置完美！${NC}"
        echo -e "${GREEN}✨ 你可以开始使用 Auggie CLI × BMad-Method 集成框架了。${NC}"
    else
        echo -e "${YELLOW}✅ 基本配置正确，但有一些建议需要注意。${NC}"
        echo -e "${YELLOW}💡 请查看上面的警告信息并考虑进行优化。${NC}"
    fi
else
    echo -e "${RED}❌ 发现了一些问题需要修复。${NC}"
    echo -e "${RED}🔧 请查看上面的错误信息并修复相关问题。${NC}"
fi

echo ""
echo -e "${INFO} 接下来的步骤:"

if [ $FAILED -gt 0 ]; then
    echo "1. 🔧 修复上述失败的检查项"
    echo "2. 📖 查看 PROJECT_IMPLEMENTATION_GUIDE.md 获取详细指导"
    echo "3. 🔄 重新运行此验证脚本"
else
    echo "1. 📝 配置 .env 文件中的 API 密钥"
    echo "2. 🧪 运行一些测试命令验证功能"
    echo "3. 📚 查看文档了解高级功能"
    echo "4. 🚀 开始使用集成框架！"
fi

echo ""
echo -e "${CYAN}💡 有用的命令:${NC}"
echo "  • 测试 Auggie CLI: auggie --rules .augment/rules --dry-run"
echo "  • 测试 BMad-Method: bmad-method validate --dry-run"
echo "  • 查看配置: node -e \"console.log(require('./bmad-config.js'))\""
echo "  • 生成报告: node scripts/generate-integrated-report.js --help"

# 退出码
if [ $FAILED -gt 0 ]; then
    exit 1
else
    exit 0
fi
