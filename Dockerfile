FROM openjdk:11.0-jdk AS build

ENV CMAK_VERSION=3.0.0.4

RUN wget "https://github.com/yahoo/kafka-manager/archive/${CMAK_VERSION}.tar.gz"

RUN tar -xzf ${CMAK_VERSION}.tar.gz \
    && cd /CMAK-${CMAK_VERSION} \
    && echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt \
    && ./sbt clean dist \
    && unzip -d ./builded ./target/universal/CMAK-${CMAK_VERSION}.zip \
    && mv -T ./builded/CMAK-${CMAK_VERSION} /opt/kafka-manager

FROM openjdk:11.0-jdk-slim

RUN apk update && apk add bash curl
COPY --from=build /opt/CMAK /opt/CMAK
WORKDIR /opt/CMAK

EXPOSE 9000
ENTRYPOINT ["./bin/CMAK","-Dconfig.file=conf/application.conf"]
