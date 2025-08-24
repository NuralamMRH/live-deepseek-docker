#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
if ! command_exists docker || ! command_exists docker-compose; then
    echo "Error: Docker and/or Docker Compose not found. Please run setup-vps.sh first."
    exit 1
fi

# Stop any running containers
echo "Stopping existing containers..."
docker-compose -f docker-compose.vps.yml down

# Pull latest images
echo "Pulling latest images..."
docker-compose -f docker-compose.vps.yml pull

# Build and start services
echo "Starting services..."
docker-compose -f docker-compose.vps.yml up -d --build

# Wait for services to start
echo "Waiting for services to start..."
sleep 10

# Check service status
echo "Checking service status..."
docker-compose -f docker-compose.vps.yml ps

echo "
Deployment complete! Services are available at:
- OpenWebUI: http://YOUR_VPS_IP:8080
- Ollama API: http://YOUR_VPS_IP:11434

To view logs:
- All services: docker-compose -f docker-compose.vps.yml logs -f
- OpenWebUI: docker-compose -f docker-compose.vps.yml logs -f openwebui
- Ollama: docker-compose -f docker-compose.vps.yml logs -f ollamadeepseek

To stop services:
docker-compose -f docker-compose.vps.yml down
" 
