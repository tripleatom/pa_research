clc; close all; clear;
load('F:\2020at\pa_research\mat\11.2\surface\surf06.mat')
i = 378734;
i = 220;
y = velocity(i).v;
x = 1:length(y);
TF = islocalmin(y);
plot(x,y,x(TF),y(TF),'r*')
hold on
TF2 = islocalmin(-y);
plot(x(TF2), y(TF2),'g*')
hold off