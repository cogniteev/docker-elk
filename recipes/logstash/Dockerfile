FROM logstash:1.5.5-1

ONBUILD ADD ./conf /etc/logstash/
CMD ["logstash", "-f", "/etc/logstash"]
