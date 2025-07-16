#!/bin/bash

# Get the droplet IP
DROPLET_IP="165.232.86.188"

echo "🚀 Deploying FastAPI + PostgreSQL on DigitalOcean Droplet: $DROPLET_IP"
echo "🎯 Backend API with Database - Clean and Simple"

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Clean up to free space
echo "🧹 Cleaning up..."
docker system prune -f

# Build and start backend services
echo "🔨 Building and starting services..."
docker-compose up --build -d

# Wait for services
echo "⏳ Waiting for services to be ready..."
sleep 15

# Check status
echo "📊 Service Status:"
docker-compose ps

echo ""
echo "🎉 Deployment Complete!"
echo "🔗 Backend API: http://$DROPLET_IP:8000"
echo "📋 API Docs: http://$DROPLET_IP:8000/docs"
echo "🌐 Also available on: http://$DROPLET_IP:3000 (same as port 8000)"
echo ""
echo "✅ You can test all API endpoints at: http://$DROPLET_IP:8000/docs"
echo ""
echo "To check logs: docker-compose logs"
echo "To stop: docker-compose down"
