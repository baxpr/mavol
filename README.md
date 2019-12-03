Correct computation of regional from multi-atlas outputs

There is a bug in this Matlab Nifti toolbox:
https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image
The load_nii function returns incorrect values for the pixdim fields of the Nifti header. The related functions load_nii_hdr and load_untouch_nii return the correct values for the pixdim fields.

The load_nii bug affected some version of the multi-atlas segmentation pipeline, e.g.
https://github.com/vuiiscci/Multi_Atlas_app
The regional volume estimates in the VOL_TXT/target_processed_label_volumes.txt file were underestimated in many cases.

The code here loads the multi-atlas segmentation image (SEG/orig_target_seg.nii.gz) and computes correct regional volumes. It also reports the size of the error in the output of any multi-atlas pipeline that was affected by the bug.

As an alternative for the Matlab Nifti toolbox, newer versions of matlab have niftiread, niftiinfo, and niftiwrite functions. Another possibility is SPM12, which provides tools for reading and writing Nifti files.

