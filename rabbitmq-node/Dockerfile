FROM rabbitmq:3.6.9

RUN rabbitmq-plugins enable --offline rabbitmq_management

EXPOSE 15671
EXPOSE 15672
EXPOSE 25672
EXPOSE 4369
EXPOSE 9100
EXPOSE 9101
EXPOSE 9102
EXPOSE 9103
EXPOSE 9104
EXPOSE 9105

RUN mkdir /opt/rabbit
ADD setup.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/setup.sh

RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq /var/log/rabbitmq

CMD /opt/rabbit/setup.sh
