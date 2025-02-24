function Rout=reflect(Rin,M)

% Given an input ray Rin = [x,y,z,kx,ky,kz];

kin = Rin(4:6,end);kin=kin/norm(kin);
rin = Rin(1:3,end);

% Given a mirror M = [x,y,z,kx,ky,kz];
km = M(4:6);km=km/norm(km);
rm = M(1:3);

% Law of reflection vector form
kout = kin-2*sum(kin.*km)*km;

% Find out where the input vector intersects a plane
% https://en.wikipedia.org/wiki/Line%E2%80%93plane_intersection
d = sum((rm-rin).*km)/sum(kin.*km);

% Intersection point
r_intersect = rin + kin*d;

% output ray
Rout = [r_intersect; kout];
Rout = [Rin Rout];


end

