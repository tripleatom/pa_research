clc; close all; clear

mat_path = 'F:/2020at/pa_research/mat/11.2/delete_still';

surf_or_liquid = 'surf';
file = dir([mat_path '/' surf_or_liquid '*.mat']);
whole_v = [];

for i = 1:length(file)
    disp(i)
    load([mat_path '/' file(i).name]);
    v = extractfield(velocity, 'v');
    whole_v = [whole_v, v];
end

lens = 40; % field lens magnification
whole_v = whole_v / 40;

h = histogram(whole_v, 'Normalization', 'pdf');
h.BinWidth = 1;
title_text = 'worms instant velocity distribution (delete still)';

if strcmp(surf_or_liquid, 'surf')
    title(['Surface ' title_text])
else
    title(['Liquid ' title_text])
end

xlabel('velocity ($\mu m/s$)', 'Interpreter', 'latex')
ylabel('probability density function')
