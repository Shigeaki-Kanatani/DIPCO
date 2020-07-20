function Resolution_adjustment(F_XYZIDint, out_dir)
    
    F_XYZIDint2 = F_XYZIDint;
    F_XYZIDint2(:,3) = F_XYZIDint2(:,3)*5;
    F_XYZIDint2(:,2) = F_XYZIDint2(:,2)*0.585;
    F_XYZIDint2(:,1) = F_XYZIDint2(:,1)*0.585;
    Header ={'X', 'Y', 'Z', 'ID', 'Intensity'};
    csvwrite_with_headers([out_dir '\' 'F_XYZIDint2.csv'],F_XYZIDint2,Header);
    %csvwrite([out_dir '\' 'F_XYZIDint2.csv'], F_XYZIDint2);