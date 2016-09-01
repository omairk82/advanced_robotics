%fixedpolicy.m
% For CS5454 HW3, problem 1a
% M. Omair Khan
% 04/29/13

clc; clear all; close all;
addpath('..')

%initialize scenario
s0 = [0,0,0,0]; %assume scenario starts with static cart and pole
a0 = 1; %assume initial action is +1
timeout = 100000; %timeout counter

%------- Fixed Policy 1: based on theta -----
[R, Sp] = cartStep(s0,a0); %intial run to get things started;
ctr = 0; %initialize step counter
%Sp = [theta thetadot x xdot]
while R ~= -100
    if Sp(1) < 0
        a = -1;
    else
        a = 1;
    end %if
    [R, Sp] = cartStep(Sp,a); %iterate on scenario
    ctr = ctr+1; %iterate counter
    
    if ctr>timeout
        fprintf('Timeout fault protection invoked!')
        break
    end %if
end %while
fprintf('Fixed Policy 1 (based on theta) iterated %d times before failure\n',ctr)


%------- Fixed Policy 2: based on thetadot -----
[R, Sp] = cartStep(s0,a0); %intial run to get things started;
ctr = 0; %initialize step counter
%Sp = [theta thetadot x xdot]
while R ~= -100
    if Sp(2) < 0
        a = -1;
    else
        a = 1;
    end %if
    [R, Sp] = cartStep(Sp,a); %iterate on scenario
    ctr = ctr+1; %iterate counter
    
    if ctr>timeout
        fprintf('Timeout fault protection invoked!')
        break
    end %if
end %while
fprintf('Fixed Policy 2 (based on thetadot) iterated %d times before failure\n',ctr)