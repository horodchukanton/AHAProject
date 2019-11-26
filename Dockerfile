FROM ubuntu:latest
EXPOSE 3000

RUN apt-get update && apt-get upgrade -yq && apt-get install libmojolicious-perl -yq

RUN mkdir /opt/AHAProject
COPY lib /opt/AHAProject/lib
COPY distracker.pl /opt/AHAProject/distracker.pl
RUN chmod +x /opt/AHAProject/distracker.pl

WORKDIR /opt/AHAProject
#ENTRYPOINT '/bin/bash'
CMD ["perl", "-Ilib", "distracker.pl", "daemon"]