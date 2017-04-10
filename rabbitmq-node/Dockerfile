FROM rabbitmq:3.6.9

RUN rabbitmq-plugins enable --offline rabbitmq_management

EXPOSE 15671 15672

RUN mkdir /opt/rabbit
ADD setup.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/setup.sh

RUN chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq /var/log/rabbitmq

CMD /opt/rabbit/setup.sh
