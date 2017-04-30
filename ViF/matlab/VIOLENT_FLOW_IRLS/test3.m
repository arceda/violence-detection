

%path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\noFights2\';
%file = '74.avi';

%path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\fights\';
%file = 'newfi1.avi';

path = 'D:\TESIS\VIDEOS VIOLENCE\CAVIAR\yt\';
file = 'CCTV footage shows brutal Melbourne assault.mp4';

%vec = VIF_create_feature_vec('D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\fights', 'newfi27.avi');
%vec = VIF_create_feature_vec('D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\fights', 'newfi27.avi');
%vec = VIF_create_feature_vec('D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\noFights2', '27.avi');
vec = VIF_create_feature_vec(path, file);

pred = svmclassify(svmModel, vec');



mov = VideoReader(strcat(path, file));
for i = 1:mov.NumberOfFrames
    img = read(mov, i);
    imshow(img);
end    


prediccion = pred;

if strcmp(prediccion,'fights') 
    msgbox('ACCION VIOLENTA');
else
    msgbox('ACCION NORMAL');
end 