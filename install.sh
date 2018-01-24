#!/bin/bash
cargo build --release
if [[ $? -ne 0 ]]; then
  exit 1
fi

mv target/release/zas /usr/local/bin/zas
if [[ $? -ne 0 ]]; then
  exit 1
fi

rm -rf target

zas install
if [[ $? -ne 0 ]]; then
  exit 1
fi
