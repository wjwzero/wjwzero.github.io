FROM registry.docker-cn.com/library/tomcat:7
MAINTAINER zhangduanfeng "zhangduanfeng@jimi360.cn"
VOLUME /tmp
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN rm -rf $CATALINA_HOME/webapps/*
ADD tuqiang-web.war $CATALINA_HOME/webapps/ROOT.war
ENV JAVA_OPTS="$JAVA_OPTS -server -Xmx3g -Xms3g -Xss512k -Xmn1g -XX:MaxPermSize=256m -XX:PermSize=256m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSFullGCsBeforeCompaction=10 -XX:+CMSClassUnloadingEnabled -Xloggc:logs/gc.log -XX:ErrorFile=logs/hs_error%p.log"
WORKDIR $CATALINA_HOME
RUN sed -i '/org.apache.jasper.servlet.JspServlet/a\\t<init-param>\n\t\t<param-name>mappedfile<\/param-name>\n\t\t<param-value>false<\/param-value>\n\t<\/init-param>' conf/web.xml
#CMD ["catalina.sh", "run"]