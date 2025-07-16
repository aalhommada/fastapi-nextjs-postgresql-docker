@echo off
setlocal

echo 🚀 FastAPI + Next.js + PostgreSQL Docker App
echo ==============================================

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker is not running. Please start Docker and try again.
    exit /b 1
)
echo ✅ Docker is running

if "%1"=="dev" (
    echo 🔨 Building and starting in DEVELOPMENT mode ^(hot reload^)...
    docker-compose --env-file .env.dev up --build
) else if "%1"=="prod" (
    echo 🔨 Building and starting in PRODUCTION mode ^(optimized^)...
    docker-compose --env-file .env.prod up --build
) else if "%1"=="start" (
    echo 🔨 Building and starting in DEVELOPMENT mode ^(default^)...
    docker-compose --env-file .env.dev up --build
) else if "%1"=="stop" (
    echo 🛑 Stopping the application...
    docker-compose down
) else if "%1"=="clean" (
    echo 🧹 Cleaning up containers and volumes...
    docker-compose down -v
    docker system prune -f
) else if "%1"=="logs" (
    echo 📋 Showing application logs...
    docker-compose logs -f
) else if "%1"=="rebuild" (
    echo � Rebuilding all containers...
    docker-compose down
    docker-compose --env-file .env.dev build --no-cache
    docker-compose --env-file .env.dev up
) else (
    echo Usage: %0 {dev^|prod^|start^|stop^|clean^|logs^|rebuild}
    echo.
    echo Commands:
    echo   dev     - Start in DEVELOPMENT mode ^(hot reload, volume mounts^)
    echo   prod    - Start in PRODUCTION mode ^(optimized, no mounts^)
    echo   start   - Start ^(defaults to development mode^)
    echo   stop    - Stop all services
    echo   clean   - Stop services and remove containers/volumes
    echo   logs    - Show application logs
    echo   rebuild - Rebuild all containers from scratch
    echo.
    echo Development vs Production:
    echo   DEV:  Hot reload, volume mounts, dev dependencies
    echo   PROD: Optimized build, no mounts, production dependencies
    echo.
    echo After starting, access:
    echo   Frontend: http://localhost:3000
    echo   Backend:  http://localhost:8000
    echo   API Docs: http://localhost:8000/docs
    exit /b 1
)
