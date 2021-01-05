#!/bin/bash
status_code=$(curl --write-out %{http_code} --silent --output /dev/null https://www.jonathanclarke.ie)

if [[ "$status_code" -ne 200 ]] ; then
  echo $status_code
  exit 1
else
  echo $status_code    
  exit 0
fi
