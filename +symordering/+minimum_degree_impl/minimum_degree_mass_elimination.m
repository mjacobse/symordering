function p = minimum_degree_mass_elimination(A)
% MINIMUM_DEGREE_MASS_ELIMINATION  Minimum degree permutation
%   p = MINIMUM_DEGREE_MASS_ELIMINATION(A) Returns the minimum degree permutation of matrix A.
%
%   Basic implementation of minimum degree using the elimination graph
%   representation. Uses "mass elimination" as described in Section 3.1 of [1]
%   to eliminate multiple nodes simultaneously if they have equivalent degrees.
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
i = 1;
while i <= n
    degrees = sum(G, 1);
    [min_degree, node_to_eliminate] = min(degrees);

    neighbors = find(G(:,node_to_eliminate));
    G(neighbors, neighbors) = true;
    % Now we can use Theorem 3.1 of [1] to identify nodes that we can mass
    % eliminate. Note that we have not yet eliminated the selected node, so we
    % do not subtract 1 from min_degree. Due to that, we also keep the already
    % selected node 'node_to_eliminate' in any case.
    new_neighbor_degrees = sum(G(:,neighbors), 1);
    nodes_to_eliminate = neighbors(new_neighbor_degrees == min_degree);

    G(:,nodes_to_eliminate) = [];
    G(nodes_to_eliminate,:) = [];
    p(i:i+length(nodes_to_eliminate)-1) = original_indices(nodes_to_eliminate);
    original_indices(nodes_to_eliminate) = [];

    i = i + length(nodes_to_eliminate);
end

end
