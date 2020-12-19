#!/bin/bash 

grep 02 $1 | grep PM | awk -F" " '{print$1, $2, $5, $6}' >>Dealers_working_during_losses

 
