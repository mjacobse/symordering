function p = minimum_local_fill(A)
% MINIMUM_LOCAL_FILL  Minimum local fill permutation
%   p = MINIMUM_LOCAL_FILL(A) Returns the minimum local fill permutation of matrix A.
%
%   Wrapper that calls not the most basic, but a better performing
%   implementation of minimum local fill. See subdirectory +minimum_local_fill
%   for actual implementations.

p = symordering.minimum_local_fill_impl.minimum_local_fill_fewer_updates(A);

end
