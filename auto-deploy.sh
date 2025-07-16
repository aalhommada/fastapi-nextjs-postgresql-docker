#!/bin/bash

# Auto-deployment script for DigitalOcean
# This script runs on the droplet and pulls the latest changes

echo "🔄 Auto-deployment triggered..."

# Navigate to app directory
cd /opt/app/fastapi-nextjs-postgresql-docker || exit 1

# Pull latest changes
echo "📥 Pulling latest changes from GitHub..."
git pull origin main

# Stop current containers
echo "🛑 Stopping current containers..."
docker-compose down

# Clean up to free space
echo "🧹 Cleaning up old images..."
docker system prune -f

# Build and start services
echo "🔨 Building and starting services..."
docker-compose up --build -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 20

# Check status
echo "📊 Checking service status..."
docker-compose ps

echo ""
echo "🎉 Auto-deployment completed!"
echo "🔗 Backend API: http://165.232.86.188:8000"
echo "📋 API Docs: http://165.232.86.188:8000/docs"
echo ""
echo "Timestamp: $(date)"
