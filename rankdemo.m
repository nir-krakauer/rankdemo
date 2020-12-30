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
## @deftypefn {Script File} @
## rankdemo
## 
## Demonstrates importance ranking a software collection based on the dependency graph.
##
## @end deftypefn

## Author: Nir Krakauer <mail@nirkrakauer.net>

data_dir = 'data_samples_12-24/'; #change this to the right path, if needed

pkg load jsonstuff #provides jsondecode

dataset = 'Python' #options: Python Rust TypeScript Swift Ruby PHP Objective-C Java HTML CSS C# CoffeeScript

filename = [data_dir dataset '_dependencies.json'];
file = [data_dir dataset "_projects.csv"];

fid = fopen (filename);
if fid < 0
  error (['file ' filename ' not found'])
endif
data = textscan (fid, '%s', "Delimiter", "", "EndOfLine", "");
fclose(fid);
stru = jsondecode (char(data));
fields = fieldnames (stru);
n = numel (fields)
fields_num = str2double (fields); #they are sorted

pkg load io
C = csv2cell (file, 1);
C_num = cell2mat (C(:, 2));

#construct dependency matrix
keep_sparse = true;
if keep_sparse
  D = sparse (n, n);
  D = logical (D);
else
  D = zeros (n, n, "logical");
endif
for i = 1:n
  [~, inds] = ismember (stru.(fields{i}), fields_num);
  D(inds(inds > 0), i) = true;
endfor
D0 = D;

#find strongly connected components, incidentally constructing a topological ordering
c = graph_comps (D);
nc = max (c)
c = (nc+1) - c; #flip the component order
[~, ic, jc] = unique (c);
n_per_c = accumarray (jc, 1);
D = graph_condense (D, c);
#add indirect dependecies
D = transclose (D);

#intrinsic values of projects -- assume same (unit) value for each project (can replace with another measure)
v = n_per_c;

#implement p = (speye(nc, nc)-D) \ v
#after the topological ordering, D should be upper triangular, allowing us to find p by back substitution:
p = v;
for i = (nc-1):-1:1
  p(i) = v(i) + sum(p(i + find(D(i, (i+1):nc))));
endfor

#names of top projects using the proposed ranking
[~, is] =  sort (p, "descend");
ntop = 10;
fields_num_top = fields_num(ic(is(1:ntop)));
inds = nan (ntop, 1);
for i = 1:ntop
  [~, ind] = ismember (fields_num_top(i), C_num);
  inds(i) = ind;
endfor
names_top = C(inds, 3)
scores_top = p(is(1:ntop))

#names of top projects by number of direct dependencies only
pd = sum (D0, 2);
[~, isd] =  sort (pd, "descend");
fields_numd_top = fields_num(isd(1:ntop));
indsd = nan (ntop, 1);
for i = 1:ntop
  [~, ind] = ismember (fields_numd_top(i), C_num);
  indsd(i) = ind;
endfor
namesd_top = C(indsd, 3)
scoresd_top = full(pd(isd(1:ntop)))


%{
#expected output for the sample data:
dataset = Python
n =  29603
nc =  29559
names_top =
{
  [1,1] = packaging
  [2,1] = setuptools
  [3,1] = zope.interface
  [4,1] = requests
  [5,1] = python-dateutil
  [6,1] = cryptography
  [7,1] = zope.proxy
  [8,1] = configparser
  [9,1] = more-itertools
  [10,1] = asgiref
}
scores_top =
   436454
   218142
    52387
    45568
    29176
    23622
    22208
    19695
    16977
    16233
namesd_top =
{
  [1,1] = requests
  [2,1] = setuptools
  [3,1] = Django
  [4,1] = python-dateutil
  [5,1] = Flask
  [6,1] = Jinja2
  [7,1] = pytest
  [8,1] = boto3
  [9,1] = pandas
  [10,1] = Pillow
}
   7445
   1337
   1301
   1154
    953
    944
    783
    773
    745
    688
%}
