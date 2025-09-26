#!/bin/bash

# 🛠️ Auggie CLI × BMad-Method 集成安装脚本
# 此脚本将自动复制所有必要的配置文件到你的项目中

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

echo -e "${BLUE}${ROCKET} Auggie CLI × BMad-Method 集成安装程序${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""

# 检查是否在正确的目录中
if [ ! -f "bmad-integration-config-examples/bmad-config.js" ]; then
    echo -e "${RED}${CROSS} 错误: 请在 auggie-bmad-integration 目录中运行此脚本${NC}"
    exit 1
fi

# 获取目标目录
TARGET_DIR="${1:-.}"
if [ "$TARGET_DIR" = "." ]; then
    echo -e "${INFO} 将在当前目录的上级目录安装配置文件"
    TARGET_DIR="../"
else
    echo -e "${INFO} 将在 $TARGET_DIR 目录安装配置文件"
fi

# 确保目标目录存在
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}${CROSS} 目标目录不存在: $TARGET_DIR${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}${WARNING} 即将复制以下文件到 $TARGET_DIR:${NC}"
echo -e "  • bmad-config.js"
echo -e "  • .augment/rules/bmad-integration.md"
echo -e "  • .github/workflows/bmad-auggie-integration.yml"
echo -e "  • scripts/generate-integrated-report.js"
echo ""

# 询问用户确认
read -p "是否继续? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}安装已取消${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}开始安装...${NC}"

# 复制主配置文件
echo -e "${CYAN}复制主配置文件...${NC}"
cp bmad-integration-config-examples/bmad-config.js "$TARGET_DIR/"
echo -e "${GREEN}${CHECKMARK} bmad-config.js${NC}"

# 创建并复制 .augment 目录
echo -e "${CYAN}创建 .augment 目录结构...${NC}"
mkdir -p "$TARGET_DIR/.augment/rules"
mkdir -p "$TARGET_DIR/.augment/config"
mkdir -p "$TARGET_DIR/.augment/templates"
cp bmad-integration-config-examples/.augment/rules/bmad-integration.md "$TARGET_DIR/.augment/rules/"
echo -e "${GREEN}${CHECKMARK} .augment/rules/bmad-integration.md${NC}"

# 创建并复制 .github 目录
echo -e "${CYAN}创建 GitHub Actions 工作流...${NC}"
mkdir -p "$TARGET_DIR/.github/workflows"
cp bmad-integration-config-examples/.github/workflows/bmad-auggie-integration.yml "$TARGET_DIR/.github/workflows/"
echo -e "${GREEN}${CHECKMARK} .github/workflows/bmad-auggie-integration.yml${NC}"

# 创建并复制 scripts 目录
echo -e "${CYAN}复制脚本文件...${NC}"
mkdir -p "$TARGET_DIR/scripts"
cp bmad-integration-config-examples/scripts/generate-integrated-report.js "$TARGET_DIR/scripts/"
echo -e "${GREEN}${CHECKMARK} scripts/generate-integrated-report.js${NC}"

# 创建额外的规则文件
echo -e "${CYAN}创建额外的规则文件...${NC}"

# 创建安全规则文件
cat > "$TARGET_DIR/.augment/rules/security-rules.md" << 'EOF'
# 安全审查规则

## 输入验证
- 检查所有用户输入是否经过验证
- 确保使用参数化查询防止 SQL 注入
- 验证文件上传的类型和大小限制

## 身份认证和授权
- 检查 API 端点的权限控制
- 验证 JWT token 的正确使用
- 确保敏感操作需要额外验证

## 数据保护
- 检查敏感数据是否加密存储
- 验证传输过程中的数据加密
- 确保日志中不包含敏感信息
EOF
echo -e "${GREEN}${CHECKMARK} .augment/rules/security-rules.md${NC}"

# 创建性能规则文件
cat > "$TARGET_DIR/.augment/rules/performance-rules.md" << 'EOF'
# 性能审查规则

## 数据库优化
- 检查是否存在 N+1 查询问题
- 验证数据库索引的合理使用
- 确保查询语句的效率

## 缓存策略
- 检查缓存的合理使用
- 验证缓存失效策略
- 确保缓存一致性

## 资源管理
- 检查内存泄漏风险
- 验证文件句柄的正确关闭
- 确保异步操作的正确处理
EOF
echo -e "${GREEN}${CHECKMARK} .augment/rules/performance-rules.md${NC}"

# 创建规则配置文件
cat > "$TARGET_DIR/.augment/config/rule-config.json" << 'EOF'
{
  "rules": {
    "bmad-integration": {
      "enabled": true,
      "priority": "high",
      "weight": 1.0,
      "categories": [
        "architecture",
        "quality",
        "testing",
        "security",
        "performance"
      ]
    },
    "security-rules": {
      "enabled": true,
      "priority": "critical",
      "weight": 1.5,
      "categories": ["security"]
    },
    "performance-rules": {
      "enabled": true,
      "priority": "medium",
      "weight": 0.8,
      "categories": ["performance"]
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
    "showSuggestions": true
  }
}
EOF
echo -e "${GREEN}${CHECKMARK} .augment/config/rule-config.json${NC}"

echo ""
echo -e "${GREEN}${CHECKMARK} 安装完成！${NC}"
echo ""
echo -e "${BLUE}接下来的步骤:${NC}"
echo -e "1. ${YELLOW}安装依赖:${NC}"
echo -e "   npm install -g @augmentcode/auggie"
echo -e "   npx bmad-method install"
echo ""
echo -e "2. ${YELLOW}配置环境变量 (GitHub Secrets):${NC}"
echo -e "   AUGGIE_API_KEY=your_auggie_api_key_here"
echo -e "   BMAD_LICENSE_KEY=your_bmad_license_key_here"
echo ""
echo -e "3. ${YELLOW}验证配置:${NC}"
echo -e "   auggie --rules .augment/rules --dry-run"
echo -e "   bmad-method validate"
echo ""
echo -e "4. ${YELLOW}查看详细文档:${NC}"
echo -e "   打开 auggie-bmad-integration-guide.html"
echo ""
echo -e "${GREEN}🎉 祝你使用愉快！${NC}"
