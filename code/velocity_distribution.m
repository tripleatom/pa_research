clc; close all; clear

mat_path = 'F:/2020at/pa_research/mat/11.2/clear';
file = dir([mat_path '/*.mat']);

load([mat_path '/' file(1).name]);

whole_v = [];

for i = 1:length(file)
    v = extractfield(velocity, 'mean');
    whole_v = [whole_v, v];
end

h = histogram(whole_v,'Normalization','pdf');
