# create directory
mkdir -p data/node1 data/node2 data/node3 data/node4 data/rpc data/bootnode1 data/bootnode2
sudo chmod 775 \
    data/node* \
    data/rpc \
    data/bootnode* \
# start docker
sudo docker-compose up -d