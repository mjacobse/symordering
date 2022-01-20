function p = minimum_local_fill(A)
% MINIMUM_LOCAL_FILL  Minimum local fill permutation
%   p = MINIMUM_LOCAL_FILL(A) Returns the minimum local fill permutation of matrix A.
%
%   Most basic implementation of minimum local fill using the elimination graph
%   representation (see e.g. [1]). Does not use any tricks to reduce the amount
%   of work.
%
%   [1] https://doi.org/10.1137/S0895479896302692

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
    fillin = compute_fillin(G);
    [~, node_to_eliminate] = min(fillin);

    is_neighbor = G(:,node_to_eliminate);
    G(is_neighbor, is_neighbor) = true;

    G(:,node_to_eliminate) = [];
    G(node_to_eliminate,:) = [];
    p(i) = original_indices(node_to_eliminate);
    original_indices(node_to_eliminate) = [];
end

end


function fillin = compute_fillin(G)
% For each node, computes the amount of fillin that occurs when eliminating that
% node.

n = size(G,1);
fillin = zeros(1,n);
for node = 1:n
    neighbors = find(G(:,node));
    fillin(node) = length(neighbors)^2 - nnz(G(neighbors, neighbors));
end

end
