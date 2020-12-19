#!/bin/bash 

grep 11 $1 | grep PM | awk -F" " '{print$1, $2, $5, $6}' >>Dealers_working_during_losses 

