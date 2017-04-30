%videos = {'fi1_xvid.avi', 'fi2_xvid.avi', 'fi3_xvid.avi', 'fi4_xvid.avi', 'fi5_xvid.avi' };

num_videos = 123;

path = 'D:\TESIS\VIDEOS VIOLENCE\VIOLENCE FLOW\noviolence\';


%videos = cell(num_videos,1);
%videos{1} = ['fi1_xvid.avi'];
%videos{2} = ['fi2_xvid.avi'];
%videos{3} = ['fi3_xvid.avi'];
%videos{4} = ['fi4_xvid.avi'];
%videos{5} = ['fi5_xvid.avi'];

videos_data = [];

for v = 1 : num_videos    

    disp(strcat('processing video_',int2str(v)));
    %videos_data = [videos_data ; extreme_aceleration(videos{v})];
    %name_video = strcat(path,'',int2str(v),'.avi');
    %[DATA, HIST] = extreme_aceleration(name_video);
    %vec_data = VIF_create_feature_vec(path, strcat('no',int2str(v),'_xvid.avi') );
    file_name =  strcat('',int2str(v), '.avi');
    video_path = strcat(path, file_name);
    
    box = my_obj_track( video_path, 0);   
    
    vec_data = VIF_create_feature_vec_2(path, file_name, box);
    %vec_data = VIF_create_feature_vec(path, strcat('',int2str(v),'.mp4') , 0);
    videos_data = [videos_data; vec_data'];
end    

dlmwrite('FLOW.NOFIGHT_HS.1HIST.MOVE.csv', videos_data, ',');

