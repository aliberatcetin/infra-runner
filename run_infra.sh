#!/bin/bash

TARGET_NAME="docker-cluster-default-latest-e-i-v-l-develop-n1"
CONTAINER_RUNNER_NAME="hpc_infra_runner"
IMAGE_NAME="beratcetin787878/task-graph-infra"

# Step 1: Get container IP
CONTAINER_ID=$(docker ps -qf "name=^/${TARGET_NAME}$")
if [ -z "$CONTAINER_ID" ]; then
    echo "Container $TARGET_NAME not found or not running."
    exit 1
fi

CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_ID")
echo "IP of $TARGET_NAME is: $CONTAINER_IP"

# Step 2: Check if hpc_infra_runner exists
RUNNER_EXISTS=$(docker ps -a -q -f name=^/${CONTAINER_RUNNER_NAME}$)

if [ -n "$RUNNER_EXISTS" ]; then
    echo "Container $CONTAINER_RUNNER_NAME already exists."

    # Start it if it's not running
    RUNNER_RUNNING=$(docker ps -q -f name=^/${CONTAINER_RUNNER_NAME}$)
    if [ -z "$RUNNER_RUNNING" ]; then
        echo "Starting existing container..."
        docker start "$CONTAINER_RUNNER_NAME"
    else
        echo "Container is already running."
    fi
else
    echo "Running new container $CONTAINER_RUNNER_NAME..."
    docker run -d \
        -e GRAPH_MASTER_IP="$CONTAINER_IP" \
        --name "$CONTAINER_RUNNER_NAME" \
        -p 8080:8080 -p 8081:8081 -p 3000:3000 \
        "$IMAGE_NAME"
fi

# Step 3: Copy and execute the script
docker cp entrypoint.sh "$CONTAINER_RUNNER_NAME":/opt/entrypoint.sh
docker exec "$CONTAINER_RUNNER_NAME" chmod +x /opt/entrypoint.sh
docker exec "$CONTAINER_RUNNER_NAME" /opt/entrypoint.sh
