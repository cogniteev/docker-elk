FROM logstash:1.5.3

ONBUILD ADD ./conf /etc/logstash/
CMD ["logstash", "-f", "/etc/logstash"]
