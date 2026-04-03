FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    init \
    systemd \
    curl \
    ca-certificates \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://uisp.ui.com/install > /tmp/uisp_inst.sh && \
    sed -i 's/read -p.*/echo Y/' /tmp/uisp_inst.sh && \
    bash /tmp/uisp_inst.sh || true

EXPOSE 80 443 8080 8443

VOLUME ["/data", "/etc/uisp"]

ENTRYPOINT ["/sbin/init"]
