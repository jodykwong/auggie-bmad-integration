# 🤝 Contributing to Auggie CLI × BMad-Method Integration

Thank you for your interest in contributing to this project! We welcome contributions from the community and are pleased to have you join us.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)
- [Feature Requests](#feature-requests)

## 📜 Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## 🚀 Getting Started

### Prerequisites

- Node.js 22 or higher
- Git
- Basic knowledge of JavaScript, Shell scripting, and GitHub Actions
- Familiarity with Auggie CLI and BMad-Method (helpful but not required)

### First Steps

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/your-username/auggie-bmad-integration.git
   cd auggie-bmad-integration
   ```
3. **Create a branch** for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 🛠️ How to Contribute

### Types of Contributions

We welcome several types of contributions:

- 🐛 **Bug fixes**
- ✨ **New features**
- 📖 **Documentation improvements**
- 🧪 **Tests**
- 🎨 **UI/UX improvements**
- 🔧 **Configuration enhancements**
- 📱 **Platform support** (new OS support)

### Areas Where Help is Needed

- **Testing**: Cross-platform testing, edge case handling
- **Documentation**: Translations, examples, tutorials
- **Features**: New integration options, additional tools support
- **Performance**: Script optimization, caching improvements
- **Security**: Security audits, vulnerability fixes

## 💻 Development Setup

### Local Development

1. **Install dependencies**:
   ```bash
   # Install global dependencies
   npm install -g @augmentcode/auggie
   npx bmad-method install
   ```

2. **Test the setup scripts**:
   ```bash
   # Test on Linux/macOS
   ./setup.sh --dry-run
   
   # Test on Windows (in Command Prompt)
   setup.bat --dry-run
   ```

3. **Validate configuration files**:
   ```bash
   # Validate JavaScript syntax
   node -c bmad-integration-config-examples/bmad-config.js
   node -c bmad-integration-config-examples/scripts/generate-integrated-report.js
   ```

### Testing Your Changes

Before submitting, please test your changes:

1. **Manual Testing**:
   ```bash
   # Create a test directory
   mkdir test-integration
   cd test-integration
   
   # Run your modified setup script
   ../setup.sh
   
   # Verify all files are created correctly
   ls -la
   ```

2. **Cross-Platform Testing**:
   - Test on different operating systems if possible
   - Verify shell scripts work in different shell environments
   - Test batch scripts on different Windows versions

## 📏 Coding Standards

### Shell Scripts (setup.sh)

- Use `#!/bin/bash` shebang
- Include `set -e` for error handling
- Use meaningful variable names
- Add comments for complex logic
- Follow POSIX compatibility when possible

```bash
# Good example
TARGET_DIR="${1:-.}"
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory does not exist"
    exit 1
fi
```

### Batch Scripts (setup.bat)

- Use `@echo off` at the beginning
- Include error handling with appropriate exit codes
- Use meaningful variable names
- Add comments for complex logic

```batch
REM Good example
set "TARGET_DIR=%~1"
if "%TARGET_DIR%"=="" set "TARGET_DIR=.."
if not exist "%TARGET_DIR%" (
    echo Error: Directory does not exist
    exit /b 1
)
```

### JavaScript Files

- Use ES6+ features when appropriate
- Include JSDoc comments for functions
- Follow consistent indentation (2 spaces)
- Use meaningful variable and function names

```javascript
/**
 * Generates an integrated report from multiple sources
 * @param {Object} bmadReport - BMad-Method analysis report
 * @param {Object} auggieReports - Auggie CLI analysis reports
 * @returns {string} Formatted markdown report
 */
function generateMarkdownReport(bmadReport, auggieReports) {
  // Implementation here
}
```

### Documentation

- Use clear, concise language
- Include code examples where appropriate
- Keep README.md up to date
- Use proper Markdown formatting
- Include emoji for better readability (but don't overuse)

## 📤 Submitting Changes

### Pull Request Process

1. **Update documentation** if needed
2. **Add or update tests** for your changes
3. **Ensure all tests pass**
4. **Update CHANGELOG.md** with your changes
5. **Create a pull request** with a clear title and description

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Other (please describe)

## Testing
- [ ] Tested on Linux/macOS
- [ ] Tested on Windows
- [ ] Manual testing completed
- [ ] All existing functionality still works

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
```

### Commit Message Guidelines

Use clear, descriptive commit messages:

```bash
# Good examples
git commit -m "feat: add support for custom rule directories"
git commit -m "fix: handle spaces in file paths on Windows"
git commit -m "docs: update installation instructions"
git commit -m "refactor: improve error handling in setup script"
```

Format: `type(scope): description`

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

## 🐛 Reporting Issues

### Before Reporting

1. **Search existing issues** to avoid duplicates
2. **Test with the latest version**
3. **Gather system information** (OS, Node.js version, etc.)

### Issue Template

```markdown
## Bug Description
Clear description of the bug

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- OS: [e.g., Ubuntu 20.04, Windows 10, macOS 12]
- Node.js version: [e.g., 22.0.0]
- Auggie CLI version: [e.g., 1.0.0]
- BMad-Method version: [e.g., 4.43.0]

## Additional Context
Any other relevant information
```

## 💡 Feature Requests

We welcome feature requests! Please:

1. **Check existing issues** for similar requests
2. **Describe the problem** you're trying to solve
3. **Propose a solution** if you have one in mind
4. **Consider the scope** - is this a common use case?

### Feature Request Template

```markdown
## Feature Description
Clear description of the proposed feature

## Problem Statement
What problem does this solve?

## Proposed Solution
How should this feature work?

## Alternatives Considered
Other approaches you've considered

## Additional Context
Any other relevant information
```

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page

## 📞 Getting Help

If you need help:

1. **Check the documentation** first
2. **Search existing issues**
3. **Create a new issue** with the "question" label
4. **Join discussions** in existing issues

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing! 🎉
