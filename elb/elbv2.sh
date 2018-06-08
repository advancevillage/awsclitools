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

function CreateTargetGroup(){
	name=${1:-"default`date +%Y%m%d%H%M%S`"}
	json=$elbroot/tmp`date +%Y%m%d%H%M%S`.json
	protocol="HTTP"
	port=80
	vpcid=`GetVPCID`
	aws elbv2 create-target-group \
		--name $name \
		--protocol $protocol \
		--port $port \
		--vpc-id $vpcid > $json
	arn=`cat $json | jq -r ".TargetGroups[0].TargetGroupArn"`
	rm -f $json
	echo "$arn"
}

function GetTargetGroupArnByName(){
	name=${1:-""}
	if [ -z "$name" ]; then
		echo "Name is empty!"
		exit 1
	fi
	json=$elbroot/tmp`date +%Y%m%d%H%M%S`.json
	aws elbv2  describe-target-groups --names $name > $json
	arn=`cat $json | jq -r ".TargetGroups[0].TargetGroupArn"`
	rm -f $json
	echo "$arn"
}

function DeleteTargetGroupByName(){
	name=${1:-""}
	if [ -z "$name" ]; then
		echo "Name is empty!"
		exit 1
	fi
	arn=`GetTargetGroupArnByName $name`
	aws elbv2 delete-target-group --target-group-arn $arn
	echo "true"
}


function CreateListener(){
	name=${1:-""}
	if [ -z "$name" ]; then
		echo "Name is empty!"
		exit 1
	fi
	arn=`GetLoadBalanceArnByName $name`
	protocol=${2:-"http"}
	port=80
	[ "$protocol" == "https" ] && port=443
	if [ "$protocol" == "http" ]; then
		echo "http"
	elif [ "$protocol" == "https" ]; then
		echo "https"
	fi
}