
WI_IN = 2;
WF_IN = 10;
WI_OUT = 2;
WF_OUT = 10;
WI_COEFF = 1;
WF_COEFF = 15;

% import Neural_Signal_Sample.mat
Neural_Signal_Sample = load('Neural_Signal_Sample.mat').neural_signal;

% convert to fixed point
Neural_Signal_Sample_FI = fi(Neural_Signal_Sample, 1, WI_IN+WF_IN, WF_IN);

% hex coefficients for the texbook's given filter 
ORDER = 5;
hex_coeff = ['D7AC'; 'E464'; 'AE68'; '5198'; '1B9C'; '2854'];

% moving average filter coeff
% ORDER = 3;
% avg_coeff = zeros(1, ORDER+1) + (1/(ORDER+1));

fixed_coeff = hex2fi(hex_coeff, WI_COEFF+WF_COEFF, WF_COEFF, 1);
% fixed_coeff = fi(avg_coeff, 1, WI_COEFF+WF_COEFF, WF_COEFF);


%% Simulate Debug Signal

debug_signal = [1; 1.5; 1.75; 1; 1.5; 1.75; 1; 1.5; 1.75];

debug_coeff = [0.5; 0.5; 0.5; -0.5; -0.5; -0.5];
fixed_debug_coeff = fi(debug_coeff, 1, WI_COEFF+WF_COEFF, WF_COEFF);

debug_results = Fixed_Point_FIR(debug_signal, fixed_debug_coeff, WI_IN, WF_IN, WI_COEFF, WF_COEFF, WI_OUT, WF_OUT);


%% Write coefficients to file
% format in hex for hdl simulation

coeff_file = fopen('filter_coefficients.mem', 'w');

for i = 1:length(fixed_coeff)
    fprintf(coeff_file, '%s\n', bin(fixed_coeff(i)));
end

fclose(coeff_file);

%% Write input to file
% format in hex for hdl simulation

input_file = fopen('test_signal.mem', 'w');

for i = 1:length(Neural_Signal_Sample_FI)
    fprintf(input_file, '%s\n', bin(Neural_Signal_Sample_FI(i)));
end

fclose(input_file);

%% Fixed Point FIR Filter (MATLAB)
% Run matlab simulation

matlab_results = Fixed_Point_FIR(Neural_Signal_Sample_FI, fixed_coeff, WI_IN, WF_IN, WI_COEFF, WF_COEFF, WI_OUT, WF_OUT);


%% Fixed Point FIR Filter (HDL)
% Read in the results from the HDL simulation

hdl_results_hex = readlines('C:\Users\Camse\OneDrive\Schoolwork\2023_Fall\COMPE-570\Fixed_Point_FIR\Fixed_Point_FIR.sim\sim_1\behav\xsim\sample_out_1.mem', "EmptyLineRule", "skip");

hdl_results_FI = hex2fi(hdl_results_hex, WI_OUT+WF_OUT, WF_OUT, 1);

%% Plot Neural Signal Sample

plot(Neural_Signal_Sample_FI);

%% Plot HDL/Matlab Comparison

% plot the overlayed results
subplot(1,2,1);
hold on;
plot(matlab_results);
plot(hdl_results_FI);
hold off;
legend('Matlab', 'HDL');
title('Matlab / HDL Results');

% plot the error
subplot(1,2,2);
plot(abs(matlab_results-hdl_results_FI));
title('Absolute Error');

