#!/bin/bash

########
# This is a custom DNS adapter for the german Schlundtech domain provider.
# Use as DNS api with the acme.sh LetsEncrypt script.
# See https://github.com/Neilpang/acme.sh for more information.
#
# Usage: acme.sh --issue --dns dns_schlundtech -d www.domain.com
#
# Author: Holger Böhnke
# Report Bugs here: https://github.com/hmb/acme.sh
#
########

########  Public functions #####################

# Usage: dns_myapi_add   _acme-challenge.www.domain.com   "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"
dns_schlundtech_add() {
  local fulldomain=$1
  local txtvalue=$2
  
  _info "using schlundtech dns api"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
  _err "Not implemented!"
  return 1
}

# Usage: fulldomain txtvalue
# Remove the txt record after validation.
dns_schlundtech_rm() {
  local fulldomain=$1
  local txtvalue=$2
  
  _info "using schlundtech dns api"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
}

####################  Private functions below ##################################

_split_domain() {
  local fulldomain=$1
  
  domain="$(echo $fulldomain | sed 's/.*\.\([^.]*\.[^.]*\)/\1/')" 
  subdomain="$(echo $fulldomain | sed 's/\(.*\)\.[^.]*\.[^.]*/\1/')"
}


_init_requests() {
  local domain=$1
  local subdomain=$2
  local value=$3
  local sedcmd="s/{domain}/${domain}/;s/{subdomain}/${subdomain}/;s/{value}/${value}/;"

	xmladd='<?xml version="1.0" encoding="utf-8"?>
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
	</request>'

	xmlrm='<?xml version="1.0" encoding="utf-8"?>
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
	</request>'

	xmladd="$(echo "$xmladd" | sed "$sedcmd")"
	xmlrm="$(echo "$xmlrm"  | sed "$sedcmd")" 
}
