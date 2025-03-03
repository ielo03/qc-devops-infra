#!/bin/bash
set -e

# Define expected responses
EXPECTED_GET='[{"id":1,"title":"Test","recipe":"<h3>Test</h3><p>This is a test.</p>"}]'

echo "Running integration tests..."

# ------------------------------
# Test 1: GET /api/recipes
# ------------------------------
echo "Testing GET /api/recipes..."
GET_RESPONSE=$(curl -s http://localhost:3000/api/recipes)
if [ "$GET_RESPONSE" == "$EXPECTED_GET" ]; then
  echo "GET /api/recipes returned expected response."
else
  echo "GET /api/recipes response did not match expected."
  echo "Expected: $EXPECTED_GET"
  echo "Got:      $GET_RESPONSE"
  exit 1
fi

# ------------------------------
# Test 2: POST /api/concoct
# ------------------------------
echo "Testing POST /api/concoct..."
START_TIME=$(date +%s%3N)  # milliseconds timestamp

POST_RESPONSE=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"drink": "Old Fashioned"}' \
  http://localhost:3000/api/concoct)

END_TIME=$(date +%s%3N)
ELAPSED=$((END_TIME - START_TIME))
echo "POST /api/concoct took ${ELAPSED}ms."

if [ $ELAPSED -gt 5000 ]; then
  echo "Error: POST /api/concoct took too long (>$ELAPSED ms)."
  exit 1
fi

# Parse the JSON response using jq.
TITLE=$(echo "$POST_RESPONSE" | jq -r '.title')
RECIPE=$(echo "$POST_RESPONSE" | jq -r '.recipe')

if [ "$TITLE" != "Old Fashioned" ]; then
  echo "Error: Expected title 'Old Fashioned', got '$TITLE'."
  exit 1
fi

if [[ "$RECIPE" != \<h3\>* ]]; then
  echo "Error: The recipe does not start with '<h3>'. Got: $RECIPE"
  exit 1
fi

echo "POST /api/concoct returned the expected response."
echo "All integration tests passed!"
