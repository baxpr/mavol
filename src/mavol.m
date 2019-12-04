function mavol(varargin)

% We know:
warning('off','MATLAB:table:ModifiedAndSavedVarnames')

% Parse inputs and report
P = inputParser;
addOptional(P,'assr_label','Unknown_assessor');
addOptional(P,'seg_niigz','/INPUTS/orig_target_seg.nii.gz');
addOptional(P,'vol_txt','/INPUTS/target_processed_label_volumes.txt');
addOptional(P,'out_dir','/OUTPUTS');
parse(P,varargin{:});

assr_label = P.Results.assr_label;
seg_niigz = P.Results.seg_niigz;
vol_txt = P.Results.vol_txt;
out_dir = P.Results.out_dir;

fprintf('assr_label: %s\n',assr_label);
fprintf('seg_niigz: %s\n',seg_niigz);
fprintf('vol_txt: %s\n',vol_txt);
fprintf('out_dir: %s\n',out_dir);

% Copy SEG/TICV file to output location and unzip
copyfile(seg_niigz,fullfile(out_dir,'seg.nii.gz'));
system(['gunzip -f ' fullfile(out_dir,'seg.nii.gz')]);
seg_nii = fullfile(out_dir,'seg.nii');

% Get pixdim with NIfTI_20140122
n_affected = load_nii(seg_nii);
pixdim_affected = n_affected.hdr.dime.pixdim(2:4);
voxvol_affected = prod(pixdim_affected);

% Get pixdim with niftiread
n_true = niftiinfo(seg_nii);
pixdim_true = n_true.PixelDimensions;
voxvol_true = prod(pixdim_true);

% Compute error in load_nii method
vol_pcterror = 100 * (voxvol_affected-voxvol_true) / voxvol_true;

% Load the erroneous vol_txt to get ROI list
rois = readtable(vol_txt,'Delimiter','comma','Format','%s%s%f');

% Fix the format of labels to be machine readable and numeric
rois.label = strrep( ...
	rois.LabelNumber_BrainCOLOR_, '208+209','208 209');
rois.label = cellfun( ...
	@str2num, rois.label, 'UniformOutput',false);

% Fix the region names too
rois.name = cellfun(@(x) strrep(x,' ','_'),rois.LabelName_BrainCOLOR_, ...
	'UniformOutput',false);
rois.name = cellfun(@lower,rois.name,'UniformOutput',false);
rois.name = cellfun(@matlab.lang.makeValidName,rois.name,'UniformOutput',false);

% Load the TICV image
seg = niftiread(seg_nii);

% Compute volumes and write to output file
results = table(vol_pcterror,'VariableNames',{'load_nii_vol_pcterror'});
for r = 1:height(rois)
	voxels = sum( ismember(seg(:),rois.label{r}) );
	results.([rois.name{r} '_mm3']) = voxels * voxvol_true;
end
writetable(results,fullfile(out_dir,'stats.csv'));

% Make PDF


% Exit if we're compiled
if isdeployed
	exit(0)
end

