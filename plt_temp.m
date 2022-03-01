colors = prism(lastlabel);

figure;
for i=1:lastlabel
    if length(velocity(i).v)>60   %==nframes-1 
        plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3),'LineStyle','none','Marker','.','MarkerSize',5);
        hold on;
        plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3));
        %saveas(gcf,'liq2_track','jpg');
        %text(tracks(i).x(1),tracks(i).y(1),['tracks',(num2str(i))],'HorizontalAlignment','left')
    end
end