function [odt_modulation_analysis,isGood]=qpd_odt_modulation(qpd_data,opts)

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

odt_modulation_analysis = struct;

x1_ind = 1;
y1_ind = 2;
s1_ind = 3;
x2_ind = 4;
y2_ind = 5;
s2_ind = 6;

isGood = true;

try
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

       x1 = qpd.data(inds,x1_ind)./qpd.data(inds,s1_ind);
       y1 = qpd.data(inds,y1_ind)./qpd.data(inds,s1_ind);

       s1 = mean(qpd.data(inds,s1_ind));
       s1err = std(qpd.data(inds,s1_ind));

        x2 = qpd.data(inds,x2_ind)./qpd.data(inds,s2_ind);
        y2 = qpd.data(inds,y2_ind)./qpd.data(inds,s2_ind);
        s2 = mean(qpd.data(inds,s2_ind));
        s2err = std(qpd.data(inds,s2_ind));

%         fit1 = sinefit(t(:),x1(:),1e-3*opts.Frequency,opts.RampTime);
        fit1 = sinefit(t(:),x1(:),opts.RampTime);

        cI1=confint(fit1,0.667);     
%         fit2 = sinefit(t(:),x2(:),1e-3*opts.Frequency,opts.RampTime);
        fit2 = sinefit(t(:),x2(:),opts.RampTime);

        cI2=confint(fit1,0.667);

        odt_modulation_analysis(kk).t = t;
        odt_modulation_analysis(kk).X1         = x1;
        odt_modulation_analysis(kk).Fit1       = fit1;  
        odt_modulation_analysis(kk).Sum1       = s1;
        odt_modulation_analysis(kk).Sum1Err    = s1err;
        odt_modulation_analysis(kk).Amp1       = fit1.amp;
        odt_modulation_analysis(kk).Amp1Err    = 0.5*(cI1(2,1)-cI1(1,1));
        odt_modulation_analysis(kk).Phi1       = fit1.phase;
        odt_modulation_analysis(kk).Phi1Err     = 0.5*(cI1(2,2)-cI1(1,2));
        odt_modulation_analysis(kk).Freq1       = fit1.freq;
        odt_modulation_analysis(kk).Freq1Err     = 0.5*(cI1(2,6)-cI1(1,6));
        odt_modulation_analysis(kk).DriftFunc1  = @(t) fit1.offset + fit1.v*t +fit1.a*t.^2;

        odt_modulation_analysis(kk).X2         = x2;
        odt_modulation_analysis(kk).Fit2       = fit2;  
        odt_modulation_analysis(kk).Sum2       = s2;
        odt_modulation_analysis(kk).Sum2Err    = s2err;
        odt_modulation_analysis(kk).Amp2       = fit2.amp;
        odt_modulation_analysis(kk).Amp2Err    = 0.5*(cI2(2,1)-cI2(1,1));
        odt_modulation_analysis(kk).Phi2       = fit2.phase;
        odt_modulation_analysis(kk).Phi2Err     = 0.5*(cI2(2,2)-cI2(1,2));  
        odt_modulation_analysis(kk).Freq2       = fit2.freq;
        odt_modulation_analysis(kk).Freq2Err     = 0.5*(cI2(2,6)-cI2(1,6));
        odt_modulation_analysis(kk).DriftFunc2  = @(t) fit2.offset + fit2.v*t +fit2.a*t.^2;
    end
catch ME
   warning(getReport(ME,'extended','hyperlinks','on')); 
   isGood = false;
end

end

function fout = sinefit(t,y,RampTime)
    env = @(t) [t>=RampTime]+[t<RampTime].*t/RampTime;
    myfunc = @(A,B,C,D,E,freq,t) env(t).*A.*sin(2*pi*t*freq + B) + C + D*t + E*t.^2;        
    myfit = fittype(@(amp,phase,offset,v,a,freq,t) myfunc(amp,phase,offset,v,a,freq,t),'independent',{'t'},...
        'coefficients',{'amp','phase','offset','v','a','freq'});
    opt = fitoptions(myfit);
    
    % Sampling frequency in kHz (ms is the time base)    
    Fs = 1/(t(2)-t(1));
    
    % Step size is 1/100 of the total time
    N100 = floor(length(t)/100);
    S=zeros(100,1);
    dt = N100/Fs;
    for kk=1:100
       S(kk)=sum(circshift(y,kk*N100).*y);
    end
    S=S-mean(S);
    L=length(S);
    f = 1/L*(0:(L/2))/dt;
    Y = fft(S);    
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);    
    [~,ind]=max(P1);
    fguess = f(ind);    
    
    cS=sum(sin(2*pi*fguess*t).*(y-mean(y)));
    cC=sum(cos(2*pi*fguess*t).*(y-mean(y)));
    
    cS0=cS/sqrt(cS^2+cC^2);
    cC0=cC/sqrt(cS^2+cC^2);

    phase_guess=atan2(cC0,cS0);
    
    if round(mod(phase_guess,2*pi)/pi) == 1
        amp_guess = (max(y)-min(y))*.5;
        phase_guess=mod(phase_guess+pi,2*pi);
    else
        amp_guess = -(max(y)-min(y))*.5;
        phase_guess=phase_guess;
    end

    opt.StartPoint = [amp_guess phase_guess mean(y) 0 0 fguess];       

    fout = fit(t,y,myfit,opt);        
end

function fout = sinefitFreq(t,y,f,RampTime)
    env = @(t) [t>=RampTime]+[t<RampTime].*t/RampTime;
    myfunc = @(A,B,C,D,E,t) env(t).*A.*sin(2*pi*t*f + B) + C + D*t + E*t.^2;        
    myfit = fittype(@(amp,phase,offset,v,a,t) myfunc(amp,phase,offset,v,a,t),'independent',{'t'},...
        'coefficients',{'amp','phase','offset','v','a'});
    opt = fitoptions(myfit);
    opt.StartPoint = [(max(y)-min(y))*.5 0 mean(y) 0 0];
    fout = fit(t,y,myfit,opt);    
end
