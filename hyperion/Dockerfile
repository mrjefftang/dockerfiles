FROM --platform=linux/arm/v8 ubuntu:focal

EXPOSE 8090/tcp
EXPOSE 19444/tcp
EXPOSE 19400/tcp
EXPOSE 19445/tcp
EXPOSE 19333/tcp

VOLUME /data

RUN apt-get update && apt -y install \
        curl \
        libexpat1 \
        libcec4 \
        libfreetype6 \
        libglib2.0-0 \
        libusb-1.0-0 && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSLO https://github.com/hyperion-project/hyperion.ng/releases/download/2.0.16/Hyperion-2.0.16-Linux-armv7l.deb && apt install ./Hyperion-2.0.16-Linux-armv7.deb && rm Hyperion-2.0.16-Linux-armv7.deb

WORKDIR /data

CMD hyperiond -v -u /data