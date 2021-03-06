function wd_3dplot(zdata1,zmin)
%CREATEFIGURE(ZDATA1)
%  ZDATA1:  surface zdata

%  Auto-generated by MATLAB on 07-Jan-2014 13:08:20

% Create figure
figure1 = figure(20);

if nargin<2
    zmin=0;
end


% Create axes
axes1 = axes('Parent',figure1,'CLim',[zmin max(zdata1(:))]);
view(axes1,[-39.5 36]);
grid(axes1,'on');
hold(axes1,'all');

% Create mesh
mesh(zdata1,'Parent',axes1,'Marker','.','LineStyle','none','FaceColor','none');
%mesh(zdata1,[0,2000,0,2000,0,0.06],'Parent',axes1,'Marker','.','LineStyle','none','FaceColor','none');
