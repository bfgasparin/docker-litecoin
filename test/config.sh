#!/bin/bash
set -e

testAlias+=(
	[litecoind:trusty]='litecoind'
)

imageTests+=(
	[litecoind]='
		rpcpassword
	'
)
