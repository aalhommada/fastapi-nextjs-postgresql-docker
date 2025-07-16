#!/bin/bash

# Get the droplet IP
DROPLET_IP="165.232.86.188"

echo "🚀 Deploying MINIMAL FastAPI + Next.js + PostgreSQL on DigitalOcean Droplet: $DROPLET_IP"
echo "🔧 This version uses development mode to avoid memory-intensive builds"

# Check if swap exists, if not create it
if ! swapon --show | grep -q "/swapfile"; then
    echo "💾 Creating swap space..."
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "✅ Swap space created"
fi

# Update the API URL in docker-compose.minimal.yml
sed -i "s/DROPLET_IP_PLACEHOLDER/$DROPLET_IP/g" docker-compose.minimal.yml

echo "✅ Updated docker-compose.minimal.yml with IP: $DROPLET_IP"

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.minimal.yml down

# Clean up to free space
echo "🧹 Cleaning up..."
docker system prune -f

# Build and start all services
echo "🔨 Building and starting services (minimal version)..."
docker-compose -f docker-compose.minimal.yml up --build -d

# Wait for services
echo "⏳ Waiting for services to be ready..."
sleep 20

# Check status
echo "📊 Service Status:"
docker-compose -f docker-compose.minimal.yml ps

echo ""
echo "🎉 Minimal Deployment Complete!"
echo "🌐 Frontend: http://$DROPLET_IP:3000 (Development Mode)"
echo "🔗 Backend API: http://$DROPLET_IP:8000"
echo "📋 API Docs: http://$DROPLET_IP:8000/docs"
echo ""
echo "⚠️  Note: Frontend runs in development mode to avoid build issues"
echo "📱 It may take a moment for Next.js to compile pages on first visit"
echo ""
echo "To check logs: docker-compose -f docker-compose.minimal.yml logs"
echo "To stop: docker-compose -f docker-compose.minimal.yml down"
