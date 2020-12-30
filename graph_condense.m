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
## @deftypefn {Function File} {[@var{Mc}] = } @
## graph_condense (@var{M}, @var{c})
## 
## return condensed adjacency matrix with one row for each strongly connected component (from graph_comps)
##
## @end deftypefn

## Author: Nir Krakauer <mail@nirkrakauer.net>


function Mc = graph_condense(M, c)
  
  Mc = accumdim(c, accumdim(c, M, 1, [], @max), 2, [], @max);
  
  %{
  #equivalently
  for i = 1:nc
    for j = 1:nc
      Mc(i, j) = any ((M(c == i, c == j))(:)); 
    endfor
  endfor
  %}  
  
  if issparse (M)
    Mc = sparse (Mc);
  endif
  
endfunction


#Nuutila 1995 Figure 3.2 example   
%!test
%! A = [0 1 0 0 0 1 0 1 0 0; 1 0 1 0 0 0 0 0 0 0; 0 1 0 1 0 0 0 0 0 0; 0 0 0 0 1 0 0 0 0 0; 0 0 0 1 0 0 0 0 0 0; 0 0 0 0 0 0 1 0 0 0; 0 0 0 1 0 1 0 0 0 0; 0 0 0 0 0 0 0 0 1 0; 0 0 1 0 1 0 0 1 0 1; 0 0 0 0 0 0 0 0 0 0];
%! Ac = graph_condense (A, graph_comps(A)); 
%! assert (Ac, [1   0   0   0;   1   1   0   0;   0   0   0   0;   1   1   1   1]);
