# symordering

MATLAB and GNU Octave implementations of greedy ordering algorithms for sparse matrices.

Goals are:

* Simplicity, to illustrate the basic ideas of these algorithms
* Comparability of different implementations and algorithms

Performance and efficiency on the other hand are not the main focus.
For somewhat small matrices, these functions should still be quite usable.

## Usage

Add this folder to the path, then for example:

```matlab
A = gallery('wathen', 3, 3);
p = symordering.minimum_degree(A);
```
