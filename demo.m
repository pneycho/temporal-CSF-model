    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo to execute the spatio-Temporal JND profile of video frame calculation
% 
% CHANGES TO MAKE:
% Insert the path to the video file, and change the value
% of the variable 'inx' to whichever frame number you want.
%
% Written by Shreyan Sanyal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc
clear all

vid = VideoReader('INSERT PATH TO VIDEO FILE HERE'); %insert path to video file here

inx = 1; %change to whichever frame number you are trying to calculate
I = read(vid,inx); 
I2 = read(vid,inx+1);
fr = vid.FrameRate;
p = 7;


[T_JND_s, T_JND] = tempCsfModel(I, I2, fr, p)
