hTrace = figure;
colors = prism(lastlabel); 
hold on

for i = 1:lastlabel

    if length(velocity(i).v) > 50 %60 works
        plot(tracks(i).x / 5.3, tracks(i).y / 5.3, 'Color', colors(i, 1:3), 'LineStyle', 'none', 'Marker', '.', 'MarkerSize', 5);
        axis ij
        hold on;
        plot(tracks(i).x / 5.3, tracks(i).y / 5.3, 'Color', colors(i, 1:3));
        %text(tracks(i).x(1) / 5.3, tracks(i).y(1) / 5.3, ['tracks', (num2str(i))], 'HorizontalAlignment', 'left')
        axis ij
        %v=[v,[velocity(i).v]];
    end

end

%saveas(hTrace, '7.fig');% change name
