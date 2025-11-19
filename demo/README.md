# ANSAI Docker Playground

Try ANSAI's AI-powered self-healing **without installing anything** on your system.

## 🚀 Quick Start (30 seconds)

```bash
# 1. Clone ANSAI
git clone https://github.com/thebyrdman-git/ansai.git
cd ansai/demo

# 2. Start the playground
docker-compose up -d

# 3. Enter the environment
docker exec -it ansai-playground /bin/bash

# 4. Run the demo
ansai-demo
```

## 🎬 What You'll See

The interactive demo will:

1. ✅ Start a Flask web service
2. 💥 Crash it intentionally
3. 🔍 Show ANSAI detecting the failure
4. 🤖 Display AI root cause analysis
5. ✅ Automatically heal the service

**Total time:** ~30 seconds from crash to recovery.

## 🎮 Demo Modes

### Mode 1: With Real AI (Recommended)

```bash
# Set your Groq API key (free: console.groq.com)
export ANSAI_GROQ_API_KEY="gsk_your_key_here"

# Start with AI enabled
docker-compose up -d

# Enter and run demo
docker exec -it ansai-playground /bin/bash
ansai-demo
```

**You'll see:** Real AI analysis from Groq explaining WHY the service failed.

### Mode 2: Demo Mode (No API Key)

```bash
# Start without API key
docker-compose up -d

# Demo runs with simulated AI output
docker exec -it ansai-playground /bin/bash
ansai-demo
```

**You'll see:** Simulated AI analysis showing what ANSAI does.

## 🔧 Manual Testing

Inside the container, you can experiment freely:

```bash
# Check service status
systemctl status demo-app

# Watch logs in real-time
journalctl -u demo-app -f

# Test the app
curl localhost:5000/          # API docs
curl localhost:5000/health    # Health check

# Trigger failures manually
curl localhost:5000/crash     # Immediate crash
curl localhost:5000/hang      # Simulate timeout

# Restart service manually
sudo systemctl restart demo-app
```

## 📦 What's Inside

The playground includes:

- **demo-app**: A Flask web service that can fail on command
- **systemd**: Real service management (crashes are real)
- **ANSAI**: Full self-healing framework
- **AI integration**: Groq API support (with your key)

## 🛠️ Customization

### Use Your Own Service

Edit `demo-flask-app.py` to replace the demo app with your own:

```python
# Your Flask app here
@app.route('/your-endpoint')
def your_handler():
    return {"status": "running"}
```

Rebuild: `docker-compose build`

### Test Different Failures

```bash
# Memory leak
curl localhost:5000/memory

# Connection timeout
curl localhost:5000/hang

# Hard crash
curl localhost:5000/crash
```

## 📊 Expected Output

```
╔═══════════════════════════════════════════════════════════╗
║     🤖 ANSAI Interactive Demo                             ║
║     Watch AI-Powered Self-Healing in Real-Time           ║
╚═══════════════════════════════════════════════════════════╝

Step 1: Starting demo-app service
✅ Service started successfully

Step 2: Crashing the service
💥 Service crashed

Step 3: ANSAI Detection & AI Root Cause Analysis
🤖 AI-POWERED ROOT CAUSE ANALYSIS

ROOT CAUSE:
The demo-app service crashed due to unhandled exception...

Step 4: ANSAI Self-Healing
✅ SUCCESS: Service healed and running
```

## 🧹 Cleanup

```bash
# Stop and remove container
docker-compose down

# Remove all data
docker-compose down -v
```

## 🐛 Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs

# Verify Docker supports systemd
docker info | grep -i cgroup
```

### Service won't start inside container

```bash
# Enter container
docker exec -it ansai-playground /bin/bash

# Check service status
sudo systemctl status demo-app

# View logs
sudo journalctl -u demo-app -n 50
```

### AI analysis not working

```bash
# Verify API key is set
echo $ANSAI_GROQ_API_KEY

# Test Groq API directly
curl https://api.groq.com/openai/v1/models \
  -H "Authorization: Bearer $ANSAI_GROQ_API_KEY"
```

## 💡 Next Steps

After trying the playground:

1. **Deploy to production**: Follow the [Quick Start Guide](http://ansai.dev#quick-start)
2. **Read the docs**: [ansai.dev](http://ansai.dev)
3. **Join the community**: [GitHub Discussions](https://github.com/thebyrdman-git/ansai/discussions)

## 🤝 Contributing

Found a bug? Have an idea? [Open an issue](https://github.com/thebyrdman-git/ansai/issues)!

