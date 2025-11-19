# Contributing Workflows to ANSAI

**Help build the most useful AI-powered automation library.**

---

## 🎯 What We're Looking For

**Great workflow contributions:**
- Solve real problems
- Use AI meaningfully (not just for hype)
- Are well-documented
- Include examples
- Handle errors gracefully
- Work with multiple AI backends

**We especially want:**
- AI-powered analysis tools
- Intelligent automation workflows
- Creative AI integrations
- Real-world use cases
- Galaxy role enhancements

---

## 🚀 Quick Start

### 1. Set Up Development Environment

```bash
# Clone ANSAI
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai

# Create your workflow directory
mkdir -p examples/workflows/your-category
cd examples/workflows/your-category

# Copy the template
cp ../../TEMPLATE.sh your-workflow-name
chmod +x your-workflow-name
```

### 2. Develop Your Workflow

```bash
# Edit your workflow
vim your-workflow-name

# Test it
./your-workflow-name --help
./your-workflow-name [test-args]
```

### 3. Document It

```bash
# Create README
cat > README.md << 'EOF'
# Your Workflow Name

## What It Does
...

## How To Use
...

## Examples
...
EOF
```

### 4. Submit It

```bash
# Create a branch
git checkout -b feature/your-workflow-name

# Add your files
git add examples/workflows/your-category/

# Commit
git commit -m "Add your-workflow-name: Brief description"

# Push and create PR
git push origin feature/your-workflow-name
```

---

## 📋 Workflow Template

Use this as your starting point:

```bash
#!/bin/bash
# ansai-your-workflow - Brief description
# Part of ANSAI AI-Powered Workflows

set -euo pipefail

# Configuration
LITELLM_URL="${LITELLM_URL:-http://localhost:4000}"
DEFAULT_MODEL="${ANSAI_AI_MODEL:-gpt-4o}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Help function
show_help() {
    cat << EOF
ansai-your-workflow - Brief description

USAGE:
    ansai-your-workflow [OPTIONS] <arguments>

OPTIONS:
    --option VALUE    Description
    --help, -h        Show this help

EXAMPLES:
    ansai-your-workflow --option value

REQUIRES:
    - LiteLLM proxy running (ansai-litellm-proxy)
    - API key configured
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            # Handle other arguments
            shift
            ;;
    esac
done

# Check if LiteLLM is running
if ! curl -s "$LITELLM_URL/health" >/dev/null 2>&1; then
    echo -e "${RED}❌ LiteLLM proxy not running${NC}" >&2
    exit 1
fi

# Your workflow logic here

# Call AI
REQUEST_BODY=$(cat << EOF
{
  "model": "$DEFAULT_MODEL",
  "messages": [
    {
      "role": "system",
      "content": "You are..."
    },
    {
      "role": "user",
      "content": "..."
    }
  ]
}
EOF
)

RESPONSE=$(curl -s -X POST "$LITELLM_URL/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -d "$REQUEST_BODY")

# Extract and display result
RESULT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
echo "$RESULT"
```

---

## ✅ Checklist Before Submitting

### Functionality
- [ ] Works with LiteLLM
- [ ] Works with at least 2 AI models (GPT-4, Claude, or local)
- [ ] Handles errors gracefully
- [ ] Returns meaningful exit codes
- [ ] Includes `--help` option
- [ ] Tests pass

### Code Quality
- [ ] Uses `set -euo pipefail`
- [ ] Has proper error checking
- [ ] Uses meaningful variable names
- [ ] Includes comments for complex logic
- [ ] Follows shell best practices

### Documentation
- [ ] Has comprehensive README.md
- [ ] Includes usage examples
- [ ] Documents prerequisites
- [ ] Shows expected output
- [ ] Lists common issues

### User Experience
- [ ] Clear, helpful error messages
- [ ] Colored output for readability
- [ ] Progress indicators for long operations
- [ ] Sensible defaults
- [ ] Environment variable support

---

## 📝 Documentation Standards

### README.md Structure

