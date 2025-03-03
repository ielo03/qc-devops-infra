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
docker-compose up --build -d

echo "Waiting for services to stabilize..."
sleep 15  # adjust the sleep time as needed

echo "========================================"
echo "Running additional integration tests..."
# Here, add your integration test commands. For example:
# curl -s -I http://localhost:3000/api/health
# Or if you have an integration test script, run it:
if [ -x "./integration-tests.sh" ]; then
  ./integration-tests.sh
else
  echo "No integration test script found. Please add integration test commands here."
fi

echo "========================================"
echo "Shutting down docker-compose services..."
docker-compose down

echo "========================================"
echo "All tests and deployment steps completed successfully."
