#!/bin/bash
ulimit -t 1800
gap.sh -o 4G $1 &> $1.logout
