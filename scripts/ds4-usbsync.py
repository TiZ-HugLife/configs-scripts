#!/usr/bin/env python2
# This tool is supposed to override the PS4 BDADDR inside a DualShock 4
# By Frank Zhao, see http://eleccelerator.com/wiki/index.php?title=DualShock_4
# You may need to install a filter driver before libusb can access the device, use "install-filter-win.exe" from libusb-win32
 
import sys, time, getopt, select
import usb.core, usb.util
from netaddr import *
 
def main(argv):
    verbose = False
    mac = False
    needRead = False
 
    try:
       opts, args = getopt.getopt(argv,"hvra:",[])
    except getopt.GetoptError:
        print 'Error: GetoptError'
        printHelp()
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            printHelp()
            sys.exit()
        elif opt in ("-a"):
            mac = EUI(arg)
        elif opt in ("-r"):
            needRead = True
        elif opt in ("-v"):
            verbose = True
 
    if mac != None and mac != False and mac != 0:
        if verbose:
            print 'Setting MAC to: ', str(mac), ' , words[', len(mac.words) ,']: ', mac.words
 
    if verbose:
        print 'Searching for USB device with VID 0x054C and PID 0x05C4'
 
    dev = usb.core.find(idVendor = 0x054C, idProduct = 0x05C4)
    if dev == None or dev == False or dev == 0:
        print 'Unable to find DualShock 4'
        print 'You may need to install a filter driver before libusb can access the device, use "install-filter-win.exe" from libusb-win32'
        quit()
 
    if verbose:
        print 'Found DualShock 4 in USB port'
    
    if dev.is_kernel_driver_active(0) is True:
        if verbose:
            print 'Detaching kernel driver'
        dev.detach_kernel_driver(0)
 
    dev.set_configuration()
    if verbose:
        print 'USB device set configuration'
 
    if needRead:
        if verbose:
            print 'Attempting read with USB control transfer GET REPORT on 0x12'
        msg = dev.ctrl_transfer(0xA1, 0x01, 0x0312, 0x0000, 0x0010);
        if verbose:
            print 'Read back raw data from report 0x12: [ ', printHexArray(msg), ']'
        print 'Read DualShock4 UID: ', EUI(format(msg[6], 'X') + '-' + format(msg[5], 'X') + '-' + format(msg[4], 'X') + '-' + format(msg[3], 'X') + '-' + format(msg[2], 'X') + '-' + format(msg[1], 'X'))
        print 'Read PlayStation4 MAC: ', EUI(format(msg[15], 'X') + '-' + format(msg[14], 'X') + '-' + format(msg[13], 'X') + '-' + format(msg[12], 'X') + '-' + format(msg[11], 'X') + '-' + format(msg[10], 'X'))
 
    if mac != None and mac != False and mac != 0:
        if verbose:
            print 'USB sending control transfer SET REPORT on 0x13'
        msg = [0x13, mac.words[5], mac.words[4], mac.words[3], mac.words[2], mac.words[1], mac.words[0], 0x56, 0xE8, 0x81, 0x38, 0x08, 0x06, 0x51, 0x41, 0xC0, 0x7F, 0x12, 0xAA, 0xD9, 0x66, 0x3C, 0xCE];
        ret = dev.ctrl_transfer(0x21, 0x09, 0x0313, 0x0000, msg);
        print 'Written raw data to report 0x13, return code was: ', ret
        if needRead:
            if verbose:
                print 'Attempting read with USB control transfer GET REPORT on 0x12'
            msg = dev.ctrl_transfer(0xA1, 0x01, 0x0312, 0x0000, 0x0010);
            if verbose:
                print 'Read back raw data from report 0x12: [ ', printHexArray(msg), ']'
            print 'Read DualShock4 UID: ', EUI(format(msg[6], 'X') + '-' + format(msg[5], 'X') + '-' + format(msg[4], 'X') + '-' + format(msg[3], 'X') + '-' + format(msg[2], 'X') + '-' + format(msg[1], 'X'))
            print 'Read PlayStation4 MAC: ', EUI(format(msg[15], 'X') + '-' + format(msg[14], 'X') + '-' + format(msg[13], 'X') + '-' + format(msg[12], 'X') + '-' + format(msg[11], 'X') + '-' + format(msg[10], 'X'))
 
    if verbose:
        print 'That\'s all this tool will do, goodbye'
        quit()
 
def printHexArray(arr):
    str = ''
    for i in arr:
        str += '0x' + format(i, 'X') + ', '
    return str
 
def printHelp():
    print 'This tool is supposed to override the PS4 BDADDR inside a DualShock 4'
    print ''
    print 'command line options:'
    print '-h'
    print '    will print the help'
    print ''
    print '-a <PS4\'s BDADDR>'
    print '    will set BDADDR, common formats accepted but no spaces allowed'
    print ''
    print '-r'
    print '    will do a control transfer read on report 0x12'
    print ''
    print '-v'
    print '    will enable verbose output'
    print ''
    print 'By Frank Zhao, see http://eleccelerator.com/wiki/index.php?title=DualShock_4'
 
if __name__ == "__main__":
    main(sys.argv[1:])
