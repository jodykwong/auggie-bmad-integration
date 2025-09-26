// bmad-config.js - BMad-Method 与 Auggie CLI 集成配置
module.exports = {
  // 项目基本信息
  project: {
    name: 'my-integrated-project',
    version: '1.0.0',
    description: 'BMad-Method 与 Auggie CLI 集成项目',
    repository: 'https://github.com/username/my-integrated-project'
  },

  // 集成配置
  integrations: {
    auggie: {
      // 启用 Auggie CLI 集成
      enabled: true,
      
      // 规则文件路径
      rules: [
        '.augment/rules/bmad-integration.md',
        '.augment/rules/security-rules.md',
        '.augment/rules/performance-rules.md'
      ],
      
      // 触发器配置
      triggers: {
        'pre-commit': {
          enabled: true,
          rules: ['bmad-integration', 'security-rules'],
          failOnError: true,
          timeout: 30000 // 30秒超时
        },
        'pre-push': {
          enabled: true,
          rules: ['bmad-integration', 'security-rules', 'performance-rules'],
          failOnError: true,
          timeout: 60000 // 60秒超时
        },
        'pr-review': {
          enabled: true,
          rules: ['bmad-integration', 'security-rules', 'performance-rules'],
          failOnError: false, // PR 审查不阻塞，仅提供建议
          timeout: 120000 // 120秒超时
        }
      },
      
      // Auggie CLI 选项
      options: {
        // 启用上下文引擎
        contextEngine: true,
        
        // 自动修复（谨慎使用）
        autoFix: false,
        
        // 报告格式
        reportFormat: 'markdown',
        
        // 详细程度
        verbose: true,
        
        // 并发处理
        concurrency: 4,
        
        // 缓存配置
        cache: {
          enabled: true,
          ttl: 3600000, // 1小时缓存
          directory: '.augment/cache'
        }
      }
    }
  },

  // BMad-Method 工作流配置
  workflows: {
    // 代码审查工作流
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
          command: 'auggie --print "根据 BMad-Method 标准审查此代码"',
          required: true
        },
        {
          name: '更新知识库',
          command: 'bmad-method update-kb',
          required: false
        }
      ]
    },
    
    // 持续集成工作流
    continuousIntegration: {
      name: '持续集成工作流',
      steps: [
        {
          name: '代码质量检查',
          command: 'bmad-method lint',
          required: true
        },
        {
          name: '安全扫描',
          command: 'auggie --rules .augment/rules/security-rules.md --quiet',
          required: true
        },
        {
          name: '性能分析',
          command: 'auggie --rules .augment/rules/performance-rules.md --quiet',
          required: false
        }
      ]
    }
  },

  // 环境配置
  environments: {
    development: {
      auggie: {
        options: {
          verbose: true,
          autoFix: false,
          reportFormat: 'console'
        }
      }
    },
    staging: {
      auggie: {
        options: {
          verbose: false,
          autoFix: false,
          reportFormat: 'json'
        }
      }
    },
    production: {
      auggie: {
        options: {
          verbose: false,
          autoFix: false,
          reportFormat: 'json',
          onlyErrors: true
        }
      }
    }
  },

  // 通知配置
  notifications: {
    slack: {
      enabled: false,
      webhook: process.env.SLACK_WEBHOOK_URL,
      channels: {
        errors: '#dev-alerts',
        reports: '#code-review'
      }
    },
    email: {
      enabled: false,
      smtp: {
        host: process.env.SMTP_HOST,
        port: process.env.SMTP_PORT,
        auth: {
          user: process.env.SMTP_USER,
          pass: process.env.SMTP_PASS
        }
      },
      recipients: ['dev-team@company.com']
    }
  }
};
