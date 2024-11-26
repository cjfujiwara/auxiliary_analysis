function hF = qpd_show_lattice_fluor(data,calib,opt)
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
    set(opt.Parent,'Name','qpd_lattice_fluor','color','w',...
        'Position',[100 100 1600 350])
    clf(opt.Parent)

else
    clf(opt.Parent)
end


if ~isempty(opt.FigLabel)
    uicontrol('style','text','parent',opt.Parent,'string',opt.FigLabel,...
        'fontsize',7,'horizontalalignment','left',...
        'backgroundcolor','w','Position',[0 0 600 15]);
end

co=parula(length(data));

margins =struct;
margins.yTop = 25;
margins.yBot=60;        % y bottom margin
margins.xLeft=50;       % x left margin
margins.xRight=50;      % y right margin    
margins.ySpace=40;      % y space between objects        
margins.xSpace=50;      % x space between objects
%% X
opt.Parent.UserData.Axes{1}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,5,1,opt.Parent,margins));
co1=get(gca,'colororder');
for kk=1:length(data)   
    plot(data(kk).t,1e3*data(kk).X,'.','color',co(kk,:));
    hold on
end
xlabel('time (ms)')
ylabel('x lattice (mV)');
title('x lattice');


% strX1 = ['$' num2str(round(1e3*data.Xbar)) ...
%      '~\mathrm{mV}\pm' ...
%      num2str(round(1e3*data.Xstd)) '~\mathrm{mV}$'];
% 
% strX2 = ['$' num2str(round(1e3*calib.X_ErpermV*data.Xbar)) ...
%     '~E_R\pm' ...
%     num2str(round(1e3*calib.X_ErpermV*data.Xstd)) '~E_R$'];
% strX=[strX1 newline strX2];
% text(.01,.01,strX,'interpreter','latex','units','normalized',...
%     'horizontalalignment','left','verticalalignment','bottom');

%% y
opt.Parent.UserData.Axes{2}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,5,2,opt.Parent,margins));
for kk=1:length(data)
    plot(data(kk).t,1e3*data(kk).Y,'.','color',co(kk,:));
    hold on
end

xlabel('time (ms)')
ylabel('y lattice (mV)');
title('y lattice');

% strY1 = ['$' num2str(round(1e3*data.Ybar)) ...
%      '~\mathrm{mV}\pm' ...
%      num2str(round(1e3*data.Ystd)) '~\mathrm{mV}$'];
% 
% strY2 = ['$' num2str(round(1e3*calib.Y_ErpermV*data.Ybar)) ...
%     '~E_R\pm' ...
%     num2str(round(1e3*calib.Y_ErpermV*data.Ystd)) '~E_R$'];
% strY=[strY1 newline strY2];
% text(.01,.01,strY,'interpreter','latex','units','normalized',...
%     'horizontalalignment','left','verticalalignment','bottom');

%% z
opt.Parent.UserData.Axes{3}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,5,3,opt.Parent,margins));
for kk=1:length(data)
    plot(data(kk).t,1e3*data(kk).Z,'.','color',co(kk,:));
    hold on
end

xlabel('time (ms)')
ylabel('z lattice (mV)');
title('z lattice');

% strZ1 = ['$' num2str(round(1e3*data.Zbar)) ...
%      '~\mathrm{mV}\pm' ...
%      num2str(round(1e3*data.Zstd)) '~\mathrm{mV}$'];
% strZ2 = ['$' num2str(round(1e3*calib.Z_ErpermV*data.Zbar)) ...
%     '~E_R\pm' ...
%     num2str(round(1e3*calib.Z_ErpermV*data.Zstd)) '~E_R$'];
% strZ=[strZ1 newline strZ2];
% text(.01,.01,strZ,'interpreter','latex','units','normalized',...
%     'horizontalalignment','left','verticalalignment','bottom');

%% Versus Var
opt.Parent.UserData.Axes{4}=axes('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,5,4,opt.Parent,margins));
    
co1=get(gca,'colororder');

if isfield(opt,'X')
   xxx = 1:length(data); 
   lbl=opt.xVar;
else
    xxx=opt.X;
   lbl='index';
end

errorbar(xxx,calib.X_ErpermV*[data.Xbar]*1e3,calib.X_ErpermV*[data.Xstd]*1e3,'o','color',.5*co1(1,:),'markerfacecolor',co1(1,:));
hold on
errorbar(xxx,calib.Y_ErpermV*[data.Ybar]*1e3,calib.Y_ErpermV*[data.Ystd]*1e3,'o','color',.5*co1(2,:),'markerfacecolor',co1(2,:));
errorbar(xxx,calib.Z_ErpermV*[data.Zbar]*1e3,calib.Z_ErpermV*[data.Zstd]*1e3,'o','color',.5*co1(3,:),'markerfacecolor',co1(3,:));


xlabel(lbl)
ylabel('depth (Er)');
%%

X0=mean([data.Xbar]);
XE = std([data.Xbar]);

Y0=mean([data.Ybar]);
YE = std([data.Ybar]);

Z0=mean([data.Zbar]);
ZE = std([data.Zbar]);

%% summary table
opt.Parent.UserData.Axes{4}=uitable('parent',opt.Parent,'units','pixels','Position',...
    qpd_getAxisPos(1,5,5,opt.Parent,margins));
tbl={
    ['X Er/mV'], [num2str(calib.X_ErpermV,'%.2f')],[calib.X_CalibrationStr];
['Y Er/mV'], [num2str(calib.Y_ErpermV,'%.2f')],[calib.Y_CalibrationStr];
['Z Er/mV'], [num2str(calib.Z_ErpermV,'%.2f')],[calib.Z_CalibrationStr];
[char(916) 'X (mV,Er)'], [num2str(1e3*X0,'%.0f') ' ' char(177) ' ' num2str(1e3*XE,'%.0f')], [num2str(1e3*X0*calib.X_ErpermV,'%.0f') ' ' char(177) ' ' num2str(1e3*XE*calib.X_ErpermV,'%.0f')];
[char(916) 'Y (mV,Er)'], [num2str(1e3*Y0,'%.0f') ' ' char(177) ' ' num2str(1e3*YE,'%.0f')],[num2str(1e3*Y0*calib.Y_ErpermV,'%.0f') ' ' char(177) ' ' num2str(1e3*YE*calib.Y_ErpermV,'%.0f')];
[char(916) 'Z (mV,Er)'], [num2str(1e3*Z0,'%.0f') ' ' char(177) ' ' num2str(1e3*ZE,'%.0f')],[num2str(1e3*Z0*calib.Z_ErpermV,'%.0f') ' ' char(177) ' ' num2str(1e3*ZE*calib.Z_ErpermV,'%.0f')]
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
