# API Policy Hub

A comprehensive platform for managing and discovering API policies for the WSO2 API Platform. This project provides both a backend API service (built with Go) and a modern frontend application (built with React and TypeScript) for browsing, versioning, and synchronizing API policies.

[![Go](https://img.shields.io/badge/Go-1.24+-00ADD8.svg)](https://golang.org/)
[![React](https://img.shields.io/badge/React-19.2+-61dafb.svg)](https://react.dev/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.9+-blue.svg)](https://www.typescriptlang.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12+-336791.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## ✨ Features

### Backend (Go)
- **Policy Management**: Full CRUD operations for API policies
- **Version Control**: Immutable policy versioning with rich documentation
- **Synchronization**: CI/CD integration via sync endpoints
- **Search & Filtering**: Advanced policy discovery capabilities
- **Asset Management**: Support for icons, banners, and media files
- **RESTful API**: Well-documented endpoints with OpenAPI specification
- **Database**: PostgreSQL with SQLC-generated type-safe queries
- **Docker Support**: Containerized deployment with docker-compose

### Frontend (React/TypeScript)
- **Policy Discovery**: Intuitive search and filtering interface
- **Rich Documentation**: Markdown rendering with syntax highlighting
- **Version Management**: Easy browsing of policy versions
- **Theme Support**: Light/dark mode with persistent preferences
- **Fully Responsive**: Optimized for all device sizes
- **Modern UI**: Material-UI components with custom theming

## 🛠️ Tech Stack

### Backend
- **Go** 1.24+ - Backend language
- **Gin** - HTTP web framework
- **PostgreSQL** - Database
- **SQLC** - Type-safe SQL code generation
- **Docker** - Containerization
- **Make** - Build automation

### Frontend
- **React** 19.2+ - UI framework
- **TypeScript** 5.9+ - Type safety
- **Material-UI** 7.3+ - Component library
- **Vite** 7.2+ - Build tool and dev server
- **React Router** - Client-side routing
- **React Markdown** - Markdown rendering

### Monorepo Tools
- **Make** - Unified build automation (root Makefile for cross-project commands)

## 📋 Prerequisites

- **Go**: 1.24.0 or later
- **Node.js**: 18.x or later (tested with v22.14.0)
- **npm**: 9.x or later (tested with v10.9.2)
- **PostgreSQL**: 12 or later
- **Make**: For build automation
- **Git**: For version control
- **Docker**: Optional, for containerized setup

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd apim-policy-hub
```

### 2. Configure Environment
Before starting the setup, configure your environment variables:

**For Backend:**
Copy and edit the environment file:
```bash
cp backend/.env.example backend/.env
```
Edit `backend/.env` with your database connection details and other settings.

**For Frontend:**
Create frontend environment file:
```bash
# Create frontend/.env.local
echo "VITE_API_BASE_URL=http://localhost:8080" > frontend/.env.local
```

## 🚀 Setup Options

Choose **one** of the following setup methods. Each provides a complete working environment.

```mermaid
flowchart TD
    A[Clone Repository] --> B[Configure Environment<br/>cp backend/.env.example backend/.env<br/>Edit backend/.env<br/>Create frontend/.env.local]
    B --> C{Choose Setup Method}
    
    C --> D[Option 1: Full Automated]
    C --> E[Option 2: Root Directory]
    C --> F[Option 3: Manual Navigation]
    
    D --> G{With Sample Data?}
    G -->|Yes| H[make full-setup]
    G -->|No| I[make setup]
    H --> J[make start]
    I --> J
    J --> K[Backend + Frontend Ready]
    
    E --> L{Setup Docker PostgreSQL?}
    L -->|Yes| M[make backend-setup]
    L -->|No| N[make backend-run]
    M --> O{Populate Sample Data?}
    O -->|Yes| P[make backend-populate-data]
    O -->|No| Q[make backend-run]
    P --> Q
    
    N --> R[make frontend-setup]
    Q --> R
    R --> S[make frontend-dev]
    S --> K
    
    F --> T[cd backend]
    T --> U{Setup Docker PostgreSQL?}
    U -->|Yes| V[make docker-up]
    U -->|No| W[make run]
    V --> X{Populate Sample Data?}
    X -->|Yes| Y[make populate-sample-data]
    X -->|No| Z[make run]
    Y --> Z
    
    W --> AA[cd ../frontend]
    Z --> AA
    AA --> BB[npm install]
    BB --> CC[npm run dev]
    CC --> K
    
    K --> DD[Access Application<br/>Backend: localhost:8080<br/>Frontend: localhost:3000]
```

### Option 1: Full Automated Setup
```bash
# With sample data (recommended for first-time users)
make full-setup  # Complete setup with Docker, dependencies, SQLC, sample data, and frontend install
make start       # Start both backend and frontend servers

# Without sample data
make setup       # Complete setup with Docker, dependencies, SQLC, and frontend install (no sample data)
make start       # Start both backend and frontend servers
```
*Use `make full-setup` for a fully functional environment with demo data, or `make setup` for an empty database. Backend at `http://localhost:8080`, Frontend at `http://localhost:3000`.*

### Option 2: Backend + Frontend from Root Directory (Recommended)
```bash
# Choose your database setup:
# For Docker PostgreSQL: make backend-setup
# For existing PostgreSQL: skip to make backend-run

# Optional: Populate with sample data
make backend-populate-data

# Start services
make backend-run            # Backend server
make frontend-setup          # Install frontend dependencies
make frontend-dev            # Frontend development server
```
*Recommended for development. Use Docker PostgreSQL for quick setup or existing PostgreSQL if you have your own database.*

### Option 3: Manual Directory Navigation
```bash
cd backend

# Choose your database setup:
# For Docker PostgreSQL: make docker-up
# For existing PostgreSQL: skip to make run

# Optional: Populate with sample data
make populate-sample-data

# Start backend
make run

# Start frontend (in another terminal)
cd ../frontend
npm install
npm run dev
```
*Use for manual control with directory changes. Choose Docker or existing PostgreSQL based on your setup.*

## 📁 Project Structure

```
apim-policy-hub/
├── backend/                 # Go backend service
│   ├── api/                # OpenAPI specifications
│   ├── cmd/                # Application entry points
│   ├── internal/           # Private application code
│   │   ├── config/        # Configuration management
│   │   ├── db/            # Database layer
│   │   ├── http/          # HTTP handlers and middleware
│   │   ├── logging/       # Logging utilities
│   │   ├── policy/        # Policy business logic
│   │   ├── sync/          # Synchronization services
│   │   └── validation/    # Input validation
│   ├── scripts/           # Database scripts
│   ├── docs/              # Backend documentation
│   ├── docker-compose.yml # Docker services
│   ├── Dockerfile         # Container definition
│   ├── Makefile           # Build automation
│   └── go.mod             # Go dependencies
├── frontend/               # React frontend application
│   ├── src/
│   │   ├── components/    # UI components
│   │   ├── contexts/      # React contexts
│   │   ├── hooks/         # Custom hooks
│   │   ├── lib/           # Utilities and constants
│   │   ├── pages/         # Route components
│   │   └── content/       # Static content
│   ├── package.json       # Node dependencies
│   ├── vite.config.ts     # Vite configuration
│   └── tsconfig.json      # TypeScript configuration
├── .gitignore             # Git ignore rules
└── README.md              # This file
```

## 📚 Documentation

### Backend Documentation
Located in `backend/docs/`:
- **[Architecture](./backend/docs/ARCHITECTURE.md)** - System design and data flow
- **[Features](./backend/docs/FEATURES.md)** - Complete feature overview
- **[API Reference](./backend/docs/API_REFERENCE.md)** - All endpoints with examples
- **[Setup Guide](./backend/docs/SETUP.md)** - Detailed installation instructions

### API Specification
- **[OpenAPI Spec](./backend/api/openapi.yaml)** - Complete API contract

## 🛠️ Development

### Backend Development
```bash
make backend-test     # Run tests
make backend-build    # Build binary
make backend-lint     # Lint code
make backend-dev      # Run in development mode
make backend-sqlc     # Generate SQLC code
```

### Frontend Development
```bash
make frontend-build   # Production build
make frontend-preview # Preview production build
make frontend-lint    # Run ESLint
```

### Database Management
```bash
make backend-docker-up      # Start PostgreSQL container
make backend-docker-down    # Stop PostgreSQL container
make backend-docker-clean   # Stop containers and remove volumes (clean DB)
make backend-populate-data  # Populate with sample data
```

## 🔧 Configuration

### Backend Environment Variables
Create `backend/.env`:
```bash
SERVER_HOST=0.0.0.0
SERVER_PORT=8080
DB_HOST=localhost
DB_PORT=5432
DB_NAME=policyhub
DB_USER=your_username
DB_PASSWORD=your_password
LOG_LEVEL=info

# Azure Storage Configuration
AZURE_STORAGE_ACCOUNT_NAME=your_storage_account
AZURE_STORAGE_ACCOUNT_KEY=yourstoragekey==
AZURE_STORAGE_CONTAINER_NAME=policies
POLICY_BASE_PATH=policies
```

### Frontend Environment Variables
Create `frontend/.env.local`:
```bash
VITE_API_BASE_URL=http://localhost:8080
```

## Support

For support and questions:
- Check the [documentation](./backend/docs/)
- Open an issue on GitHub
- Review the [API Reference](./backend/docs/API_REFERENCE.md)

---

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

