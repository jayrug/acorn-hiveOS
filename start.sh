#!/bin/bash

while true
do
	# ./AcornMiner <Hostname> <Port> <Wallet address> <Worker name> <Password> <Clock [MHz] (optional)>
	./AcornMiner pool.bsod.pw 2153 DPsLbaMuyABRDvNrNfKbaDJQnr5um4e2fw workername password 125

	echo "Restarting the miner in 10 seconds..."
	sleep 10
done
