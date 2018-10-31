function [actual_centers, actual_radii] = find_circles(filename) 

[timestep,num_atoms,box_size,x_norm,y_norm,z_norm] = read_file(filename);

x0 = box_size(1,1);
dx = box_size(1,2) - box_size(1,1); 
y0 = box_size(2,1);
dy = box_size(2,2) - box_size(2,1);
pixel_size = 0.5* (box_size(3,2) - box_size(3,1));
num_pixel_x = ceil(dx/pixel_size); 
num_pixel_y = ceil(dx/pixel_size);

pixel_x = dx/num_pixel_x;
pixel_y = dy/num_pixel_y;

unormalize = @(x, x0, dx) x0 + x*dx; 
x_c = unormalize(x_norm, x0, dx); 
y_c = unormalize(y_norm, y0, dy);

x_r = unormalize(x_norm, x0-dx, dx); 
x_l = unormalize(x_norm, x0+dx, dx); 
y_u = unormalize(y_norm, y0+dy, dy);
y_d = unormalize(y_norm, y0-dy, dy);

X = [x_l; x_r; x_c; x_l; x_r; x_c; x_l; x_r; x_c];
Y = [y_u; y_u; y_u; y_c; y_c; y_c; y_d; y_d; y_d];
[A, real_sizes] = hist3([X,Y],[3*num_pixel_x,3*num_pixel_y]);
x_real = real_sizes{1};
y_real = real_sizes{2};
%%
A = (A<=0);
figure(); imagesc(x_real,y_real,A');
set(gca,'ydir','normal')
num_pixels = min(num_pixel_x, num_pixel_y);

stats = regionprops('table',A','Centroid','Area','MajorAxisLength','MinorAxisLength','Orientation');
C = cat(1, stats.Centroid);
%R = sqrt(stats.Area/pi);
angle = stats.Orientation;
majoraxis = stats.MajorAxisLength.*sqrt((cosd(angle)*pixel_x).^2  + (sind(angle)*pixel_y).^2);
minoraxis = stats.MinorAxisLength.*sqrt((sind(angle)*pixel_x).^2  + (cosd(angle)*pixel_y).^2);
R = 0.25*(majoraxis + minoraxis);

actual_centers = []; 
actual_radii = [];

for i = 1:size(C,1)
  if (C(i,1)>num_pixel_x) && (C(i,1)<2*num_pixel_x) && (C(i,2)>num_pixel_y) ... 
  &&(C(i,2)<2*num_pixel_y)
   unnormlize_center = [x_real(round(C(i,1))), y_real(round(C(i,2)))]; 
   actual_centers = [actual_centers; unnormlize_center];
   actual_radii = [actual_radii; R(i,:)];
  end
end

viscircles(actual_centers, actual_radii,'EdgeColor','r');
xlim(box_size(1,:));
ylim(box_size(2,:));
end
