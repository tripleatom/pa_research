%% set param
clc; close all; clear;
mat_path = 'F:/2020at/pa_research/mat/11.2/delete_still';
surf_or_not = 'surf';
file = dir([mat_path '/' surf_or_not '*.mat']);
lens_magnification = 40;
minprominence = 1;

%% calculate mutation rate
mutation_rate = [];
mutation_duration = [];

for oo = 1:length(file)
    current_proj = file(oo).name(1:end -4);
    load([mat_path '/' file(oo).name])

    parfor j = 1:length(velocity)
        velocity_array = velocity(j).v / lens_magnification;
        time_array = 1:length(velocity_array);
        time_array = time_array / FrameRate;

        % find local minimum and maximum
        TF1 = islocalmin(velocity_array, 'MinProminence', minprominence);
        TF2 = islocalmin(-velocity_array, 'MinProminence', minprominence);

        % extremum index
        k_min = find(TF1);
        k_max = find(TF2);

        %filter valid data
        for i = 1:length(k_min)

            if i + 1 > length(k_max)
                break
            end
        
            % extract 3 points
            left = velocity_array(k_max(i));
            right = velocity_array(k_max(i + 1));
            middle = velocity_array(k_min(i));
        
            % determine if through or not
            upper_bound = (left + right) / 2;
        
            % todo: adjust contraints::
            if middle < upper_bound * 2/3 ...
                && (left - middle) > upper_bound / 7 && (right - middle) > upper_bound / 7 ...
                && min(left, right) - middle > 7
            
                % accept
                mutation_duration = [mutation_duration, time_array(k_max(i + 1)) - time_array(k_max(i))];
            else
                % remove the local minimum index
                TF1(k_min(i)) = ~TF1(k_min(i));
            end
        
        end
        temp_rate = sum(TF1)/time_array(end);
        if temp_rate~=0
            mutation_rate = [mutation_rate, temp_rate]
        end

    end

end

%% plot distribution
plt_path = 'F:/2020at/pa_research/result/11.2/velocity_mutation';

figure
h1 = histogram(mutation_rate, 'Normalization', 'pdf');
%h.BinWidth = 1;

title_text = 'worm mutation rate distribution';

if strcmp(surf_or_not, 'surf')
    title(['Surface ' title_text])
else
    title(['Liquid ' title_text])
end
xlim([0 7])
xlabel('velocity mutation rate (times/s)')
ylabel('probability density function')
fname = [plt_path, '/', 'rate_', surf_or_not];
saveas(gca, fname, 'png');

figure;
h2 = histogram(mutation_duration, 'Normalization', 'pdf');
%h.BinWidth = 1;

title_text = 'worm mutation duration distribution';

if strcmp(surf_or_not, 'surf')
    title(['Surface ' title_text])
else
    title(['Liquid ' title_text])
end
xlim([0 .9])
xlabel('velocity mutation duration (s)')
ylabel('probability density function')
fname = [plt_path, '/', 'duration_', surf_or_not];
saveas(gca, fname, 'png');