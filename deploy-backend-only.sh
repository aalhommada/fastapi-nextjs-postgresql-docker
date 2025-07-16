#!/bin/bash

# Get the droplet IP
DROPLET_IP="165.232.86.188"

echo "🚀 Deploying BACKEND-ONLY FastAPI + PostgreSQL on DigitalOcean Droplet: $DROPLET_IP"
echo "🎯 This version only runs the backend API - perfect for testing API functionality"

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.backend-only.yml down 2>/dev/null || true
docker-compose -f docker-compose.simple.yml down 2>/dev/null || true
docker-compose -f docker-compose.minimal.yml down 2>/dev/null || true

# Clean up to free space
echo "🧹 Cleaning up..."
docker system prune -f

# Build and start backend services only
echo "🔨 Building and starting backend services..."
docker-compose -f docker-compose.backend-only.yml up --build -d

# Wait for services
echo "⏳ Waiting for services to be ready..."
sleep 15

# Check status
echo "📊 Service Status:"
docker-compose -f docker-compose.backend-only.yml ps

echo ""
echo "🎉 Backend-Only Deployment Complete!"
echo "🔗 Backend API: http://$DROPLET_IP:8000"
echo "📋 API Docs: http://$DROPLET_IP:8000/docs"
echo "🌐 Also available on: http://$DROPLET_IP:3000 (same as port 8000)"
echo ""
echo "✅ You can test all API endpoints at: http://$DROPLET_IP:8000/docs"
echo ""
echo "To check logs: docker-compose -f docker-compose.backend-only.yml logs"
echo "To stop: docker-compose -f docker-compose.backend-only.yml down"
