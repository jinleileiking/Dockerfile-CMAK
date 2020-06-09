FROM openjdk:11.0-jdk AS build

ENV CMAK_VERSION=3.0.0.4

RUN wget "https://github.com/yahoo/kafka-manager/archive/${CMAK_VERSION}.tar.gz"

RUN tar -xzf ${CMAK_VERSION}.tar.gz 
WORKDIR CMAK-${CMAK_VERSION}
# RUN cd CMAK-${CMAK_VERSION} \
RUN ./sbt clean dist 
RUN unzip -d ./builded ./target/universal/cmak-${CMAK_VERSION}.zip 
RUN mv -T ./builded/cmak-${CMAK_VERSION} /opt/cmak

FROM openjdk:11.0-jdk-slim

COPY --from=build /opt/cmak /opt/cmak
WORKDIR /opt/cmak

EXPOSE 9000
ENTRYPOINT ["./bin/cmak","-Dconfig.file=conf/application.conf"]
