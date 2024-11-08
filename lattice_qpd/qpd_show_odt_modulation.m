function hF = qpd_show_odt_modulation(qpd_odt,opts)
if nargin == 1
    opts = struct;
end

% VperV2um1 = 0.000988;  % 2024/10/21
% VperV2um2 = 0.000695; % 2024/10/21

if ~isfield(opts,'mVoverV_per_um_1')
    opts.mVoverV_per_um_1 =  1e3*0.000988;    
end

if ~isfield(opts,'mVoverV_per_um_2')
    opts.mVoverV_per_um_2 = 1e3*0.000695;
end

if ~isfield(opts,'mVoverV_per_um_1_CalibrationStr')
    opts.mVoverV_per_um_1_CalibrationStr = '2024/10/21, issues';
end

if ~isfield(opts,'mVoverV_per_um_2_CalibrationStr')
    opts.mVoverV_per_um_2_CalibrationStr = '2024/10/21, issues';
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

%% Initialize Figure
hF=figure;
hF.Name='qpd_lattice_load';
hF.Color='w';
hF.Position = [100 100 1200 300];
clf
if ~isempty(opts.FigLabel)
    uicontrol('style','text','parent',hF,'string',FigLabel,...
        'fontsize',7,'horizontalalignment','left',...
        'backgroundcolor','w');
end


co=parula(length(qpd_odt));

co1=[    0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840
];

margins =struct;
margins.yTop = 25;
margins.yBot=60;        % y bottom margin
margins.xLeft=50;       % x left margin
margins.xRight=50;      % y right margin    
margins.ySpace=40;      % y space between objects        
margins.xSpace=50;      % x space between objects

% 
% fig=figure(1);
% fig.Position=[50 50 1200 400];
% clf
% t=linspace(0,150,100);
% co1=get(gca,'colororder');
% co = parula(length(qpd_odt));
% fig.Color='w';

%% XDT 1 Mod

