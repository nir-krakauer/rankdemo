## Copyright (C) 2020 Nir Krakauer
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## For a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {[@var{M}] = } @
## transclose (@var{M})
## 
## given the upper triangular adjacency matrix of a directed graph,
## compute the adjacency matrix of its transitive closure
##
## implements the Roy-Warshall algorithm, which is simple to code but possibly not the most efficient
##
## @end deftypefn

## Author: Nir Krakauer <mail@nirkrakauer.net>

function M = transclose(M)

n = size (M, 1);

for j = 1:n
  for i = 1:(j-1)
      if M(i, j)
        M(i, (i+1):n) = M(i, (i+1):n) | M(j, (i+1):n);
      endif
  endfor
endfor
