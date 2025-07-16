import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'FastAPI + Next.js + PostgreSQL App',
  description: 'A full-stack application with FastAPI backend, Next.js frontend, and PostgreSQL database',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
