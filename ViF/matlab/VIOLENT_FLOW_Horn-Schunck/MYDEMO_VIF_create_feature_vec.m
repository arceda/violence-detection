function feature_vec = MYDEMO_VIF_create_feature_vec(imgCell)
%       
% Inputs:
%          path , file_name    - of the AVI file. 
%
% Outputs:
%          feature_vec    -  vector of VIF features, size = M * N * 21. 

	FR   = 25;            % frame rate
	movment_int = 3;      % frames intervat between Current frame and Prev frame
	N = 4;                % number of  vertical blocks in frame
	M = 4;                % number of  horisontal blocks in frame

	K=4;

	%mov = aviread(fullfile(path,file_name));
    %mov = VideoReader(fullfile(path,file_name));

	frame_gap = 2*movment_int;

	index = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %frame_test = rgb2gray(read(mov, 1));
    frame_test = rgb2gray(imgCell{1});
    
    
    [r_frame_test, c_frame_test] = size(frame_test);
    rescale = 100 / r_frame_test;
    frame_test_resize = imresize(frame_test, rescale);
    [r_frame_test, c_frame_test] = size(frame_test_resize);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	flow = zeros(r_frame_test, c_frame_test);
    
    [rows, cols] = size(imgCell);
    %numFrames = mov.NumberOfFrames;    
    numFrames = cols;    
    
    for f = 1:frame_gap:numFrames - frame_gap -5   
		
		% Ignore 3 first frames of the clip 
		%Prev_F =           read(mov, f + 3);                                    
		%Current_F =        read(mov, f + 3 + movment_int);   
		%Next_F =           read(mov, f + 3 + 2*movment_int); 
        Prev_F =           imgCell{f + 3};                                    
		Current_F =        imgCell{f + 3 + movment_int};   
		Next_F =           imgCell{f + 3 + 2*movment_int};  
		
		% if colored movie change to gray levels
		if size(Current_F,3)>1                                                       
			Prev_F = rgb2gray(Prev_F);
			Current_F = rgb2gray(Current_F);
			Next_F = rgb2gray(Next_F);
		end
		
		Prev_F = single(Prev_F);
		Current_F = single(Current_F);
		Next_F = single(Next_F);

		rescale = 100 / size(Current_F,1);
        %rescale = r_frame_test / size(Current_F,1);
		if rescale < 0.8
			Prev_F = imresize(Prev_F, rescale);
			Current_F = imresize(Current_F, rescale);
			Next_F = imresize(Next_F, rescale);
		end

		[m1,vx1,vy1] = VIF_create_frame_flow(Prev_F, Current_F,  N, M);
		index = index + 1;
		[m2,vx2,vy2] = VIF_create_frame_flow(Current_F, Next_F,  N, M );
		delta = abs(m1 - m2);
		flow = flow + double(delta > mean2(delta));
        
	end
	flow = flow./index;
	feature_vec = VIF_create_block_hist(flow,N,M);

end
