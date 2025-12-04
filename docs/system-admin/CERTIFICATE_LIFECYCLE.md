# 🔐 Certificate Lifecycle Patterns

**Never let a certificate expire again.**

Managing SSL/TLS certificates is critical but error-prone. This pattern automates the entire lifecycle: request, validation, installation, and renewal.

## 🧠 The AI Advantage

1. **Discovery:** Scans your network for unknown/expiring certs.
2. **Validation:** Verifies the certificate chain and ciphers *after* installation.
3. **Smart Reload:** Knows which services need reloading (Nginx? Apache? Postfix?) when a cert changes.

## 🛠️ Implementation

### 1. Certificate Definitions

```yaml
managed_certificates:
  - domain: "api.example.com"
    provider: "letsencrypt"
    services: ["nginx", "postfix"]
    deploy_to: 
      - "/etc/nginx/ssl/"
      - "/etc/postfix/certs/"
```

### 2. The Renewal Logic

The `cert_manager` role handles the complexity:

- Checks expiration date (local file AND live socket)
- Runs `certbot` or API calls to provider
- Distributes files to correct paths with correct permissions
- Restarts defined services only if cert changed

### 3. Emergency Revocation

If a key is compromised, trigger the **Panic Mode**:

```bash
ansible-playbook playbooks/security/revoke-cert.yml -e domain=api.example.com
```

This instantly revokes the cert, generates a new key/cert pair, and deploys it everywhere.

## 🤖 Example Workflow

1. **Daily Check** finds `db.example.com` cert expires in 29 days.
2. **Automation** requests renewal from CA.
3. **Validation** confirms new cert is valid for 365 days.
4. **Deployment** copies cert to database servers.
5. **Service Restart** reloads PostgreSQL gracefully.
6. **Final Check** connects to port 5432 to verify SSL handshake.


