function Hmaxima2PointCloud(data_dir, out_dir)

 %Nobuyuki Tanaka et al., 
 %Whole-tissue phenotyping of FFPE tumors: Unraveling cancer heterogeneity in three dimensions" 

 % This script generate centroids list(point cloud) from Hmaxima images
 % x, y is Hmaxima images width and height
 
 %changed 20171026, removed requirement for x, y
 
 Im=datastore(data_dir, 'FileExtensions', '.tif','Type', 'image');
 list = dir([data_dir '\' '*.tif']); 
 Size_image=logical(readimage(Im,1));
 [y, x] = size(Size_image);
 
 BW=zeros(y, x, length(list));
 
 poolobj = gcp('nocreate');
 delete(poolobj);
 no_of_workers = 12;
 parpool ('local',no_of_workers);  
 
 parfor d=1:length(list)
 
     T_image=logical(readimage(Im,d));
     BW(:,:,d)= T_image;
 
 end
 
 poolobj = gcp('nocreate');
 delete(poolobj);

 CC = bwconncomp(BW,26);
 SS = regionprops(CC,'Centroid');
 centroids = cat(1, SS.Centroid);
 
 save ([out_dir '\' 'centroid.mat'],'centroids');
 F_XYZ= fix(centroids);
 save ([out_dir '\' 'F_XYZ.mat'],'F_XYZ');
 
 Temp1=false(length(SS),1);
 ID=find(not(Temp1)); 
 F_XYZID=cat(2, F_XYZ, ID);
 save ([out_dir '\' 'F_XYZID.mat'],'F_XYZID');
 
end