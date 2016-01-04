# Docker ELK stack

Run the latest version of the ELK (Elasticseach, Logstash, Kibana) stack with Docker and Docker-compose. Authentication is managed by [Shield](https://www.elastic.co/products/shield).

It will give you the ability to analyze any data set by using the searching/aggregation capabilities of Elasticseach and the visualization power of Kibana.

Based on the official images:

* [elasticsearch](https://registry.hub.docker.com/_/elasticsearch/)
* [logstash](https://registry.hub.docker.com/_/logstash/)
* [kibana](https://registry.hub.docker.com/_/kibana/)

# Requirements

## Setup

1. Install [Docker](http://docker.io).
2. Install [Docker-compose](http://docs.docker.com/compose/install/).
3. Install [Docker-machine](https://docs.docker.com/machine/install-machine/).
4. Clone this repository
5. Run 'docker-machine create -d virtualbox HOSTNAME' to create a new Docker host using VirtualBox driver
6. Switch to Docker host context: eval $(docker-machine env HOSTNAME)
7. Run 'create-images.sh' to create Logstash / Elasticsearch / Kibana images containing the configurations
8. Run 'docker-compose up' to run the stack

Note: usage of docker-machine is not mandatory (even if it's really convenient). If you can already talk to a Docker Engine, you do not need steps 3/5/6

## Populate

Send log file to logstash

```bash
$ nc DOCKER_HOST_IP 5000 < /path/to/logfile.log
```

And then access Kibana UI by hitting [http://localhost:5601](http://localhost:5601) with a web browser.

> Shield is enabled. Use the following credentials to access Kibana: kibana_admin / kibana

You can also access:
* Sense: [http://localhost:5601/app/sense](http://localhost:5601/app/sense)

By default, the stack exposes the following ports:
* 5000: Logstash TCP input
* 5514: Logstash syslog input
* 9200: Elasticsearch HTTP
* 5601: Kibana

# Configuration

If the configuration of a component changes, the image need to be re-created and the stack needs to be re-deployed

## How can I tune Kibana configuration?

The Kibana default configuration is stored in `kibana/config/kibana.yml`.

## How can I tune Logstash configuration?

The logstash configuration is stored in `logstash/config/logstash.conf`.

The folder `logstash/config` is mapped onto the container `/etc/logstash/conf.d` so you
can create more than one file in that folder if you'd like to. However, you must be aware that config files will be read from the directory in alphabetical order.

## How can I specify the amount of memory used by Logstash?

The Logstash container use the *LS_HEAP_SIZE* environment variable to determine how much memory should be associated to the JVM heap memory (defaults to 500m).

If you want to override the default configuration, add the *LS_HEAP_SIZE* environment variable to the container in the `docker-compose.yml`:

## How can I tune Elasticsearch configuration?

The Elasticsearch container is using the shipped configuration and it is not exposed by default.

If you want to override the default configuration, create a file `elasticsearch/config/elasticsearch.yml` and add your configuration in it.

Then, you'll need to re-create the image

You can also specify the options you want to override directly in the command field:

```yml
elasticsearch:
  build: elasticsearch/
  command: elasticsearch -Des.network.host=_non_loopback_ -Des.cluster.name: my-cluster
  ports:
    - "9200:9200"
```

# Storage

## How can I store Elasticsearch data?

The data stored in Elasticsearch will be persisted after container reboot but not after container removal.

In order to persist Elasticsearch data even after removing the Elasticsearch container, you'll have to mount a volume on your Docker host. Update the elasticsearch container declaration to:

```yml
elasticsearch:
  build: elasticsearch/
  command: elasticsearch -Des.network.host=_non_loopback_
  ports:
    - "9200:9200"
  volumes:
    - /path/to/storage:/usr/share/elasticsearch/data
```

This will store elasticsearch data inside `/path/to/storage`.
