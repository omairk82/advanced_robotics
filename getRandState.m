function [ state, state_index ] = getRandState( )
%getRandState.m 
%   S = [theta thetadot x xdot]
%   returns random state that is snapped to the nearest tile location
%   For CS5454 HW3
%   M. Omair Khan
%   04/29/13

sLim = [pi/15, pi, 2.4, 2]; %distance from midpoint = 0 in each variable
%Determine zero point location for each tile variable
state = zeros(1,4);
for i=1:length(state)
    state(i) = -sLim(i) + (sLim(i)*2)*rand(); %random value within the state var limits
end %for

%snap random state value to the nearest discretized tile location
state_index = getTile(state);


end %function