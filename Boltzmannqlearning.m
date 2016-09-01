function [q, itr] = Boltzmannqlearning(episode_lim)
% Boltzmannqlearning.m
% Runs the q-learning algorithm with boltzmann exploration
% input is the number of episodes to run
% output is the last updated q table and the number of iterations in each episode
% For CS5454 HW3, problem 1
% M. Omair Khan
% 04/29/13
clc; close all;
addpath('..')
format compact

gamma=0.90;            % learning parameter
q = qValueTable2(0);   % initialize Q-Value Table as zeros
q1= qValueTable2(inf); % initialize previous Q-Valut Table as large number
count=0;               % counter
goal = -100;           % episode stop condition
sLim = [pi/15, pi, 2.4, 2]; %distance from midpoint = 0 in each variable
fprintf('Working up to %d episodes\n',episode_lim)
T_high = 9; T_low = -3;%T raised to the power of 10 limits based on getting float values not equal to inf from matlab
T = logspace(T_high,T_low,episode_lim); %Temperature parameter drops at equal log space values over length episode_lim
% try
for episode=1:episode_lim
   if mod(episode,episode_lim/20)==0;fprintf('Made progress up to episode %d\n',episode);end %if
   R=0;% reset episode's initial R value
   if episode == 1 %initial state is always [0,0,0,0] 
       state = [0,0,0,0];
       si = getTile(state);
   else
       [state, si] = getRandState(); % generate random initial state for the episode
   end %if
   itr(episode)=0; %reset iteration counter for the episode
   a=0; %initialize action to dummy value;
   while R>goal
       if a==0 %take random action for the first permutation of the new episode
           % determine action, a = -1 or 1
           if sum(state < -sLim)==0 && sum(state > sLim)==0
               if round(rand()) == 0; a = -1; else a = 1; end %chose random action
           elseif sum(state < -sLim)>0
               a = 1; %condition if at low low edge of boundary
           elseif sum(state < -sLim)>0
               a = -1; %conidtion if at high edge of boundary
           end %if
       end %if
       %if a != 0, then use the action that is passed from the q-learning iteration

       % determine reward for action, a
       R = cartStep(state,a);
       if a==-1; ai=2;else ai=a;end %if %replace a=-1 with integer index

       %determine rewards for the next potential states
       [R_a1, ns_a1] = cartStep(state,1);
       ns_a1i = getTile(ns_a1);
       qVal_a1 = q(ns_a1i(1), ns_a1i(2), ns_a1i(3), ns_a1i(4),1); %action = 1 corresponds to dim=1
       [R_am1, ns_am1] = cartStep(state,-1);
       ns_am1i = getTile(ns_am1);
       qVal_am1 = q(ns_am1i(1), ns_am1i(2), ns_am1i(3), ns_am1i(4),2); %action = -1 corresponds to dim=2

       %Value for potential next states based on Boltzmann exploration
       P = zeros(1,2);
       for i=[1,2] %i==1 -> a=1 ; i==2 -> a=-1
           if i==1; qVal = qVal_a1; else qVal = qVal_am1; end %if %set proper q-value
           num = exp( qVal / T(episode) );
           den = exp( sum(qVal_a1 + qVal_am1) / T(episode) );
           P(i) = num/den;
       end %for
       [Pmax,b] = max(P);
       if b==1; qMax = qVal_a1; else qMax = qVal_am1; end% if %apply more probable state's Q value for Q table update

       %Q-table = [[theta],[thetadot],[x],[xdot],[action]]-> multidimensional matrix

       %Q-learning update to Q-value table
       q(si(1),si(2),si(3),si(4),ai)= R + gamma*qMax; %assuming learning rate, alpha = 1
       %keyboard
       %itr(episode),si,q(si(1),si(2),si(3),si(4),ai),R %Debug print
       if R>goal
           %update the state based on action taken
           if b==1 %state corresponding to action = 1
               state=ns_a1;
               si = ns_a1i;
               a=1;
           else %state corresponding to action = -1
               state=ns_am1;
               si = ns_am1i;
               a=-1;
           end %if
           %keyboard
           itr(episode) = itr(episode)+1; %update episonde's iteration counter
       end %if
   end %while
   % break if convergence: small deviation on q for 1000 consecutive runs
   qDiff = sum(sum(sum(sum(sum(abs(q1-q)))))); %one sum fxn call for each dimension of q
   qSum = sum(sum(sum(sum(sum(q))))); %one sum fxn call for each dimension of q
   if qDiff<0.0001 && qSum~=0
      if count>1000 %covergence met with sufficient iterations!
         episode % report last episode
         break
      else
         count=count+1; % set counter if deviation of q is small
      end
   else
      q1=q;
      count=0; % reset counter when deviation of q from previous q is large
   end
end

semilogx(T,itr,'.')
xlabel('Temperature parameter value (T)')
ylabel('# of iterations in episode')
figure;
plot(T,itr,'.')
xlabel('Temperature parameter value (T)')
ylabel('# of iterations in episode')
[aa,bb] = max(itr);
fprintf('max iterations in an episode = %d, where T = %g in episode %d\n',aa,T(bb),bb)
% catch
%     keyboard
% end %catch

