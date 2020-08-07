#!/bin/bash

SINK=$(pacmd list-sinks | sed -n '/^\s*\* index:/,/device.description/p' | sed -n 's/\s*device.description = "\(.*\)"$/\1/p')
SOURCE=$(pacmd list-sources | sed -n '/^\s*\* index:/,/device.description/p' | sed -n 's/\s*device.description = "\(.*\)"$/\1/p')

echo " ${SOURCE} |   ${SINK}"
