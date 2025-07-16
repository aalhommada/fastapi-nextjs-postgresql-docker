#!/bin/bash

# Enhanced deployment script for DigitalOcean droplet
set -e  # Exit on any error

# Configuration
DROPLET_IP="165.232.86.188"
APP_NAME="fastapi-backend"
COMPOSE_FILE="docker-compose.yml"

echo "🚀 Enhanced Deployment Script for $APP_NAME"
echo "================================================"
echo "🎯 Droplet IP: $DROPLET_IP"
echo "🕐 Start time: $(date)"
echo ""

# Function to check if service is healthy
check_health() {
    local service=$1
    local max_attempts=30
    local attempt=0
    
    echo "🔍 Checking health of $service..."
    
    while [ $attempt -lt $max_attempts ]; do
        if docker-compose exec -T $service curl -f http://localhost:8000/health > /dev/null 2>&1; then
            echo "✅ $service is healthy"
            return 0
        fi
        
        attempt=$((attempt + 1))
        echo "⏳ Attempt $attempt/$max_attempts - waiting for $service..."
        sleep 5
    done
    
    echo "❌ $service failed to become healthy"
    return 1
}

# Stop existing containers gracefully
echo "🛑 Stopping existing containers..."
docker-compose down --timeout 30 || true

# Clean up resources
echo "🧹 Cleaning up resources..."
docker system prune -f --volumes
docker network prune -f

# Pull latest code (if running on droplet)
if [ -d ".git" ]; then
    echo "📥 Pulling latest code..."
    git pull origin main
fi

# Build images
echo "🔨 Building Docker images..."
docker-compose build --no-cache --parallel

# Start database first
echo "🗄️ Starting database..."
docker-compose up -d db

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
timeout=60
elapsed=0

while [ $elapsed -lt $timeout ]; do
    if docker-compose exec -T db pg_isready -U user -d appdb > /dev/null 2>&1; then
        echo "✅ Database is ready"
        break
    fi
    sleep 2
    elapsed=$((elapsed + 2))
done

if [ $elapsed -ge $timeout ]; then
    echo "❌ Database failed to start within timeout"
    docker-compose logs db
    exit 1
fi

# Start backend
echo "🚀 Starting backend..."
docker-compose up -d backend

# Wait for backend to be healthy
if ! check_health backend; then
    echo "❌ Backend failed to start properly"
    docker-compose logs backend
    exit 1
fi

# Start nginx
echo "🌐 Starting nginx..."
docker-compose up -d nginx

# Final health check
echo "🔍 Final health check..."
sleep 5

if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ External health check passed"
else
    echo "❌ External health check failed"
    docker-compose logs
    exit 1
fi

# Show final status
echo ""
echo "📊 Final Status:"
docker-compose ps

echo ""
echo "🎉 Deployment completed successfully!"
echo "================================================"
echo "🔗 Backend API: http://$DROPLET_IP:8000"
echo "📋 API Documentation: http://$DROPLET_IP:8000/docs"
echo "🌐 Alternative URL: http://$DROPLET_IP:3000"
echo "🕐 Completion time: $(date)"
echo ""
echo "📋 Useful commands:"
echo "  - View logs: docker-compose logs"
echo "  - Stop services: docker-compose down"
echo "  - Restart: ./deploy.sh"
echo "  - Troubleshoot: ./troubleshoot.sh"
echo ""

# Test all endpoints
echo "🧪 Testing endpoints..."
echo "  - Root: $(curl -s http://localhost:8000/ | jq -r '.message // "Failed"')"
echo "  - Health: $(curl -s http://localhost:8000/health | jq -r '.status // "Failed"')"
echo "  - Users: $(curl -s http://localhost:8000/users/ | jq -r 'length // "Failed"') users found"

echo ""
echo "✅ All systems operational!"