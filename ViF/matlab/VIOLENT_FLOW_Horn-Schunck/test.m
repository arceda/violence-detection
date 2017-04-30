%testing

%training svm
%data_fights     = csvread('VIF-IRLS_SVV_fight_70(SS-3).csv');  %100 X 40
%data_nofights   = csvread('VIF-IRLS_SVV_no_fight_70(SS-3).csv');  %100 X 40
%[acc, sd, auc, fpr, tpr, model] = analisis(data_fights, data_nofights);


path = 'D:\TESIS\VIDEOS VIOLENCE\SVV\fight\';
file_name = '1.mp4';
file_name = '5.mp4';
file_name = '6.mp4';
file_name = '54.mp4';
file_name = '53.mp4';
%file_name = '45.mp4';
%file_name = '42.mp4';
%file_name = '21.mp4';


%path = 'D:\TESIS\VIDEOS VIOLENCE\SVV\nofight\';
%file_name = '2.mp4';
%file_name = '22.mp4';
%file_name = '10.mp4';
%file_name = '57.mp4';

%violent actions
mov = VideoReader(fullfile(path,file_name));
vec_data = VIF_create_feature_vec(path, file_name);

for(i=1:mov.NumberOfFrames)
   
    im = read(mov, i);
    imshow(im);
end

pred = svmclassify(model, vec_data');

if(pred == 1)
    h = msgbox('VIOLENT ACTION', 'VIOLENT','error');
else
    h = msgbox('NORMAL','Success');
end
