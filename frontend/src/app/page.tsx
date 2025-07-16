'use client'

import { useState, useEffect } from 'react'
import axios from 'axios'

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'

interface User {
  id: number
  name: string
  email: string
  created_at: string
}

export default function HomePage() {
  const [users, setUsers] = useState<User[]>([])
  const [newUser, setNewUser] = useState({ name: '', email: '' })
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState('')
  const [isConnected, setIsConnected] = useState(false)

  // Fetch users from backend
  const fetchUsers = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/users/`)
      setUsers(response.data)
    } catch (error) {
      console.error('Error fetching users:', error)
      setMessage('Error fetching users')
    }
  }

  // Create new user
  const createUser = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!newUser.name || !newUser.email) return

    setLoading(true)
    try {
      await axios.post(`${API_BASE_URL}/users/`, newUser)
      setNewUser({ name: '', email: '' })
      setMessage('User created successfully!')
      fetchUsers() // Refresh the list
    } catch (error: any) {
      setMessage(error.response?.data?.detail || 'Error creating user')
    } finally {
      setLoading(false)
    }
  }

  // Test backend connection
  const testConnection = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/health`)
      setMessage(`Backend connected! Status: ${response.data.status}`)
      setIsConnected(true)
    } catch (error) {
      setMessage('Failed to connect to backend')
      setIsConnected(false)
    }
  }

  useEffect(() => {
    testConnection()
    fetchUsers()
  }, [])

  return (
    <main style={mainStyle}>
      <div style={containerStyle}>
        <header style={headerStyle}>
          <h1>🚀 FastAPI + Next.js + PostgreSQL</h1>
          <p>Full-stack application with App Router</p>
        </header>
        
        <section style={sectionStyle}>
          <div style={connectionStyle}>
            <button onClick={testConnection} style={buttonStyle}>
              Test Backend Connection
            </button>
            <div style={statusStyle}>
              <span style={{
                ...statusIndicatorStyle,
                backgroundColor: isConnected ? '#4ade80' : '#f87171'
              }}>
                {isConnected ? '🟢' : '🔴'}
              </span>
              <span>{isConnected ? 'Connected' : 'Disconnected'}</span>
            </div>
          </div>
          
          {message && (
            <div style={{
              ...messageStyle,
              backgroundColor: message.includes('Error') ? '#fee2e2' : '#dcfce7',
              color: message.includes('Error') ? '#dc2626' : '#16a34a'
            }}>
              {message}
            </div>
          )}
        </section>

        <section style={sectionStyle}>
          <h2>➕ Create New User</h2>
          <form onSubmit={createUser} style={formStyle}>
            <input
              type="text"
              placeholder="Enter name"
              value={newUser.name}
              onChange={(e) => setNewUser({ ...newUser, name: e.target.value })}
              style={inputStyle}
              required
            />
            <input
              type="email"
              placeholder="Enter email"
              value={newUser.email}
              onChange={(e) => setNewUser({ ...newUser, email: e.target.value })}
              style={inputStyle}
              required
            />
            <button type="submit" disabled={loading} style={buttonStyle}>
              {loading ? '⏳ Creating...' : '✨ Create User'}
            </button>
          </form>
        </section>

        <section style={sectionStyle}>
          <h2>👥 Users List ({users.length})</h2>
          {users.length === 0 ? (
            <div style={emptyStateStyle}>
              <p>📭 No users found</p>
              <p>Create your first user above!</p>
            </div>
          ) : (
            <div style={userGridStyle}>
              {users.map((user) => (
                <div key={user.id} style={userCardStyle}>
                  <div style={userHeaderStyle}>
                    <h3>{user.name}</h3>
                    <span style={userIdStyle}>#{user.id}</span>
                  </div>
                  <p style={userEmailStyle}>📧 {user.email}</p>
                  <p style={userDateStyle}>
                    📅 {new Date(user.created_at).toLocaleDateString('en-US', {
                      year: 'numeric',
                      month: 'short',
                      day: 'numeric',
                      hour: '2-digit',
                      minute: '2-digit'
                    })}
                  </p>
                </div>
              ))}
            </div>
          )}
        </section>
      </div>
    </main>
  )
}

// Styles
const mainStyle = {
  minHeight: '100vh',
  backgroundColor: '#f8fafc',
  padding: '20px'
}

const containerStyle = {
  maxWidth: '1200px',
  margin: '0 auto',
  backgroundColor: 'white',
  borderRadius: '12px',
  boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
  padding: '40px'
}

const headerStyle = {
  textAlign: 'center' as const,
  marginBottom: '40px',
  borderBottom: '2px solid #e2e8f0',
  paddingBottom: '20px'
}

const sectionStyle = {
  marginBottom: '40px'
}

const connectionStyle = {
  display: 'flex',
  alignItems: 'center',
  gap: '20px',
  marginBottom: '20px'
}

const statusStyle = {
  display: 'flex',
  alignItems: 'center',
  gap: '8px',
  fontSize: '14px',
  fontWeight: '500'
}

const statusIndicatorStyle = {
  width: '12px',
  height: '12px',
  borderRadius: '50%'
}

const messageStyle = {
  padding: '12px 16px',
  borderRadius: '8px',
  marginBottom: '20px',
  fontWeight: '500'
}

const formStyle = {
  display: 'flex',
  flexDirection: 'column' as const,
  gap: '16px',
  maxWidth: '400px'
}

const inputStyle = {
  padding: '12px 16px',
  border: '2px solid #e2e8f0',
  borderRadius: '8px',
  fontSize: '16px',
  fontFamily: 'inherit'
}

const buttonStyle = {
  padding: '12px 24px',
  backgroundColor: '#3b82f6',
  color: 'white',
  border: 'none',
  borderRadius: '8px',
  cursor: 'pointer',
  fontSize: '16px',
  fontWeight: '600',
  fontFamily: 'inherit'
}

const emptyStateStyle = {
  textAlign: 'center' as const,
  padding: '40px',
  color: '#64748b',
  backgroundColor: '#f8fafc',
  borderRadius: '8px',
  border: '2px dashed #cbd5e1'
}

const userGridStyle = {
  display: 'grid',
  gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))',
  gap: '20px'
}

const userCardStyle = {
  border: '2px solid #e2e8f0',
  borderRadius: '12px',
  padding: '20px',
  backgroundColor: '#fefefe',
  transition: 'all 0.2s ease'
}

const userHeaderStyle = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  marginBottom: '12px'
}

const userIdStyle = {
  backgroundColor: '#3b82f6',
  color: 'white',
  padding: '4px 8px',
  borderRadius: '4px',
  fontSize: '12px',
  fontWeight: '600'
}

const userEmailStyle = {
  margin: '8px 0',
  color: '#475569'
}

const userDateStyle = {
  margin: '8px 0',
  color: '#64748b',
  fontSize: '14px'
}
