function DilatePointBinary_2DSE (data_dir, out_dir, se)

 %data_dir is directory of binary images of point cloud
 %se should be 2D.
 %if se is 3D, it should be stopped, but not implemented
 Im=datastore(data_dir, 'FileExtensions', '.tif','Type', 'image');
 list = dir([data_dir '\*.tif']);
 depth=length(list);
 
 D_image=cell(depth,1);
 
 poolobj = gcp('nocreate');
 delete(poolobj);
 no_of_workers = 12;
 parpool ('local',no_of_workers);  
 

 parfor d=1:depth
 
    disp(d);
    
    D_image=imdilate(readimage(Im,d), se);
  
    fname_out =[out_dir '\DilateBinary' num2str(d, '%04i') '.tif'];
    imwrite(D_image, fname_out);
 
 end
    
 poolobj = gcp('nocreate');
 delete(poolobj);
 
 

end
 

