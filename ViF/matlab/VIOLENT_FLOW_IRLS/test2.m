

%path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\noFights2\';
%file = '74.avi'; %caminando
%file = '12.avi'; %futbol
%file = '20.avi'; %corriendo
%file = '42.avi'; %bacscket

path = 'D:\TESIS\VIDEOS VIOLENCE\FAST VIOLENCE DETECTION\Peliculas\fights\';
%file = 'newfi28.avi'; %PELICULA PELEA
%file = 'newfi46.avi'; %futbol
%file = 'newfi41.avi'; %futbol
file = 'newfi23.avi'; 

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