```markdown
# Workflow Name

## What It Does

Brief description (1-2 sentences)

## Use Cases

- Use case 1
- Use case 2
- Use case 3

## Prerequisites

- Requirement 1
- Requirement 2

## Installation

```bash
# Installation steps
```

## Usage

### Basic Usage

```bash
# Basic example
```

### Advanced Usage

```bash
# Advanced example
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| --option | Description | default |

## Examples

### Example 1: Common Scenario

```bash
# Command
```

**Output:**
```
# Expected output
```

### Example 2: Advanced Scenario

```bash
# Command
```

**Output:**
```
# Expected output
```

## Configuration

Environment variables:
- `VAR_NAME`: Description (default: value)

## Troubleshooting

### Issue: Common problem

**Solution:**
```bash
# Fix
```

## Learn More

- Related docs
- Related workflows

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev
```

---

## 🎯 AI Integration Best Practices

### 1. Use Meaningful System Prompts

**Good:**
```json
{
  "role": "system",
  "content": "You are an expert DevOps engineer analyzing deployment manifests for production safety. Be thorough but concise. Focus on preventing outages."
}
```

**Bad:**
```json
{
  "role": "system",
  "content": "You are a helpful assistant."
}
```

### 2. Structure User Prompts Well

**Good:**
```
Analyze this Kubernetes deployment for production.

Deployment content:
```yaml
[manifest]
```

Check for:
1. Security issues
2. Resource limits
3. Health checks
4. Best practices

Format as markdown with severity levels.
```

**Bad:**
```
Look at this and tell me if it's good
[content]
```

### 3. Handle AI Errors Gracefully

```bash
# Check for API errors
if echo "$RESPONSE" | jq -e '.error' >/dev/null 2>&1; then
    ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message')
    echo -e "${RED}❌ AI analysis failed: $ERROR_MSG${NC}" >&2
    
    # Provide fallback or guidance
    echo "Try again with a different model or check your API key." >&2
    exit 1
fi
```

### 4. Set Appropriate Temperature

```json
{
  "temperature": 0.2  // For factual analysis
}
```

```json
{
  "temperature": 0.7  // For creative suggestions
}
```

### 5. Limit Token Usage

```json
{
  "max_tokens": 2000  // Keep costs reasonable
}
```

---

## 🧪 Testing Your Workflow

### Manual Testing

```bash
# Test help
./your-workflow --help

# Test with valid input
./your-workflow --option value

# Test with invalid input
./your-workflow --invalid-option

# Test without LiteLLM running
systemctl stop litellm
./your-workflow
systemctl start litellm

# Test with different AI models
ANSAI_AI_MODEL="gpt-4o" ./your-workflow
ANSAI_AI_MODEL="claude-3-opus" ./your-workflow
ANSAI_AI_MODEL="groq/llama3-8b-8192" ./your-workflow
```

### Automated Testing

Create `tests/test-your-workflow.sh`:

```bash
#!/bin/bash

set -e

echo "Testing your-workflow..."

# Test 1: Help works
./your-workflow --help > /dev/null
echo "✅ Help works"

# Test 2: Basic functionality
OUTPUT=$(echo "test input" | ./your-workflow)
if [[ "$OUTPUT" == *"expected"* ]]; then
    echo "✅ Basic functionality works"
else
    echo "❌ Basic functionality failed"
    exit 1
fi

# Test 3: Error handling
if ./your-workflow --invalid 2>/dev/null; then
    echo "❌ Error handling failed"
    exit 1
else
    echo "✅ Error handling works"
fi

echo "All tests passed!"
```

---

## 📊 Performance Considerations

### 1. Cache AI Responses

For expensive operations:

```bash
CACHE_DIR="$HOME/.cache/ansai/your-workflow"
mkdir -p "$CACHE_DIR"

# Generate cache key
CACHE_KEY=$(echo "$INPUT" | md5sum | cut -d' ' -f1)
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"

# Check cache
if [[ -f "$CACHE_FILE" ]] && [[ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt 3600 ]]; then
    cat "$CACHE_FILE"
    exit 0
fi

# Call AI and cache
RESPONSE=$(call_ai_function)
echo "$RESPONSE" > "$CACHE_FILE"
echo "$RESPONSE"
```

### 2. Batch Requests

Instead of:
```bash
for file in *.log; do
    analyze_file "$file"
