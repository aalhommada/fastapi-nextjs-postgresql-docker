'use client'

interface User {
  id: number
  name: string
  email: string
  created_at: string
}

interface UserCardProps {
  user: User
  onUserClick?: (user: User) => void
}

export default function UserCard({ user, onUserClick }: UserCardProps) {
  return (
    <div 
      style={cardStyle} 
      onClick={() => onUserClick?.(user)}
      role={onUserClick ? "button" : undefined}
      tabIndex={onUserClick ? 0 : undefined}
    >
      <div style={headerStyle}>
        <h3 style={nameStyle}>{user.name}</h3>
        <span style={idBadgeStyle}>#{user.id}</span>
      </div>
      
      <div style={contentStyle}>
        <p style={emailStyle}>
          <span style={iconStyle}>📧</span>
          {user.email}
        </p>
        
        <p style={dateStyle}>
          <span style={iconStyle}>📅</span>
          {new Date(user.created_at).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
          })}
        </p>
      </div>
    </div>
  )
}

const cardStyle = {
  border: '2px solid #e2e8f0',
  borderRadius: '12px',
  padding: '20px',
  backgroundColor: '#fefefe',
  transition: 'all 0.2s ease',
  cursor: 'pointer',
  ':hover': {
    borderColor: '#3b82f6',
    transform: 'translateY(-2px)',
    boxShadow: '0 8px 25px rgba(0, 0, 0, 0.1)'
  }
}

const headerStyle = {
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'center',
  marginBottom: '16px'
}

const nameStyle = {
  margin: 0,
  color: '#1e293b',
  fontSize: '18px'
}

const idBadgeStyle = {
  backgroundColor: '#3b82f6',
  color: 'white',
  padding: '4px 8px',
  borderRadius: '6px',
  fontSize: '12px',
  fontWeight: '600'
}

const contentStyle = {
  display: 'flex',
  flexDirection: 'column' as const,
  gap: '8px'
}

const emailStyle = {
  margin: 0,
  color: '#475569',
  display: 'flex',
  alignItems: 'center',
  gap: '8px'
}

const dateStyle = {
  margin: 0,
  color: '#64748b',
  fontSize: '14px',
  display: 'flex',
  alignItems: 'center',
  gap: '8px'
}

const iconStyle = {
  fontSize: '14px'
}