hF.UserData.Axes{1}=axes('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,3,1,hF,margins));
for kk=1:length(qpd_odt)   
    t=[qpd_odt(kk).t];t=t(:);
    y2 = [qpd_odt(kk).DriftFunc1(t)];
    y2 = y2(:);
    plot(t,1e3*movmean(qpd_odt(kk).X1-y2,10),'.','color',co(kk,:));
    hold on;  
end

for kk = 1:length(qpd_odt)
    t=[qpd_odt(kk).t];t=t(:);
    y1 = feval(qpd_odt(kk).Fit1,t);
    y1 = y1(:);    
    y2 = [qpd_odt(kk).DriftFunc1(t)];
    y2 = y2(:);
    plot(t,1e3*(y1-y2),'linewidth',2,'color',co(kk,:));
    hold on     
end

xlabel('total modulation time (ms)');
ylabel('qpd1 x-response (mV/V)');
title('xdt 1')

str = ['*conversion from mV/V to  '  newline ...
    'total trap motion and atom motion is non-trivial!*'];
text(.01,.01,str,'units','normalized','HorizontalAlignment','left',...
    'verticalalignment','bottom','fontsize',7);
%% XDT 1 Mod

hF.UserData.Axes{2}=axes('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,3,2,hF,margins));
for kk=1:length(qpd_odt)   
    t=[qpd_odt(kk).t];t=t(:);
    y2 = [qpd_odt(kk).DriftFunc2(t)];
    y2 = y2(:);
    plot(t,1e3*movmean(qpd_odt(kk).X2-y2,10),'.','color',co(kk,:));
    hold on;  
end

for kk = 1:length(qpd_odt)
    t=[qpd_odt(kk).t];t=t(:);
    y1 = feval(qpd_odt(kk).Fit2,t);
    y1 = y1(:);    
    y2 = [qpd_odt(kk).DriftFunc2(t)];
    y2 = y2(:);
    plot(t,1e3*(y1-y2),'linewidth',2,'color',co(kk,:));
    hold on     
end
xlabel('total modulation time (ms)');
ylabel('qpd2 x-response (mV/V)');
title('xdt 2')

str = ['*conversion from mV/V to  '  newline ...
    'total trap motion and atom motion is non-trivial!*'];
text(.01,.01,str,'units','normalized','HorizontalAlignment','left',...
    'verticalalignment','bottom','fontsize',7);

%% summary table

amp1_bar = 1e3*mean([qpd_odt.Amp1]);
amp1_err = 1e3*std([qpd_odt.Amp1]);
amp1_bar_um = 1e3*mean([qpd_odt.Amp1]/opts.mVoverV_per_um_1);
amp1_err_um = 1e3*std([qpd_odt.Amp1]/opts.mVoverV_per_um_1);
phi1_bar = mean([qpd_odt.Phi1]/(2*pi));
phi1_err = std([qpd_odt.Phi1]/(2*pi));
s1_bar = mean([qpd_odt.Sum1]);
s1_err = std([qpd_odt.Sum1]);
s1_bar_W = mean([qpd_odt.Sum1])*opts.XDT1_WperV;
s1_err_W = std([qpd_odt.Sum1])*opts.XDT1_WperV;

amp2_bar = 1e3*mean([qpd_odt.Amp2]);
amp2_err = 1e3*std([qpd_odt.Amp2]);
amp2_bar_um = 1e3*mean([qpd_odt.Amp2]/opts.mVoverV_per_um_2);
amp2_err_um = 1e3*std([qpd_odt.Amp2]/opts.mVoverV_per_um_2);
phi2_bar = mean([qpd_odt.Phi2]/(2*pi));
phi2_err = std([qpd_odt.Phi2]/(2*pi));
s2_bar = mean([qpd_odt.Sum2]);
s2_err = std([qpd_odt.Sum2]);
s2_bar_W = mean([qpd_odt.Sum2])*opts.XDT2_WperV;
s2_err_W = std([qpd_odt.Sum2])*opts.XDT2_WperV;

hF.UserData.Axes{3}=uitable('parent',hF,'units','pixels','Position',...
    qpd_getAxisPos(1,3,3,hF,margins));
tbl={
    ['xdt1 [mV/V/um]'], [num2str(opts.mVoverV_per_um_1,'%.4f')],[opts.mVoverV_per_um_1_CalibrationStr];
    ['xdt2 [mV/V/um]'], [num2str(opts.mVoverV_per_um_2,'%.4f')],[opts.mVoverV_per_um_2_CalibrationStr];  
    ['xdt1 [W/V]'], [num2str(opts.XDT1_WperV,'%.2f')],[opts.XDT1_CalibrationStr];
    ['xdt2 [W/V]'],[num2str(opts.XDT2_WperV,'%.2f')],[opts.XDT1_CalibrationStr];
    ['xdt1 ' char(966) ' [cycle]'], [num2str(phi1_bar,'%.2f') ' ' char(177) ' ' num2str(phi1_err,'%.2f')], [' '];
    ['xdt1 amp [mV/V,um]'], [num2str(amp1_bar,'%.2f') ' ' char(177) ' ' num2str(amp1_err,'%.2f')],  [num2str(amp1_bar_um,'%.2f') ' ' char(177) ' ' num2str(amp1_err_um,'%.2f')];
    ['xdt1 pow [V,W]'], [num2str(s1_bar,'%.2f') ' ' char(177) ' ' num2str(s1_err,'%.2f')],  [num2str(s1_bar_W,'%.2f') ' ' char(177) ' ' num2str(s1_err_W,'%.2f')];
    ['xdt2 ' char(966) ' [cycle]'], [num2str(phi2_bar,'%.2f') ' ' char(177) ' ' num2str(phi2_err,'%.2f')], [' '];
    ['xdt2 amp [mV/V,um]'], [num2str(amp2_bar,'%.2f') ' ' char(177) ' ' num2str(amp2_err,'%.2f')],  [num2str(amp2_bar_um,'%.2f') ' ' char(177) ' ' num2str(amp2_err_um,'%.2f')];
    ['xdt2 pow [V,W]'], [num2str(s2_bar,'%.2f') ' ' char(177) ' ' num2str(s2_err,'%.2f')],  [num2str(s2_bar_W,'%.2f') ' ' char(177) ' ' num2str(s2_err_W,'%.2f')];
};
set(hF.UserData.Axes{3},'RowName',{},'ColumnName',{},'ColumnWidth',{110 80 130},...
    'Data',tbl);



end
