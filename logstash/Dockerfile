FROM logstash:latest

COPY config/logstash.conf /etc/logstash/conf.d/logstash.conf

# Port 5000 for tcp is exposed through official image
# Expose port that receives syslog
EXPOSE 5514

CMD  ["logstash", "-f", "/etc/logstash/conf.d/logstash.conf"]
