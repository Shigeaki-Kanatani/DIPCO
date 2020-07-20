function Quantify_BinaryData_box (y, x, z, data_dir, area_dir, out_dir)

%Nobuyuki Tanaka et al., 
%Whole-tissue phenotyping of FFPE tumors: Unraveling cancer heterogeneity in three dimensions" 

%x, y, z is the number of dots making box regions, for 200um, \
%[342,342,40] for 0.585,0585,5 resolution, [40,40,40] for 5,5,5 resolution
%height, width, depth is image y, x, z
%F_XYZIint is fixed xyz coordinates and ID and signal instensity value

Im=datastore(data_dir, 'FileExtensions', '.tif','Type', 'image');
AreaIm=datastore(area_dir, 'FileExtensions', '.tif','Type', 'image');
list = dir([data_dir '\' '*.tif']);
[height,width] = size(readimage(Im,1));
depth=length(list);

Box_X= width/x;
Box_Y= height/y;
Box_Z= depth/z;

Box_list=cell(Box_Y,Box_X, Box_Z);

poolobj = gcp('nocreate');
delete(poolobj);
no_of_workers = 12;
parpool ('local',no_of_workers);

parfor k=1:Box_Z
    
    IntImage=[];
    AreaImage=[];
    for d=1:z
   
    TempImage=readimage(Im,d+(k-1)*z);
    IntImage=cat(3, IntImage, TempImage);   
   
    TempAreaImage=readimage(AreaIm,d+(k-1)*z);
    AreaImage=cat(3, AreaImage, TempAreaImage);
    
    end     
    
    for j=1:Box_X

    for i=1:Box_Y

        BoxImage=IntImage(y*(i-1)+1:y*i, x*(j-1)+1:x*j, 1:z); 
        Pixel_box(i,j,k)= nnz(BoxImage);  
       
        BoxAreaImage=AreaImage(y*(i-1)+1:y*i, x*(j-1)+1:x*j, 1:z); 
        Area_box(i,j,k)= nnz(BoxAreaImage);  
        
        disp([j,i,k]);
 
     end
 
    end

end

    Density_box= Pixel_box ./ Area_box; 
    Density_box(isnan(Density_box)) = 0 ;
    
    save([out_dir '\' 'Pixel_box.mat'],'Pixel_box');
    save([out_dir '\' 'Area_box.mat'],'Area_box');
    save([out_dir '\' 'Density_box.mat'],'Density_box');

for k=1:Box_Z
imwrite(uint16(Pixel_box(:,:,k)),[out_dir '\' 'Pixel_box' num2str(k,'%04d') '.tif']);
imwrite(uint16(Area_box(:,:,k)),[out_dir '\' 'Area_box' num2str(k,'%04d') '.tif']);
imwrite(uint16(Density_box(:,:,k)),[out_dir '\' 'Density_box' num2str(k,'%04d') '.tif']);
end

