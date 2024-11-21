function hF = qpd_show_lattice_load(qpd_lattice,calib,opt)
if nargin < 2
    calib = struct;
end

if ~isfield(calib,'X_ErpermV')
    calib.X_ErpermV = 0.22;
end

if ~isfield(calib,'X_CalibrationStr')
    calib.X_CalibrationStr = '2024/10/??';
end

if ~isfield(calib,'Y_ErpermV')
    calib.Y_ErpermV = 0.128;
end

if ~isfield(calib,'Y_CalibrationStr')
    calib.Y_CalibrationStr = '2024/10/??';
end

if ~isfield(calib,'Z_ErpermV')
    calib.Z_ErpermV = 0.24;
end
if ~isfield(calib,'Z_CalibrationStr')
    calib.Z_CalibrationStr = '2024/11/19';
end

if ~isfield(calib,'XDT1_WperV')
    calib.XDT1_WperV = 1;
end
if ~isfield(calib,'XDT1_CalibrationStr')
    calib.XDT1_CalibrationStr = '2024/10/??';
end
if ~isfield(calib,'XDT2_WperV')
    calib.XDT2_WperV = 1;
end
if ~isfield(calib,'XDT2_CalibrationStr')
    calib.XDT2_CalibrationStr = '2024/10/??';
end

%%
if nargin < 3
    opt = struct;
end

if ~isfield(opt,'FigLabel')
    opt.FigLabel='';
end
%%
if ~isfield(opt,'Parent')
    opt.Parent = figure;
    set(opt.Parent,'Name','qpd_lattice_load','color','w',...
        'Position',[100 100 1200 350])
    clf(opt.Parent)

else
    clf(opt.Parent)
end


if ~isempty(opt.FigLabel)
    uicontrol('style','text','parent',opt.Parent,'string',opt.FigLabel,...
        'fontsize',7,'horizontalalignment','left',...
        'backgroundcolor','w','Position',[0 0 600 15]);
end

co=parula(length(qpd_lattice));

margins =struct;
margins.yTop = 25;
margins.yBot=60;        % y bottom margin
margins.xLeft=50;       % x left margin
margins.xRight=50;      % y right margin    
margins.ySpace=40;      % y space between objects        
margins.xSpace=50;      % x space between objects
%% X
opt.Parent.UserData.Axes{1}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,4,1,opt.Parent,margins));
co1=get(gca,'colororder');
for kk=1:length(qpd_lattice)
    plot(qpd_lattice(kk).t,1e3*qpd_lattice(kk).X,'.','color',co1(1,:));
    hold on
end
for kk=1:length(qpd_lattice)
    plot(qpd_lattice(kk).t,1e3*feval(qpd_lattice(kk).FitX,qpd_lattice(kk).t),...
        '-','color',co(kk,:),'linewidth',2);
    hold on
end
xlabel('time (ms)')
ylabel('x lattice (mV)');
title('x lattice');

dx0    = mean([qpd_lattice.dX]);
dx0err = std([qpd_lattice.dX]);

%% y
opt.Parent.UserData.Axes{2}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,4,2,opt.Parent,margins));
for kk=1:length(qpd_lattice)
    plot(qpd_lattice(kk).t,1e3*qpd_lattice(kk).Y,'.','color',co1(2,:));
    hold on
end
for kk=1:length(qpd_lattice)
    plot(qpd_lattice(kk).t,1e3*feval(qpd_lattice(kk).FitY,qpd_lattice(kk).t),...
        '-','color',co(kk,:),'linewidth',2);
    hold on
end
xlabel('time (ms)')
ylabel('y lattice (mV)');
title('y lattice');

dy0    = mean([qpd_lattice.dY]);
dy0err = std([qpd_lattice.dY]);
%% z
opt.Parent.UserData.Axes{3}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,4,3,opt.Parent,margins));
for kk=1:length(qpd_lattice)
    plot(qpd_lattice(kk).t,1e3*qpd_lattice(kk).Z,'.','color',co1(3,:));
    hold on
end
for kk=1:length(qpd_lattice)
    plot(qpd_lattice(kk).t,1e3*feval(qpd_lattice(kk).FitZ,qpd_lattice(kk).t),...
        '-','color',co(kk,:),'linewidth',2);
    hold on
end
xlabel('time (ms)')
ylabel('z lattice (mV)');
title('z lattice');

dz0    = mean([qpd_lattice.dZ]);
dz0err = std([qpd_lattice.dZ]);

%% XDT

xdt1 = mean([qpd_lattice.XDT1]);
xdt1err = std([qpd_lattice.XDT1]);
xdt2 = mean([qpd_lattice.XDT2]);
xdt2err = std([qpd_lattice.XDT2]);
%% summary table
opt.Parent.UserData.Axes{4}=uitable('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,4,4,opt.Parent,margins));
tbl={
    ['X Er/mV'], [num2str(calib.X_ErpermV,'%.2f')],[calib.X_CalibrationStr];
['Y Er/mV'], [num2str(calib.Y_ErpermV,'%.2f')],[calib.Y_CalibrationStr];
['Z Er/mV'], [num2str(calib.Z_ErpermV,'%.2f')],[calib.Z_CalibrationStr];
[char(916) 'X (mV,Er)'], [num2str(1e3*dx0,'%.2f') ' ' char(177) ' ' num2str(dx0err*1e3,'%.2f')],[num2str(1e3*dx0*calib.X_ErpermV,'%.2f') ' ' char(177) ' ' num2str(dx0err*1e3*calib.X_ErpermV,'%.2f')];
[char(916) 'Y (mV,Er)'], [num2str(1e3*dy0,'%.2f') ' ' char(177) ' ' num2str(dy0err*1e3,'%.2f')], [num2str(1e3*dy0*calib.Y_ErpermV,'%.2f') ' ' char(177) ' ' num2str(dy0err*1e3*calib.Y_ErpermV,'%.2f')];
[char(916) 'Z (mV,Er)'], [num2str(1e3*dz0,'%.2f') ' ' char(177) ' ' num2str(dz0err*1e3,'%.2f')],[num2str(1e3*dz0*calib.Z_ErpermV,'%.2f') ' ' char(177) ' ' num2str(dz0err*1e3*calib.Z_ErpermV,'%.2f')]
['XDT1 W/V'], [num2str(calib.XDT1_WperV,'%.2f')],[calib.XDT1_CalibrationStr];
['XDT2 W/V'],[num2str(calib.XDT2_WperV,'%.2f')],[calib.XDT1_CalibrationStr];
['XDT1 (V,W)'], [num2str(xdt1,'%.2f') ' ' char(177) ' ' num2str(xdt1err,'%.2f')], [num2str(xdt1*calib.XDT1_WperV,'%.2f') ' ' char(177) ' ' num2str(xdt1err*calib.XDT1_WperV,'%.2f')];
['XDT2 (V,W)'], [num2str(xdt2,'%.2f') ' ' char(177) ' ' num2str(xdt2err,'%.2f')], [num2str(xdt2*calib.XDT2_WperV,'%.2f') ' ' char(177) ' ' num2str(xdt2err*calib.XDT2_WperV,'%.2f')];
};
set(opt.Parent.UserData.Axes{4},'RowName',{},'ColumnName',{},'ColumnWidth',{70 80 80},...
    'Data',tbl);


%% Size Changed Fcn

function resizeFunc(src,~)
    for mm=1:length(src.UserData.Axes)
        src.UserData.Axes{mm}.Position=qpd_getAxisPos(1,4,mm,src,margins);    
    end
end

opt.Parent.SizeChangedFcn = @resizeFunc;

%% 

hF = opt.Parent;
end
