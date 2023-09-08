#!/bin/bash

for i in *-exps; do
  (
	cd ${i};
	for j in *.g.out; do
		cat $j
		echo
	done
  ) > ${i}-all-output
done

wait


