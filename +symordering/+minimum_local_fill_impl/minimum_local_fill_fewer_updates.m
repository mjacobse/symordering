function p = minimum_local_fill_fewer_updates(A)
% MINIMUM_LOCAL_FILL  Minimum local fill permutation
%   p = MINIMUM_LOCAL_FILL(A) Returns the minimum local fill permutation of matrix A.
%
%   Basic implementation of minimum local fill using the elimination graph
%   representation (see e.g. [1]). Uses a few simple observations to reduce the
%   number of nodes for which the next fillin has to be computed in each step.
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

% we use a value of 'inf' to say that the fillin caused by eliminating a node
% has to be (re)computed. Initially, all fillin values have to be computed.
fillin = inf*ones(1,n);

p = zeros(1,n);
original_indices = 1:n;
for i = 1:n
    fillin = compute_fillin(G, fillin);
    [min_fillin, node_to_eliminate] = min(fillin);

    is_neighbor = G(:,node_to_eliminate);
    G(is_neighbor, is_neighbor) = true;

    if min_fillin == 0
        % if the elimination of this node does not cause any fillin, then only
        % the fillin of the neighbors of this node may decrease. So if the
        % fillin of a neighbor already was 0, then it cannot decrease further.
        fillin(is_neighbor' & fillin ~= 0) = inf;
    else
        % due to the fillin of the node to be eliminated, both neighbors of this
        % node and neighbors of neighbors of this node may have their fillin
        % changed. It is enough to mark all neighbors of neighbors as needing
        % an update, because that already includes the normal neighbors.
        for neighbor = find(is_neighbor)'
            neighbors_of_neighbor = G(:,neighbor);
            fillin(neighbors_of_neighbor) = inf;
        end
    end

    G(:,node_to_eliminate) = [];
    G(node_to_eliminate,:) = [];
    fillin(node_to_eliminate) = [];
    p(i) = original_indices(node_to_eliminate);
    original_indices(node_to_eliminate) = [];
end

end


function fillin = compute_fillin(G, fillin)
% For each node that needs updating, computes the amount of fillin that occurs
% when eliminating that node. A node that needs updating is signaled by having
% a current fillin value of 'inf'. Other fillin values are not modified, as they
% are still expected to be correct.

fillin_needs_update = ~isfinite(fillin);
for node = find(fillin_needs_update)
    neighbors = find(G(:,node));
    fillin(node) = length(neighbors)^2 - nnz(G(neighbors, neighbors));
    if fillin(node) == 0
        % cannot have less than 0 fillin, so following nodes will definitely not
        % be chosen, so we can skip computing fillin for them
        break;
    end
end

end
