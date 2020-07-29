This repo contains the processing script to identify c.g. both for the full airframe and for each station (spine) at which data is collected. This data is then used to update the numerical models of the aircraft.

A word document "Procedure for measuring Mass and CG" is provided describing the experimental mass and c.g. measurement procedure for the X-HALE.

The excel sheet "Mass and CG W19.xlsx" contains data as it was recorded from 10 scales on which the aircraft is placed. The excel sheet already has the formulas in it to give c.g., but the matlab code "massbalance_processing.m" is used to plot this data. The data has to be formatted in a specific way and an example of data is shown in "massbalancedata.txt". This is simply the measured portion of the data without empty spaces between any row or column.

Also available is a presentation called "Status.pptx" summarizing the current (as of Summer 2019) overall mass and c.g. of the aircraft.
