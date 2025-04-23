#!/bin/bash

docker stop hpc_infra_runner
docker rm hpc_infra_runner

TARGET_NAME="docker-cluster-default-latest-e-i-v-l-develop-n1"

# Step 1: Get container IP
CONTAINER_ID=$(docker ps -qf "name=^/${TARGET_NAME}$")
if [ -z "$CONTAINER_ID" ]; then
    echo "Container $TARGET_NAME not found or not running."
    exit 1
fi

CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_ID")
echo "IP of $TARGET_NAME is: $CONTAINER_IP"

# Step 2: Run the container in detached mode
docker run -d \
    -e GRAPH_MASTER_IP="$CONTAINER_IP" \
    --name hpc_infra_runner \
    -p 8080:8080 -p 8081:8081 -p 3000:3000 \
    hpc_infra

# Step 3: Copy the entrypoint.sh into the container
docker cp entrypoint.sh hpc_infra_runner:/opt/entrypoint.sh
docker exec hpc_infra_runner chmod +x /opt/entrypoint.sh

# Step 4: Execute the entrypoint script inside the container
docker exec hpc_infra_runner /opt/entrypoint.sh
