clear all;
close all;


[file,path] = uigetfile('M-Sequence.mat','Select the data file'); % select data file to load

load([path file]);

tns = ((0:Channel_2.NumPoints-1)*Channel_2.XInc + Channel_2.XOrg)*1e9;  % time in ns
AmV = (double(Channel_2.Data)*Channel_2.YInc + Channel_2.YOrg)*1000;    % amplitude in mV



N = size(AmV, 1);

dtns_i = zeros(1, N);

for i = 1:N - 1
    dtns_i(i) = tns(i + 1) - tns(i);
end

dtns_avg = sum(dtns_i.')./ N;
fs = 1./dtns_avg;

AmV_freq = fft(AmV, N);

freq = fs .* (0:N/2)./N;

figure(1);
plot(tns, AmV, 'LineWidth', 2);

xlabel('time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Signal(mVolt)', 'FontSize', 12, 'FontWeight', 'bold');
title('Signal in Time Domain', 'FontSize', 12, 'FontWeight', 'bold');
%legend({'Pulse', 'DUT'}, 'FontSize', 12, 'FontWeight', 'bold');
grid on;
print('Signal', '-depsc');

%plot(tns, AmV);
figure(2);
plot(freq, 0.5 .* db(abs(AmV_freq(1:N/2+1)).^2./N), 'LineWidth', 2);
grid on;

xlabel('Frequencies(GHz)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('P_{yy}(\mu Watt) [dB Scale]', 'FontSize', 12, 'FontWeight', 'bold');
title('Power Spectrum M-Sequence Radar', 'FontSize', 12, 'FontWeight', 'bold');
%legend({'Pulse', 'DUT'}, 'FontSize', 12, 'FontWeight', 'bold');
print('Signal_f_db', '-depsc');

%% Autocorrelation:

[Autocorr, lags] = xcorr(AmV, AmV);

figure(3);
plot(lags.*dtns_avg, Autocorr, 'LineWidth', 2, 'color', [0.6350, 0.0780, 0.1840]);
grid on;

xlabel('delay time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Autocorrelation', 'FontSize', 12, 'FontWeight', 'bold');
title('Autocorrelation plot of the signal', 'FontSize', 12, 'FontWeight', 'bold');


% print('Signal_auto', '-depsc');

%% With hann window

hann_ = hanning(N);

signal_new = AmV .* hann_;

[Autocorr, lags] = xcorr(signal_new, signal_new);

figure(4);
plot(lags.*dtns_avg, Autocorr, 'LineWidth', 2, 'color', [0.6350, 0.0780, 0.1840]);
grid on;

xlabel('delay time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Autocorrelation', 'FontSize', 12, 'FontWeight', 'bold');
title('Autocorrelation plot of the signal', 'FontSize', 12, 'FontWeight', 'bold');

% Ambiguity Nornalized

%% Autocorrelation:

[Autocorr, lags] = xcorr(AmV, AmV);

figure(5);
plot(lags.*dtns_avg, Autocorr./max(Autocorr), 'LineWidth', 2, 'color', [0.6350, 0.0780, 0.1840]);
grid on;

xlabel('delay time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Ambiguity normalized', 'FontSize', 12, 'FontWeight', 'bold');
title('Ambiguity function of the signal', 'FontSize', 12, 'FontWeight', 'bold');


% print('Signal_auto', '-depsc');

%% With hann window

hann_ = hanning(N);

signal_new = AmV .* hann_;

[Autocorr, lags] = xcorr(signal_new, signal_new);

figure(6);
plot(lags.*dtns_avg, Autocorr./max(Autocorr), 'LineWidth', 2, 'color', [0.6350, 0.0780, 0.1840]);
grid on;

xlabel('delay time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Ambiguity normalized', 'FontSize', 12, 'FontWeight', 'bold');
title('Ambiguity function of the signal', 'FontSize', 12, 'FontWeight', 'bold');







%% ambiguity function:




