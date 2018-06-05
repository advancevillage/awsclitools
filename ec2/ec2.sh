#!/bin/bash

ec2root=$root/ec2

function GetAccountID(){
   id=`aws ec2 describe-security-groups  | jq -r ".SecurityGroups[0].OwnerId"`
   echo "$id"
}

function GetVPCID(){
   vpcid=`aws ec2 describe-security-groups | jq -r ".SecurityGroups[0].VpcId"`
   echo "$vpcid"
}


function GetSecurityGroupsLength(){
    len=`aws ec2 describe-security-groups | jq -r ".SecurityGroups | length"`
    echo "$len"
}

function GetSGIDByGroupName(){
    sgname=${1:-"default"}
    sgid=`aws ec2 describe-security-groups --group-names $sgname | jq -r ".SecurityGroups[0].GroupId"`
    echo "$sgid"
}

function GetSubnetsLength(){
   len=`aws ec2 describe-subnets --filters "Name=state,Values=available" | jq -r ".Subnets | length"`
   echo "$len"
}

function GetAvailabilityZone(){
   len=`GetSubnetsLength`
   azs=()
   json=$ec2root/tmp`date +%Y%m%d%H%M%S`.json
   aws ec2 describe-subnets --filters "Name=state,Values=available" > $json
   for i in `seq 0 $((len-1))`;do
     az=`cat $json | jq -r ".Subnets[$i].AvailabilityZone"`
     azs=("${azs[*]}" "$az")
   done
   rm -f $json
   echo "${azs[*]}"  
}

function GetSubnetsSubnetsId(){
   len=`GetSubnetsLength`
   snids=()
   json=$ec2root/tmp`date +%Y%m%d%H%M%S`.json
   aws ec2 describe-subnets --filters "Name=state,Values=available" > $json
   for i in `seq 0 $((len-1))`; do
      snid=`cat $json | jq -r ".Subnets[$i].SubnetId"` 
      snids=("${snids[*]}" "$snid")
   done
   rm -f $json
   echo "${snids[*]}"
}


















