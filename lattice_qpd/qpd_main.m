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

%% Load qpd_data
src = 'X:\Data\LabJackLogs\ODTQPD';


%% XDT Modulation
if opts.doXDTModulation
    qpd_odt = qpd_od_modulation(qpd_data);
    hF(end+1) = qpd_show_odt_modulation(qpd_odt,calib);
end


end

