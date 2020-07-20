function ArrayTo16bit(array1, out_dir)

 %Nobuyuki Tanaka et al., 
 %Whole-tissue phenotyping of FFPE tumors: Unraveling cancer heterogeneity in three dimensions" 

    %This scirpt make array to 16 bit intensity images.
    %This script is used for generating images for voxelized 3D images.
    
    [height,width,depth] = size(array1); 
    Max_value=max(max(max(array1))); 
    ModiArray1=array1./Max_value.*65535; 
    
    save([out_dir '\' inputname(1) '16bit.mat'],'ModiArray1');
    
    for k=1:depth
        imwrite(uint16(ModiArray1(:,:,k)),[out_dir '\' inputname(1) '16bit' num2str(k,'%04d') '.tif']);
    end
    
end

