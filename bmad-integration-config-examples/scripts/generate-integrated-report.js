#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { program } = require('commander');

// 命令行参数解析
program
  .option('--bmad-report <path>', 'BMad-Method 报告路径')
  .option('--auggie-reports <path>', 'Auggie CLI 报告目录')
  .option('--output <path>', '输出文件路径')
  .parse();

const options = program.opts();

// 生成集成报告
async function generateIntegratedReport() {
  try {
    // 读取 BMad-Method 报告
    const bmadReport = JSON.parse(
      fs.readFileSync(options.bmadReport, 'utf8')
    );
    
    // 读取 Auggie CLI 报告
    const auggieReports = {
      security: JSON.parse(
        fs.readFileSync(path.join(options.auggieReports, 'security-report.json'), 'utf8')
      ),
      performance: JSON.parse(
        fs.readFileSync(path.join(options.auggieReports, 'performance-report.json'), 'utf8')
      ),
      integration: JSON.parse(
        fs.readFileSync(path.join(options.auggieReports, 'integration-report.json'), 'utf8')
      )
    };
    
    // 生成 Markdown 报告
    const report = generateMarkdownReport(bmadReport, auggieReports);
    
    // 写入输出文件
    fs.writeFileSync(options.output, report, 'utf8');
    
    console.log(`✅ 集成报告已生成: ${options.output}`);
  } catch (error) {
    console.error('❌ 生成报告失败:', error.message);
    process.exit(1);
  }
}

function generateMarkdownReport(bmadReport, auggieReports) {
  const timestamp = new Date().toISOString();
  
  return `# 🔍 集成代码审查报告

**生成时间**: ${timestamp}

## 📊 总体概览

| 工具 | 状态 | 问题数量 | 严重程度 |
|------|------|----------|----------|
| BMad-Method | ${bmadReport.status} | ${bmadReport.issues?.length || 0} | ${bmadReport.severity || 'N/A'} |
| Auggie (安全) | ${auggieReports.security.status} | ${auggieReports.security.issues?.length || 0} | ${auggieReports.security.severity || 'N/A'} |
| Auggie (性能) | ${auggieReports.performance.status} | ${auggieReports.performance.issues?.length || 0} | ${auggieReports.performance.severity || 'N/A'} |
| Auggie (集成) | ${auggieReports.integration.status} | ${auggieReports.integration.issues?.length || 0} | ${auggieReports.integration.severity || 'N/A'} |

## 🧠 BMad-Method 分析结果

${formatBmadReport(bmadReport)}

## 🤖 Auggie CLI 分析结果

### 🔒 安全检查
${formatAuggieReport(auggieReports.security)}

### ⚡ 性能检查
${formatAuggieReport(auggieReports.performance)}

### 🔗 集成检查
${formatAuggieReport(auggieReports.integration)}

## 💡 综合建议

${generateRecommendations(bmadReport, auggieReports)}

---
*此报告由 BMad-Method 与 Auggie CLI 集成系统自动生成*`;
}

function formatBmadReport(report) {
  if (!report.issues || report.issues.length === 0) {
    return '✅ 未发现问题';
  }
  
  return report.issues.map(issue => 
    `- **${issue.severity}**: ${issue.message} (${issue.file}:${issue.line})`
  ).join('\n');
}

function formatAuggieReport(report) {
  if (!report.issues || report.issues.length === 0) {
    return '✅ 未发现问题';
  }
  
  return report.issues.map(issue => 
    `- **${issue.severity}**: ${issue.message}\n  - 文件: ${issue.file}\n  - 建议: ${issue.suggestion || '无'}`
  ).join('\n\n');
}

function generateRecommendations(bmadReport, auggieReports) {
  const recommendations = [];
  
  // 基于报告生成建议
  const totalIssues = (bmadReport.issues?.length || 0) + 
                     (auggieReports.security.issues?.length || 0) +
                     (auggieReports.performance.issues?.length || 0) +
                     (auggieReports.integration.issues?.length || 0);
  
  if (totalIssues === 0) {
    recommendations.push('🎉 代码质量良好，符合 BMad-Method 标准！');
  } else {
    recommendations.push(`📋 发现 ${totalIssues} 个问题需要处理`);
    
    if (auggieReports.security.issues?.length > 0) {
      recommendations.push('🔒 优先处理安全问题');
    }
    
    if (bmadReport.issues?.length > 0) {
      recommendations.push('🧠 确保代码符合 BMad-Method 架构原则');
    }
    
    if (auggieReports.performance.issues?.length > 0) {
      recommendations.push('⚡ 考虑优化性能相关问题');
    }
  }
  
  return recommendations.join('\n- ');
}

// 运行脚本
generateIntegratedReport();
