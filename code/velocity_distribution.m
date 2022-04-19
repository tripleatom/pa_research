% calculate velocity_distribution of bacteria
% dir:  clear : delete the still bacteria
%       delete_still: use threshold filter the bacteria which stick on the
%       glass
clc; close all; clear

%% pre define var
mat_path = 'F:/2020at/pa_research/mat/11.2/';
out_path = 'F:/2020at/pa_research/result/11.2/distribution/';

surf_or_liquid = 'liq';
mean_or_v = 'v';
thres_or_not = true;

whole_v = load_velocity(mat_path, surf_or_liquid, mean_or_v, thres_or_not);

lens = 40; % objective lens magnification
whole_v = whole_v / lens;

%% histogram
h = histogram(whole_v, 'Normalization', 'pdf');
h.BinWidth = 1;
xlabel('velocity ($\mu m/s$)', 'Interpreter', 'latex')
ylabel('probability density function')

%% title and fname
[title_text, output_filename] = creat_title(surf_or_liquid, mean_or_v, thres_or_not);

title(title_text)
current_time = datestr(now, 'yymmdd-HHMM');
fname = [out_path output_filename '_' current_time];

%% save
saveas(gca, fname, 'png')
