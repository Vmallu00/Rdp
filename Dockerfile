FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y --no-install-recommends \
    xrdp \
    xfce4 \
    xorg \
    dbus-x11 \
    sudo \
    curl \
    wget \
    nano \
    net-tools \
    policykit-1 \
    pulseaudio \
    pulseaudio-utils \
    wine \
    wine32 && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Root password
RUN echo "root:root" | chpasswd

# Allow root to start X
RUN echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

# XFCE session
RUN echo "startxfce4" > /root/.xsession && chmod 700 /root/.xsession

# D-Bus
RUN mkdir -p /var/run/dbus && dbus-uuidgen > /var/lib/dbus/machine-id

# XRDP optimizations
RUN sed -i 's/max_bpp=32/max_bpp=16/' /etc/xrdp/xrdp.ini && \
    sed -i 's/crypt_level=high/crypt_level=low/' /etc/xrdp/xrdp.ini && \
    sed -i 's/security_layer=negotiate/security_layer=rdp/' /etc/xrdp/xrdp.ini && \
    echo "startxfce4" > /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

RUN adduser xrdp ssl-cert

COPY pulse-client.conf /etc/pulse/client.conf
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 3389

CMD ["/start.sh"]
