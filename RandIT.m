function L = RandIT(P, q, replacement)
if ~exist('replacement', 'var')
replacement = false;
end
L = zeros(q, 1);
for i = 1:q
L(i) = randsample(numel(P), 1, true, P);
if ~replacement
P(L(i)) = 0;
end
end
end