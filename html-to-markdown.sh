#!/bin/bash

pandoc -f html -t markdown-raw_html-native_divs-native_spans-fenced_divs-bracketed_spans-smart \
  | sed 's/\\//g'

