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
## @deftypefn {Function File} {[@var{c}] = } @
## graph_comps (@var{M})
##
## Given the adjacency matrix @var{M} of a directed graph, return the strongly connected components.
##
## Implements Tarjan's algorithm.
##
## The output vector @var{c} assigns each vertex of the graph to a component numbered from 1 to @var{c_n}. The component numbering follows an inverse topological sorting of the condensed graph.
##
## References: @*
## Esko Nuutila (1995), Efficient Transitive Closure Computation in Large Digraphs, Finnish Academy of Technology (Helsinki) Mathematics and Computing in Engineering Series No. 74, http://www.cs.hut.fi/~enu/thesis.html @*
## Robert Tarjan (1972), Depth-First Search and Linear Graph Algorithms, SIAM Journal on Computing 1972 1(2):146-160, doi: 10.1137/0201010 @* 
## Wikipedia, https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm#The_algorithm_in_pseudocode
##
## @end deftypefn

## Author: Nir Krakauer <mail@nirkrakauer.net>


function c = graph_comps(A)

  global M cnt c_n c index lowlink stack stack_pos onstack

  M = A; clear A
  n = size (M, 1);
  s = index = lowlink = c = zeros (n, 1);
  onstack = zeros (n, 1, "logical");
  
  cnt = stack_pos = c_n = 0;
  
  for v = 1:n
    if !index(v)
      visit (v);
     endif
  endfor
    
endfunction

function visit(v)

  global M cnt c_n c index lowlink stack stack_pos onstack
  
  cnt++;
  index(v) = lowlink(v) = cnt;
  
  stack_pos++; stack(stack_pos) = v; #push v onto stack
  onstack(v) = true;

  for w = find(M(v, :))
    if !index(w)
      visit (w)
      if lowlink(v) > lowlink(w)      
        lowlink(v) = lowlink(w);
       endif
     elseif onstack(w)
        if lowlink(v) > index(w)      
          lowlink(v) = index(w);
         endif  
     endif       
    endfor

  if lowlink(v) == index(v)
    c_n++;
    while 1
      w = stack(stack_pos); stack(stack_pos) = 0; stack_pos--; #pop w from stack
      onstack(w) = false;
      c(w) = c_n;
      if w == v
        break
      endif
    endwhile
  endif
endfunction

#Nuutila 1995 Figure 3.2 example   
%!test
%! A = [0 1 0 0 0 1 0 1 0 0; 1 0 1 0 0 0 0 0 0 0; 0 1 0 1 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0 0 0; 0 0 0 0 0 0 1 0 0 0; 0 0 0 1 0 1 0 0 0 0; 0 0 0 0 0 0 0 0 1 0; 0 0 1 0 1 0 0 1 0 1; 0 0 0 0 0 0 0 0 0 0];
%! c = graph_comps(A); 
%! assert (c, [4 4 4 1 1 2 2 4 4 3]');
