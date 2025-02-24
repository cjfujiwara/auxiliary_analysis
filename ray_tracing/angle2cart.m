function [x,y,z] = angle2cart(theta,phi)

x = sind(theta)*cosd(phi);
y = sind(theta)*sind(phi);
z = cosd(theta);


end

