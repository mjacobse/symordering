function p = minimum_degree(A)
% MINIMUM_DEGREE  Minimum degree permutation
%   p = MINIMUM_DEGREE(A) Returns the minimum degree permutation of matrix A.
%
%   Most basic implementation of minimum degree using the elimination graph
%   representation (see for example [1]). Does not consider mass elimination,
%   supervariables or similar techniques that reduce the amount of work to be
%   done.
%
%   [1] https://doi.org/10.1137/1031001

assert(size(A,1) == size(A,2), 'Matrix must be square!');
assert(issymmetric(A), 'Matrix must be symmetric!');
n = size(A,1);

% Represent the elimination graph G corresponding to matrix A as boolean
% adjacency matrix. Edges from a vertex to itself should not matter in comparing
% the degree of different vertices. To ensure that, make every vertex in G have
% an edge to itself by setting the diagonal of the adjacency matrix to true.
G = logical(A) | logical(speye(n));

p = zeros(1,n);
original_indices = 1:n;
for i = 1:n
    degrees = sum(G, 1);
    [~, node_to_eliminate] = min(degrees);

    is_neighbor = G(:,node_to_eliminate);
    G(is_neighbor, is_neighbor) = true;

    G(:,node_to_eliminate) = [];
    G(node_to_eliminate,:) = [];
    p(i) = original_indices(node_to_eliminate);
    original_indices(node_to_eliminate) = [];
end

end
