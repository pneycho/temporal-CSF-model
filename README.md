# temporal-CSF-model
>By Shreyan Sanyal

Estimates the spatio-temporal Just Noticeable Difference profile of video frames!

This is a *personal* implementation of the paper "Spatio-Temporal Just Noticeable Distortion Profile for Grey Scale Image/Video in DCT Domain". If you use this code, you must cite the following paper:

` Spatio-Temporal Just Noticeable Distortion Profile for Grey Scale Image/Video in DCT Domain", Zhenyu Wei and King N. Ngan, IEEE Transactions on Circuits and Systems for Video Technology, Vol.19, No.3, March 2009 `


## Requirements:
This program requires a block-matching motion estimation algorithm to calculate the temporal JND profile. I have used the Adaptive Rood Pattern Search algorithm (The motionEstARPS function in line 136). You can download it from [here]( https://in.mathworks.com/matlabcentral/fileexchange/8761-block-matching-algorithms-for-motion-estimation ).
Other techniques would work as well. 

[MATLAB](https://in.mathworks.com/products.html)


## Quickstart:

Edit (Put in the video file location) and run `demo.m` to get started.
So,
#### Input: 
Video file

#### Output: 
T_JND_s =  Spatial JND Profile

T_JND = Temporal JND Profile
