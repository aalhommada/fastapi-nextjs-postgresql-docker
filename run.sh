#!/bin/bash

echo "🚀 FastAPI + Next.js + PostgreSQL Docker App"
echo "=============================================="

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Docker is not running. Please start Docker and try again."
        exit 1
    fi
    echo "✅ Docker is running"
}

# Main menu
case "$1" in
    "dev")
        check_docker
        echo "🔨 Building and starting in DEVELOPMENT mode (hot reload)..."
        docker-compose --env-file .env.dev up --build
        ;;
    "prod")
        check_docker
        echo "🔨 Building and starting in PRODUCTION mode (optimized)..."
        docker-compose --env-file .env.prod up --build
        ;;
    "start")
        check_docker
        echo "🔨 Building and starting in DEVELOPMENT mode (default)..."
        docker-compose --env-file .env.dev up --build
        ;;
    "stop")
        echo "🛑 Stopping the application..."
        docker-compose down
        ;;
    "clean")
        echo "🧹 Cleaning up containers and volumes..."
        docker-compose down -v
        docker system prune -f
        ;;
    "logs")
        echo "📋 Showing application logs..."
        docker-compose logs -f
        ;;
    "rebuild")
        echo "🔄 Rebuilding all containers..."
        docker-compose down
        docker-compose --env-file .env.dev build --no-cache
        docker-compose --env-file .env.dev up
        ;;
    *)
        echo "Usage: $0 {dev|prod|start|stop|clean|logs|rebuild}"
        echo ""
        echo "Commands:"
        echo "  dev     - Start in DEVELOPMENT mode (hot reload, volume mounts)"
        echo "  prod    - Start in PRODUCTION mode (optimized, no mounts)"
        echo "  start   - Start (defaults to development mode)"
        echo "  stop    - Stop all services"
        echo "  clean   - Stop services and remove containers/volumes"
        echo "  logs    - Show application logs"
        echo "  rebuild - Rebuild all containers from scratch"
        echo ""
        echo "Development vs Production:"
        echo "  DEV:  Hot reload, volume mounts, dev dependencies"
        echo "  PROD: Optimized build, no mounts, production dependencies"
        echo ""
        echo "After starting, access:"
        echo "  Frontend: http://localhost:3000"
        echo "  Backend:  http://localhost:8000"
        echo "  API Docs: http://localhost:8000/docs"
        exit 1
        ;;
esac
