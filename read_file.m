function [timestep,num_atoms,box_size,x,y,z] = read_file(filename) 
fid = fopen(filename);

timestep_line = 2;
timestep = textscan(fid, '%f',1, 'delimiter','\n', 'headerlines',timestep_line-1); 
timestep = timestep{1};
fseek(fid,0,'bof');

num_atoms_line = 4;
num_atoms = textscan(fid, '%f',1, 'delimiter','\n', 'headerlines',num_atoms_line-1); 
num_atoms = num_atoms{1};

fseek(fid,0,'bof');
num_box_size = 6;
box_size = cell2mat(textscan(fid, '%f%f',3, 'delimiter','\n','headerlines',num_box_size-1));


%% Initialize variables. 
delimiter = ' ';
startRow = 10;

mat = dlmread(filename,delimiter,startRow,0);
x = mat(:, 3);
y = mat(:, 4);
z = mat(:, 5); 
end