#!/usr/bin/env bash

set -e

echo "jq --------------------"
sudo yum install -y jq
echo "lsof ------------------"
sudo yum install -y lsof
echo "telnet ------------------"
sudo yum install -y telnet
