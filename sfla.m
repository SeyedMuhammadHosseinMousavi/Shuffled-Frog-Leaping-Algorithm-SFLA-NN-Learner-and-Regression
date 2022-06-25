function [x,err]=sfla(CostFunction,nVar)
VarSize = [1 nVar];     
VarMin = -10;         
VarMax = 10;           
%% SFLA Parameters
theit = 100;        % Iterations
nPopMemeplex = 10;                          % Memeplex Size
nPopMemeplex = max(nPopMemeplex, nVar+1);   % Nelder-Mead Standard
nMemeplex = 6;                  % Number of Memeplexes
nPop = nMemeplex*nPopMemeplex;	% Population 
I = reshape(1:nPop, nMemeplex, []);
% FLA Parameters
fla_params.q = max(round(0.3*nPopMemeplex), 2);   % Number of Parents
fla_params.alpha = 4;   % Number of Offsprings
fla_params.beta = 4;    % Iterations
fla_params.sigma = 0.8;   % Step Size
fla_params.CostFunction = CostFunction;
fla_params.VarMin = VarMin;
fla_params.VarMax = VarMax;
% Empty Member
empty_individual.Position = [];
empty_individual.Cost = [];
pop = repmat(empty_individual, nPop, 1);
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
pop(i).Cost = CostFunction(pop(i).Position);
end
% Sort 
pop = JustSortIT(pop);
% Update 
BestSol = pop(1);
costval = nan(theit, 1);
%% SFLA 
for it = 1:theit
fla_params.BestSol = BestSol;
% Initialize Memeplexes Array
Memeplex = cell(nMemeplex, 1);
% Form Memeplexes and Run FLA
for j = 1:nMemeplex
% Memeplex Formation
Memeplex{j} = pop(I(j, :));
% Run FLA
Memeplex{j} = FLADO(Memeplex{j}, fla_params);
% Insert Updated Memeplex into Population
pop(I(j, :)) = Memeplex{j};
end
% Sort 
pop = JustSortIT(pop);
% Update 
BestSol = pop(1);
% Store 
costval(it) = BestSol.Cost;
disp(['In ITR ' num2str(it) ': Cost = ' num2str(costval(it))]);
end
x=BestSol.Position';
err=BestSol.Cost;
% Plot ITR
figure;
plot(costval,'k--','LineWidth', 2);
xlabel('ITR');
ylabel('COST Value');
