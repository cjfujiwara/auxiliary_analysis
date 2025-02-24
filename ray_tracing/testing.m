% Define initial ray
% assume that initial propagation axis is zhat

% Ray initial point
ray = [0 0 1 0 0 1]';

% A ray is defined by a 6-vector of [x y z, k1 k2 k3]
% it must be normalized by the ks
% 
% R = [x,y,z,k1,k2,k3];

% where k1,k2,k3 define propagation, and x y z is position

% A mirror is also defined by [x y z, k1 k2 k3]
% k1,k2,k3 define the normal vector and x,y,z is the center
% it must be normalized by the ks


wy = 10*0.5; % Y Waist in mm
wz = 10*2.0; % Z Waist in mm

% Center ray start
Rc0 = [0 0 0 1 0 0]';

% Define mirror
theta1 = 88.47495;
phi1 = 160;
[mx,my,mz] = angle2cart(theta1,phi1);
M1 = [50 0 0 mx my mz]';

% Calculate it
dsep = 100;
Rc = reflect(Rc0,M1);
Rc = propagate(Rc,dsep);

theta2 = 92.23;
phi2 = 10;
[mx,my,mz] = angle2cart(theta2,phi2);
M2 = [Rc(1:3,end); mx; my; mz];

% Reflect
Rc = reflect(Rc,M2);

% Propagate
Rc = propagate(Rc,50);

str=['(\theta,\phi):(' num2str(theta1) ',' num2str(phi1) ')' ...
    ';(' num2str(theta2) ',' num2str(phi2) ')' ...
    ';L:' num2str(dsep) ';\Deltaz:' num2str(dz)]; 


figure(20);
clf
plot3(Rc(1,:),Rc(2,:),Rc(3,:),'ko-');
axis equal tight
hold on
xlabel('x');
ylabel('y');
zlabel('z');
title(str);
dz = Rc(3,end)-Rc(3,1);

    tt = linspace(0,2*pi,48); % angle into 
cc= parula(length(tt));
for kk=1:length(tt)
    R = Rc0 + [0; wy*cos(tt(kk)); wz*sin(tt(kk)); Rc0(4); Rc0(5); Rc0(6)];
    R = reflect(R,M1);
    R = reflect(R,M2);
    R = propagate(R,50);
    plot3(R(1,:),R(2,:),R(3,:),'o-','color',cc(kk,:));
end

