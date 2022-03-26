clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/delete_still';
surf = 'liq';
result_path = ['F:/2020at/pa_research/result/11.2/' surf];

file = dir([mat_path '/' surf '*.mat']);

for oo = 1:length(file)
    disp(oo)
    load([mat_path '/' file(oo).name]);
    parfor i = 1:length(velocity)
        f = figure('visible', 'off');
        plot(velocity(i).v);
        title([surf, num2str(oo), '-',num2str(i)]);
        xlabel('x/frame')
        ylabel('instant velocity ($\mu m/s$)', 'Interpreter', 'latex');
        fname = [result_path, '/', num2str(oo), '_', num2str(i)];
        saveas(gca, fname, 'png');
        close(f)
    end
end