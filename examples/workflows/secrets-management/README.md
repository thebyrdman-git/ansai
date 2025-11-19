# Vault Read - Secure Secrets Management

## Purpose

Securely retrieve secrets from HashiCorp Vault using a simple command-line interface. Supports both local and remote Vault instances, making it easy to integrate secure credential management into any automation workflow.

## What It Demonstrates

- **Secrets Management:** Secure storage and retrieval of sensitive credentials
- **Security Patterns:** Token-based authentication, encrypted storage
- **Remote Access:** SSH tunneling for secure remote Vault access
- **Error Handling:** Clear error messages and security guidance
- **Integration Patterns:** Environment variable configuration, JSON parsing

## Prerequisites

- HashiCorp Vault installed (local or remote)
- `vault` CLI installed
- `jq` for JSON parsing
- Optional: SSH access to remote Vault server
- Vault token with read permissions

## Configuration

### Local Vault Setup

```bash
# Start Vault (development mode for testing)
vault server -dev

# In another terminal, set environment variables
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN='your-root-token'

# Store a secret
vault kv put app/database username=dbuser password=secretpass

# Verify
ansai-vault-read app/database
```

### Remote Vault Setup

```bash
# Set environment variables for remote access
export VAULT_HOST='vault-server.example.com'
export VAULT_PORT='8201'
export VAULT_TOKEN='your-vault-token'

# Access remote vault
ansai-vault-read app/database
```

### Production Setup

```bash
# Use token file instead of environment variable
export VAULT_TOKEN=$(cat ~/.vault-token)

# Use HTTPS in production
export VAULT_ADDR='https://vault.example.com:8200'

# Verify TLS certificate
export VAULT_CACERT='/path/to/ca.crt'
```

## Usage Examples

### Example 1: Retrieve All Keys from Secret

```bash
$ ansai-vault-read app/database

Secret: app/database
  username: dbuser
  password: secretpass
  host: localhost
  port: 5432
```

### Example 2: Retrieve Specific Key

```bash
$ ansai-vault-read app/database password

secretpass
```

### Example 3: Use in Script

```bash
#!/bin/bash
# database-backup.sh

# Get database credentials
DB_USER=$(ansai-vault-read app/database username)
DB_PASS=$(ansai-vault-read app/database password)
DB_HOST=$(ansai-vault-read app/database host)

# Run backup
pg_dump -h "$DB_HOST" -U "$DB_USER" myapp > backup.sql
```

### Example 4: Multiple Secrets

```bash
#!/bin/bash
# deploy-app.sh

# Get all required secrets
DATABASE_URL=$(ansai-vault-read app/database url)
API_KEY=$(ansai-vault-read app/external-api key)
SMTP_PASSWORD=$(ansai-vault-read app/smtp password)

# Deploy with secrets
kubectl create secret generic app-secrets \
  --from-literal=database-url="$DATABASE_URL" \
  --from-literal=api-key="$API_KEY" \
  --from-literal=smtp-password="$SMTP_PASSWORD"
```

### Example 5: Error Handling

```bash
#!/bin/bash
# safe-secret-retrieval.sh

# Try to get secret with error handling
if SECRET=$(ansai-vault-read app/api-key token 2>/dev/null); then
    echo "Secret retrieved successfully"
    export API_TOKEN="$SECRET"
else
    echo "Failed to retrieve secret, using fallback"
    export API_TOKEN="default-token"
fi
```

### Example 6: Remote Vault Access

```bash
# Access vault on remote server via SSH
VAULT_HOST=vault-prod.internal ansai-vault-read production/database password
```

## Real-World Use Cases

1. **Database Credentials**: Store and retrieve database passwords securely
2. **API Keys**: Manage external API keys without hardcoding
3. **SSH Keys**: Store private SSH keys for automation
4. **TLS Certificates**: Retrieve certificates and private keys for services
5. **SMTP Credentials**: Get email server credentials for notification systems
6. **CI/CD Secrets**: Provide deployment credentials to CI/CD pipelines
7. **Cloud Credentials**: Store AWS/Azure/GCP access keys
8. **Application Secrets**: Any sensitive configuration data

## Security Best Practices

### 1. Token Management

```bash
# Store token in file with restricted permissions
echo "hvs.your-token-here" > ~/.vault-token
chmod 600 ~/.vault-token

# Load token from file
export VAULT_TOKEN=$(cat ~/.vault-token)
```

### 2. Use AppRole for Automation

```bash
# Better than long-lived tokens
# Enable AppRole auth
vault auth enable approle

# Create role
vault write auth/approle/role/my-app \
    secret_id_ttl=24h \
    token_ttl=1h \
    token_max_ttl=4h \
    policies="my-app-policy"

# Get role ID and secret ID
ROLE_ID=$(vault read -field=role_id auth/approle/role/my-app/role-id)
SECRET_ID=$(vault write -f -field=secret_id auth/approle/role/my-app/secret-id)

# Login and get token
export VAULT_TOKEN=$(vault write -field=token auth/approle/login \
    role_id="$ROLE_ID" \
    secret_id="$SECRET_ID")
```

### 3. Least Privilege Access

```bash
# Create policy with minimal permissions
cat > my-app-policy.hcl <<EOF
path "app/database/*" {
  capabilities = ["read"]
}
path "app/api-keys/*" {
  capabilities = ["read"]
}
EOF

vault policy write my-app my-app-policy.hcl
```

### 4. Use TLS in Production

```bash
# Always use HTTPS in production
export VAULT_ADDR='https://vault.example.com:8200'
export VAULT_CACERT='/etc/vault/ca.crt'
export VAULT_CLIENT_CERT='/etc/vault/client.crt'
export VAULT_CLIENT_KEY='/etc/vault/client.key'
```

### 5. Audit Logging