done
```

Do:
```bash
ALL_LOGS=$(cat *.log)
analyze_all "$ALL_LOGS"
```

### 3. Use Cheaper Models for Simple Tasks

```bash
# For simple categorization
MODEL="groq/llama3-8b-8192"  # Fast and cheap

# For complex analysis
MODEL="gpt-4o"  # More capable
```

---

## 🎨 Categories for Workflows

Place your workflow in the appropriate category:

- **`ai-powered/`**: Core AI workflows (log analysis, incident reports)
- **`automation/`**: General automation tools
- **`monitoring/`**: Monitoring and alerting
- **`security/`**: Security and compliance
- **`deployment/`**: Deployment and CI/CD
- **`user-experience/`**: CLI tools and UX improvements
- **`context-management/`**: Environment and context switching
- **`secrets-management/`**: Secrets and credential management
- **`integrations/`**: Third-party integrations

Not sure? Ask in the PR!

---

## 💡 Inspiration Sources

### 1. Ansible Galaxy
Browse popular roles: https://galaxy.ansible.com

**Ideas:**
- Take a popular pattern
- Add AI intelligence
- Document the enhancement

### 2. Your Own Pain Points
What manual tasks do you hate?

**Examples:**
- Reading logs
- Writing documentation
- Reviewing deployments
- Debugging incidents

### 3. Community Requests
Check: https://github.com/thebyrdman-git/ansai/discussions/categories/ideas

### 4. Other Tools
What tools do you use that could be smarter?

**Examples:**
- kubectl → AI-powered Kubernetes management
- docker → AI-optimized container configs
- git → AI commit message generation

---

## 🤝 Review Process

### What We Look For

**✅ Approve:**
- Solves real problem
- Well-documented
- Tested thoroughly
- Follows best practices
- Meaningful AI use

**❌ Request Changes:**
- Missing documentation
- No error handling
- Hard-coded values
- AI used superficially
- Doesn't follow template

**💬 Discussion:**
- Novel approach
- Multiple valid implementations
- Architectural questions
- Scope clarification

### Typical Review Timeline

1. **Initial Review:** 1-3 days
2. **Feedback:** You address comments
3. **Second Review:** 1-2 days
4. **Merge:** Within 1 week (if all good)

---

## 📢 After Your PR Merges

### 1. We'll Add It To:
- Examples showcase page
- GitHub README
- Social media shoutout

### 2. You Get:
- Contributor recognition
- Link to your profile
- Community karma 🎉

### 3. Help Others:
- Answer questions about your workflow
- Maintain it (fixes, updates)
- Share your experience

---

## 🆘 Getting Help

### Before Submitting

**Questions?** Ask in:
- **Discussions:** https://github.com/thebyrdman-git/ansai/discussions/categories/q-a
- **Ideas:** https://github.com/thebyrdman-git/ansai/discussions/categories/ideas

### During Review

**Need clarification?**
- Comment on your PR
- Tag maintainers
- Join discussions

### After Merging

**Issues with your workflow?**
- You'll be notified
- Help troubleshoot
- Release updates

---

## 🏆 Hall of Fame

**Top Contributors** (coming soon):
- Creator recognition
- Featured workflows
- Community kudos

---

## 📚 Resources

- **Template:** `examples/workflows/TEMPLATE.sh`
- **Examples:** `examples/workflows/ai-powered/`
- **Docs:** https://ansai.dev
- **Community:** https://github.com/thebyrdman-git/ansai/discussions

---

## 🎯 Quick Reference

**Contribution Flow:**
```bash
1. Fork & clone
2. Create branch
3. Develop workflow
4. Write docs
5. Test thoroughly
6. Submit PR
7. Address feedback
8. Merge! 🎉
```

**Required Files:**
- `your-workflow` (executable script)
- `README.md` (documentation)
- `tests/test-your-workflow.sh` (optional but recommended)

**Code Style:**
- Use `set -euo pipefail`
- Include `--help` option
- Check LiteLLM health
- Handle errors gracefully
- Provide colored output

---

**Thank you for contributing to ANSAI!** 🚀  
**Your workflows help the entire community build intelligent automation.**

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev


