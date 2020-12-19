#!/bin/bash

find -type f -name $1 | less $1 | grep $2 | grep $3 | awk -F" " '{print$1, $2, $5, $6}'




