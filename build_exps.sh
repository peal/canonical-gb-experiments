for i in grid prim grid_perm; do
	rm -rf ${i}-exps
	mkdir ${i}-exps
	(cd ${i}-exps; gap.sh < ../${i}_exp_gen.g)
done
