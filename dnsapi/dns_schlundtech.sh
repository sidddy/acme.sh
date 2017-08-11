#!/bin/bash

#Here is a sample custom api script.
#This file name is "dns_myapi.sh"
#So, here must be a method   dns_myapi_add()
#Which will be called by acme.sh to add the txt record to your api system.
#returns 0 means success, otherwise error.
#
#Author: Neilpang
#Report Bugs here: https://github.com/Neilpang/acme.sh
#
########  Public functions #####################

#Usage: dns_myapi_add   _acme-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
dns_myapi_add() {
  fulldomain=$1
  txtvalue=$2
  _info "Using myapi"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
  _err "Not implemented!"
  return 1
}

#Usage: fulldomain txtvalue
#Remove the txt record after validation.
dns_myapi_rm() {
  fulldomain=$1
  txtvalue=$2
  _info "Using myapi"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
}

####################  Private functions below ##################################

read -r -d '' xmladd <<EOFXML
<?xml version="1.0" encoding="utf-8"?>
<request>
  <auth>
    <user>0000000</user>
    <password>xxxxxxxxxxxxxxxxxxxx</password>
    <context>10</context>
  </auth>
  <task>
    <code>0202001</code>
    <default>
      <rr_add>
        <name>{subdomain}</name>
        <type>TXT</type>
        <value>{value}</value>
        <ttl>60</ttl>
      </rr_add>
    </default>
    <zone>
      <name>{domain}</name>
    </zone>
  </task>
</request>
EOFXML



read -r -d '' xmlrm <<EOFXML
<?xml version="1.0" encoding="utf-8"?>
<request>
  <auth>
    <user>0000000</user>
    <password>xxxxxxxxxxxxxxxxxxxx</password>
    <context>10</context>
  </auth>
  <task>
    <code>0202001</code>
    <default>
      <rr_rem>
        <name>{subdomain}</name>
        <type>TXT</type>
        <value>{value}</value>
      </rr_rem>
    </default>
    <zone>
      <name>{domain}</name>
    </zone>
  </task>
</request>
EOFXML

echo "----------------"
echo "$xmladd" | sed 's/{domain}/example.com/;s/{subdomain}/acmedom/;s/{value}/wurst/' 
echo "----------------"
echo "$xmlrm" | sed 's/{domain}/example.com/;s/{subdomain}/acmedom/;s/{value}/wurst/' 
echo "----------------"
