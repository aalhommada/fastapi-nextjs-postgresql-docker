# Deployment Guide

This guide explains how to set up automatic deployment from GitHub to your DigitalOcean droplet.

## Prerequisites

- DigitalOcean droplet (IP: 165.232.86.188)
- GitHub repository: aalhommada/fastapi-nextjs-postgresql-docker
- SSH access to the droplet

## Server Setup (One-time)

### 1. Initial Server Configuration

Run the setup script on your droplet:

```bash
# SSH into your droplet
ssh root@165.232.86.188

# Download and run the setup script
curl -sSL https://raw.githubusercontent.com/aalhommada/fastapi-nextjs-postgresql-docker/main/setup-server.sh | bash

# Or manually copy the setup-server.sh file and run it
chmod +x setup-server.sh
./setup-server.sh
```

### 2. Clone the Repository

```bash
cd /root
git clone https://github.com/aalhommada/fastapi-nextjs-postgresql-docker.git
cd fastapi-nextjs-postgresql-docker
```

### 3. Test Local Deployment

```bash
# Test the production configuration
docker-compose -f docker-compose.prod.yml up --build -d

# Check if everything is running
docker-compose -f docker-compose.prod.yml ps

# Test the endpoints
curl http://localhost:8000/health
curl http://localhost:3000
```

## GitHub Actions Setup

### 1. Generate SSH Key Pair

On your local machine:

```bash
# Generate a new SSH key pair for GitHub Actions
ssh-keygen -t rsa -b 4096 -C "github-actions@yourdomain.com" -f ~/.ssh/github_actions_key

# Copy the public key to your droplet
ssh-copy-id -i ~/.ssh/github_actions_key.pub root@165.232.86.188

# Get the private key content (you'll need this for GitHub secrets)
cat ~/.ssh/github_actions_key
```

### 2. Configure GitHub Secrets

In your GitHub repository, go to **Settings > Secrets and variables > Actions** and add:

| Secret Name | Value |
|-------------|-------|
| `DIGITALOCEAN_SSH_KEY` | Content of your private SSH key (`~/.ssh/github_actions_key`) |
| `DROPLET_IP` | `165.232.86.188` |

### 3. Test the Deployment

1. Make a small change to your code
2. Commit and push to the `main` branch
3. Check the Actions tab in GitHub to see the deployment progress

## Application URLs

After deployment, your application will be available at:

- **Frontend**: http://165.232.86.188:3000
- **Backend API**: http://165.232.86.188:8000
- **API Documentation**: http://165.232.86.188:8000/docs
- **Health Check**: http://165.232.86.188:8000/health

## Environment Configuration

### Development (Local)
- Uses `docker-compose.yml`
- Frontend connects to `http://localhost:8000`

### Production (DigitalOcean)
- Uses `docker-compose.prod.yml`
- Frontend connects to `http://165.232.86.188:8000`
- Optimized for production with proper restart policies

## Troubleshooting

### Check Container Status
```bash
ssh root@165.232.86.188
cd /root/fastapi-nextjs-postgresql-docker
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml logs
```

### Manual Deployment
```bash
ssh root@165.232.86.188
cd /root/fastapi-nextjs-postgresql-docker
git pull origin main
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml up --build -d
```

### Check Application Health
```bash
# Backend health
curl http://165.232.86.188:8000/health

# Frontend
curl http://165.232.86.188:3000

# API docs
curl http://165.232.86.188:8000/docs
```

## Security Notes

- Firewall is configured to allow only necessary ports (22, 80, 443, 3000, 8000)
- Docker containers restart automatically on failure
- Database data is persisted in Docker volumes
- GitHub Actions uses SSH key authentication

## Monitoring

Monitor your deployment:

1. **GitHub Actions**: Check the Actions tab for deployment status
2. **Server Logs**: SSH into server and check `docker-compose logs`
3. **Application Health**: Use the `/health` endpoint for monitoring

## Next Steps

1. Set up domain name and SSL certificates
2. Add monitoring and alerting
3. Set up database backups
4. Implement blue-green deployment for zero downtime
