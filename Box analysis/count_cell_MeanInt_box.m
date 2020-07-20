function count_cell_MeanInt_box (y, x, z, height, width, depth, F_XYZIDint, out_dir)

 %Nobuyuki Tanaka et al., 
 %Whole-tissue phenotyping of FFPE tumors: Unraveling cancer heterogeneity in three dimensions" 

%x, y, z is the number of dots making box regions, for 200um, [342,342,40]
%height, width, depth is image y, x, z
%F_XYZIint is fixed xyz coordinates and ID and signal instensity value

Box_X= width/x;
Box_Y= height/y;
Box_Z= depth/z;

Box_list=cell(Box_Y,Box_X, Box_Z);

poolobj = gcp('nocreate');
delete(poolobj);
no_of_workers = 12;
parpool ('local',no_of_workers);

parfor k=1:Box_Z

for j=1:Box_X

for i=1:Box_Y

Ind_T = F_XYZIDint(:,2)>= (i-1)*x+1 & F_XYZIDint(:,2)<= i*x & F_XYZIDint(:,1)>= (j-1)*y+1 & F_XYZIDint(:,1)<= j*y & F_XYZIDint(:,3)>=(k-1)*z+1 & F_XYZIDint(:,3)<=k*z;
MatT=F_XYZIDint(Ind_T,:);

if (isempty(MatT) == 1)
    MatT=zeros(1,5);
    
end

Cell_number_box(i,j,k)= nnz(MatT(:,1)); 
MeanInt_box(i,j,k)= mean2(MatT(:,5)); 
MeanInt_var_box(i,j,k)= var(MatT(:,5)); 
Box_list{i,j,k}=MatT;
 
disp([j,i,k]);
 
end
 
end

end

save([out_dir '\' 'Cell_number_box.mat'],'Cell_number_box');
save([out_dir '\' 'MeanInt_box.mat'],'MeanInt_box');
save([out_dir '\' 'MeanInt_var_box.mat'],'MeanInt_var_box');
save([out_dir '\' 'Box_list.mat'], 'Box_list');
sum(sum(sum(Cell_number_box)))

poolobj = gcp('nocreate');
delete(poolobj);
