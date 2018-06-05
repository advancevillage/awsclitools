#!/bin/bash

elbroot=$root/elb

function CreateLoadBalance(){
	json=$elbroot/tmp`date +%Y%m%d%H%M%S`.json
	loadBalanceName=${1:-"default`date +%Y%m%d%H%M%S`"}
	subnets=(`GetSubnetsSubnetsId`)
	sgs=(`GetSGIDByGroupName`)
	scheme="internal"
	ipAddressType="ipv4"
	type="application"
	aws elbv2 create-load-balancer --name $loadBalanceName \
		--type $type \
		--subnets ${subnets[*]} \
		--security-groups ${sgs[*]} \
		--scheme $scheme \
		--ip-address-type $ipAddressType > $json
	code=`cat $json | jq -r ".LoadBalancers[0].State.Code"`
	rm -f $json
	echo "$code"
}

function GetLoadBalanceArnByName(){
	name=${1:-""}
	if [ -z "$name" ]; then
		echo "Name is empty!"
		exit 1
	fi
	arn=`aws elbv2 describe-load-balancers --names $name | jq -r ".LoadBalancers[0].LoadBalancerArn"`
	echo "$arn"
}

function GetLoadBalanceCount(){
	count=`aws elbv2  describe-load-balancers | jq -r ".LoadBalancers | length"`
	echo "$count"
}


function DeleteLoadBalanceByName(){
	name=${1:-""}
	if [ -z "$name" ]; then
		echo "Name is empty!"
		exit 1
	fi
	arn=`GetLoadBalanceArnByName $name`
	aws elbv2  delete-load-balancer --load-balancer-arn $arn
	echo "true"
}