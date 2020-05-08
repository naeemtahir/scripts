#!/usr/bin/env python3
# Filename: ddwrt_traffic_report.py

"""Generates network traffic report from DD-WRT log. TOO SLOW FOR LARGER LOG FILES, HAS BEEN SUPERCEDED BY ddwrt_traffic_report.sh"""

import argparse
import datetime
import socket
import time

DATE='DATE'
TIME='TIME'
DIRECTION='DIRECTION'
SRC='SRC'
SPT='SPT'
DST='DST'
DPT='DPT'
PROTO='PROTO'
STATUS='STATUS'

__author__ = "Naeem Tahir"
__copyright__ = "Copyright 2016, Naeem Tahir"
__license__ = "GPL"
__version__ = "1.0"
__maintainer__ = "Naeem Tahir"
__email__ = "naeem.tahir@yahoo.com"
__status__ = "Production"

DIRECTION_MAP = {'IN=br0 OUT=vlan1':'OUT', 'IN=vlan1 OUT=':'IN', 'IN=br0 OUT=':'LCL'}
FIELD_DELIM = '='


def main():
    args = parse_args()

    log_file = args.input
    report = generate_output_file_name(args.output)
    resolve_host = args.resolve_hosts
    verbosity_on = args.verbose

    start_time = time.time()

    generate_report(log_file, report, resolve_host, verbosity_on)

    end_time = time.time()
    
    if verbosity_on:    
        print('Finished in %0.3fs.' % (end_time - start_time))
    

def generate_report(log_file, report, resolve_host, verbosity_on):
    if verbosity_on:
        print('Calculating lines.........', end="")
    
    line_total = get_line_total(log_file)
    
    if verbosity_on:
        print('processing.........', end="")
    
    with open(log_file, mode="r") as input_file:
        with open(report, mode='w') as output_file:
            output_file.write(format(DATE, TIME, DIRECTION, SRC, SPT, DST, DPT, PROTO, STATUS))

            line_no = 0
            for line in input_file:
                if verbosity_on and (line_no == 1 or line_no == line_total or line_no % 100 == 0):
                   print('%.2f%%.........' % ((line_no/line_total)*100), end="")
                
                line_no = line_no + 1
                
                if (line.find('IN=') >= 0):
                    data = extract_data(line, resolve_host)
                    if data != None:
                        output_file.write(format(data[DATE], data[TIME], data[DIRECTION], data[SRC], data[SPT], data[DST], data[DPT], data[PROTO], data[STATUS]))
                

def get_line_total(input_file):
    with open(input_file) as f:
        for i, l in enumerate(f):
            pass
    return i + 1

    
def generate_output_file_name(oldname):
    return '{}.{:%Y%m%d%H%M}'.format(oldname, datetime.datetime.now())


def parse_args():
    parser = argparse.ArgumentParser(description='Generates network traffic report from DD-WRT log.')
    parser.add_argument('input', help='DD-WRT log file.')
    parser.add_argument('output', help='Output file')
    parser.add_argument('-r', '--resolve-hosts', action="store_true", help='Resolve IP addresses to host names')
    parser.add_argument('-v', '--verbose', action="store_true", help='Verbosity on')    
    
    args = parser.parse_args()
    
    return args


def extract_data(line, resolve_host):
    
    data = line.split()
    field_mapping = get_field_mapping(data)
        
    date = '{} {}'.format(data[0], data[1])
    time = data[2]
    status = data[5]    
    direction = DIRECTION_MAP['{} {}'.format(data[6], data[7])]
    src = field_mapping[SRC]
    if resolve_host:
        src = get_host(src)
            
    sport = ''
    try:
        sport = field_mapping[SPT]
    except:
        pass

    dest = field_mapping[DST]
    if resolve_host:
        dest = get_host(dest)
        
    dport = ''
    try:
        dport = field_mapping[DPT]
    except:
        pass
    
    protocol = ''
    try:
        protocol = field_mapping[PROTO]
    except:
        pass    

    return {DATE:date, TIME:time, DIRECTION:direction, SRC:src, SPT:sport, DST:dest, DPT:dport, PROTO:protocol, STATUS:status}


def get_host(ip):
    try:
        host_info = socket.gethostbyaddr(ip)
        return host_info[0]
    except:
        return ip


def get_field_mapping(data):
    field_mapping = {}
    
    for element in data:
         e = element.split(FIELD_DELIM)
         if len(e) > 1:
             field_mapping[e[0]] = e[1]
             
    return field_mapping
    
    
def format(date, time, direction, src, spt, dst, dpt, proto, status):
    return '{},{},{},{},{},{},{},{},{}\n'.format(date, time, direction, src, spt, dst, dpt, proto, status)
    
    
if __name__ == '__main__':
    main()
