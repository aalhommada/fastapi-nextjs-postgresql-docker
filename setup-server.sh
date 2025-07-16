#!/bin/bash

# DigitalOcean Droplet Initial Setup Script
# Run this script once on your droplet to set up the environment

echo "🚀 Setting up DigitalOcean droplet for FastAPI + Next.js deployment..."

# Update system packages
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install Docker
echo "🐳 Installing Docker..."
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce

# Install Docker Compose
echo "🐳 Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Install Git
echo "📚 Installing Git..."
apt install -y git

# Install Node.js (for any server-side operations)
echo "📦 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# Create project directory
echo "📁 Setting up project directory..."
mkdir -p /root/fastapi-nextjs-postgresql-docker
cd /root/fastapi-nextjs-postgresql-docker

# Clone the repository (you'll need to run this manually with your repo)
echo "📥 Clone your repository manually:"
echo "git clone https://github.com/aalhommada/fastapi-nextjs-postgresql-docker.git /root/fastapi-nextjs-postgresql-docker"

# Set up firewall
echo "🔒 Configuring firewall..."
ufw allow ssh
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 3000  # Next.js
ufw allow 8000  # FastAPI
ufw --force enable

# Start and enable Docker
echo "🐳 Starting Docker service..."
systemctl start docker
systemctl enable docker

# Add current user to docker group (if not root)
usermod -aG docker $USER

echo "✅ Server setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Clone your repository to /root/fastapi-nextjs-postgresql-docker"
echo "2. Set up GitHub Actions secrets:"
echo "   - DIGITALOCEAN_SSH_KEY: Your private SSH key"
echo "   - DROPLET_IP: 165.232.86.188"
echo "3. Push code to trigger deployment"
echo ""
echo "🌐 Your application will be available at:"
echo "   Frontend: http://165.232.86.188:3000"
echo "   Backend:  http://165.232.86.188:8000"
echo "   API Docs: http://165.232.86.188:8000/docs"
