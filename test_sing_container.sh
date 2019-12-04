#!/bin/bash

singularity run \
--cleanenv \
--home `pwd`/INPUTS \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
baxpr-mavol-master-v1.0.0.simg \
assr_label TESTPROJ-x-TESTSUBJ-x-TESTSESS-x-TESTSCAN-x-MultiAtlas \
seg_niigz /INPUTS/orig_target_seg_ticv.nii.gz \
vol_txt /INPUTS/target_processed_label_volumes.txt \
out_dir /OUTPUTS
