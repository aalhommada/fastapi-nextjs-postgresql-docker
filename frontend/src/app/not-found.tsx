export default function NotFound() {
  return (
    <div style={containerStyle}>
      <h1>404</h1>
      <h2>Page Not Found</h2>
      <p>The page you are looking for doesn't exist.</p>
      <a href="/" style={linkStyle}>
        ← Back to Home
      </a>
    </div>
  )
}

const containerStyle = {
  display: 'flex',
  flexDirection: 'column' as const,
  alignItems: 'center',
  justifyContent: 'center',
  minHeight: '50vh',
  textAlign: 'center' as const,
  gap: '20px',
  padding: '40px'
}

const linkStyle = {
  color: '#3b82f6',
  textDecoration: 'none',
  fontSize: '16px',
  fontWeight: '600'
}
