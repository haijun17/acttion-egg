FROM debian:stable-slim

LABEL version="debian:stable-slim"


RUN apt-get update && apt-get upgrade -y&&apt-get install -y xfonts-utils fontconfig  curl openssl gnupg xfonts-utils fontconfig apt-utils\
    && mv /etc/localtime /etc/localtime.bak && ln -svf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80  --recv-keys 0xB1998361219BD9C9 \
    && curl -O https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-2_all.deb && apt-get install -y ./zulu-repo_1.0.0-2_all.deb && apt-get update && rm -rf zulu-repo_1.0.0-2_all.deb && apt-get install -y zulu8-jdk\
    && mkdir -p /data/hybrid-cloud3/tmpdir \
    && mkdir -p /data/hybrid-cloud3/logs \
    && rm -rf /var/cache/apt/*

CMD ["java" "-version"]

WORKDIR /usr/share/fonts/
RUN curl -O https://apidocs.bestsign.cn/docCenter/apis/download/mswfonts.tar.gz && tar xzf mswfonts.tar.gz && mkfontscale && mkfontdir && fc-cache

# 定义work目录
WORKDIR /data/hybrid-cloud3
#上传jar 包
ADD  https://apidocs.bestsign.cn/docCenter/apis/download/hybrid-cloud3_release-SAAS-40328_20250321-154253.jar  /data/hybrid-cloud3/hybrid-cloud3.jar

# 更新漏洞
RUN apt-get update -y && apt-get upgrade -y

# 端口，要与java应用配置文件一致。
EXPOSE 8015

ENTRYPOINT ["sh","-c","java -Dspring.config.location=application.properties  -Dsun.misc.URLClassPath.disableJarChecking=true -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom -jar hybrid-cloud3.jar"]