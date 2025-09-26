@echo off
setlocal enabledelayedexpansion

REM 🛠️ Auggie CLI × BMad-Method 集成安装脚本 (Windows)
REM 此脚本将自动复制所有必要的配置文件到你的项目中

echo 🚀 Auggie CLI × BMad-Method 集成安装程序
echo ================================================
echo.

REM 检查是否在正确的目录中
if not exist "bmad-integration-config-examples\bmad-config.js" (
    echo ❌ 错误: 请在 auggie-bmad-integration 目录中运行此脚本
    pause
    exit /b 1
)

REM 获取目标目录
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=.."

echo ℹ️ 将在 %TARGET_DIR% 目录安装配置文件

REM 确保目标目录存在
if not exist "%TARGET_DIR%" (
    echo ❌ 目标目录不存在: %TARGET_DIR%
    pause
    exit /b 1
)

echo.
echo ⚠️ 即将复制以下文件到 %TARGET_DIR%:
echo   • bmad-config.js
echo   • .augment\rules\bmad-integration.md
echo   • .github\workflows\bmad-auggie-integration.yml
echo   • scripts\generate-integrated-report.js
echo.

REM 询问用户确认
set /p "confirm=是否继续? (y/N): "
if /i not "%confirm%"=="y" (
    echo 安装已取消
    pause
    exit /b 0
)

echo.
echo 开始安装...

REM 复制主配置文件
echo 复制主配置文件...
copy "bmad-integration-config-examples\bmad-config.js" "%TARGET_DIR%\" >nul
echo ✅ bmad-config.js

REM 创建并复制 .augment 目录
echo 创建 .augment 目录结构...
if not exist "%TARGET_DIR%\.augment\rules" mkdir "%TARGET_DIR%\.augment\rules"
if not exist "%TARGET_DIR%\.augment\config" mkdir "%TARGET_DIR%\.augment\config"
if not exist "%TARGET_DIR%\.augment\templates" mkdir "%TARGET_DIR%\.augment\templates"
copy "bmad-integration-config-examples\.augment\rules\bmad-integration.md" "%TARGET_DIR%\.augment\rules\" >nul
echo ✅ .augment\rules\bmad-integration.md

REM 创建并复制 .github 目录
echo 创建 GitHub Actions 工作流...
if not exist "%TARGET_DIR%\.github\workflows" mkdir "%TARGET_DIR%\.github\workflows"
copy "bmad-integration-config-examples\.github\workflows\bmad-auggie-integration.yml" "%TARGET_DIR%\.github\workflows\" >nul
echo ✅ .github\workflows\bmad-auggie-integration.yml

REM 创建并复制 scripts 目录
echo 复制脚本文件...
if not exist "%TARGET_DIR%\scripts" mkdir "%TARGET_DIR%\scripts"
copy "bmad-integration-config-examples\scripts\generate-integrated-report.js" "%TARGET_DIR%\scripts\" >nul
echo ✅ scripts\generate-integrated-report.js

REM 创建安全规则文件
echo 创建额外的规则文件...
(
echo # 安全审查规则
echo.
echo ## 输入验证
echo - 检查所有用户输入是否经过验证
echo - 确保使用参数化查询防止 SQL 注入
echo - 验证文件上传的类型和大小限制
echo.
echo ## 身份认证和授权
echo - 检查 API 端点的权限控制
echo - 验证 JWT token 的正确使用
echo - 确保敏感操作需要额外验证
echo.
echo ## 数据保护
echo - 检查敏感数据是否加密存储
echo - 验证传输过程中的数据加密
echo - 确保日志中不包含敏感信息
) > "%TARGET_DIR%\.augment\rules\security-rules.md"
echo ✅ .augment\rules\security-rules.md

REM 创建性能规则文件
(
echo # 性能审查规则
echo.
echo ## 数据库优化
echo - 检查是否存在 N+1 查询问题
echo - 验证数据库索引的合理使用
echo - 确保查询语句的效率
echo.
echo ## 缓存策略
echo - 检查缓存的合理使用
echo - 验证缓存失效策略
echo - 确保缓存一致性
echo.
echo ## 资源管理
echo - 检查内存泄漏风险
echo - 验证文件句柄的正确关闭
echo - 确保异步操作的正确处理
) > "%TARGET_DIR%\.augment\rules\performance-rules.md"
echo ✅ .augment\rules\performance-rules.md

REM 创建规则配置文件
(
echo {
echo   "rules": {
echo     "bmad-integration": {
echo       "enabled": true,
echo       "priority": "high",
echo       "weight": 1.0,
echo       "categories": [
echo         "architecture",
echo         "quality",
echo         "testing",
echo         "security",
echo         "performance"
echo       ]
echo     },
echo     "security-rules": {
echo       "enabled": true,
echo       "priority": "critical",
echo       "weight": 1.5,
echo       "categories": ["security"]
echo     },
echo     "performance-rules": {
echo       "enabled": true,
echo       "priority": "medium",
echo       "weight": 0.8,
echo       "categories": ["performance"]
echo     }
echo   },
echo   "thresholds": {
echo     "critical": 0,
echo     "high": 2,
echo     "medium": 5,
echo     "low": 10
echo   },
echo   "reporting": {
echo     "format": "markdown",
echo     "includeContext": true,
echo     "showSuggestions": true
echo   }
echo }
) > "%TARGET_DIR%\.augment\config\rule-config.json"
echo ✅ .augment\config\rule-config.json

echo.
echo ✅ 安装完成！
echo.
echo 接下来的步骤:
echo 1. 安装依赖:
echo    npm install -g @augmentcode/auggie
echo    npx bmad-method install
echo.
echo 2. 配置环境变量 (GitHub Secrets):
echo    AUGGIE_API_KEY=your_auggie_api_key_here
echo    BMAD_LICENSE_KEY=your_bmad_license_key_here
echo.
echo 3. 验证配置:
echo    auggie --rules .augment\rules --dry-run
echo    bmad-method validate
echo.
echo 4. 查看详细文档:
echo    打开 auggie-bmad-integration-guide.html
echo.
echo 🎉 祝你使用愉快！
pause
