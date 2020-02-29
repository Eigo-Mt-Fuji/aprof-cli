FROM erlang:21-slim

ENV LANG=C.UTF-8
WORKDIR /usr/local/src/
ADD ./ex_awsconf /usr/local/src/ex_awsconf-cli
RUN chmod 755 /usr/local/src/ex_awsconf-cli
ENTRYPOINT [ "/usr/local/src/ex_awsconf-cli" ]