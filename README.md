# GraphStorage

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://SebastianM-C.github.io/GraphStorage.jl/stable)
[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://SebastianM-C.github.io/GraphStorage.jl/latest)
[![Build Status](https://travis-ci.com/SebastianM-C/GraphStorage.jl.svg?branch=master)](https://travis-ci.com/SebastianM-C/GraphStorage.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/SebastianM-C/GraphStorage.jl?svg=true)](https://ci.appveyor.com/project/SebastianM-C/GraphStorage-jl)
[![Codecov](https://codecov.io/gh/SebastianM-C/GraphStorage.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/SebastianM-C/GraphStorage.jl)

This is an _experimental_ package for storing hierarchical data in graphs.
The data is stored within the properties of the vertices of a directed graph
(a `MetaDiGraph` from [MetaGraphs.jl](https://github.com/JuliaGraphs/MetaGraphs.jl))
and data points are identified by a path through the graph. A path is a collection
of edges with the same label (a dictionary with a key `id` corresponding to the
index of the path).

If one would think of an analogy with a table, the rows of the table correspond
to a path through the graph.
