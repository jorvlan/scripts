The order in which you need to use these scripts to analyse pupil diameter data with Pupil Labs Eye-tracking.

1. Use 'Reformat_data_for_Interpol_TOS_Pupil_Labs.m' to reformat the raw data output.

2. Use 'interpol_convert_IDF_TXT_TOS_Pupil_Labs.m' to create a .mat structure than can be read by the interpol tooblox.

3. Use 'pupil_1st_level_TOS_Pupil_Labs.m' to analyze pupil diameter data at the individual subject level.

4. Use 'Pupil_2ndlevel_initialize.m' to initialize the .mat data structure for group analysis (statistics).

To be added: 

5. Use 'pupil_2nd_level.m' to visually inspect the group descriptives (average pupil diameter, timeseries of the pupil diameter). 
