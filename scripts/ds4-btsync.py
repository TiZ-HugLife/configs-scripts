#!/usr/bin/env python3
# Based on code from ds4drv.

import socket
import subprocess

L2CAP_PSM_HIDP_CTRL = 0x11
L2CAP_PSM_HIDP_INTR = 0x13

HIDP_TRANS_SET_REPORT = 0x50
HIDP_DATA_RTYPE_OUTPUT  = 0x02

def setup():
    try:
        subprocess.check_output(["hcitool", "clock"],
                                stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError:
        raise Exception("'hcitool clock' returned error. Make sure "
                        "your bluetooth device is powered up with "
                        "'hciconfig hciX up'.")
    except OSError:
        raise Exception("'hcitool' could not be found, make sure you "
                        "have bluez-utils installed.")

def scan():
    try:
        res = subprocess.check_output(["hcitool", "scan", "--flush"],
                                      stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError:
         raise Exception("'hcitool scan' returned error. Make sure "
                         "your bluetooth device is powered up with "
                         "'hciconfig hciX up'.")

    devices = []
    res = res.splitlines()[1:]
    for _, bdaddr, name in map(lambda l: l.split(b"\t"), res):
        devices.append((bdaddr.decode("utf8"), name.decode("utf8")))

    return devices

def connect(addr):
    ctl_socket = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_SEQPACKET,
                               socket.BTPROTO_L2CAP)
    int_socket = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_SEQPACKET,
                               socket.BTPROTO_L2CAP)

    try:
        ctl_socket.connect((addr, L2CAP_PSM_HIDP_CTRL))
        int_socket.connect((addr, L2CAP_PSM_HIDP_INTR))
        int_socket.setblocking(False)
    except socket.error as err:
        raise Exception("Failed to connect: {0}".format(err))

if __name__ == "__main__":
    setup()
    for bdaddr, name in scan():
        if name == "Wireless Controller":
            print("Found device {}".format(bdaddr))
            connect(bdaddr)
