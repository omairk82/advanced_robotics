function [] = generatePotentialField2(xLims,yLims,obstacles,includeRand,goals)
% generatePotentialField.m
% Plots a vector field with the given inputs
% xLim = [x1,x2] -> limits of x-component of meshgrid
% yLim = [y1,y2] -> limits of y-component of meshgrid
% obstables = {[x0,y0],[x1,y1],[x2,y2],...} -> obstacle locations input as cell
% includeRand = boolean for whether or not to include a random field overlay
% goals = {[x0,y0],[x1,y1],[x2,y2],...} -> goal locations input as cell
% magnitude on goals vectors will be double those of obstacles
% For CS5454 HW3, problem 3a
% M. Omair Khan
% 04/29/13

close all; format compact;

%Establish base x & y vectors for use in potential field plot
space_step = 50;
[x,y] = meshgrid(linspace(xLims(1),xLims(2),space_step),linspace(yLims(1),yLims(2),space_step));

%initialize gradients for the field
dx = zeros(length(x),length(y),length(obstacles)); dy=zeros(length(x),length(y),length(obstacles));

%define infinte values for potential field
hugeVal = 10;

%add obstacles
str = 'Added Obstacles\n';
fprintf(str)
xgrid = linspace(xLims(1),xLims(2),space_step);
ygrid = linspace(yLims(1),yLims(2),space_step);
for i = 1:length(obstacles)
    obsx(i) = obstacles{i}(1); obsy(i) = obstacles{i}(2); %initialize u and v vectors due to obstacles
    obsr(i) = obstacles{i}(3); %obstacle's radius
    obss(i) = obstacles{i}(4); %obstacle's sphere of incluence
    beta = 2; %fix scaling factor for all obstacles
    for m=1:length(xgrid)
        for n=1:length(ygrid)
            pos = [xgrid(n),ygrid(m)]; %grid location
            dist = sqrt((obsx(i) - pos(1))^2 + (pos(2) - obsy(i))^2); %distance between obstacle and grid location
            T = atan( (obsy(i)-pos(2))/(obsx(i)-pos(1)) ); %orientation of the grid point with respect to the obstacle
            if pos(1)>0 && pos(2)>0
                T=-T; %second quadrant
            elseif pos(1)<0 && pos(2)<0;
                T=-T; %third quadrant
            end%if
            if dist<obsr
                dy(m,n,i) = -sign(sin(T))*hugeVal; %approximates infinte amount
                dx(m,n,i) = -sign(cos(T))*hugeVal; %approximates infinte amount
            elseif obsr(i)<=dist && dist<=(obss(i) + obsr(i))
                dx(m,n,i) = -beta*(obss(i) + obsr(i) - dist)*cos(T);
                dy(m,n,i) = -beta*(obss(i) + obsr(i) - dist)*sin(T);
            else
                dx(m,n,i) = 0;
                dy(m,n,i) = 0;
            end %if
            %pos,dist,T,dx(m,n,i),dy(m,n,i),keyboard
        end %for
    end %for
%     figure
%     quiver(x,y,dx(:,:,i),dy(:,:,i))
%     hold on; plot(obsx(i),obsy(i),'r.','MarkerSize',32); hold off %overlay obstacle location onto vector field plot
end %for
figure('Name','Vector field with obstacles included')
%sum up the gradient vectors for each grid point over each obstacle
uobs = sum(dx,3); %sum each obstacle's x-gradient at each grid point
vobs = sum(dy,3); %sum each obstacle's x-gradient at each grid point
quiver(x,y,uobs,vobs)
hold on; plot(obsx,obsy,'r.','MarkerSize',32); hold off %overlay obstacle location onto vector field plot
axis([xLims(1) xLims(2) yLims(1) yLims(2)]), title('Vector field with obstacles included')

% add random field
if includeRand == true
    str = 'Added Random Field\n';
    fprintf(str)
    uRand= xLims(1) + (xLims(2)-xLims(1)).*rand(size(x)); %x_comp of vector is = random value within range of mesh grid
    vRand= yLims(1) + (yLims(2)-yLims(1)).*rand(size(y)); %y_comp of vector is = random value within range of mesh grid
%     figure,quiver(x,y,uRand,vRand)
%     title('Random vector field');xlabel('x');ylabel('y');
%     axis([xLims(1) xLims(2) yLims(1) yLims(2)])
    %update the vector field
    uobs = uobs + uRand;
    vobs = vobs + vRand;
    figure('Name','Vector field random field included')
    %sum up the u & vvectors for each grid point to include effects of random field
    quiver(x,y,uobs,vobs)
    hold on; plot(obsx,obsy,'r.','MarkerSize',32); hold off %overlay obstacle location onto vector field plot
    axis([xLims(1) xLims(2) yLims(1) yLims(2)]), title('Vector field random field included')
end %if

%add goals
%initialize gradients for the field
dx = zeros(length(x),length(y),length(obstacles)); dy=zeros(length(x),length(y),length(obstacles));
str = 'Added Goals\n';
fprintf(str)
xgrid = linspace(xLims(1),xLims(2),space_step);
ygrid = linspace(yLims(1),yLims(2),space_step);
if ~isempty(goals)
    for i = 1:length(goals)
        gx(i) = goals{i}(1); gy(i) = goals{i}(2); %initialize u and v vectors due to obstacles
        gr(i) = goals{i}(3); %obstacle's radius
        gs(i) = goals{i}(4); %obstacle's sphere of incluence
        alpha = hugeVal; %fix scaling factor for all goals
        for m=1:length(xgrid)
            for n=1:length(ygrid)
                pos = [xgrid(n),ygrid(m)]; %grid location
                dist = sqrt((gx(i) - pos(1))^2 + (pos(2) - gy(i))^2); %distance between obstacle and grid location
                T = atan2( (gy(i)-pos(2))/(gx(i)-pos(1)) ,0); %orientation of the grid point with respect to the obstacle
                if pos(1)>0 && pos(2)>0
                    T=-T; %first quadrant
                elseif pos(1)>0 && pos(2)<0;
                    T=-T; %fourth quadrant
                end%if

                if dist<obsr
                    dx(m,n,i)=0;
                    dy(m,n,i)=0;
                elseif obsr(i)<=dist && dist<=(gs(i) + gr(i))
                    dx(m,n,i) = alpha*gs*cos(T);
                    dy(m,n,i) = alpha*gs*sin(T);                     
                else
                    dx(m,n,i) = alpha*gs*cos(T);
                    dy(m,n,i) = alpha*gs*sin(T); 
                end %if
                %pos,dist,T,dx(m,n,i),dy(m,n,i),keyboard
            end %for
        end %for
        figure
        quiver(x,y,dx(:,:,i),dy(:,:,i))
        hold on; plot(gx(i),gy(i),'g.','MarkerSize',32); hold off %overlay obstacle location onto vector field plot
        axis([xLims(1) xLims(2) yLims(1) yLims(2)]), title('Vector field with goals included')
    end %for
    figure('Name','Vector field with goals included')
    %sum up the gradient vectors for each grid point over each obstacle
    uobs = uobs + sum(dx,3); %sum each obstacle's x-gradient at each grid point
    vobs = vobs + sum(dy,3); %sum each obstacle's x-gradient at each grid point
    quiver(x,y,uobs,vobs)
    hold on; plot(gx,gy,'g.','MarkerSize',32); hold off %overlay obstacle location onto vector field plot
    hold on; plot(obsx,obsy,'r.','MarkerSize',32); hold off %overlay obstacle location onto vector field plot
    axis([xLims(1) xLims(2) yLims(1) yLims(2)]), title('Vector field with goals included')
end %if