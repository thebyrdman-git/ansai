# Contributing to ANSAI

**Welcome, Builder!** 🎨

ANSAI isn't just software - it's a creative platform. Think of it like Minecraft or Lego: we provide the blocks, you build amazing things.

## 🎯 How You Can Contribute

### 1. Share Your Creations (MOST VALUABLE!)

**Built something cool with ANSAI?** This is what we want most!

**Examples of community creations:**
- Custom healing strategies for specific applications
- Integration with services we haven't thought of
- Novel orchestration workflows
- Creative combinations of existing blocks
- Industry-specific automation patterns

**How to share:**
1. Open a [Show & Tell discussion](https://github.com/thebyrdman-git/ansai/discussions/categories/show-and-tell)
2. Describe what you built and why
3. Share code/config (optional but appreciated!)
4. Explain what problems it solves

**The best community creations become official examples!**

### 2. Request Building Blocks

**Missing a piece you need?** Tell us!

**Good requests include:**
- The problem you're trying to solve
- What building block would help
- How you'd use it
- Bonus: A rough implementation idea

**Where to request:**
- [Ideas Discussion](https://github.com/thebyrdman-git/ansai/discussions/categories/ideas)
- Be specific about YOUR use case, not generic features

### 3. Improve Examples & Patterns

**Found a better way to do something?**

- Submit improved examples
- Add comments explaining WHY, not just WHAT
- Share alternative approaches
- Document edge cases you discovered

### 4. Fix Bugs & Issues

**Something broken?**

1. Search [existing issues](https://github.com/thebyrdman-git/ansai/issues)
2. If not found, create a new issue with:
   - What you were trying to build
   - What happened vs. what you expected
   - Steps to reproduce
   - Your environment (OS, Ansible version, etc.)

**Want to fix it yourself?**
1. Fork the repository
2. Create a branch: `git checkout -b fix/issue-description`
3. Make your fix
4. Test thoroughly
5. Submit a PR with clear description

### 5. Improve Documentation

**Documentation that helps builders:**
- Real-world examples
- "How I built X" tutorials
- Common pitfalls and solutions
- Creative use cases
- Video tutorials or demos

**Not helpful:**
- Generic API documentation (code is self-documenting)
- Explaining Ansible basics (users should know Ansible)
- Long-winded explanations (show, don't tell)

## 🚀 Getting Started

### For First-Time Contributors

```bash
# 1. Fork & clone
git clone https://github.com/YOUR_USERNAME/ansai.git
cd ansai

# 2. Create a branch for your contribution
git checkout -b feature/my-awesome-creation

# 3. Make your changes

# 4. Test locally
cd orchestrators/ansible
ansible-playbook --check playbooks/deploy-self-healing.yml

# 5. Commit with clear message
git add .
git commit -m "feat: Add ChatOps integration example"

# 6. Push and create PR
git push origin feature/my-awesome-creation
```

### Contribution Guidelines

#### Commit Messages
We use conventional commits:
- `feat:` New building block or pattern
- `fix:` Bug fixes
- `docs:` Documentation improvements
- `example:` New examples or tutorials
- `test:` Test additions or fixes
- `refactor:` Code improvements without functionality changes

```bash
# Good commits
feat: Add Slack notification integration block
example: Multi-region failover with custom logic
docs: Tutorial on building ChatOps workflows
fix: Healing script fails with PostgreSQL 15

# Bad commits
Update stuff
Fixed it
Changes
WIP
```

#### Code Style

**Ansible Playbooks:**
- Use descriptive task names
- Comment WHY, not WHAT
- Group related tasks logically
- Use meaningful variable names
- Follow [Ansible best practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

**Shell Scripts:**
- Use `shellcheck` for validation
- Add comments for complex logic
- Handle errors gracefully
- Use meaningful function names

**Python:**
- Follow PEP 8
- Type hints for public functions
- Docstrings for modules and functions
- Keep it simple (remember: users will customize this)

#### Testing Your Contribution

**Before submitting:**

```bash
# 1. Test deployment
cd orchestrators/ansible
ansible-playbook --check playbooks/deploy-self-healing.yml

# 2. Run test suite
cd tests
./run-all-tests.sh

# 3. Test in a VM or container
# Don't submit PRs that "work on my machine" but untested elsewhere
```

## 🌟 Types of Contributions We Love

### ⭐⭐⭐ HIGHLY VALUED
- **Community creations**: "Here's what I built!"
- **Real-world examples**: "Here's how I solved X"
- **Novel integrations**: Connecting ANSAI to new services
- **Pattern libraries**: Reusable, tested patterns
- **Video tutorials**: Show, don't just tell

### ⭐⭐ VERY VALUABLE
- **Bug fixes**: Especially with test cases
- **Documentation improvements**: With real examples
- **Test coverage**: Expanding the test suite
- **Performance improvements**: With benchmarks

### ⭐ HELPFUL
- **Code refactoring**: Keep it simple
- **Dependency updates**: If needed and tested
- **CI/CD improvements**: Faster, more reliable builds

### ❌ NOT DESIRED
- **Massive rewrites**: Talk to us first
- **New dependencies**: Unless absolutely necessary
- **Breaking changes**: Without community consensus
- **Generic "improvements"**: Without clear use case
- **Premature optimization**: Show it's actually a problem first

## 🤝 Community Guidelines

### The ANSAI Way

**We are builders helping builders.**

- **Be respectful**: Everyone is learning
- **Be specific**: "Here's what I tried" beats "it doesn't work"
- **Be constructive**: Suggest improvements, don't just criticize
- **Be creative**: There's no "right" way to use ANSAI
- **Share generously**: Help others learn from your work

### What We Celebrate

- **Creativity**: Novel solutions to problems
- **Simplicity**: Elegant over complex
- **Practicality**: Solves real problems
- **Generosity**: Sharing knowledge and code
- **Collaboration**: Building on each other's work

### What We Don't Tolerate

- **Gatekeeping**: "You're doing it wrong"
- **Elitism**: Making others feel inferior
- **Harassment**: Of any kind, for any reason
- **Spam**: Self-promotion without value
- **Plagiarism**: Claiming others' work as your own

## 📊 Recognition & Credit

### How We Recognize Contributors

- **Show & Tell Features**: Best creations highlighted
- **Contributors List**: Everyone who helps
- **Official Examples**: Top community patterns become official
- **Maintainer Status**: Active, helpful contributors
- **Conference Talks**: Present your creations

### Authorship & Licensing

- **You own your creations**: Always
- **MIT License**: For contributions to the main repo
- **Attribution**: We credit original authors
- **Derivative Works**: Encouraged! Share improvements back

## 🚀 Becoming a Maintainer

**Active contributors can become maintainers.**

**What we look for:**
- Consistent, quality contributions
- Helpful community engagement
- Understanding of ANSAI philosophy
- Collaborative mindset
- Initiative and ownership

**Maintainer privileges:**
- Merge PRs
- Triage issues
- Guide roadmap
- Shape community
- Represent ANSAI

**Interested?** Contribute regularly and we'll reach out!

## 📚 Resources

- **[Documentation](docs/)**: Complete guides
- **[GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)**: Ask questions, share ideas
- **[Issue Tracker](https://github.com/thebyrdman-git/ansai/issues)**: Known problems
- **[Show & Tell](https://github.com/thebyrdman-git/ansai/discussions/categories/show-and-tell)**: Community creations
- **[Roadmap](docs/Q1_2025_GROWTH_PLAN.md)**: What's coming

## ❓ Questions?

**Before contributing:**
- Check existing discussions and issues
- Review documentation
- Test locally first

**Still stuck?**
- Ask in [GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)
- Be specific about what you're trying to build
- Share what you've tried so far

---

## 🎨 Remember: You're Not Just Contributing Code

**You're sharing creativity, solving problems, and inspiring others.**

Every contribution - whether it's a bug fix, a new pattern, a tutorial, or just sharing what you built - makes ANSAI better for everyone.

**Thank you for being part of this community!** 🚀

---

*ANSAI: The building blocks. Your creativity. Infinite possibilities.*

