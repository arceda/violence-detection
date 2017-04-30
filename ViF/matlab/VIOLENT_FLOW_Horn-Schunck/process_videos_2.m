
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = 'D:\TESIS\VIDEOS VIOLENCE\SVV\fight\';
videos = csvread('D:\TESIS\VIDEOS VIOLENCE\SVV\fights_indoor.csv');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[rows, cols] = size(videos);

videos_data = [];

for v = 1 : rows    
%for v = 1 : 1    
    file_name =  strcat(int2str(videos(v,1)), '.mp4');
    disp(strcat(int2str(v), '-processing video ', file_name ));
    
    video_path = strcat(path, file_name);
    %%%%%%%%%%%%% OBTENEMOS EL BOUNDING BOX DEL MOVIMIENTO%%%%%%
    %box = my_obj_track( video_path, 0);   
    
    vec_data = VIF_create_feature_vec_2(path, file_name, 0 );
    videos_data = [videos_data; vec_data'];
end    

%dlmwrite('VIF.HS.1HIST.MOVE_SVV.FIGHT.60.SS3.csv', videos_data, ',');
dlmwrite('VIF.HS.1HIST_SVV.FIGHT.60.SS3.csv', videos_data, ',');

