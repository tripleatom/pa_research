%% load data
clc; close all; clear;
format long
mat_path = 'F:/2020at/pa_research/mat/11.2/delete_still';
surf = 'surf';
file = dir([mat_path '/', surf, '*.mat']);
lens_magnification = 40;
minprominence = 1;

file_i = 1; j = 222;
load([mat_path '/' file(file_i).name])

y = velocity(j).v / lens_magnification;
x = 1:length(y);
x = x / FrameRate;

%% find extremum
[TF1, P1] = islocalmin(y, 'MinProminence', minprominence);
plot(x, y, x(TF1), y(TF1), 'r*')
hold on
[TF2, P2] = islocalmin(-y, 'MinProminence', minprominence);
plot(x(TF2), y(TF2), 'g*')
xlabel('time / s');
ylabel('velocity / $\mu s/s$', 'Interpreter', 'latex');
hold off

sum(TF1);
sum(TF2);

k_min = find(TF1);
k_max = find(TF2);

%% filter valid data
mutation_duration = [];
mutation_duration_fraction = [];

for i = 1:length(k_min)

    if i + 1 > length(k_max)
        break
    end

    % extract 3 points
    left = y(k_max(i));
    right = y(k_max(i + 1));
    middle = y(k_min(i));

    % determine if give up or not
    upper_bound = (left + right) / 2;

    % todo: adjust contraints::
    if middle < upper_bound * 2/3 ...
        && (left - middle) > upper_bound / 7 && (right - middle) > upper_bound / 7 ...
        && min(left, right) - middle > 7
    
        % accept
        mutation_duration = [mutation_duration, x(k_max(i + 1)) - x(k_max(i))];
    else
        %continue
        TF1(k_min(i)) = ~TF1(k_min(i));
    end

end

%% PLOT

plot(x, y, x(TF1), y(TF1), 'r*')
hold on
plot(x(TF2), y(TF2), 'g*')
title([surf, num2str(file_i), '-', num2str(j)]);
xlabel('time / s');
ylabel('velocity / $\mu s/s$', 'Interpreter', 'latex');
hold off

sum(TF1);
whole_time = x(end);
freq = sum(TF1) / whole_time;

figure;
plot(tracks(j).x, tracks(j).y)
hold on
title(['surf-1-' num2str(j)])
text(tracks(j).x(1), tracks(j).y(1), ['start point'], 'HorizontalAlignment', 'left')
plot(tracks(j).x(TF1), tracks(j).y(TF1), 'r*')
hold off