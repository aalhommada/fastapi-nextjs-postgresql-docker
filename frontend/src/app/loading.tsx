export default function Loading() {
  return (
    <div style={loadingContainerStyle}>
      <div style={spinnerStyle}></div>
      <p style={loadingTextStyle}>Loading...</p>
    </div>
  )
}

const loadingContainerStyle = {
  display: 'flex',
  flexDirection: 'column' as const,
  alignItems: 'center',
  justifyContent: 'center',
  minHeight: '50vh',
  gap: '20px'
}

const spinnerStyle = {
  width: '40px',
  height: '40px',
  border: '4px solid #f3f3f3',
  borderTop: '4px solid #3b82f6',
  borderRadius: '50%',
  animation: 'spin 1s linear infinite'
}

const loadingTextStyle = {
  color: '#64748b',
  fontSize: '16px'
}
