#!/bin/bash

echo "🚀 DigitalOcean Deployment Script"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please don't run this script as root"
    exit 1
fi

# Check if domain is provided
DOMAIN=${1:-aalhommada.com}
print_status "Setting up deployment for domain: $DOMAIN"

# Step 1: Update system
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    print_status "Docker installed successfully"
else
    print_status "Docker already installed"
fi

# Step 3: Install Docker Compose
print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_status "Docker Compose installed successfully"
else
    print_status "Docker Compose already installed"
fi

# Step 4: Install Nginx and Certbot
print_status "Installing Nginx and Certbot..."
sudo apt install -y nginx certbot python3-certbot-nginx ufw

# Step 5: Configure firewall
print_status "Configuring firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Step 6: Setup SSL certificate
print_status "Setting up SSL certificate for $DOMAIN..."
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

# Step 7: Clone repository if not exists
if [ ! -d "/opt/app/.git" ]; then
    print_status "Cloning repository..."
    sudo mkdir -p /opt/app
    sudo chown $USER:$USER /opt/app
    git clone https://github.com/aalhommada/fastapi-nextjs-postgresql-docker.git /opt/app
else
    print_status "Repository already exists, pulling latest changes..."
    cd /opt/app
    git pull origin main
fi

# Step 8: Set permissions
cd /opt/app
chmod +x run.sh
chmod +x deploy.sh

# Step 9: Create production environment file
print_status "Creating production environment file..."
cat > .env.production << EOF
DEV_MODE=false
NODE_ENV=production
FRONTEND_DOCKERFILE=Dockerfile
BACKEND_VOLUME_MOUNT=/app/placeholder
FRONTEND_VOLUME_MOUNT=/app/placeholder
NODE_MODULES_VOLUME=/app/node_modules_placeholder
NEXT_VOLUME=/app/.next_placeholder
POSTGRES_USER=user
POSTGRES_PASSWORD=$(openssl rand -base64 32)
POSTGRES_DB=appdb
NEXT_PUBLIC_API_URL=https://$DOMAIN/api
EOF

# Step 10: Start the application
print_status "Starting the application..."
docker-compose -f docker-compose.production.yml --env-file .env.production up --build -d

print_status "Deployment completed!"
echo ""
echo "🎉 Your application should now be available at:"
echo "   - https://$DOMAIN"
echo "   - API Documentation: https://$DOMAIN/api/docs"
echo ""
echo "📋 Next steps:"
echo "   1. Check logs: docker-compose -f docker-compose.production.yml logs -f"
echo "   2. Monitor status: docker-compose -f docker-compose.production.yml ps"
echo "   3. Set up automatic deployment with GitHub Actions"
echo ""
print_warning "Make sure your domain $DOMAIN points to this server's IP address!"
