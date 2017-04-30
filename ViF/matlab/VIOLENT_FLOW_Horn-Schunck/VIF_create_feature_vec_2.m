function feature_vec = VIF_create_feature_vec(path,file_name, boxoverlapped)
%       
% Inputs:
%          path , file_name    - of the AVI file. 
%
% Outputs:
%          feature_vec    -  vector of VIF features, size = M * N * 21. 

	FR   = 25;            % frame rate
	%movment_int = 3;      % frames intervat between Current frame and Prev frame
    movment_int = 3;      % frames intervat between Current frame and Prev frame
	N = 4;                % number of  vertical blocks in frame
	M = 4;                % number of  horisontal blocks in frame
    
    rows_min = 100;
    cols_min = 134;
    
	K=4;

	%mov = aviread(fullfile(path,file_name));
    mov = VideoReader(fullfile(path,file_name));

	frame_gap = 2*movment_int;

	index = 0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    frame_test = rgb2gray(read(mov, 1));
    
    
    
    %[r_frame_test, c_frame_test] = size(frame_test);
    %flow = zeros(r_frame_test, c_frame_test);
    flow = zeros(rows_min, cols_min);
    
    
    
    if(boxoverlapped ~= 0 )
        area_box = boxoverlapped(1,4) * boxoverlapped(1,3);
        area_frame_min = rows_min * cols_min;
        if(area_box < area_frame_min)
            flow = zeros(boxoverlapped(1,4), boxoverlapped(1,3)); %width = cols, height = rows
        end
    end
   
   
	%flow = zeros(r_frame_test, c_frame_test);
    %flow = zeros(100,134);
	% for every Frame
	%for f = 1:frame_gap:length(mov)- frame_gap -5
    numFrames = mov.NumberOfFrames;    
    
    for f = 1:frame_gap:numFrames - frame_gap -5   
    
		% Ignore 3 first frames of the clip 
		%Prev_F =           mov(f + 3).cdata;                                    
		%Current_F =        mov(f + 3 + movment_int).cdata;
		%Next_F =           mov(f + 3 + 2*movment_int).cdata;
        Prev_F =           read(mov, f + 3);                                    
		Current_F =        read(mov, f + 3 + movment_int);   
		Next_F =           read(mov, f + 3 + 2*movment_int); 
        
        
        if(boxoverlapped ~= 0)
            %disp('boxoverlapped');
            %disp(boxoverlapped);
            
            x = boxoverlapped(1,1);
            y = boxoverlapped(1,2);
            width = boxoverlapped(1,3);
            height = boxoverlapped(1,4);

            y_f = y + height - 1;
            x_f = x + width - 1;
            
            Prev_F      = Prev_F( y : y_f  ,  x : x_f );  
            Current_F   = Current_F( y : y_f  ,  x : x_f );  
            Next_F      = Next_F( y : y_f  ,  x : x_f );  
            
            %imshow(Current_F);
        end
		
		% if colored movie change to gray levels
		if size(Current_F,3)>1                                                       
			Prev_F = rgb2gray(Prev_F);
			Current_F = rgb2gray(Current_F);
			Next_F = rgb2gray(Next_F);
        end
               
		
		Prev_F = single(Prev_F);
		Current_F = single(Current_F);
		Next_F = single(Next_F);
        
        %disp(size(Current_F));

		
        
        Prev_F          = imresize(Prev_F,      size(flow));
        Current_F       = imresize(Current_F,   size(flow));
        Next_F          = imresize(Next_F,      size(flow));
        
        %disp('currentF before');
        %disp(size(Current_F));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%

        %obtenemos el flujo optico
		[m1,vx1,vy1] = VIF_create_frame_flow(Prev_F, Current_F,  N, M);
		index = index + 1;
		[m2,vx2,vy2] = VIF_create_frame_flow(Current_F, Next_F,  N, M );
        
        %obtenemos el la diferencia de magnitudes de los vectores de flujo
        %optico
		delta = abs(m1 - m2);
        
        %imshow(delta);
        
        %disp(m1);
        %dlmwrite('flow.csv', m1, ',');
        
        %disp('size flow');
        %disp(size(flow));
        %disp('size delta');
        %disp(size(delta));
        
        %si la diferencia de magnitudes de flujo optico es mayor al
        %promedio = 1, caso contrario = 0, esto lo almacenamos en flow
		flow = flow + double(delta > mean2(delta));
        
    end
    
    %flow = b_x,y; contine el promedio de todos los frames de b_x,y,t por cada pixel
	flow = flow./index;
    %imshow(flow);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %[r, c] = size(flow);
    %if(r < c) min = r; else min = c; end
    %min = min/4;
    %H = ones(min, min)/ (min*min);
    %IH = imfilter(flow, H);
    %imshowpair(flow,IH,'montage');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %dlmwrite('flow.csv', flow, ',');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%HISTOGRAMA POR BLOQUES%%%%%%%%%%%%%%%
	%feature_vec = VIF_create_block_hist(flow,N,M);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %HISTOGRAMA TOTOAL
    flow_vec = reshape(flow, numel(flow), 1);
    Count = histc(flow_vec,0:0.05:1);
    feature_vec = Count/sum(Count);
    
    %bar(0:0.05:1,Count,'histc')
    
    %disp(feature_vec);
    %disp(size(feature_vec))
end
