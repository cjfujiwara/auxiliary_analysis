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

% Display this filename
disp(repmat('-',1,60));disp(repmat('-',1,60));    
disp(['Calling ' mfilename '.m']);
disp(repmat('-',1,60));disp(repmat('-',1,60));    

% Add all subdirectories for this m file
curpath = fileparts(mfilename('fullpath'));
addpath(curpath);addpath(genpath(curpath));

a = fileparts(curpath);
addpath(a);addpath(genpath(a));

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

if ~isfield(opts,'doLatticeFluor')
   opts.doLatticeFluor =true;
end

if ispc
    src='X:\LabJackLogs\ODTQPD';
else
    src= '/Volumes/main/LabJackLogs/ODTQPD';
end

if nargin<1
   npt=[]; 
end



output= struct;
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
    disp('qpd modulation analysis');
    [qpd_odt,ret] = qpd_odt_modulation(qpd_data);
    if ret
        figs{end+1} = qpd_show_odt_modulation(qpd_odt,calib,opts); 
        output.QPD_Modulation = qpd_odt;
    else
        output.QPD_Modulation = [];
        figs{end+1}={};
    end
end

%% Lattice Load
if opts.doLatticeLoad
    disp('qpd lattice load');
    [qpd_lattice,ret] = qpd_lattice_load(qpd_data);
    if ret
        output.QPD_LatticeLoad = qpd_lattice;
        figs{end+1} = qpd_show_lattice_load(qpd_lattice,calib,opts);
    else
        output.QPD_LatticeLoad = [];
        figs{end+1}={};
    end
end

%% Lattice Fluor
if opts.doLatticeFluor
    disp('qpd lattice fluor');
    [qpd_lattice_fluor_out,ret] = qpd_lattice_fluor(qpd_data);
    
    if ret
        output.QPD_LatticeFluor = qpd_lattice_fluor_out;
        figs{end+1} = qpd_show_lattice_fluor(qpd_lattice_fluor_out,calib,opts);
    else
        output.QPD_LatticeFluor = [];
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

