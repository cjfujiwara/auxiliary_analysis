function Rout = propagate(Rin, d)

% Given an input ray Rin = [x,y,z,kx,ky,kz];
kin = Rin(4:6,end);kin=kin/norm(kin);
rin = Rin(1:3,end);


rout = kin*d+rin;

Rout = [rout; kin];
Rout = [Rin Rout];
end

