#!/bin/bash 

grep 5 $1 | grep AM | awk -F" " '{print$1, $2, $5, $6}' >>Dealers_working_during_losses 


