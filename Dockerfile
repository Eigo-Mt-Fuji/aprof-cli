FROM erlang:21-slim

ENV LANG=C.UTF-8
WORKDIR /usr/local/src/
ADD ./aprof_cli /usr/local/src/aprof_cli
RUN chmod 755 /usr/local/src/aprof_cli
ENTRYPOINT [ "/usr/local/src/aprof_cli" ]