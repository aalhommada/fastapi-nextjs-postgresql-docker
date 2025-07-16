from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, Column, Integer, String, DateTime, text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from pydantic import BaseModel
from datetime import datetime
import os
import time
from dotenv import load_dotenv

load_dotenv()

# Database configuration
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:secure_password_123@db:5432/appdb")

def create_database_engine():
    """Create database engine with retry logic"""
    max_retries = 30
    retry_delay = 2
    
    for attempt in range(max_retries):
        try:
            engine = create_engine(DATABASE_URL)
            # Test the connection
            with engine.connect() as connection:
                connection.execute(text("SELECT 1"))
            print(f"✅ Database connection successful on attempt {attempt + 1}")
            return engine
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"❌ Database connection failed (attempt {attempt + 1}/{max_retries}): {e}")
                print(f"⏳ Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                print(f"💥 Database connection failed after {max_retries} attempts")
                raise e

# Create engine with retries
engine = create_database_engine()
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Database Models
class UserDB(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    email = Column(String, unique=True, index=True)
    created_at = Column(DateTime, default=datetime.utcnow)

# Pydantic models
class UserCreate(BaseModel):
    name: str
    email: str

class User(BaseModel):
    id: int
    name: str
    email: str
    created_at: datetime
    
    class Config:
        from_attributes = True

# Create tables with retry logic
def create_tables():
    """Create database tables with retry logic"""
    max_retries = 5
    for attempt in range(max_retries):
        try:
            Base.metadata.create_all(bind=engine)
            print("✅ Database tables created successfully")
            break
        except Exception as e:
            if attempt < max_retries - 1:
                print(f"❌ Failed to create tables (attempt {attempt + 1}/{max_retries}): {e}")
                time.sleep(2)
            else:
                print(f"💥 Failed to create tables after {max_retries} attempts")
                raise e

create_tables()

# FastAPI app
app = FastAPI(title="Simple API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for now
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# API Routes
@app.get("/")
async def root():
    return {"message": "Hello from FastAPI Backend!", "status": "working"}

@app.get("/health")
async def health_check(db: Session = Depends(get_db)):
    try:
        # Test database connectivity
        db.execute(text("SELECT 1"))
        return {
            "status": "healthy", 
            "timestamp": datetime.utcnow(),
            "database": "connected"
        }
    except Exception as e:
        return {
            "status": "unhealthy", 
            "timestamp": datetime.utcnow(),
            "database": "disconnected",
            "error": str(e)
        }

@app.post("/users/", response_model=User)
async def create_user(user: UserCreate, db: Session = Depends(get_db)):
    # Check if user already exists
    db_user = db.query(UserDB).filter(UserDB.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create new user
    db_user = UserDB(name=user.name, email=user.email)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.get("/users/", response_model=list[User])
async def get_users(db: Session = Depends(get_db)):
    users = db.query(UserDB).all()
    return users

@app.get("/users/{user_id}", response_model=User)
async def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserDB).filter(UserDB.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)