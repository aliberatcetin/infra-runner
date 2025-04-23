./run_infra.sh is enough for running db+backend+frontend.

./start.sh -n <> script must have been executed before ./run_infra.sh since
it is looking for GRAPH_MASTER_NODE_IP which is typically n1.