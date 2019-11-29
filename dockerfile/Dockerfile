#VERSION EE:latest
FROM java:8
MAINTAINER wangjianwei "wangjianwei@jimi360.cn"
VOLUME /tmp
RUN mkdir -p /usr/local/cron
COPY ./ /usr/local/cron
WORKDIR /usr/local/cron/
env JVM_PARAM "-server -Xmx512M -Xms512M -Xmn256M -XX:PermSize=128M -XX:MaxPermSize=256M -XX:GCTimeRatio=19 -XX:+ClassUnloading -XX:+UseConcMarkSweepGC -Xloggc:log/gc.log"
ENTRYPOINT java -Dloader.path=/usr/local/cron/lib ${JVM_PARAM} -jar /usr/local/cron/jmax-cron.jar
