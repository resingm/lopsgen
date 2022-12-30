#!/bin/bash

LUA_PATH="?.lua;$LUA_PATH" lua ./lopsgen/init.lua \
  --base-path "https://www.maxresing.de" \
  --input "./content" \
  --output "./site" \
  --static "./static" \
  --template-base "./layout/base.html" \
  --template-header "./layout/header.html"
