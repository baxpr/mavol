
ticv_niigz = '../INPUTS/orig_target_seg_ticv.nii.gz';
vol_txt = '../INPUTS/target_processed_label_volumes.txt';
out_dir = '../OUTPUTS';

addpath('../NIfTI_20140122');



% Copy TICV file to output location and unzip
copyfile(ticv_niigz,fullfile(out_dir,'orig_target_seg_ticv.nii.gz'));
system(['gunzip -f ' fullfile(out_dir,'orig_target_seg_ticv.nii.gz')]);
ticv_nii = fullfile(out_dir,'orig_target_seg_ticv.nii');

% Get pixdim with NIfTI_20140122
n_affected = load_nii(ticv_nii);
pixdim_affected = n_affected.hdr.dime.pixdim(2:4);
voxvol_affected = prod(pixdim_affected);

% Get pixdim with niftiread
n_true = niftiinfo(ticv_nii);
pixdim_true = n_true.PixelDimensions;
voxvol_true = prod(pixdim_true);

% Compute error in load_nii method
vol_pcterror = 100 * (voxvol_affected-voxvol_true) / voxvol_true;

% Load the erroneous vol_txt to get ROI list
data = readtable(vol_txt,'Delimiter','comma','Format','%s%s%f');

% Fix the format of labels to be machine readable and numeric
data.LabelNumber_BrainCOLOR_ = strrep( ...
	data.LabelNumber_BrainCOLOR_, '208+209','208 209');
data.LabelNumber_BrainCOLOR_ = cellfun( ...
	@str2num, data.LabelNumber_BrainCOLOR_, 'UniformOutput',false);