```bash
# Enable audit logging in Vault
vault audit enable file file_path=/var/log/vault-audit.log

# Monitor access
tail -f /var/log/vault-audit.log | jq '.request.path'
```

## Integration Patterns

### With Context Management

```bash
# Hook to load context-specific secrets
# ~/.config/ansai/hooks/post-switch-work.sh
#!/bin/bash

# Load work database credentials
export DB_PASSWORD=$(ansai-vault-read work/database password)
export API_KEY=$(ansai-vault-read work/api-keys external)

echo "Work secrets loaded"
```

### With Ansible

```yaml
# playbook.yml
- name: Deploy application with Vault secrets
  hosts: webservers
  tasks:
    - name: Get database password from Vault
      shell: ansai-vault-read app/database password
      register: db_password
      delegate_to: localhost
      
    - name: Configure application
      template:
        src: app-config.j2
        dest: /etc/app/config.yml
      vars:
        database_password: "{{ db_password.stdout }}"
```

### With Docker/Podman

```bash
#!/bin/bash
# run-container-with-secrets.sh

# Get secrets
DB_PASS=$(ansai-vault-read app/database password)
API_KEY=$(ansai-vault-read app/api-keys external)

# Run container with secrets as environment variables
podman run -d \
  -e DATABASE_PASSWORD="$DB_PASS" \
  -e API_KEY="$API_KEY" \
  myapp:latest
```

### With Systemd Services

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Application
After=network.target

[Service]
Type=simple
ExecStartPre=/usr/local/bin/load-secrets.sh
ExecStart=/usr/local/bin/myapp
EnvironmentFile=/run/myapp/secrets.env
```

```bash
#!/usr/bin/bash
# /usr/local/bin/load-secrets.sh
mkdir -p /run/myapp
cat > /run/myapp/secrets.env <<EOF
DATABASE_PASSWORD=$(ansai-vault-read app/database password)
API_KEY=$(ansai-vault-read app/api-keys external)
EOF
chmod 600 /run/myapp/secrets.env
```

## Advanced Features

### Secret Rotation

```bash
#!/bin/bash
# rotate-secrets.sh

# Get old password
OLD_PASS=$(ansai-vault-read app/database password)

# Generate new password
NEW_PASS=$(openssl rand -base64 32)

# Update database
mysql -u root -p"$OLD_PASS" -e "ALTER USER 'app'@'%' IDENTIFIED BY '$NEW_PASS';"

# Update Vault
vault kv put app/database password="$NEW_PASS"

echo "Password rotated successfully"
```

### Secret Caching (with expiry)

```bash
#!/bin/bash
# cached-vault-read.sh
CACHE_DIR=~/.cache/vault-secrets
CACHE_TTL=300  # 5 minutes

get_secret_cached() {
    local path="$1"
    local key="$2"
    local cache_file="$CACHE_DIR/$(echo "$path-$key" | md5sum | cut -d' ' -f1)"
    
    # Check cache
    if [[ -f "$cache_file" ]]; then
        local age=$(($(date +%s) - $(stat -c %Y "$cache_file")))
        if [[ $age -lt $CACHE_TTL ]]; then
            cat "$cache_file"
            return 0
        fi
    fi
    
    # Fetch and cache
    mkdir -p "$CACHE_DIR"
    chmod 700 "$CACHE_DIR"
    ansai-vault-read "$path" "$key" | tee "$cache_file"
    chmod 600 "$cache_file"
}
```

## Troubleshooting

### Token Expired

```bash
# Error: permission denied
# Solution: Generate new token or use AppRole

vault login

# Or with AppRole
vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID"
```

### Connection Refused

```bash
# Error: connection refused
# Check Vault is running
vault status

# Check VAULT_ADDR is correct
echo $VAULT_ADDR

# Test connectivity
curl $VAULT_ADDR/v1/sys/health
```

### Secret Not Found

```bash
# List available secrets
vault kv list app/

# Verify path
vault kv get app/database
```

### Permission Denied

```bash
# Check your token's capabilities
vault token capabilities app/database

# Should show: ["read"]
```

## Building Blocks Demonstrated

- ✅ **Secrets Management:** Secure credential storage and retrieval
- ✅ **Security Patterns:** Token auth, encrypted storage, least privilege
- ✅ **Remote Access:** SSH tunneling for distributed systems
- ✅ **Error Handling:** Clear security guidance and failure modes
- ✅ **Integration:** Easy to use in scripts, Ansible, CI/CD

## Integration with Other ANSAI Workflows

- **ansai-context-switch**: Load context-specific secrets via hooks
- **ansai-dr-test**: Retrieve backup encryption keys
- **ansai-miraclemax-deploy**: Get SSH keys and credentials
- **ansai-budget-analyzer**: Fetch bank API credentials (privacy-first)
- **ansai-email-processor**: Retrieve SMTP credentials

## Common Secret Structures

```bash
# Database credentials
vault kv put app/database \
    host=db.example.com \
    port=5432 \
    username=appuser \
    password=secret123 \
    database=myapp

# API keys
vault kv put app/api-keys \
    openai=sk-xxx \
    stripe=sk_live_xxx \
    sendgrid=SG.xxx

# SSH keys
vault kv put app/ssh-keys \
    private_key=@~/.ssh/id_rsa \
    public_key=@~/.ssh/id_rsa.pub

# SMTP credentials
vault kv put app/smtp \
    host=smtp.gmail.com \
    port=587 \
    username=user@example.com \
    password=apppassword
```

## Contributing

Want to enhance vault operations? Ideas:
- vault-write script for secret creation
- vault-list for browsing secrets
- vault-rotate for automatic rotation
- vault-backup for disaster recovery
- Integration with cloud KMS services

## License

MIT License - Free to use and modify

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev


