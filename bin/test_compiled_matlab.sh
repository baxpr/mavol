#!/bin/bash

xvfb-run --server-num=$(($$ + 99)) \
--server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
bash run_mavol.sh /usr/local/MATLAB/MATLAB_Runtime/v97 \
assr_label TESTPROJ-x-TESTSUBJ-x-TESTSESS-x-TESTSCAN-x-MultiAtlas_v2 \
seg_niigz ../INPUTS/orig_target_seg.nii.gz \
ticv_niigz ../INPUTS/orig_target_ticv.nii.gz \
vol_txt ../INPUTS/target_processed_label_volumes.txt \
out_dir ../OUTPUTS
