These directory contains the experiments for the paper "Canonical Images in Graph Backtracking" by Christopher Jefferson, Rebecca Waldecker and Wilf A. Wilson.

Running these experiments requires:

* A unix operating system (Linux or MacOS)
* A recent copy of GAP (the experiments were run in GAP 4.12.2)
* The following extra GAP packages:

- vole, GraphBacktracking, BacktrackKit. These packages are not yet packaged with GAP, and can be found at peal.github.io

To ensure GAP does not cache any results, and to allow us to stop experiments if they run out of time or memory, each experiment is run in a seperate copy of GAP


To run the experiments:

1) Run './build_exps.sh'. This will make a number of new directories full of GAP programs, each of which runs one experiment.
2) Go into each of those directories and run the following command:
    for i in *.g; do ../run_exp.sh $i; done
3) Go back to the start directory and run './build_exps.sh'
4) Run 'gap make_results.g', which will print out the results tables

5) To generate the graph-based experiments, go into 'sts' and run 'gap exp.g'. The graphs used here were originally distributed with Bliss (https://pallini.di.uniroma1.it/Graphs.html).
