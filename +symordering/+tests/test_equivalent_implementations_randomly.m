function test_equivalent_implementations_randomly(funcs)

dim_min = 1;
dim_max = 20;
num_tries = 1000;

for i_try = 1:num_tries
    dim = randi([dim_min, dim_max]);
    density = rand();
    A = sprand(dim, dim, density);
    A = A + A';  % make symmetric

    p_reference = funcs{1}(A);
    for i_impl = 2:length(funcs)
        p = funcs{i_impl}(A);
        if ~all(p == p_reference)
            p
            p_reference
            error('The implementation "%s" returned a different permutation!', ...
                  get_implementation_name(funcs{i_impl}));
        end
    end
end

end


function name = get_implementation_name(implementation_func)

name = char(implementation_func);
name(1:find(name == '.', 1, 'last')) = [];
name(find(name == '(', 1, 'first'):end) = [];
name(name == ' ') = [];

end
