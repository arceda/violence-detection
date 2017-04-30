function plop_hist

    path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\fights\';    
    figure,
    
    %subplot(2,5,1); hist(VIF_create_feature_vec(path, 'newfi1.avi' ));
    subplot(2,4,1); hist(VIF_create_feature_vec(path, 'newfi1.avi' ));
    title('Movies fight');    
    subplot(2,4,2); hist(VIF_create_feature_vec(path, 'newfi10.avi' ));
    title('Movies fight');    
    subplot(2,4,3); hist(VIF_create_feature_vec(path, 'newfi40.avi' ));
    title('Movies fight');
    subplot(2,4,4); hist(VIF_create_feature_vec(path, 'newfi55.avi' ));
    title('Movies fight');    
   
    
    
    path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\noFights2\';
    subplot(2,4,5); hist(VIF_create_feature_vec(path, '1.avi' ));
    title('Movies no fight');    
    subplot(2,4,6); hist(VIF_create_feature_vec(path, '34.avi' ));
    title('Movies no fight');    
    subplot(2,4,7); hist(VIF_create_feature_vec(path, '65.avi' ));
    title('Movies no fight');
    subplot(2,4,8); hist(VIF_create_feature_vec(path, '78.avi' ));
    title('Movies no fight');    
    
    
    %hockey
    figure,    
    path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\HockeyFights\';
    subplot(2,4,1); hist(VIF_create_feature_vec(path, 'fi1_xvid.avi' ));
    title('Hockey fight');    
    subplot(2,4,2); hist(VIF_create_feature_vec(path, 'fi12_xvid.avi' ));
    title('Hockey fight');    
    subplot(2,4,3); hist(VIF_create_feature_vec(path, 'fi123_xvid.avi' ));
    title('Hockey fight');
    subplot(2,4,4); hist(VIF_create_feature_vec(path, 'fi234_xvid.avi' ));
    title('Hockey fight');    
    %subplot(2,5,5); hist(VIF_create_feature_vec(path, 'fi499_xvid.avi' ));
    %title('Hockey fight');
    
    subplot(2,4,5); hist(VIF_create_feature_vec(path, 'no11_xvid.avi' ));
    title('Hockey no fight');    
    subplot(2,4,6); hist(VIF_create_feature_vec(path, 'no145_xvid.avi' ));
    title('Hockey no fight');    
    subplot(2,4,7); hist(VIF_create_feature_vec(path, 'no234_xvid.avi' ));
    title('Hockey no fight');
    subplot(2,4,8); hist(VIF_create_feature_vec(path, 'no300_xvid.avi' ));
    title('Hockey no fight');    
    %subplot(2,5,10); hist(VIF_create_feature_vec(path, 'no444_xvid.avi' ));
    %title('Hockey no fight');
end