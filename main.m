
%% Shuffled Frog Leaping Algorithm (SFLA) NN Learner 

% Shuffled Frog Leaping Algorithm (SFLA) is used to improve weights and
% biases of trained neural network. You can use your data or change the NN 
% structure. Please play with parameters depending on your data and system.

%% Clearing and Loading Data 
clear;
data=JustLoad();
warning('off');
% Inputs (Train and Test)
inputs=rescale(data.TrainInputs)';
TstInputs=rescale(data.TestInputs)';

% Targets (Train and Test)
targets=rescale(data.TrainTargets)';
TstTargets=rescale(data.TestTargets)';

sizenn=size(inputs);sizenn=sizenn(1,1);

% Number of neurons----------------------
n = 12;
%----------------------------------------

% 'trainlm'	    Levenberg-Marquardt
% 'trainbr' 	Bayesian Regularization (good)
% 'trainbfg'	BFGS Quasi-Newton
% 'trainrp'  	Resilient Backpropagation
% 'trainscg'	Scaled Conjugate Gradient
% 'traincgb'	Conjugate Gradient with Powell/Beale Restarts
% 'traincgf'	Fletcher-Powell Conjugate Gradient
% 'traincgp'	Polak-Ribiére Conjugate Gradient
% 'trainoss'	One Step Secant (good)
% 'traingdx'	Variable Learning Rate Gradient Descent
% 'traingdm'	Gradient Descent with Momentum
% 'traingd' 	Gradient Descent
% Creating the NN ----------------------------
net = feedforwardnet(n,'traingdx');
%---------------------------------------------

% configure the neural network 
[net tr]= train(net,inputs, targets);
perf = perform(net,inputs, targets);%mse

% Current NN Weights and Bias
% Create Handle for Error
h = @(x) NMSE(x, net, inputs, targets);

%% SFLA NN
[x, err_ga] = sfla(h, sizenn*n+n+n+1);
%-----------------------------------------

net = setwb(net, x');
% Optimized NN Weights and Bias
getwb(net);
% Error for Optimized NN
Error = targets - net(inputs);
calc = mean(Error.^2)/mean(var(targets',1));

%-----------------------------------------
Outputs=net(inputs);
TestOutputs=net(TstInputs);

% Train
TrMSE=mse(targets,Outputs);
TrRMSE=sqrt(TrMSE);
TrMAE=mae(targets,Outputs);
TrCC= corrcoef(targets,Outputs);
TrR_Squared=TrCC*TrCC;

%Test
TsMSE=mse(TstTargets,TestOutputs);
TsRMSE=sqrt(TsMSE);
TsMAE=mae(TstTargets,TestOutputs);
TsCC = corrcoef(TstTargets,TestOutputs);
TsR_Squared=TsCC*TsCC;

% Statistics
% Train
fprintf('Training "MSE" Is =  %0.4f.\n',TrMSE)
fprintf('Training "RMSE" Is =  %0.4f.\n',TrRMSE)
fprintf('Training "MAE" Is =  %0.4f.\n',TrMAE)
fprintf('Training "Correlation Coefficient" Is =  %0.4f.\n',TrCC(1,2))
fprintf('Training "R_Squared" Is =  %0.4f.\n',TrR_Squared(1,2))
% Test
fprintf('Testing "MSE" Is =  %0.4f.\n',TsMSE)
fprintf('Testing "RMSE" Is =  %0.4f.\n',TsRMSE)
fprintf('Testing "MAE" Is =  %0.4f.\n',TsMAE)
fprintf('Testing "Correlation Coefficient" Is =  %0.4f.\n',TsCC(1,2))
fprintf('Testing "R_Squared" Is =  %0.4f.\n',TsR_Squared(1,2))
view(net);

%% Plots 
trer=targets-Outputs;
tser=TstTargets-TestOutputs;
figure;
subplot(3,2,1)
plot(targets,'linewidth',2); title('Train');
hold on;
plot(Outputs,'linewidth',2);legend('Target','Output');
subplot(3,2,2)
plot(TstTargets,'linewidth',2); title('Test');
hold on;
plot(TestOutputs,'linewidth',2);legend('Target','Output');
subplot(3,2,3)
plot(trer,'linewidth',2); title('Train Error');
subplot(3,2,4)
plot(tser,'linewidth',2); title('Test Error');
subplot(3,2,5)
[population2,gof] = fit(targets',Outputs','poly3');
plot(targets',Outputs','o',...
'LineWidth',1,...
'MarkerSize',6,...
'MarkerEdgeColor','k',...
'MarkerFaceColor',[0.9,0.9,0.1]);
title(['Train  R = ' num2str(1-gof.rmse)]);xlabel('Target');ylabel('Output');   
hold on
plot(population2,'k-','predobs');xlabel('Target');ylabel('Output');   
hold off
subplot(3,2,6)
[population2,gof] = fit(TstTargets',TestOutputs','poly3');
plot(TstTargets',TestOutputs','o',...
'LineWidth',1,...
'MarkerSize',6,...
'MarkerEdgeColor','r',...
'MarkerFaceColor',[0.9,0.9,0.1]);
title(['Test  R = ' num2str(1-gof.rmse)]);xlabel('Target');ylabel('Output');   
hold on
plot(population2,'r-','predobs');xlabel('Target');ylabel('Output');   
hold off



