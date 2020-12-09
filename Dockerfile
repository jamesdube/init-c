FROM scratch
ADD init-c.sh /tmp/init-c.sh
RUN pwd
RUN chmod +x /tmp/init-c.sh
ENTRYPOINT ["/tmp/init-c.sh"]