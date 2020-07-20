function XYZ2Binary (F_XYZ, height, width, depth, out_dir)

 %Nobuyuki Tanaka et al., 
 %Whole-tissue phenotyping of FFPE tumors: Unraveling cancer heterogeneity in three dimensions" 

 %This script generate binary images from XYZ coordinates(F_XYZ) in out_dir
 %folder. Size of binary image(height, width, depth are required.
   
 poolobj = gcp('nocreate');
 delete(poolobj);
 no_of_workers = 12;
 parpool ('local',no_of_workers);
 
 sparse_binary=cell(depth,1);
 
    parfor d=1:depth
    
    disp(d);
    F_Ind_D = F_XYZ(:,3)==d;
    XYZ=F_XYZ(F_Ind_D,:);
    x=XYZ(:,1);
    y=XYZ(:,2);
    
    image_D= sparse(y,x,1,height,width); 
    sparse_binary(d,1)={image_D};
    
    image_tif=full(image_D);
    fname_out =[out_dir '\binary' num2str(d,'%04i') '.tif'];
    imwrite(image_tif, fname_out);
    
    end
    
    save('sparse_binary.mat', 'sparse_binary');

    poolobj = gcp('nocreate');
    delete(poolobj);
 
end