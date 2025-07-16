#!/bin/bash

echo "🔍 Backend Troubleshooting Script"
echo "=================================="

# Navigate to app directory
cd /opt/app/fastapi-nextjs-postgresql-docker

echo "📊 Current container status:"
docker-compose ps

echo ""
echo "🔍 Backend container logs (last 20 lines):"
docker-compose logs --tail=20 backend

echo ""
echo "🔍 Nginx container logs (last 10 lines):"
docker-compose logs --tail=10 nginx

echo ""
echo "🌐 Testing backend directly (inside docker network):"
docker-compose exec backend curl -f http://localhost:8000/health 2>/dev/null && echo "✅ Backend health check OK" || echo "❌ Backend health check FAILED"

echo ""
echo "🌐 Testing nginx proxy:"
curl -f http://localhost/health 2>/dev/null && echo "✅ Nginx proxy OK" || echo "❌ Nginx proxy FAILED"

echo ""
echo "🔗 Testing external access:"
curl -f http://165.232.86.188:8000/health 2>/dev/null && echo "✅ External access OK" || echo "❌ External access FAILED"

echo ""
echo "📋 Docker network info:"
docker network ls | grep fastapi

echo ""
echo "🔧 Container network details:"
docker-compose exec backend ping -c 2 db 2>/dev/null && echo "✅ Backend can reach DB" || echo "❌ Backend cannot reach DB"
