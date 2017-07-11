function [out] = func_W(x,z)
        out = norm(x-imhistmatch(x,z));
end

%EOF