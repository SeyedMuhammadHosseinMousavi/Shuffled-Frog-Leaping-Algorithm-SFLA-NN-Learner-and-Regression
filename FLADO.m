function pop = FLADO(pop, params)
%% FLA Parameters
q = params.q;           % Parents
alpha = params.alpha;   % Offsprings
beta = params.beta;     % Iterations
sigma = params.sigma;
CostFunction = params.CostFunction;
VarMin = params.VarMin;
VarMax = params.VarMax;
VarSize = size(pop(1).Position);
BestSol = params.BestSol;
nPop = numel(pop);      % Population 
P = 2*(nPop+1-(1:nPop))/(nPop*(nPop+1));    % Selection Probabilities
% Calculate Population Range (Smallest Hypercube)
LowerBound = pop(1).Position;
UpperBound = pop(1).Position;
for i = 2:nPop
LowerBound = min(LowerBound, pop(i).Position);
UpperBound = max(UpperBound, pop(i).Position);
end
%% FLA Body
for it = 1:beta
% Select Parents
L = RandIT(P, q);
B = pop(L);
% Generate Offsprings
for k = 1:alpha
% Sort 
[B, SortOrder] = JustSortIT(B);
L = L(SortOrder);
% Flags
ImprovementStep2 = false;
Censorship = false;
% Improve First Stage
NewSol1 = B(end);
Step = sigma*rand(VarSize).*(B(1).Position-B(end).Position);
NewSol1.Position = B(end).Position + Step;
if DORange(NewSol1.Position, VarMin, VarMax)
NewSol1.Cost = CostFunction(NewSol1.Position);
if NewSol1.Cost<B(end).Cost
B(end) = NewSol1;
else
ImprovementStep2 = true;
end
else
ImprovementStep2 = true;
end
% Improve Second Stage 
if ImprovementStep2
NewSol2 = B(end);
Step = sigma*rand(VarSize).*(BestSol.Position-B(end).Position);
NewSol2.Position = B(end).Position + Step;
if DORange(NewSol2.Position, VarMin, VarMax)
NewSol2.Cost = CostFunction(NewSol2.Position);
if NewSol2.Cost<B(end).Cost
B(end) = NewSol2;
else
Censorship = true;
end
else
Censorship = true;
end
end
% Censorship
if Censorship
B(end).Position = unifrnd(LowerBound, UpperBound);
B(end).Cost = CostFunction(B(end).Position);
end
end
% Subcomplex to Main Complex
pop(L) = B;
end
end