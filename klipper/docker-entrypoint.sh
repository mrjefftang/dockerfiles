#!/bin/sh
/srv/klipper/linux_mcu &
/srv/venv/bin/python klipper/klippy/klippy.py -I ${KLIPPER_TTY} -a ${KLIPPER_API} -l ${KLIPPER_LOG} ${KLIPPER_CFG}
