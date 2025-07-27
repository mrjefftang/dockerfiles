FROM debian:bookworm-slim

EXPOSE 8090/tcp
EXPOSE 19444/tcp
EXPOSE 19400/tcp
EXPOSE 19445/tcp
EXPOSE 19333/tcp

VOLUME /data

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gpg \
    ca-certificates \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://releases.hyperion-project.org/hyperion.pub.key | gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://apt.releases.hyperion-project.org/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/hyperion.list
RUN apt-get update && apt-get install -y hyperion && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/hyperiond"]
CMD ["-u", "/data"]