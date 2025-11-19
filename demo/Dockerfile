# ANSAI Demo Environment
# Try ANSAI without installing anything on your system

FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ansible \
    curl \
    systemd \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install AI dependencies
RUN pip3 install litellm

# Create a demo user
RUN useradd -m -s /bin/bash demo && \
    echo "demo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy ANSAI
WORKDIR /home/demo
COPY . /home/demo/ansai
RUN chown -R demo:demo /home/demo/ansai

# Create a simple demo service that will "fail"
RUN echo '#!/bin/bash\nwhile true; do\n  echo "Demo service running..."\n  sleep 5\ndone' > /usr/local/bin/demo-service && \
    chmod +x /usr/local/bin/demo-service

# Create systemd service for demo
RUN echo '[Unit]\nDescription=ANSAI Demo Service\n\n[Service]\nType=simple\nExecStart=/usr/local/bin/demo-service\nRestart=always\n\n[Install]\nWantedBy=multi-user.target' > /etc/systemd/system/demo-service.service

USER demo
WORKDIR /home/demo

# Expose port for any web services
EXPOSE 4000

CMD ["/bin/bash", "-c", "echo 'ANSAI Demo Environment Ready!' && echo 'Try: sudo systemctl stop demo-service' && echo 'Then watch ANSAI heal it automatically!' && /bin/bash"]

