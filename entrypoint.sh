#!/bin/bash

# Set Neo4j password only if not already initialized
if [ ! -f "/var/lib/neo4j/data/dbms/auth" ]; then
    neo4j-admin dbms set-initial-password asdzxc1122..
fi

# Start Neo4j
neo4j start
sleep 10

cd /opt/thesis-task-graph-interface
# Start frontend using PM2
pm2 start npm --name frontend -- start

# Start backend
nohup java -jar /opt/app.jar > /opt/app.log 2>&1 &

cd /opt
rm -rf mpi-api
git clone https://github.com/aliberatcetin/mpi-api.git
cd mpi-api/build
make
./api &

# Keep container alive with PM2 logs
pm2 logs
