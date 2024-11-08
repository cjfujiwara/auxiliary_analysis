function [figs,output] = qpd_main(npt,opts)
% qpd_main.m
%
% This function is the main analysis for the QPD data that is produced by
% the labjack.
%
% npt - the input can take different forms
%     ExecutionDates : this is useful if you have a data set that you want
%     to compare the qpd data to. The file name of every QPD file should be
%     associatd with the ExecutionDate associated with a particular run of
%     the sequencer.
%
%     Empty : This is useful if you just want to watch the most recent
%     data. By default this will simply just output the most recent labjack
%     trace
%
% opts - options

% Source Directory for files


calib = qpd_calibrations;

figs={};
%% Default Settings
if nargin <2
    opts = struct;
end

if ~isfield(opts,'doLatticeLoad')
    opts.doLatticeLoad = true;
end

if ~isfield(opts,'doXDTModulation')
    opts.doXDTModulation = true;
end

if ispc
    src='X:\LabJackLogs\ODTQPD';
else
    src= '/Volumes/main/LabJackLogs/ODTQPD';
end

if nargin<1
   npt=[]; 
end


%% Load qpd_data

if isempty(npt)
    [qpd_data,ret] = getDataRecent(src);
    if ~ret
       return; 
    end
else
    disp(['gathering ' num2str(length(npt)) ' qpd files']);
    for kk=1:length(npt)
        [data,ret]=getData(npt(kk),src);
        if ret            
            if ~exist('qpd_data','var')
                qpd_data(1) = data;
            else
                qpd_data(end+1)=data;
            end
        end
    end
end


%% XDT Modulation
if opts.doXDTModulation
    [qpd_odt,ret] = qpd_odt_modulation(qpd_data);
    if ret
        figs{end+1} = qpd_show_odt_modulation(qpd_odt,calib); 
    else
        figs{end+1}={};
    end
end

%% Lattice Load
if opts.doLatticeLoad
    [qpd_lattice,ret] = qpd_lattice_load(qpd_data);
    if ret
        figs{end+1} = qpd_show_lattice_load(qpd_lattice,calib);
    else
        figs{end+1}={};
    end
end

end
function [data,ret] = getDataRecent(src)
    ret=true;
    d = now;
    YYYY=datestr(d,'YYYY');
    mm = datestr(d,'mm');
    dd = datestr(d,'dd');
    pd_dir = fullfile(src,YYYY,[YYYY '.' mm],[mm '.' dd]);
    flist=dir([pd_dir filesep 'ODTQPD_*.mat']);
    filename=flist(end).name;
    fullfilename = fullfile(pd_dir,filename);
    if exist(fullfilename,'file')
        data=load(fullfilename); 
    else
        warning('unable to find file');
        disp(fullfilename);
        ret=false;
    end
end

function [data,ret]=getData(d,src)
    ret=true;
    YYYY=datestr(d,'YYYY');
    mm = datestr(d,'mm');
    dd = datestr(d,'dd');

    fdate = datestr(d,'YYYY-mm-dd_HH-MM-SS');
    pd_dir = fullfile(src,YYYY,[YYYY '.' mm],[mm '.' dd]);
    filename = ['ODTQPD_' fdate '.mat'];

    fullfilename = fullfile(pd_dir,filename);

    if exist(fullfilename,'file')
        data=load(fullfilename); 
    else
        warning('unable to find file');
        disp(fullfilename);
        ret=false;
    end
end

