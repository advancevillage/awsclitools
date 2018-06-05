#!/bin/bash

elbroot=$root/elb

function CreateLoadBalance(){
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
		--ip-address-type $ipAddressType
}
