#!/bin/bash

########
# This is a custom DNS adapter for the german Schlundtech domain provider.
# Use as DNS api with the acme.sh LetsEncrypt script.
# See https://github.com/Neilpang/acme.sh for more information.
#
# Usage: acme.sh --issue --dns dns_schlundtech -d www.domain.com
#
# Author: Holger Böhnke
# Report bugs here: https://github.com/hmb/acme.sh
#
########

########  Public functions #####################

# Add the txt record before validation.
# Usage: dns_schlundtech_add _acme-challenge.www.domain.com "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"

dns_schlundtech_add() {
  local fulldomain=$1
  local txtvalue=$2

  _info "using the schlundtech dns api"
  _debug fulldomain "$fulldomain"
  _debug txtvalue "$txtvalue"
  _err "Not implemented!"
  return 1
}


# Remove the txt record after validation.
# Usage: dns_schlundtech_rm _acme-challenge.www.domain.com "XKrxpRBosdIKFzxW_CT3KLZNf6q0HG9i01zxXp5CPBs"

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


_init_request_add() {
  local user="$1"
  local password="$2"
  local context="$3"
  local domain="$4"
  local subdomain="$5"
  local value="$6"

  local sedcmd="s/{user}/${user}/;s/{password}/${password}/;s/{context}/${context}/;s/{domain}/${domain}/;s/{subdomain}/${subdomain}/;s/{value}/${value}/;"

  xmladd='<?xml version="1.0" encoding="utf-8"?>
  <request>
    <auth>
      <user>{user}</user>
      <password>{password}</password>
      <context>{context}</context>
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

  xmladd="$(echo "$xmladd" | sed "$sedcmd")"
}


_init_request_rm() {
  local user="$1"
  local password="$2"
  local context="$3"
  local domain="$4"
  local subdomain="$5"
  local value="$6"

  local sedcmd="s/{user}/${user}/;s/{password}/${password}/;s/{context}/${context}/;s/{domain}/${domain}/;s/{subdomain}/${subdomain}/;s/{value}/${value}/;"

  xmlrm='<?xml version="1.0" encoding="utf-8"?>
  <request>
    <auth>
      <user>{user}</user>
      <password>{password}</password>
      <context>{context}</context>
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

  xmlrm="$(echo "$xmlrm"  | sed "$sedcmd")" 
}


_send_request() {
  local request="$1"
  local url="$2"

  response="$(curl -s -H "Content-type: text/xml" --data-binary "${request}" "${url}")"
  _debug "response: $response"
}
