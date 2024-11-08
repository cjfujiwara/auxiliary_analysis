function calib = qpd_calibrations
% qpd_calibrations.m
%
% This function output the calibrations for our QPD and monitor photodiodes
% for some important light features. Ideally, any optical potential that is
% made should have a signal that is calibrated by this file.

calib = struct;
%% QPD XDT1
calib.mVoverV_per_um_1                   = 1e3*0.000988;    
calib.mVoverV_per_um_1_CalibrationStr    = '2024/10/21, issues';
calib.XDT1_WperV                         = 1;
calib.XDT1_CalibrationStr                = '2024/10/??'; 

%% QPD XDT2

calib.mVoverV_per_um_2                   =  1e3*0.000695;
calib.mVoverV_per_um_2_CalibrationStr    = '2024/10/21, issues';
calib.XDT2_WperV                         = 1;
calib.XDT2_CalibrationStr                = '2024/10/??';

%% X Lattice
calib.X_ErpermV = 0.22;
calib.X_CalibrationStr = '2024/10/??';
%% Y Lattice
calib.Y_ErpermV = 0.128;
calib.Y_CalibrationStr = '2024/10/??';

%% ZLattice
calib.Z_ErpermV = 0.20;
calib.Z_CalibrationStr = '2024/10/??';

end

