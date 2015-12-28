FROM elasticsearch:latest

ENV ES_JAVA_OPTS="-Des.path.conf=/etc/elasticsearch"

RUN plugin install license
RUN plugin install shield

RUN /usr/share/elasticsearch/bin/shield/esusers useradd logstash -p 'logstash' -r logstash
RUN /usr/share/elasticsearch/bin/shield/esusers useradd kibana -p 'kibana' -r kibana4_server
RUN /usr/share/elasticsearch/bin/shield/esusers useradd kibana_admin -p 'kibana' -r kibana4

CMD ["elasticsearch","-Des.network.host=0.0.0.0"]
