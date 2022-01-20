function p = minimum_degree(A)
% MINIMUM_DEGREE  Minimum degree permutation
%   p = MINIMUM_DEGREE(A) Returns the minimum degree permutation of matrix A.
%
%   Wrapper that calls not the most basic, but a better performing
%   implementation of minimum degree. See subdirectory +minimum_degree for
%   actual implementations.

p = symordering.minimum_degree_impl.minimum_degree_mass_elimination(A);

end
