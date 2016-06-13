FROM logstash:2.3.2-1

RUN setcap 'cap_net_bind_service=+ep' \
   "$(readlink -f "$(which java)")"

ONBUILD ADD ./conf /etc/logstash/
CMD ["logstash", "-f", "/etc/logstash"]
