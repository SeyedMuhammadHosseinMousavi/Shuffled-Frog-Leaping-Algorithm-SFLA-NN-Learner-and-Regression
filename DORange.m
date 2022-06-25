function b = DORange(x, VarMin, VarMax)
b = all(x >= VarMin) && all(x <= VarMax);
end