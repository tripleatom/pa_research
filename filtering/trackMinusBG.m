%locate bacteria
tic
clc
close all
clear
folder = {'E:\HRtrackJD\20190918\0min\';...
    'E:\HRtrackJD\20190918\7min\';...
    'E:\HRtrackJD\20190918\45min\';};
for fn=1:3
% path='I:\HRtrackJD\20190625\blank\';
fn
path = folder{fn};
% cd('H:\HRtrackJD\20190516\result\H2O2');
cd(path)
file=dir([path '*.avi']);
for oo=1:length(file)
    oo

movobj = VideoReader([path file(oo).name]);
% movobj = VideoReader([Name '.avi']); % read data from a movie
nframes = movobj.NumberOfFrames;
FrameRate = movobj.FrameRate;
Frame = zeros(1024,1280);
savestats = [];
parfor index=1:nframes
   im = read(movobj,index);
   Frame = Frame + double(im(:,:,1));
end
    Frame = Frame/nframes;
% level=input('level='); 

% matlabpool
parfor index=1:nframes
   im = read(movobj,index);
   im = double(im(:,:,1))-Frame;
   im = uint8(im-min(min(im)));
%    se = strel('disk',30);
%    fo = imopen(im,se);
%    f2 = imsubtract(im,fo);
% %    f2 = imtophat(im,se);
   se = strel('disk',30); 
   f2 = imsubtract(imadd(im,imtophat(im,se)),imbothat(im,se));

%     level = graythresh(f2);
    bw = im2bw(f2,0.22); %Set the threshold automatically or manually
    se = strel('disk',4);
    bw = imopen(bw,se);
    bw = imclose(bw,se); 
%     bw = bwareaopen(bw,3);
    bw = ~bw;   
%     figure
%     imshow(bw);
    L = bwlabel(bw);
    stats = regionprops(L,'Area','Centroid','BoundingBox','Orientation','MajorAxisLength','MinorAxisLength'); 
     
    if ~isempty(stats)
        [stats(1:length(stats)).frame] = deal(index);
        savestats = [savestats;stats];
    end  
%     clear stats L bw se f2 im
end
% matlabpool close


pixels_per_micron=1/5.3;
micron_search_radius=100;
pixel_search_radius=micron_search_radius*pixels_per_micron;

xy = cat(1,savestats.Centroid);
x=xy(:,1)';y=xy(:,2)';
clear xy;
frame = [savestats.frame];
area = [savestats.Area];
boundingbox = cat(1,savestats.BoundingBox)';
orientation = [savestats.Orientation];
majorlength = [savestats.MajorAxisLength];
minorlength = [savestats.MinorAxisLength];
baclabel=zeros(size(x)); 
i=min(frame); spanA=find(frame==i); 
baclabel(1:length(spanA))=1:length(spanA); 
lastlabel=length(spanA); 
for i=min(frame):max(frame)-1 % loop over all frame(i),frame(i+1) pairs.
    spanA=find(frame==i);
    spanB=find(frame==i+1);
    dx = ones(length(spanA),1)*x(spanB) - x(spanA)'*ones(1,length(spanB));
    dy = ones(length(spanA),1)*y(spanB) - y(spanA)'*ones(1,length(spanB));
    dr2 = dx.^2 + dy.^2; % dr2(m,n) = distance^2 between r_A(m) (in frame i) and r_B(n) (in frame i+1)
    dr2test=(dr2<pixel_search_radius^2); % dr2test=1 if beads A and B could be the same.
%     [from,to,orphan]=beadsorter(dr2test);% RELATIVE  indices of connected and unconnected beads
    
    from=find(sum(dr2test,2)==1); % connected to only ONE bead in next frame:  from(i) -> 1 bead
    to=find(sum(dr2test,1)==1)'; % connected from only ONE bead in previous frame: 1 bead -> to(i)
    [i,j]=find(dr2test(from,to)); % returns list of row,column indices of nonzero entries in good subset of correction
    from=from(i); to=to(j);  % translate list indices to row,column numbers.
    orphan=setdiff(1:size(dr2test,2),to); % anyone not pointed to is an orphan

    from=spanA(from); to=spanB(to); orphan=spanB(orphan); % translate to ABSOLUTE indices
    baclabel(to)=baclabel(from); % propagate labels of connected beads
    if length(orphan)>0 % there is at least one new (or ambiguous) bead 
        baclabel(orphan)=lastlabel+(1:length(orphan)); % assign new labels for new beads.
        lastlabel=lastlabel+length(orphan); % keep track of running total number of beads
    end
end

emptybac.x=0; emptybac.y=0; emptybac.area=0; emptybac.frame=0;emptybac.boundingbox=0;emptybac.orientation=0;
emptybac.majorlength=0;emptybac.minorlength=0;
tracks(1:lastlabel)=deal(emptybac); % initialize for purposes of speed and memory management.
for i=1:lastlabel % reassemble beadlabel into a structured array 'tracks' containing all info
    baci=find(baclabel==i);
    tracks(i).x=x(baci)/pixels_per_micron;
    tracks(i).y=y(baci)/pixels_per_micron;
    tracks(i).area=area(baci)/pixels_per_micron^2;   
    tracks(i).boundingbox=boundingbox(:,baci);
    tracks(i).orientation=orientation(baci);
    tracks(i).majorlength=majorlength(baci);
    tracks(i).minorlength=minorlength(baci);
    tracks(i).frame=frame(baci);
end


%     figure;
%    imshow(read(movobj,1)); colors=prism(lastlabel);hold on;  % plot the tracks to check everything's OK. 
%     for i=1:lastlabel, 
%         Ax = tracks(i).x(1:length(tracks(i).x)-1);
%         Bx = tracks(i).x(2:length(tracks(i).x));
%         Ay = tracks(i).y(1:length(tracks(i).y)-1);
%         By = tracks(i).y(2:length(tracks(i).y));
%         dx = Bx-Ax;
%         dy = By-Ay;
%         dr = sqrt(dx.^2+dy.^2);
%         velocity(i).v = dr*FrameRate;
%         plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3),'LineStyle','none','Marker','.','MarkerSize',5);
%         axis ij
%         hold on;
%         plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3));
%         text([tracks(i).x(1)/5.3],[tracks(i).y(1)/5.3],[(num2str(i))],'HorizontalAlignment','left')
%         axis ij
%     end
%     hTrace=figure;
%     imshow(read(movobj,1)); colors=prism(lastlabel);hold on
%     for i=1:lastlabel
%        if length(velocity(i).v)>50
%         plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3),'LineStyle','none','Marker','.','MarkerSize',5);
%         axis ij 
%         hold on;
%         plot(tracks(i).x/5.3,tracks(i).y/5.3,'Color',colors(i,1:3));
%         text(tracks(i).x(1)/5.3,tracks(i).y(1)/5.3,['tracks',(num2str(i))],'HorizontalAlignment','left')
%         axis ij
%           v=[v,[velocity(i).v]];
%        end
%        
%     end
%     saveas(hTrace,[TraceAllName '.fig']);
    save(file(oo).name(1:end-4),'tracks','lastlabel','movobj')
    clearvars -except  file path oo folder fn
%     
end
end
toc
