#!/bin/bash
SRC=${1:-192.168.1.33}
tftp -g -r edxcel $SRC

