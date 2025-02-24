function [r] = ray_project(Rref,R)


kin = Rref(4:6);kin=kin/norm(kin);

p1 = Rref(1:3);
p2 = R(1:3);

end

