order=3;
framelen=9;

figure(i);
    for i=1:lastlabel
       if length(velocity(i).v)>120 %& length(velocity(i).v)<200   %==nframes-1
        %plot(tracks(i).x,tracks(i).y,'Color',colors(i,1:3),'LineStyle','none','Marker','.','MarkerSize',5);
        %hold on;
        %plot(tracks(i).x,tracks(i).y,'Color',colors(i,1:3));
        %text(tracks(i).x(1),tracks(i).y(1),['tracks',(num2str(i))],'HorizontalAlignment','left')
        %plot(velocity(i).v);
        sgf=sgolayfilt(velocity(i).v,order,framelen);
        %plot(sgf,'Color',colors(i,1:3));
        title('v - t of \Delta pilA, near surface');
        xlabel('x/frame')
        ylabel('velocity');
        saveas(gca,num2str(i),'jpg');
        %hold on;
       end
       
    end