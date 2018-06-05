#!/bin/bash

export root=`dirname $0`

source $root/ec2/ec2.sh
source $root/elb/elbv2.sh

opt=${1:-""}


GetSecurityGroupsLength

GetSGIDByGroupName $opt

GetVPCID

GetAccountID

GetSubnetsLength

azs=(`GetAvailabilityZone`)

echo ${azs[*]}

subnetids=(`GetSubnetsSubnetsId`)

echo ${subnetids[*]}

#CreateLoadBalance

GetLoadBalanceCount

DeleteLoadBalanceByName