function [ tile_index ] = getTile( S )
%getTile.m 
%   S = [theta thetadot x xdot]
%   loc = grid location as cell in state space {theta thetadot x xdot}
%   For CS5454 HW3, problem 1a
%   M. Omair Khan
%   04/29/13

sLim = [pi/15, pi, 2.4, 2]; %distance from midpoint = 0 in each variable
tile_step = [pi/60, pi/8, 0.1, 0.2]; %[theta thetadot x xdot]
zeroPtLoc = zeros(1,4);
%Determine zero point location for each tile variable
for i=1:length(S)
    zeroPtLoc(i) = (length(-sLim(i):tile_step(i):sLim(i)) - 1)/2;
    zeroPtLoc(i) = zeroPtLoc(i) + 1; %offset index by 1 so min limit is index = 1
end %for
%zeroPtLoc

%snap entry values to tne nearest discretized tile location
for i=1:length(S)
    tile_index(i) = round(S(i)/tile_step(i)) + zeroPtLoc(i);
end %for

%fix boundary tiles
% low boundaries
x = find(tile_index <= 0);
if ~isempty(x)
    tile_index(x) = 1;
end %if
%high boundaries
for i=1:length(sLim)
    if tile_index(i) > length(-sLim(i):tile_step(i):sLim(i))
        tile_index(i) = length(-sLim(i):tile_step(i):sLim(i));
    end %if
end %for

end %function