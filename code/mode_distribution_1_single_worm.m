clc; clear; close all;

mat_path = 'F:/2020at/pa_research/mat/11.2/with_angle/';
result_path = 'F:/2020at/pa_research/result/11.2/track_eg/';

surf_or_liquid = 'surf';
oo = 9;
i = 59;

file = dir([mat_path surf_or_liquid '*.mat']);
lens_magnification = 40;


load([mat_path '/' file(oo).name]);

temp_v = velocity(i).v;
temp_angle = angle_velocity(i).v; % radius
thres = velocity(i).threshold;

worm_thres = .25;
mode_choosen = 'pause';
%%
if strcmp(mode_choosen, 'run')
    ind = temp_v > thres;
elseif strcmp(mode_choosen, 'pause')
    ind = (temp_v <= thres);
end

left = 0;
mode_flag = false;
worm_marker = zeros(length(temp_v));

for j = 1:length(temp_v)

    if ind(j) == 1 && mode_flag == false
        mode_flag = true;
        left = j;

    elseif ind(j) == 0 && mode_flag == true
        mode_flag = false;
        temp_time = (j - left) / FrameRate;

        if temp_time > worm_thres
            worm_marker(left:j - 1) = 1;
        end

        left = 0;
    end

end

worm_marker = logical(worm_marker);

% change to um
temp_v = temp_v / lens_magnification;
%% plot
x = 1:length(temp_v);
x = x / FrameRate;

current_time = datestr(now, 'mmdd-HH');
title = [result_path surf_or_liquid '_' num2str(oo) '_' num2str(i)];

% track
figure
hold on
[X, ~] = a_trous_dwt1D(tracks(i).x, 1);
[Y, ~] = a_trous_dwt1D(tracks(i).y, 1);
X = X / lens_magnification;
Y = Y / lens_magnification;
h1 = plot(X, Y, 'b');
flag = false;

for j = 1:length(ind)

    if ind(j) == 1 && flag == false
        flag = true;
        left = j;

    elseif ind(j) == 0 && flag == true
        flag = false;
        h2 = plot(X(left:j - 1), Y(left:j - 1)', 'r');
        left = 0;
    end

end

flag = false;

for j = 1:length(worm_marker)

    if worm_marker(j) == 1 && flag == false
        flag = true;
        left = j;

    elseif worm_marker(j) == 0 && flag == true
        flag = false;
        h3 = plot(X(left:j - 1), Y(left:j - 1)', 'g');
        left = 0;
    end

end
xlabel('X position ($\mu m$)', 'Interpreter', 'latex')
ylabel('Y position ($\mu m$)', 'Interpreter', 'latex')

legend(h1, 'run')

if exist('h2', 'var')
    legend([h1, h2],'run', 'pause');
end

if exist('h3' ,'var')
    legend([h1, h3],'run',  'worm');
end

if exist('h2', 'var') && exist('h3' ,'var')
    legend([h1,h2, h3],'run','pause',  'worm');
end

f1name = [title '_track_' current_time];
saveas(gca, f1name, 'png')
hold off

% velocity
figure
hold on
plot(x, temp_v', 'b')

flag = false;

for j = 1:length(ind)

    if ind(j) == 1 && flag == false
        flag = true;
        left = j;

    elseif ind(j) == 0 && flag == true
        flag = false;
        plot(x(left:j - 1), temp_v(left:j - 1)', 'r')
        left = 0;
    end

end

flag = false;

for j = 1:length(worm_marker)

    if worm_marker(j) == 1 && flag == false
        flag = true;
        left = j;

    elseif worm_marker(j) == 0 && flag == true
        flag = false;
        plot(x(left:j - 1), temp_v(left:j - 1)', 'g')
        left = 0;
    end

end

xlabel('Time(s)')
ylabel('velocity ($\mu m/s$)', 'Interpreter', 'latex')
set(gca,'Position',[.13 .4 .8 .4]);
f2name = [title '_v_' current_time];
saveas(gca, f2name, 'png')
hold off

figure
hold on 
plot(x(1:end - 1), temp_angle, 'b')
flag = false;

for j = 1:length(ind)

    if ind(j) == 1 && flag == false
        flag = true;
        left = j;

    elseif ind(j) == 0 && flag == true
        flag = false;
        plot(x(left:j - 1), temp_angle(left:j - 1)', 'r')
        left = 0;
    end

end

flag = false;

for j = 1:length(worm_marker)

    if worm_marker(j) == 1 && flag == false
        flag = true;
        left = j;

    elseif worm_marker(j) == 0 && flag == true
        flag = false;
        plot(x(left:j - 1), temp_angle(left:j - 1)', 'g')
        left = 0;
    end

end
xlabel('Time(s)')
ylabel('angular velocity (rad/s)')
set(gca,'Position',[.13 .4 .8 .4]);
f3name = [title '_angle_v_' current_time];
saveas(gca, f3name, 'png')
hold off
% plot(x(1:end), double(ind)-3, 'b')
