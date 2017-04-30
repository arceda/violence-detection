%function [A] = MYDEMO()

    mov = VideoReader('D:\TESIS\VIDEOS VIOLENCE\CAVIAR\yt\CCTV footage shows brutal Melbourne assault(400x224).mp4');
    
    numFrames = mov.NumberOfFrames;
    frameRate = mov.FrameRate; 
    
    images{numFrames} = [];
    index_images = 1;
    
    for t = 1 : numFrames - 1
        currFrame_1 = read(mov, t); 
         
        
        images{index_images} = currFrame_1;
        
        if (mod(t, frameRate) == 0) % cada 25 frames generamos el vector de caracteristicas 
            index_images = 1;
            feature_vec = MYDEMO_VIF_create_feature_vec(images);
        end    
        
        index_images = index_images + 1;
        
        imshow(currFrame_1);  
    end      

%end