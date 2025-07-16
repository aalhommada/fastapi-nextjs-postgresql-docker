#!/bin/bash

# Enhanced troubleshooting script
echo "🔍 Enhanced Backend Troubleshooting Script"
echo "==========================================="
echo "🕐 $(date)"
echo ""

# Navigate to app directory
cd /opt/app/fastapi-nextjs-postgresql-docker 2>/dev/null || {
    echo "❌ Cannot find app directory"
    pwd
    ls -la
    exit 1
}

# Check Docker and Docker Compose
echo "🐳 Docker Information:"
echo "  - Docker version: $(docker --version)"
echo "  - Docker Compose version: $(docker-compose --version)"
echo "  - Docker status: $(systemctl is-active docker)"
echo ""

# Check current container status
echo "📊 Container Status:"
docker-compose ps
echo ""

# Check service health
echo "🔍 Service Health Checks:"

# Database health
echo "  Database:"
if docker-compose exec -T db pg_isready -U user -d appdb > /dev/null 2>&1; then
    echo "    ✅ PostgreSQL is ready"
else
    echo "    ❌ PostgreSQL is not ready"
fi

# Backend health
echo "  Backend:"
if docker-compose exec -T backend curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "    ✅ Backend health check OK"
else
    echo "    ❌ Backend health check FAILED"
fi

# Nginx health
echo "  Nginx:"
if docker-compose exec -T nginx curl -f http://localhost/health > /dev/null 2>&1; then
    echo "    ✅ Nginx health check OK"
else
    echo "    ❌ Nginx health check FAILED"
fi

echo ""

# Test external access
echo "🌐 External Access Tests:"
echo "  - Port 8000: $(curl -s -o /dev/null -w '%{http_code}' http://165.232.86.188:8000/health)"
echo "  - Port 3000: $(curl -s -o /dev/null -w '%{http_code}' http://165.232.86.188:3000/health)"
echo ""

# Check network connectivity
echo "🔧 Network Connectivity:"
echo "  - Backend -> Database:"
if docker-compose exec -T backend ping -c 2 db > /dev/null 2>&1; then
    echo "    ✅ Backend can reach database"
else
    echo "    ❌ Backend cannot reach database"
fi

echo "  - Nginx -> Backend:"
if docker-compose exec -T nginx ping -c 2 backend > /dev/null 2>&1; then
    echo "    ✅ Nginx can reach backend"
else
    echo "    ❌ Nginx cannot reach backend"
fi

echo ""

# Show recent logs
echo "📋 Recent Logs (last 20 lines):"
echo ""
echo "--- Database Logs ---"
docker-compose logs --tail=20 db

echo ""
echo "--- Backend Logs ---"
docker-compose logs --tail=20 backend

echo ""
echo "--- Nginx Logs ---"
docker-compose logs --tail=20 nginx

echo ""

# Show resource usage
echo "📊 Resource Usage:"
echo "  - Disk usage: $(df -h / | tail -1 | awk '{print $5}') used"
echo "  - Memory usage:"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""

# Show network information
echo "🌐 Network Information:"
echo "  - Docker networks:"
docker network ls | grep -E "(fastapi|app-network|bridge)"

echo "  - Container IPs:"
docker-compose exec -T backend ip addr show eth0 | grep inet | head -1 | awk '{print "    Backend: " $2}'
docker-compose exec -T nginx ip addr show eth0 | grep inet | head -1 | awk '{print "    Nginx: " $2}'
docker-compose exec -T db ip addr show eth0 | grep inet | head -1 | awk '{print "    Database: " $2}'

echo ""

# Check file permissions and ownership
echo "🔐 File Permissions:"
echo "  - App directory: $(ls -ld /opt/app/fastapi-nextjs-postgresql-docker)"
echo "  - Docker compose file: $(ls -l docker-compose.yml)"
echo "  - Backend directory: $(ls -ld backend/)"

echo ""

# Check environment variables
echo "🌍 Environment Variables:"
echo "  - DATABASE_URL: $(docker-compose exec -T backend env | grep DATABASE_URL | cut -d'=' -f1)=***"
echo "  - POSTGRES_DB: $(docker-compose exec -T db env | grep POSTGRES_DB)"
echo "  - POSTGRES_USER: $(docker-compose exec -T db env | grep POSTGRES_USER)"

echo ""

# Check port usage
echo "🔌 Port Usage:"
echo "  - Ports in use:"
netstat -tlnp | grep -E ":(8000|3000|5432)" | head -10

echo ""

# System health
echo "🖥️ System Health:"
echo "  - Load average: $(uptime | awk -F'load average:' '{print $2}')"
echo "  - Free memory: $(free -h | grep Mem | awk '{print $7}')"
echo "  - Disk space: $(df -h / | tail -1 | awk '{print $4}') available"

echo ""

# Recent system logs
echo "📋 Recent System Logs:"
echo "  - Docker service logs:"
journalctl -u docker --no-pager --lines=5

echo ""

# Recommendations
echo "💡 Troubleshooting Recommendations:"
echo "  1. If containers are not running: docker-compose up -d"
echo "  2. If health checks fail: docker-compose restart <service>"
echo "  3. If database issues: docker-compose logs db"
echo "  4. If backend issues: docker-compose logs backend"
echo "  5. If network issues: docker-compose down && docker-compose up -d"
echo "  6. If persistent issues: docker-compose down && docker system prune -f && docker-compose up -d --build"
echo "  7. Full reset: docker-compose down -v && docker system prune -af && ./deploy.sh"

echo ""
echo "🔗 Quick Actions:"
echo "  - Restart all: docker-compose restart"
echo "  - View live logs: docker-compose logs -f"
echo "  - Rebuild and restart: docker-compose up -d --build"
echo "  - Full redeploy: ./deploy.sh"

echo ""
echo "🏁 Troubleshooting completed at $(date)"