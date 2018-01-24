#!/usr/bin/env bats

@test "dns: resolves app.local domain to 127.0.0.1" {
  response="$(dig app.local @127.0.0.1 -p $ZAS_DNS_PORT +short +retry=0)"

  [ "$response" = "127.0.0.1" ]
}

@test "dns: resolves anything_asdfasdf.local to 127.0.0.1" {
  response="$(dig anything_asdfasdf.local @127.0.0.1 -p $ZAS_DNS_PORT +nocomment +retry=0)"

  domain="$(echo "$response" | grep -v "^;" | grep "\.local" | cut -d "	" -f 1)"
  domain="${domain%.}"
  ip="$(echo "$response" | grep -v "^;" | grep "\.local" | cut -d "	" -f 5)"

  [ "$domain" = "anything_asdfasdf.local" ]
  [ "$ip" = "127.0.0.1" ]
}

@test "dns: accepts more than one request" {
  dig app.local @127.0.0.1 -p $ZAS_DNS_PORT +nocomment +retry=0
  dig app.local @127.0.0.1 -p $ZAS_DNS_PORT +nocomment +retry=0
  dig app.local @127.0.0.1 -p $ZAS_DNS_PORT +nocomment +retry=0
  dig app.local @127.0.0.1 -p $ZAS_DNS_PORT +nocomment +retry=0
}

@test "dns: does not know any other domains" {
  response="$(dig google.com @127.0.0.1 -p $ZAS_DNS_PORT +short +retry=0)"

  [ "$response" = "" ]
}
