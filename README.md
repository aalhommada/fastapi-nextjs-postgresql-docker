# FastAPI + Next.js + PostgreSQL Docker Application

## Full Stack Application with Automatic Deployment

### Quick Start - Local Development

1. **Clone and run locally**:
```bash
git clone https://github.com/aalhommada/fastapi-nextjs-postgresql-docker.git
cd fastapi-nextjs-postgresql-docker
docker-compose up --build
```

2. **Access Your App**:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs

### Production Deployment

🚀 **Live Application**: 
- **Frontend**: http://165.232.86.188:3000
- **Backend API**: http://165.232.86.188:8000
- **API Documentation**: http://165.232.86.188:8000/docs

### Automatic Deployment

This project includes GitHub Actions for automatic deployment to DigitalOcean. Every push to `main` branch automatically deploys to the server.

📋 **Setup Guide**: See [DEPLOYMENT.md](DEPLOYMENT.md) for complete deployment instructions.

### Project Structure
```
├── frontend/          # Next.js application
│   ├── components/   # React components
│   ├── pages/        # Next.js pages
│   └── Dockerfile
├── backend/           # FastAPI application
│   ├── main.py       # FastAPI app with user management
│   ├── requirements.txt
│   └── Dockerfile
├── .github/workflows/ # GitHub Actions
│   └── deploy.yml    # Automatic deployment workflow
├── docker-compose.yml      # Local development config
├── docker-compose.prod.yml # Production config
├── setup-server.sh         # Server setup script
├── DEPLOYMENT.md           # Deployment guide
└── README.md
```

### Services
- **PostgreSQL**: Database on port 5432
- **FastAPI**: Backend API on ports 8000 & 3000

### API Endpoints
- `GET /` - Root endpoint with status
- `GET /health` - Health check
- `GET /docs` - Swagger API documentation
- `POST /users/` - Create a new user
- `GET /users/` - Get all users
- `GET /users/{user_id}` - Get specific user

### Development Commands
```bash
# Start services
docker-compose up --build

# Start in background
docker-compose up -d --build

# View logs
docker-compose logs

# Stop services
docker-compose down

# Clean up everything
docker-compose down -v
docker system prune -f
```

### Test the API
```bash
# Test health endpoint
curl http://localhost:8000/health

# Create a user
curl -X POST "http://localhost:8000/users/" \
     -H "Content-Type: application/json" \
     -d '{"name": "John Doe", "email": "john@example.com"}'

# Get all users
curl http://localhost:8000/users/
```

### Environment
- **Database**: PostgreSQL 15
- **Backend**: FastAPI with SQLAlchemy ORM
- **Container**: Docker & Docker Compose

---
**Simple and reliable FastAPI backend!** 🚀
