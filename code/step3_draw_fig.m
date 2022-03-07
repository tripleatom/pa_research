pixels_per_micron = 1/5.3;

hTrace = figure;
colors = prism(lastlabel);

for i = 1:length(velocity)

    if length(velocity(i).v) > 50 %60 works
        plot(tracks(i).x * pixels_per_micron, tracks(i).y * pixels_per_micron, 'Color', colors(i, 1:3), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 5);
        axis ij padded
        hold on;
        %text(tracks(i).x(1) / 5.3, tracks(i).y(1) / 5.3, ['tracks', (num2str(i))], 'HorizontalAlignment', 'left')
        %axis ij
        %v=[v,[velocity(i).v]];
    end

end

% saveas(hTrace, '7.fig');
