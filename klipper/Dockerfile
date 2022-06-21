# =====================================
# Build
# =====================================
FROM python:3 as build

ARG REPO=https://github.com/Klipper3d/klipper
ARG BRANCH=master

WORKDIR /srv

# Install system dependencies
RUN apt update && \
    apt install -y \
        avr-libc \
        avrdude \
        binutils-arm-none-eabi \
        binutils-avr \
        build-essential \
        curl \
        dfu-util \
        gcc-avr \
        gcc-arm-none-eabi \
        libffi-dev \
        libncurses-dev \
        libnewlib-arm-none-eabi \
        libusb-dev \
        libusb-1.0-0 \
        pkg-config \
        stm32flash \
        sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Checkout project
RUN git clone -b ${BRANCH} ${REPO}

# Install Z-calibration plugin
RUN curl -fsSLo klipper/klippy/extras/z_calibration.py https://raw.githubusercontent.com/protoloft/klipper_z_calibration/master/z_calibration.py 

# Build klipper
RUN python -m venv venv && \
    venv/bin/pip install -r klipper/scripts/klippy-requirements.txt && \
    venv/bin/pip install numpy matplotlib && \
    venv/bin/python -m compileall klipper/klippy && \
    venv/bin/python klipper/klippy/chelper/__init__.py && \
    sed -i 's|python2|../venv/bin/python|g' klipper/Makefile

# Create a firmware folder to store images
RUN mkdir klipper/firmware

# Build Linux MCU
COPY mcu.config klipper/.config
RUN cd klipper && \
    make clean && \
    make && \
    mv out/klipper.elf firmware/linux_mcu && \
    make distclean

COPY skr-1.4.config klipper/.config
RUN cd klipper && \
    make clean && \
    make && \
    mv out/klipper.bin firmware/skr-1.4.bin && \
    make distclean

COPY octopus.config klipper/.config
RUN cd klipper && \
    make clean && \
    make && \
    mv out/klipper.bin firmware/octopus.bin && \
    make distclean

COPY skr-pico_uart.config klipper/.config
RUN cd klipper && \
    make clean && \
    make && \
    mv out/klipper.uf2 firmware/skr-pico_uart.uf2 && \
    make distclean

COPY skr-pico_usb.config klipper/.config
RUN cd klipper && \
    make clean && \
    make && \
    mv out/klipper.uf2 firmware/skr-pico_usb.uf2 && \
    make distclean

COPY v0-display.config klipper/.config
RUN cd klipper && \
    make clean && \
    make && \
    mv out/klipper.bin firmware/v0-display.bin && \
    make distclean

# =====================================
# Runtime
# =====================================
FROM python:3 as run

VOLUME /data

ENV KLIPPER_CFG=/data/klipper/printer.cfg
ENV KLIPPER_TTY=/data/klipper.tty
ENV KLIPPER_API=/data/klipper.sock

RUN useradd -m -G dialout,tty klipper

# Install system dependencies
RUN apt update && \
    apt install -y \
        avrdude \
        dfu-util \
        stm32flash \
        sudo && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /srv
COPY --chown=klipper:klipper --from=build /srv/klipper ./klipper
COPY --chown=klipper:klipper --from=build /srv/venv ./venv
COPY docker-entrypoint.sh /

USER klipper:dialout
CMD /docker-entrypoint.sh
