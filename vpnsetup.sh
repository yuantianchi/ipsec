#!/bin/bash

PSK=$1
LeftId=$2
RightId=$3
LeftSubnet=$4
RightSubnet=$5



yum -y install openswan

echo "$LeftId  0.0.0.0 : PSK \"$PSK\"
" > /etc/ipsec.d/test.secrets

echo "conn test
  authby=secret
  auto=start
  leftId=$LeftId
  left=%defaultroute
  leftsubnet=$LeftSubnet
  leftnexthop=%defaultroute
  right=$RightId
  rightsubnet=$RightSubnet
  keyingtries=%forever
  ike=aes128-sha1;modp1024
  ikelifetime=86400s
  phase2alg=aes128-sha1
  salifetime=3600s
  pfs=no
" > /etc/ipsec.d/test.conf







echo "1" > /proc/sys/net/ipv4/ip_forward
echo "0" > /proc/sys/net/ipv4/conf/all/accept_redirects
echo "0" > /proc/sys/net/ipv4/conf/all/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/eth0/send_redirects
echo "0" > /proc/sys/net/ipv4/conf/default/accept_redirects
echo "0" > /proc/sys/net/ipv4/conf/eth0/accept_redirects
echo "0" >/proc/sys/net/ipv4/conf/eth0/rp_filter
echo "0" >/proc/sys/net/ipv4/conf/ip_vti0/rp_filter





service ipsec start
#ipsec verify


iptables -t mangle -A FORWARD -o eth0 -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1387
