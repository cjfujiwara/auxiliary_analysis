function XDT_Modulation=qpd_odt_modulation(qpd_data,opts)

if nargin==1
    opts=struct;    
end

if ~isfield(opts,'Frequency')
   opts.Frequency = 55; 
end

if ~isfield(opts,'RampTime')
   opts.RampTime = 50; 
end

if ~isfield(opts,'ModulationTime')
   opts.ModulationTime = 50; 
end

if ~isfield(opts,'StartTime')
   opts.StartTime = 'auto'; 
end

% Conversion from V/V to position athe atoms
% NOTE THAT THIS CALBIRATION WAS NOT DONE PROPLERY AND ASSUMES AN IN PHASE
% DRIVE WITH APPRIORPIATE MOTION.

opts.X1_name = 'X1';
opts.Y1_name = 'Y1';
opts.S1_name = 'SUM1';
    
opts.X2_name = 'X2';
opts.Y2_name = 'Y2';
opts.S2_name = 'SUM2';   
XDT_Modulation = struct;

for kk=1:length(qpd_data)
   qpd=qpd_data(kk);
   
   t = qpd.t;
   t = t*1e3;
   
   total_time = opts.RampTime+opts.ModulationTime;

   if isequal(opts.StartTime,'auto')
        ind = 10;
        iStart=max(find(diff(qpd.data(:,ind))==1));    
        opts.StartTime = t(iStart)-opts.RampTime;
   end
   iStart = find(t>opts.StartTime,1);      
   t=t-opts.StartTime;   
   iEnd = find(t>total_time,1)-1;   
   inds=iStart:iEnd;      
   t = t(inds); 
   
   x1 = qpd.data(inds,1)./qpd.data(inds,3);
   y1 = qpd.data(inds,2)./qpd.data(inds,3);
   
   s1 = mean(qpd.data(inds,3));
   s1err = std(qpd.data(inds,3));

    x2 = qpd.data(inds,4)./qpd.data(inds,6);
    y2 = qpd.data(inds,5)./qpd.data(inds,6);
    s2 = mean(qpd.data(inds,6));
    s2err = std(qpd.data(inds,6));
   
    fit1 = sinefit(t(:),x1(:),1e-3*opts.Frequency,opts.RampTime);
    cI1=confint(fit1,0.667);     
    fit2 = sinefit(t(:),x2(:),1e-3*opts.Frequency,opts.RampTime);
    cI2=confint(fit1,0.667);
    
    XDT_Modulation(kk).t = t;
    XDT_Modulation(kk).X1         = x1;
    XDT_Modulation(kk).Fit1       = fit1;  
    XDT_Modulation(kk).Sum1       = s1;
    XDT_Modulation(kk).Sum1Err    = s1err;
    XDT_Modulation(kk).Amp1       = fit1.amp;
    XDT_Modulation(kk).Amp1Err    = 0.5*(cI1(2,1)-cI1(1,1));
    XDT_Modulation(kk).Phi1       = fit1.phase;
    XDT_Modulation(kk).Phi1Err     = 0.5*(cI1(2,2)-cI1(1,2));
    XDT_Modulation(kk).DriftFunc1  = @(t) fit1.offset + fit1.v*t +fit1.a*t.^2;

    XDT_Modulation(kk).X2         = x2;
    XDT_Modulation(kk).Fit2       = fit2;  
    XDT_Modulation(kk).Sum2       = s2;
    XDT_Modulation(kk).Sum2Err    = s2err;
    XDT_Modulation(kk).Amp2       = fit2.amp;
    XDT_Modulation(kk).Amp2Err    = 0.5*(cI2(2,1)-cI2(1,1));
    XDT_Modulation(kk).Phi2       = fit2.phase;
    XDT_Modulation(kk).Phi2Err     = 0.5*(cI2(2,2)-cI2(1,2));  
    XDT_Modulation(kk).DriftFunc2  = @(t) fit2.offset + fit2.v*t +fit2.a*t.^2;

end

end

function fout = sinefit(t,y,f,RampTime)
    env = @(t) [t>=RampTime]+[t<RampTime].*t/RampTime;
    myfunc = @(A,B,C,D,E,t) env(t).*A.*sin(2*pi*t*f + B) + C + D*t + E*t.^2;        
    myfit = fittype(@(amp,phase,offset,v,a,t) myfunc(amp,phase,offset,v,a,t),'independent',{'t'},...
        'coefficients',{'amp','phase','offset','v','a'});
    opt = fitoptions(myfit);
    opt.StartPoint = [(max(y)-min(y))*.5 0 mean(y) 0 0];
    fout = fit(t,y,myfit,opt);    
end