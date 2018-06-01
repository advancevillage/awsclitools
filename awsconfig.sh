#!/bin/bash

export root=`dirname $0`

source $(dirname $0)/ec2/ec2.sh

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
