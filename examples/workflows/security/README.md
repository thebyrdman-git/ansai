# Security Workflows

Security-focused automation workflows for auditing, hardening, and monitoring infrastructure.

## 🛡️ ansai-git-security-audit

A comprehensive security scanner for Git repositories to ensure they are safe for public release.

### Features
- **Sensitive Data Detection**: Finds passwords, API keys, tokens, and secrets
- **Personal Info Scanning**: Detects emails, domains, and internal paths
- **Artifact Cleanup**: Identifies accidental tracking of build artifacts and temp files
- **.gitignore Validation**: Checks for essential ignore patterns
- **AI Analysis**: Optional AI-powered risk assessment and remediation advice
- **Report Generation**: Creates detailed Markdown reports of findings

### Usage
```bash
# Audit current directory
./ansai-git-security-audit

# Audit specific repository
./ansai-git-security-audit /path/to/repo

# Generate AI analysis (requires LiteLLM or Fabric)
export ANSAI_AI_BACKEND="litellm"
./ansai-git-security-audit
```

### Return Codes
- `0`: Clean (Safe to publish)
- `1`: Warnings (Needs cleanup)
- `2`: Critical (DO NOT publish)

### Example Output
```
╔════════════════════════════════════════════════════════════╗
║                    AUDIT SUMMARY                           ║
╚════════════════════════════════════════════════════════════╝

Total Issues Found: 4
  Sensitive Data: 0
  Personal Info: 2
  Temp Files: 1
  Build Artifacts: 1

✅ SUCCESS: Repository appears clean
   Ready for public distribution
```

