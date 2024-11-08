function qpd_lattice = qpd_lattice_load(qpd_data,opts)

if nargin==1
    opts=struct;    
end

if ~isfield(opts,'StartTime')
   opts.StartTime = 'auto'; 
end


xdt1_ind        = 3;
xdt2_ind        = 6;
xlatt_ind       = 7;
ylatt_ind       = 8;
zlatt_ind       = 9;

qpd_lattice = struct;


for kk=1:length(qpd_data)
   qpd=qpd_data(kk);   
   t = qpd.t;
   t = t*1e3;

   if isequal(opts.StartTime,'auto')
        ind = 10;
        iStart=max(find(diff(qpd.data(:,ind))==1));    
        opts.StartTime = t(iStart);
   end

    i1 = find(t>opts.StartTime,1);

    tpre = t(1:i1);
    x = movmean(qpd.data(1:i1,xlatt_ind),10);
    y = movmean(qpd.data(1:i1,ylatt_ind),10);
    z = movmean(qpd.data(1:i1,zlatt_ind),10);

    xdt1 = mean(qpd.data(1:i1,xdt1_ind));
    xdt1Err=std(qpd.data(1:i1,xdt1_ind));
    xdt2 = mean(qpd.data(1:i1,xdt2_ind));
    xdt2Err=std(qpd.data(1:i1,xdt2_ind));

    FitX=minJerkLoadFit(tpre,x);    cIx = confint(FitX,0.66);
    FitY=minJerkLoadFit(tpre,y);    cIy = confint(FitY,0.66);
    FitZ=minJerkLoadFit(tpre,z);    cIz = confint(FitZ,0.66);

    qpd_lattice(kk).t = tpre;
    qpd_lattice(kk).X = x;
    qpd_lattice(kk).Y = y;
    qpd_lattice(kk).Z = z;


    qpd_lattice(kk).XDT1 = xdt1;
    qpd_lattice(kk).XDT1Err = xdt1Err;
    qpd_lattice(kk).XDT2 = xdt2;
    qpd_lattice(kk).XDT2Err = xdt2Err;
    qpd_lattice(kk).FitX = FitX;
    qpd_lattice(kk).dX = FitX.dy;
    qpd_lattice(kk).dXErr = 0.5*(cIx(2,1)-cIx(1,1));
    qpd_lattice(kk).FitY = FitY;
    qpd_lattice(kk).dY = FitY.dy;
    qpd_lattice(kk).dYErr = 0.5*(cIy(2,1)-cIy(1,1));
    qpd_lattice(kk).FitZ = FitZ;
    qpd_lattice(kk).dZ = FitZ.dz;
    qpd_lattice(kk).dZErr = 0.5*(cIz(2,1)-cIz(1,1));
end

end

function fout=minJerkLoadFit(t,y,opts)
    myfit = fittype(@(y0,dy,t0,T,t) min_jerk(y0,dy,t0,T,t),'independent','t',...
        'coefficients',{'y0','dy','t0','T'});
    fitopt = fitoptions(myfit);
    y0_guess = mean(y(1:10));
    y1_guess = mean(y(end-10:end));
    dy_guess = y1_guess-y0_guess;
    t0_guess = 0;
    T_guess = mean(t);

    fitopt.StartPoint = [y0_guess dy_guess t0_guess T_guess];
    fout = fit(t(:),y(:),myfit,fitopt);
end

function y=min_jerk(y0,dy,t0,T,t)
    y = y0+dy*(6*((t-t0)/T).^5-15*((t-t0)/T).^4+10*((t-t0)/T).^3).*[t>=t0].*[t<(t0+T)] + dy.*[t>=(t0+T)];
end

