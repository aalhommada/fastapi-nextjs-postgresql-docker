# FastAPI + PostgreSQL Docker Deployment

## Quick Deploy on DigitalOcean Droplet

### 1. Clone and Deploy
```bash
git clone https://github.com/aalhommada/fastapi-nextjs-postgresql-docker.git
cd fastapi-nextjs-postgresql-docker
chmod +x deploy.sh
./deploy.sh
```

### 2. Access Your App
- **Backend API**: http://165.232.86.188:8000
- **API Documentation**: http://165.232.86.188:8000/docs
- **Alternative URL**: http://165.232.86.188:3000 (same API)

### 3. Project Structure
```
├── backend/           # FastAPI application
├── frontend/          # Next.js 15+ App Router
├── docker-compose.yml # Production deployment config
├── deploy.sh          # One-command deployment
└── README.md         # This file
```

### 4. Services
- **PostgreSQL**: Database on port 5432
- **FastAPI**: Backend API on ports 8000 & 3000

### 5. Tech Stack
- **Database**: PostgreSQL 15
- **Backend**: FastAPI with SQLAlchemy
- **Container**: Docker & Docker Compose

### 6. Commands
```bash
# View logs
docker-compose logs

# Stop services
docker-compose down

# Restart services
./deploy.sh
```

---
**Production-ready FastAPI backend!** 🚀
- **Local Development**: Hot reloading for both frontend and backend
- **Modern Architecture**: Uses Next.js App Router for better performance and developer experience

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Git (for version control)

### Running Locally

1. **Clone or navigate to the project directory**:
   ```bash
   cd Fastapi-nextjs-postgresql-docker
   ```

2. **Start all services**:
   ```bash
   # Windows - Development mode (hot reload)
   .\run.bat dev
   
   # Windows - Production mode (optimized)
   .\run.bat prod
   
   # Linux/Mac - Development mode
   ./run.sh dev
   
   # Linux/Mac - Production mode  
   ./run.sh prod
   
   # Or manually with Docker Compose
   docker-compose --env-file .env.dev up --build   # Development
   docker-compose --env-file .env.prod up --build  # Production
   ```

3. **Access the application**:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - API Documentation: http://localhost:8000/docs
   - Next.js API Route Example: http://localhost:3000/api/test

### Services

- **PostgreSQL**: Runs on port 5432
- **FastAPI Backend**: Runs on port 8000
- **Next.js Frontend**: Runs on port 3000 (App Router)

### Testing the Application

1. Open http://localhost:3000 in your browser
2. Click "Test Backend Connection" to verify the backend is working
3. Create a new user using the form
4. View the list of users retrieved from the database
5. Test the Next.js API route at http://localhost:3000/api/test

### API Endpoints

**FastAPI Backend**:
- `GET /` - Root endpoint
- `GET /health` - Health check
- `POST /users/` - Create a new user
- `GET /users/` - Get all users
- `GET /users/{user_id}` - Get a specific user

**Next.js API Routes**:
- `GET /api/test` - Test Next.js API route
- `POST /api/test` - Test POST to Next.js API route

### Development Commands

**Using the helper scripts**:
```bash
# Windows
.\run.bat start    # Production mode
.\run.bat dev      # Development mode
.\run.bat stop     # Stop all services
.\run.bat clean    # Clean up containers and volumes
.\run.bat logs     # Show logs

# Linux/Mac
./run.sh start     # Production mode
./run.sh dev       # Development mode
./run.sh stop      # Stop all services
./run.sh clean     # Clean up containers and volumes
./run.sh logs      # Show logs
```

**Using Docker Compose directly**:
```bash
# Development
docker-compose -f docker-compose.dev.yml up --build

# Production
docker-compose up --build

# Stop services
docker-compose down

# Clean up volumes
docker-compose down -v
```

### Project Structure

```
├── backend/
│   ├── main.py              # FastAPI application
│   ├── requirements.txt     # Python dependencies
│   ├── Dockerfile          # Backend container config
│   └── .env                # Backend environment variables
├── frontend/
│   ├── src/
│   │   ├── app/            # Next.js App Router
│   │   │   ├── layout.tsx  # Root layout
│   │   │   ├── page.tsx    # Home page
│   │   │   ├── loading.tsx # Loading UI
│   │   │   ├── not-found.tsx # 404 page
│   │   │   ├── globals.css # Global styles
│   │   │   └── api/        # API routes
│   │   │       └── test/
│   │   │           └── route.ts # Example API route
│   │   └── components/     # Reusable components
│   │       └── UserCard.tsx # User card component
│   ├── package.json        # Node.js dependencies
│   ├── tsconfig.json       # TypeScript configuration
│   ├── next.config.js      # Next.js configuration
│   ├── Dockerfile          # Frontend container config
│   ├── Dockerfile.dev      # Development container config
│   └── .env.local          # Frontend environment variables
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions for deployment
├── docker-compose.yml      # Production container orchestration
├── docker-compose.dev.yml  # Development container orchestration
├── run.bat                 # Windows helper script
├── run.sh                  # Linux/Mac helper script
├── .gitignore             # Git ignore rules
└── README.md
```

### App Router Features

The Next.js 15+ App Router provides:

- **File-based routing**: Routes are defined by the file system
- **Layouts**: Shared UI between routes
- **Loading states**: Automatic loading UI
- **Error boundaries**: Better error handling
- **API routes**: Server-side API endpoints in the same project
- **Server components**: Better performance with server-side rendering
- **Client components**: Interactive components with `'use client'`

### Environment Variables

The application uses the following environment variables:

**Backend (.env)**:
- `DATABASE_URL`: PostgreSQL connection string

**Frontend (.env.local)**:
- `NEXT_PUBLIC_API_URL`: Backend API URL

### What's New in App Router

1. **File-based routing**: No more `pages/` directory
2. **Layout system**: Shared layouts with `layout.tsx`
3. **Loading UI**: Automatic loading states with `loading.tsx`
4. **Error handling**: Better error boundaries
5. **API routes**: Modern API routes in `app/api/`
6. **Server components**: Default server-side rendering
7. **Client components**: Explicit client-side interactivity

### Troubleshooting

**Port conflicts**: Make sure ports 3000, 8000, and 5432 are not in use by other applications.

**Database connection issues**: Wait a few seconds for PostgreSQL to fully start before the backend tries to connect.

**Frontend not connecting to backend**: Check that the `NEXT_PUBLIC_API_URL` environment variable is set correctly.

**TypeScript errors**: The project is set up with TypeScript. Install dependencies with `npm install` to resolve type errors.
