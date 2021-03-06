%% Plot 2D Particle information OVER raw data
% Version 1.0
tic
clear all
undock
vidon=1; %Set to 1 to save video
framerate=30;
load('constants.mat');
%[m,n]=size(Ein);
radix2 = 2048;
xmax = 2048; % max pixels in x propagation
ymax = 2048; % max pixels in y propagation
zmax = 10E-3; % max distance in z propagation
xscale = 1000*ps/mag; %recontructed distance in mm
yscale = 1000*ps/mag; %recontructed distance in mm
zscale = 1000; %recontructed distance in mm
rect = [vortloc(1)-radix2/2,vortloc(2)-radix2,radix2-1,radix2-1]; %Cropping
rect = [260,60,2048,2048]; %temp Cropping
lastframe = 'numfiles';
lastframe = '100';
%load('1E-5Dilute-30th_2er512size.mat');fignum=20;
%load('1E-5Dilute-35th_2er512size.mat');fignum=21;
%load('1E-5Dilute-40th_2er512size.mat');fignum=22;
%%load('1E-5Dilute-30th_3er512size.mat');fignum=23; %the one
%load('1E-5Dilute-35th_3er512size.mat');fignum=24;
%load('1E-5Dilute-40th_3er512size.mat');fignum=25;
%load('DH__80th_3er2048size.mat');
%load('DH__70th_4er2048size.mat');
%xyzfile='DH-th200_dernum2.mat';
xyzfile='./analysis-20141012/GOOD-1E-5Dilute-th3E-01_dernum4_day73588497963.mat';
backgroundfile='background.mat';
varnam=who('-file',backgroundfile);
background=load(backgroundfile,varnam{1});
background=background.bg;

varnam=who('-file',xyzfile);
beadxyz=load(xyzfile,varnam{1});
beadxyz=beadxyz.(varnam{1});

dirname = '';
filename    = '1E-5Dilute_';
fignum=1;
a=0.0E-3;
b=10;
c=size(beadxyz,2)/1;
d=0;%round(c/1.1);
handle=figure(fignum); set(handle, 'Position', [700 200 512 512])
%clear beadxyz;beadxyz=E1;

filename = strcat(dirname,filename);
filesort = dir([filename,'*.tif']);
numfiles = numel(filesort);
for L = 1:numfiles
    [filesort(L).pathstr, filesort(L).firstname, filesort(L).ext] = ...
        fileparts([filesort(L).name]);
    %filesort(i).matname=strcat(filesort(i).matname,'.mat');
end

Holo = imcrop((double(imread([filesort(1).name]))) ./ background,rect);
maxint = 2*mean(Holo(:));
    
mov(eval(lastframe)).cdata=[];
mov(eval(lastframe)).colormap=[];

for L=1:eval(lastframe)
    %figure(fignum)
    %
%     Holo = imcrop(double((imread([filesort(L).name]))),rect);
    Holo = imcrop((double(imread([filesort(L).name]))) ./ background,rect);
%     maxint = 2*mean(Holo(:));
%     maxint = max(Holo(:));
    Holo(Holo>maxint) = maxint;
    Holo = 255.*Holo./maxint;
    
    imagesc(linspace(0,3.33),linspace(0,3.33),flipud(Holo))
    colormap gray
    caxis([0, 255])
    set(gca,'ydir','normal')
    hold on
    plot3(xscale*beadxyz(L).time(:,1),yscale*(ymax-beadxyz(L).time(:,2)),zscale*beadxyz(L).time(:,3),'b.');
%     plot3(xscale*beadxyz(L+1).time(:,1),yscale*(ymax-beadxyz(L+1).time(:,2)),zscale*beadxyz(L+1).time(:,3),'b.');
%     plot3(xscale*beadxyz(L+2).time(:,1),yscale*(ymax-beadxyz(L+2).time(:,2)),zscale*beadxyz(L+2).time(:,3),'b.');
    hold off
    xlabel('(mm)')
    ylabel('(mm)')
    zlabel('Through Focus (mm)')
    %
    %{
    %
    plot3(xscale*beadxyz(L).time(:,1),zscale*beadxyz(L).time(:,3),yscale*(ymax-beadxyz(L).time(:,2)),'b.');
%     axis([0,xmax,a,b,0,ymax]);
%     view(15,15) % small perspective in z
%     view(0,0) %flat
    %view(-38+3*L-3,30+3*L-3)
    %view(-38+L/10,30)
    %view(-34,56)
    xlabel('(mm)')
    zlabel('(mm)')
    ylabel('Through Focus (mm)')
    %}
    title(['Frame#:',num2str(L),'   (time in AU)']);
    grid on
    box off
    axis image
    %hold on
    if L>d
        drawnow
    end
    %pause(0.1)
    %hold off
    %
    if vidon==1
%        t = colorbar;
%        set(get(t,'ylabel'),'string','Z Depth(m)','fontsize',16)
        mov(:,L) = getframe(fignum) ;
    end
end
hold off

if vidon==1
    filename=xyzfile;
    writerObj = VideoWriter([filename(1:end-4),'_',num2str(uint8(rand*100))],'MPEG-4');
    writerObj.FrameRate = framerate;
    open(writerObj);
    writeVideo(writerObj,mov);
    close(writerObj);
end

toc