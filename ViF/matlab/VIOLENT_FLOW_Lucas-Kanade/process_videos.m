%videos = {'fi1_xvid.avi', 'fi2_xvid.avi', 'fi3_xvid.avi', 'fi4_xvid.avi', 'fi5_xvid.avi' };

num_videos = 100;

path = 'D:\TESIS\VIDEOS VIOLENCE\SVV\fight\';


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
    vec_data = VIF_create_feature_vec(path, strcat('',int2str(v),'.mp4') );
    videos_data = [videos_data; vec_data'];
end    

dlmwrite('VIF-LucasKanade_SVV_fight_100(SS-6).csv', videos_data, ',');

