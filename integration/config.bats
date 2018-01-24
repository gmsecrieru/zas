#!/usr/bin/env bats

@test "config: displays a message if app is not configured" {
  response="$(curl -s -H 'Host: notexistent.local' localhost:$ZAS_HTTP_PORT)"

  [ "$response" = "App not configured" ]
}
