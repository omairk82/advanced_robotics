% [R Sp] = function cartStep(s, a)
% Function to compute the next step and reward given a current state
% vector, s, and an action, a (-1 or 1).
% The state vector has 4 components, namely [theta thetadot x xdot],
% defined in the assignment.
% This code was taken from cpole.c, written by Richard S. Sutton.

function [R Sp] = cartStep(s, a)

GRAV=9.8;
MASSC=1.0;
MASSP=0.1;
TOTALMASS=MASSC+MASSP;
LENGTH=0.5;
MASSLENGTH=LENGTH * MASSP;
FORCE=10;
TAU=0.02;

f = a * FORCE;
cost = cos(s(1));
sint = sin(s(1));

t = (f + MASSLENGTH * s(2)^2 * sint) / TOTALMASS;
tacc = (GRAV * sint - cost * t) / (LENGTH * (4.0 / 3.0 - ...
    MASSP * cost^2 / TOTALMASS));
xacc = t - MASSLENGTH * tacc * cost / TOTALMASS;

x = s(3) + TAU * s(4);
xdot = s(4) + TAU * xacc;
theta = s(1) + TAU * s(2);
thetadot = s(2) + TAU * tacc;

Sp = [theta thetadot x xdot];

% Check whether we went outside our boundaries
if (abs(x) > 2.4 || abs(theta) > 24*pi / 360)
    R = -100;
else
    R = 1;
end