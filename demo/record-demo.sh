#!/bin/bash
# Script to record ANSAI demo for GIF generation
# Requires: asciinema and agg

set -e

echo "═══════════════════════════════════════════════════════"
echo "  🎬 ANSAI Demo Recording Script"
echo "═══════════════════════════════════════════════════════"
echo ""

# Check for asciinema
if ! command -v asciinema &> /dev/null; then
    echo "❌ asciinema not found"
    echo "   Install: pip3 install asciinema"
    exit 1
fi

# Check for agg and offer to install
if ! command -v agg &> /dev/null; then
    echo "⚠️  agg not found (needed to convert to GIF)"
    echo ""
    echo "Install agg? (y/n)"
    read -r install_agg
    if [[ "$install_agg" == "y" ]]; then
        echo "Installing agg..."
        cd /tmp
        curl -L -o agg https://github.com/asciinema/agg/releases/download/v1.4.3/agg-x86_64-unknown-linux-gnu
        chmod +x agg
        sudo mv agg /usr/local/bin/
        echo "✅ agg installed"
        echo ""
    else
        echo "Continuing without agg - you can convert later..."
        echo ""
    fi
fi

# Create output directory
mkdir -p /home/jbyrd/ansai/docs/images

echo "Starting recording in 3 seconds..."
echo "This will run the demo script automatically."
echo ""
sleep 3

# Record the demo
asciinema rec -c "bash /home/jbyrd/ansai/demo/try-ansai.sh" \
    --title "ANSAI: AI-Powered Self-Healing in Action" \
    --overwrite \
    /home/jbyrd/ansai/demo/ansai-demo.cast

echo ""
echo "✅ Recording saved to: demo/ansai-demo.cast"
echo ""

# Convert to GIF if agg is available
if command -v agg &> /dev/null; then
    echo "Converting to GIF..."
    agg \
        --theme monokai \
        --font-size 16 \
        --line-height 1.3 \
        --cols 100 \
        --rows 30 \
        /home/jbyrd/ansai/demo/ansai-demo.cast \
        /home/jbyrd/ansai/docs/images/ansai-demo.gif
    
    echo "✅ GIF saved to: docs/images/ansai-demo.gif"
    echo ""
    echo "File size: $(du -h /home/jbyrd/ansai/docs/images/ansai-demo.gif | cut -f1)"
else
    echo "⚠️  Skipping GIF conversion (agg not installed)"
    echo ""
    echo "To convert manually:"
    echo "  npm install -g @asciinema/agg"
    echo "  agg demo/ansai-demo.cast docs/images/ansai-demo.gif"
fi

echo ""
echo "🎉 Demo recording complete!"
echo ""
echo "Next steps:"
echo "  1. Review the GIF: open docs/images/ansai-demo.gif"
echo "  2. Add to landing page (already done in code)"
echo "  3. Commit and deploy"
echo ""

