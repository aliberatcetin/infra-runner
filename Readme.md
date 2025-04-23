./run_infra.sh is enough for running db+backend+frontend.

./start.sh -n $N script must have been executed before ./run_infra.sh since
it is looking for GRAPH_MASTER_NODE_IP which is typically n1.


http://localhost:3000 -> graph ui

shift + left click creates a node.

to connect two nodes, press shift and try to move a node, you will realize dependency arrow.

to delete a node, select a node and press backspace.


./run_infra.sh uses the docker repo https://hub.docker.com/repository/docker/beratcetin787878/task-graph-infra/general which contains all the necessary packages for backend/infra.