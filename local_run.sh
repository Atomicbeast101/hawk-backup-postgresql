#!/bin/bash

# Run containers locally
echo "Starting containers..."
docker compose up --build --remove-orphans $1
