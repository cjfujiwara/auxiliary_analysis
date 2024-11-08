function hF = qpd_show_lattice_load(qpd_lattice,opts)
if nargin == 1
    opts = struct;
end

if ~isfield(opts,'X_ErpermV')
    opts.X_ErpermV = 0.22;
end

if ~isfield(opts,'X_CalibrationStr')
    opts.X_CalibrationStr = '2024/10/??';
end

if ~isfield(opts,'Y_ErpermV')
    opts.Y_ErpermV = 0.128;
end

if ~isfield(opts,'Y_CalibrationStr')
    opts.Y_CalibrationStr = '2024/10/??';
end

if ~isfield(opts,'Z_ErpermV')
    opts.Z_ErpermV = 0.20;
end
if ~isfield(opts,'Z_CalibrationStr')
    opts.Z_CalibrationStr = '2024/10/??';
end

if ~isfield(opts,'XDT1_WperV')
    opts.XDT1_WperV = 1;
end
if ~isfield(opts,'XDT1_CalibrationStr')
    opts.XDT1_CalibrationStr = '2024/10/??';
end
if ~isfield(opts,'XDT2_WperV')
    opts.XDT2_WperV = 1;
end
if ~isfield(opts,'XDT2_CalibrationStr')
    opts.XDT2_CalibrationStr = '2024/10/??';
end
if ~isfield(opts,'FigLabel')
    opts.FigLabel='';
end
hF=figure;
hF.Name='qpd_lattice_load';
hF.Color='w';
hF.Position = [100 100 1200 300];

if ~isempty(opts.FigLabel)
    uicontrol('style','text','parent',hF,'string',FigLabel,...
        'fontsize',7,'horizontalalignment','left',...
        'backgroundcolor','w');
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
hF.UserData.Axes{1}=axes('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,4,1,hF,margins));
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
hF.UserData.Axes{2}=axes('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,4,2,hF,margins));
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
hF.UserData.Axes{3}=axes('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,4,3,hF,margins));
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
hF.UserData.Axes{4}=uitable('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,4,4,hF,margins));
tbl={
    ['X Er/mV'], [num2str(opts.X_ErpermV,'%.2f')],[opts.X_CalibrationStr];
['Y Er/mV'], [num2str(opts.Y_ErpermV,'%.2f')],[opts.Y_CalibrationStr];
['Z Er/mV'], [num2str(opts.Z_ErpermV,'%.2f')],[opts.Z_CalibrationStr];
[char(916) 'X (mV,Er)'], [num2str(1e3*dx0,'%.2f') ' ' char(177) ' ' num2str(dx0err*1e3,'%.2f')],[num2str(1e3*dx0*opts.X_ErpermV,'%.2f') ' ' char(177) ' ' num2str(dx0err*1e3*opts.X_ErpermV,'%.2f')];
[char(916) 'Y (mV,Er)'], [num2str(1e3*dy0,'%.2f') ' ' char(177) ' ' num2str(dy0err*1e3,'%.2f')], [num2str(1e3*dy0*opts.Y_ErpermV,'%.2f') ' ' char(177) ' ' num2str(dy0err*1e3*opts.Y_ErpermV,'%.2f')];
[char(916) 'Z (mV,Er)'], [num2str(1e3*dz0,'%.2f') ' ' char(177) ' ' num2str(dz0err*1e3,'%.2f')],[num2str(1e3*dz0*opts.Z_ErpermV,'%.2f') ' ' char(177) ' ' num2str(dz0err*1e3*opts.Z_ErpermV,'%.2f')]
['XDT1 W/V'], [num2str(opts.XDT1_WperV,'%.2f')],[opts.XDT1_CalibrationStr];
['XDT2 W/V'],[num2str(opts.XDT2_WperV,'%.2f')],[opts.XDT1_CalibrationStr];
['XDT1 (V,W)'], [num2str(xdt1,'%.2f') ' ' char(177) ' ' num2str(xdt1err,'%.2f')], [num2str(xdt1*opts.XDT1_WperV,'%.2f') ' ' char(177) ' ' num2str(xdt1err*opts.XDT1_WperV,'%.2f')];
['XDT2 (V,W)'], [num2str(xdt2,'%.2f') ' ' char(177) ' ' num2str(xdt2err,'%.2f')], [num2str(xdt2*opts.XDT2_WperV,'%.2f') ' ' char(177) ' ' num2str(xdt2err*opts.XDT2_WperV,'%.2f')];
};
set(hF.UserData.Axes{4},'RowName',{},'ColumnName',{},'ColumnWidth',{70 80 80},...
    'Data',tbl);
end
