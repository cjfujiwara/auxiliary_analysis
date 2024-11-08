function [hF,output] = qpd_main(npt,opts)
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
%% Default Settings
if nargin == 1
    opt = struct;
end

if ~isfield(opts,'doLatticeLoad')
    opts.doLatticeLoad = true;
end

if ~isfield(opts,'doXDTModulation')
    opts.doXDTModulation = true;
end

if isfield
    src='X:\LabJackLogs\ODTQPD';
else
    src= '/Volumes/main/LabJackLogs/ODTQPD';
end

%% Load qpd_data




%% XDT Modulation
if opts.doXDTModulation
    qpd_odt = qpd_od_modulation(qpd_data);
    hF(end+1) = qpd_show_odt_modulation(qpd_odt,calib);
end


end
function data = getDataRecent(src)
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
    end
end

function data=getData(d,src)
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
    end
end

