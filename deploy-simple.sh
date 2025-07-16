#!/bin/bash

# Get the droplet IP
DROPLET_IP="165.232.86.188"

echo "🚀 Deploying FastAPI + Next.js + PostgreSQL on DigitalOcean Droplet: $DROPLET_IP"

# Update the API URL in docker-compose.simple.yml
sed -i "s/DROPLET_IP_PLACEHOLDER/$DROPLET_IP/g" docker-compose.simple.yml

echo "✅ Updated docker-compose.simple.yml with IP: $DROPLET_IP"

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.simple.yml down

# Remove old images
echo "🧹 Cleaning up old images..."
docker-compose -f docker-compose.simple.yml down --rmi all

# Build and start all services
echo "🔨 Building and starting services..."
docker-compose -f docker-compose.simple.yml up --build -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check status
echo "📊 Service Status:"
docker-compose -f docker-compose.simple.yml ps

echo ""
echo "🎉 Deployment Complete!"
echo "🌐 Frontend: http://$DROPLET_IP:3000"
echo "🔗 Backend API: http://$DROPLET_IP:8000"
echo "📋 API Docs: http://$DROPLET_IP:8000/docs"
echo ""
echo "To check logs: docker-compose -f docker-compose.simple.yml logs"
echo "To stop: docker-compose -f docker-compose.simple.yml down"
