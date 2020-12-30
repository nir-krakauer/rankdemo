# rankdemo
Project importance rankings based on the transitive dependency graph.

This repository contains the following Octave program files:

 - rankdemo.m  Driver that applies method to example data.
 - graph_comps.m  Find strongly connected components in a directed graph using Tarjan's algorithm.
 - graph_condense.m  Replace strongly connected components with a single equivalent, making the graph acyclic.
 - transclose.m  Find transitive closure of a directed acyclic graph, currently using the Roy-Warshall algorithm.


As well as:

 - data_samples_12-24.zip  Dependency data for different software project subsets of libraries.io (courtesy of Nathaniel Brown). Unzip to use in rankdemo.
 - ranking.tex  A brief overview of the proposed ranking method.
 - ranking.pdf  PDF version of same.
