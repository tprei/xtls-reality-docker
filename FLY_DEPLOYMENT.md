# Fly.io Deployment Guide

This guide explains how to deploy XTLS Reality Docker on Fly.io.

## Prerequisites

1. Install the Fly.io CLI:
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. Authenticate with Fly.io:
   ```bash
   fly auth login
   ```

## Configuration

The `fly.toml` file contains the deployment configuration:

| Setting | Default | Description |
|---------|---------|-------------|
| `app` | `xtls-reality` | Application name |
| `primary_region` | `sjc` | Primary region (San Jose) |
| `SNI` | `www.samsung.com` | Masquerade target website |
| `SHORT_ID` | `aabbccdd` | Client connection identifier |

### Customizing Environment Variables

You can set environment variables during deployment:

```bash
fly deploy --env SNI=www.microsoft.com --env SHORT_ID=11223344
```

Or by using Fly.io secrets:

```bash
fly secrets set SNI=www.microsoft.com SHORT_ID=11223344
```

Note: When using secrets, remove the `[env]` section from `fly.toml` or set empty values.

## Deployment Steps

### 1. Initial Deployment

Deploy to Fly.io:
```bash
fly launch
```

This will:
- Create a new Fly.io app
- Create a persistent volume for configuration
- Deploy the container

### 2. Manual Deployment

If you prefer to configure manually:

```bash
# Create the app
fly apps create xtls-reality

# Create the volume for persistent config storage
fly volumes create xtls_reality_volume --region sjc --size 1GB

# Deploy
fly deploy
```

### 3. Reserve a Dedicated IPv4 Address (Optional)

Fly.io apps get a random shared IP by default. For a dedicated IPv4:

```bash
fly ips allocate-v4
```

Note: Dedicated IPs cost additional fees.

## Accessing Client Configuration

After deployment, retrieve your client connection details:

### Get Client Settings as Text

```bash
fly ssh console -C "cat /opt/xray/config/uuid /opt/xray/config/public /opt/xray/config/private"
```

### Regenerate Credentials

```bash
fly ssh console -C "rm /opt/xray/config/.lockfile && kill 1"
```

This will:
- Delete the lockfile
- Restart the container
- Generate new UUID and key pairs

## Regions

Choose a region close to your clients for best performance. Available regions include:

| Region | Location |
|--------|----------|
| `sjc` | San Jose, USA |
| `iad` | Virginia, USA |
| `ewr` | New Jersey, USA |
| `lhr` | London, UK |
| `fra` | Frankfurt, Germany |
| `ams` | Amsterdam, Netherlands |
| `sin` | Singapore |
| `nrt` | Tokyo, Japan |
| `hkg` | Hong Kong |

Change the `primary_region` in `fly.toml` before deploying.

## Scaling

Scale your application:

```bash
# Scale to 2 instances
fly scale count 2

# Scale memory
fly scale memory 512
```

Note: When scaling with multiple instances, each will have different generated credentials. Consider using a shared volume or pre-generating credentials for multi-instance deployments.

## Monitoring

View application logs:
```bash
fly logs
```

Check application status:
```bash
fly status
```

## Troubleshooting

### Container restarting repeatedly

Check logs to identify the issue:
```bash
fly logs --tail 50
```

### Cannot connect to port 443

Verify the service is running:
```bash
fly status
```

Ensure port 443 is not blocked by any firewall rules.

### Volume not mounting

Verify the volume exists:
```bash
fly volumes list
```

Recreate the volume if needed:
```bash
fly volumes create xtls_reality_volume --region <your-region> --size 1GB
```

## Cost Considerations

- Fly.io free tier: Up to 3 small VMs (256MB RAM, 1 CPU)
- Bandwidth: 100GB/month free allowance
- Persistent volumes: $0.015/GB/month

For production use, consider upgrading to a paid plan for better performance and reliability.
