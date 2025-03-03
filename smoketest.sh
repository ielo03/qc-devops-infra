#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

cd ../qc-devops-source

echo "========================================"
echo "Running backend tests..."
echo "========================================"
cd backend
npm install
npm test
cd ..

echo "========================================"
echo "Running frontend tests..."
echo "========================================"
cd frontend
npm install
npm test
cd ..

echo "========================================"
echo "Both backend and frontend tests passed."
echo "Building and launching docker-compose services..."
docker compose up --build -d

echo "Waiting for services to stabilize..."
./backend/wait-for-it.sh localhost:3002 --timeout=30 --strict -- echo "Backend is up!"

echo "========================================"
echo "Running additional integration tests..."
cd ../qc-devops-infra
./integration-tests.sh

echo "========================================"
echo "Shutting down docker-compose services..."
docker-compose down

echo "========================================"
echo "All tests and deployment steps completed successfully."
