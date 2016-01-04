DOCKER_ELK_HOME=$(pwd)

# Build Elasticsearch image
cd $DOCKER_ELK_HOME/elasticsearch
docker build -t elk/elasticsearch .

# Build Logstash image
cd $DOCKER_ELK_HOME/logstash
docker build -t elk/logstash .

# Build Kibana image
cd $DOCKER_ELK_HOME/kibana
docker build -t elk/kibana .
