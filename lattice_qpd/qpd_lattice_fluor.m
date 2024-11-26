function [lattice_fluor_analysis,ret] = qpd_lattice_fluor(qpd_data,opts)

if nargin==1
    opts=struct;    
end

% This looks at the last 1 second

xlatt_ind       = 7;
ylatt_ind       = 8;
zlatt_ind       = 9;

lattice_fluor_analysis = struct;
ret=true;

Nmovmean = 10;
dT = 1500; % nubmer of last ms to look at

try
    for kk=1:length(qpd_data)
       qpd=qpd_data(kk);   
       t = qpd.t;
       t = t*1e3;
       opts.StartTime = t(end)-dT; 
        i1 = find(t>opts.StartTime,1);
        tpre = t(i1:end);
        
        x=qpd.data(i1:end,xlatt_ind);
                y=qpd.data(i1:end,ylatt_ind);
        z=qpd.data(i1:end,zlatt_ind);

        
%         x = movmean(qpd.data(i1:end,xlatt_ind),Nmovmean);
%         y = movmean(qpd.data(i1:end,ylatt_ind),Nmovmean);
%         z = movmean(qpd.data(i1:end,zlatt_ind),Nmovmean);
% 
        lattice_fluor_analysis(kk).t = tpre;
        lattice_fluor_analysis(kk).X = x;
        lattice_fluor_analysis(kk).Y = y;
        lattice_fluor_analysis(kk).Z = z;

        lattice_fluor_analysis(kk).Xbar = mean(x);
        lattice_fluor_analysis(kk).Xstd = std(x);
        lattice_fluor_analysis(kk).Ybar = mean(y);
        lattice_fluor_analysis(kk).Ystd = std(y);
        lattice_fluor_analysis(kk).Zbar = mean(z);
        lattice_fluor_analysis(kk).Zstd = std(z);
    
    end
catch ME
   warning(getReport(ME,'extended','hyperlinks','on')); 
   ret = false;
end

end

