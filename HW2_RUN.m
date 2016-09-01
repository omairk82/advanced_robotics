% CS545 HW #2
% Created by M. Omair Khan
% 03/29/13

clc; clear all; close all;

global invMethod %declare inverse method toggle
% invMethod = 1; %Jacobian Transpose (prob. 1d)
% invMethod = 2; %Psuedo-Inverse (prob. 1e)
% invMethod = 3; %Psuedo-Inverse with null space optimization (prob. 1f)
% invMethod = 4; %Weighted Psuedo-Inverse (prob. 1g)
% invMethod = 5; %Weighted Psuedo-Inverse and non-weighted psuedo-invere for null optimatzion (prob. 1h)
invMethod = 6; %Weighted Psuedo-Inverse with weights to inhibit prismatic joint movement