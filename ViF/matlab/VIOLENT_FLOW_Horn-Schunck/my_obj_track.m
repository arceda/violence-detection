

function boxoverlapped = my_obj_track(path_video, display)
    obj = setupSystemObjects(path_video); 
    tracks = initializeTracks(); 
    index = 0;    
    bboxes_all = [];
    width_frame = 0;
    height_frame = 0;
    
    while ~isDone(obj.reader)
        index = index + 1;
        frame = readFrame(obj);
        
        [height_frame, width_frame, ~] = size(frame); %matlab operate in this order          
        [centroids, bboxes, mask] = detectObjects(obj, frame);        
        tracks = predictNewLocationsOfTracks(tracks);        
        [assignments, unassignedTracks, unassignedDetections] = ...
            detectionToTrackAssignment(tracks, centroids);
        tracks = updateAssignedTracks(assignments, centroids, bboxes, tracks);        
        tracks = updateUnassignedTracks(unassignedTracks, tracks);
        tracks = deleteLostTracks(tracks);
        
        [centroids, bboxes, tracks] = createNewTracks(unassignedDetections, centroids, bboxes, tracks);
    
        if(display == 1)
            bboxes = displayTrackingResults(frame, mask, tracks, obj, index, 0);
            bboxes_all = [bboxes_all ; bboxes];
        else
            if ~isempty(tracks)
                minVisibleCount = 8;
                reliableTrackInds = [tracks(:).totalVisibleCount] > minVisibleCount;
                reliableTracks = tracks(reliableTrackInds);

                if ~isempty(reliableTracks)
                    bboxes = cat(1, reliableTracks.bbox);
                    bboxes_all = [bboxes_all ; bboxes];
                end
            end
        end
    end
    
    boxoverlapped = find_overlaps(bboxes_all, 0, width_frame, height_frame);    
    %display_with_segmented_scene(boxoverlapped, path_video);
end


function display_with_segmented_scene(boxoverlapped, path_video)
   
    mov = VideoReader(path_video);
    num_frames = mov.NumberOfFrames;
   
    if(boxoverlapped ~= 0)
        x = boxoverlapped(1,1);
        y = boxoverlapped(1,2);
        width = boxoverlapped(1,3);
        height = boxoverlapped(1,4);

        y_f = y + height - 1;
        x_f = x + width - 1;
        
        for i=1:num_frames
            frame = read(mov,i);        
            %sub_frame = frame( y : y_f  ,  x : x_f );        
            frame = insertObjectAnnotation(frame, 'rectangle', ...
                    boxoverlapped, '  TOTAL ', 'Color',{'cyan'});
            imshow(frame);
            %imshow(sub_frame);
        end

        for i=1:num_frames
            frame = read(mov,i);        
            sub_frame = frame( y : y_f  ,  x : x_f );  
            imshow(sub_frame);
        end
    else
        %solo mostramos el frame
        for i=1:num_frames
            frame = read(mov,i); 
            imshow(frame);
        end        
    end
    
    
end


function tracks_new = deleteLostTracks(tracks)
    if isempty(tracks)
        tracks_new = tracks;
        return;
    end

    invisibleForTooLong = 20;
    ageThreshold = 8;

    % Compute the fraction of the track's age for which it was visible.
    ages = [tracks(:).age];
    totalVisibleCounts = [tracks(:).totalVisibleCount];
    visibility = totalVisibleCounts ./ ages;

    % Find the indices of 'lost' tracks.
    lostInds = (ages < ageThreshold & visibility < 0.6) | ...
        [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;

    % Delete lost tracks.
    tracks = tracks(~lostInds);
    tracks_new = tracks;
end

function [centroids_new, bboxes_new, tracks_new] = createNewTracks(unassignedDetections, centroids, bboxes, tracks)
    centroids = centroids(unassignedDetections, :);
    bboxes = bboxes(unassignedDetections, :);

    nextId = 1; %% le aumente
    
    for i = 1:size(centroids, 1)

        centroid = centroids(i,:);
        bbox = bboxes(i, :);

        % Create a Kalman filter object.
        kalmanFilter = configureKalmanFilter('ConstantVelocity', ...
            centroid, [200, 50], [100, 25], 100);

        % Create a new track.
        newTrack = struct(...
            'id', nextId, ...
            'bbox', bbox, ...
            'kalmanFilter', kalmanFilter, ...
            'age', 1, ...
            'totalVisibleCount', 1, ...
            'consecutiveInvisibleCount', 0);

        % Add it to the array of tracks.
        tracks(end + 1) = newTrack;

        % Increment the next id.
        nextId = nextId + 1;
    end
    centroids_new = centroids;
    bboxes_new = bboxes;
    tracks_new = tracks;
end

function obj = setupSystemObjects(path_video)
    % Initialize Video I/O
    % Create objects for reading a video from a file, drawing the tracked
    % objects in each frame, and playing the video.

    % Create a video file reader.
    %obj.reader = vision.VideoFileReader('D:\TESIS\VIDEOS VIOLENCE\SVV\fight\100.mp4');
    obj.reader = vision.VideoFileReader(path_video);
    %obj.reader = vision.VideoFileReader('D:\TESIS\VIDEOS VIOLENCE\CAVIAR\yt\7 Brutal Prison Attacks Caught On Camera!.mp4');

    % Create two video players, one to display the video,
    % and one to display the foreground mask.
    obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
    obj.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);

    % Create System objects for foreground detection and blob analysis

    % The foreground detector is used to segment moving objects from
    % the background. It outputs a binary mask, where the pixel value
    % of 1 corresponds to the foreground and the value of 0 corresponds
    % to the background.

    obj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
        'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.7);

    % Connected groups of foreground pixels are likely to correspond to moving
    % objects.  The blob analysis System object is used to find such groups
    % (called 'blobs' or 'connected components'), and compute their
    % characteristics, such as area, centroid, and the bounding box.

    obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', true, 'CentroidOutputPort', true, ...
        'MinimumBlobArea', 400);
end

function tracks = initializeTracks()
    % create an empty array of tracks
    tracks = struct(...
        'id', {}, ...
        'bbox', {}, ...
        'kalmanFilter', {}, ...
        'age', {}, ...
        'totalVisibleCount', {}, ...
        'consecutiveInvisibleCount', {});
end

function frame = readFrame(obj)
    frame = obj.reader.step();
end

function [centroids, bboxes, mask] = detectObjects(obj, frame)

    % Detect foreground.
    mask = obj.detector.step(frame);

    % Apply morphological operations to remove noise and fill in holes.
    mask = imopen(mask, strel('rectangle', [3,3])); %dilatacion
    mask = imclose(mask, strel('rectangle', [15, 15])); %erosion
    mask = imfill(mask, 'holes');

    % Perform blob analysis to find connected components.
    [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
end

 function tracks_new = predictNewLocationsOfTracks(tracks)
    for i = 1:length(tracks)
        bbox = tracks(i).bbox;

        % Predict the current location of the track.
        predictedCentroid = predict(tracks(i).kalmanFilter);

        % Shift the bounding box so that its center is at
        % the predicted location.
        predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
        tracks(i).bbox = [predictedCentroid, bbox(3:4)];
    end
    
    tracks_new = tracks;
end

function [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks, centroids)

    nTracks = length(tracks);
    nDetections = size(centroids, 1);

    % Compute the cost of assigning each detection to each track.
    cost = zeros(nTracks, nDetections);
    for i = 1:nTracks
        cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
    end

    % Solve the assignment problem.
    costOfNonAssignment = 20;
    [assignments, unassignedTracks, unassignedDetections] = ...
        assignDetectionsToTracks(cost, costOfNonAssignment);
end

function tracks_new = updateAssignedTracks(assignments, centroids, bboxes, tracks)
    numAssignedTracks = size(assignments, 1);
    for i = 1:numAssignedTracks
        trackIdx = assignments(i, 1);
        detectionIdx = assignments(i, 2);
        centroid = centroids(detectionIdx, :);
        bbox = bboxes(detectionIdx, :);

        % Correct the estimate of the object's location
        % using the new detection.
        correct(tracks(trackIdx).kalmanFilter, centroid);

        % Replace predicted bounding box with detected
        % bounding box.
        tracks(trackIdx).bbox = bbox;

        % Update track's age.
        tracks(trackIdx).age = tracks(trackIdx).age + 1;

        % Update visibility.
        tracks(trackIdx).totalVisibleCount = ...
            tracks(trackIdx).totalVisibleCount + 1;
        tracks(trackIdx).consecutiveInvisibleCount = 0;
    end
    tracks_new = tracks;
end

function tracks_new = updateUnassignedTracks(unassignedTracks, tracks)
    for i = 1:length(unassignedTracks)
        ind = unassignedTracks(i);
        tracks(ind).age = tracks(ind).age + 1;
        tracks(ind).consecutiveInvisibleCount = ...
            tracks(ind).consecutiveInvisibleCount + 1;
    end
    tracks_new = tracks;
end

function bboxes = displayTrackingResults(frame, mask, tracks, obj, index_frame, boxoverlapped)
    [height_frame, width_frame, ~] = size(frame);
    %size(frame)
    % Convert the frame and the mask to uint8 RGB.
    frame = im2uint8(frame);
    mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
    
    
    
   bboxes = []; 

    minVisibleCount = 8;
    if ~isempty(tracks)

        % Noisy detections tend to result in short-lived tracks.
        % Only display tracks that have been visible for more than
        % a minimum number of frames.
        reliableTrackInds = ...
            [tracks(:).totalVisibleCount] > minVisibleCount;
        reliableTracks = tracks(reliableTrackInds);

        % Display the objects. If an object has not been detected
        % in this frame, display its predicted bounding box.
        if ~isempty(reliableTracks)
            % Get bounding boxes.
            bboxes = cat(1, reliableTracks.bbox);

            % Get ids.
            ids = int32([reliableTracks(:).id]);

            % Create labels for objects indicating the ones for
            % which we display the predicted rather than the actual
            % location.
            labels = cellstr(int2str(ids'));
            predictedTrackInds = ...
                [reliableTracks(:).consecutiveInvisibleCount] > 0;
            isPredicted = cell(size(labels));
            isPredicted(predictedTrackInds) = {' predicted'};
            labels = strcat(labels, isPredicted);

            %boxes_overlapped = find_overlaps(bboxes, index_frame, width_frame, height_frame);
                     
            % Draw the objects on the frame.
            frame = insertObjectAnnotation(frame, 'rectangle', ...
                bboxes, labels);

            % Draw the objects on the mask.
            mask = insertObjectAnnotation(mask, 'rectangle', ...
                bboxes, labels);
            
            %if(boxes_overlapped ~= 0)
            %    frame = insertObjectAnnotation(frame, 'rectangle', ...
            %    boxes_overlapped, '  TOTAL ', 'Color',{'cyan'});
            %end    
            
           
            
        end
    
   % else
     %   stringg = 'empty tracks'
     %   
    end

    % Display the mask and the frame.
    obj.maskPlayer.step(mask);
    obj.videoPlayer.step(frame);
end


function boxes_overlapped = find_overlaps(bboxes, index_frame, width_frame, height_frame)
    %if(index_frame ~= 26)
    %    boxes_overlapped = 0;
    %    return;
    %end
    
    %pause(0.5);

    % algoritmo
    % busco el box de mayor area, y despues uno los boxes a su alrededor.
    % ESTE ALGORITMO SOLO FUNCIONA PARA PELEAS DONDE EL SON EL UNICO
    % MOVIMIENTO, MAYORMETE PUEDEN SER EN INDOORS.
    
    [rows, cols] = size(bboxes);
    
    if(rows == 0 || cols == 0)
        boxes_overlapped = 0;
        return;
    end
    
    %buscamos el box con mayor area
    max_area = 0;
    max_area_index = 0;
    
    for i = 1 : rows 
        tmp_area = bboxes(i, 3) * bboxes(i, 4);
        if( tmp_area >  max_area)
            max_area =  tmp_area;
            max_area_index = i;
        end    
    end
    
    %max_area_index
    
    %buscamos sus vecinos
    %calculamos el punto medio y radio del box como si fuera una
    %circunfrencia. (box)(x,y,width,height). la posicion 0,0 es la esquina
    %superior izquierda
    
    width =  bboxes(max_area_index, 3);
    height =  bboxes(max_area_index, 4);
    x_o = bboxes(max_area_index, 1);
    y_o = bboxes(max_area_index, 2);
    x_c = x_o + ( width / 2);
    y_c = y_o + ( height / 2);
    radio = sqrt( double((x_c - x_o)^2  + (y_c - y_o)^2 ));
    radio = radio + radio;
    
    %disp(x_o);
    %disp(y_o);
    %disp(x_c);
    %disp(y_c);
    %disp(radio);
    
    intercep_index = []; %guardara los box q se interceptan
    
    
    
    for i = 1 : rows 
        if(i == max_area_index)
            continue;
        end   
        
        %hayamos el punto medio de cada box
        temp_width =  bboxes(i, 3);
        temp_height =  bboxes(i, 4);
        temp_x_o = bboxes(i, 1);
        temp_y_o = bboxes(i, 2);
        temp_x_c = temp_x_o + ( temp_width / 2);
        temp_y_c = temp_y_o + ( temp_height / 2);
        
        %dstancia euclideana entre el box i y el box de mayor area
        distancia = sqrt( double((x_c - temp_x_c)^2  + (y_c - temp_y_c)^2 ));
        
        if( distancia < radio ) %intercepcion o estan cercanos.
            intercep_index = [intercep_index i];
        end            
    end
    
    
    %buscamos los margenes minimos y maximos
    [r,c] = size(intercep_index);
    x_min = bboxes(max_area_index, 1);
    y_min = bboxes(max_area_index, 2);
    x_max = bboxes(max_area_index, 1) + bboxes(max_area_index, 3);
    y_max = bboxes(max_area_index, 2) + bboxes(max_area_index, 4);
    
    %disp('MAX area');
    %disp([x_min y_min x_max y_max]);
    
    for i = 1 : c 
        t_x_min = bboxes(intercep_index(i), 1);
        t_y_min = bboxes(intercep_index(i), 2);
        t_x_max = bboxes(intercep_index(i), 1) + bboxes(intercep_index(i), 3);
        t_y_max = bboxes(intercep_index(i), 2) + bboxes(intercep_index(i), 4);
        
        %disp('TEMP');
        %disp([t_x_min t_y_min t_x_max t_y_max]);
        
        if(x_min > t_x_min)            
            x_min = t_x_min;
        end
        if(y_min > t_y_min) 
            y_min = t_y_min;
        end
        if(x_max < t_x_max) 
            x_max = t_x_max;
        end
        if(y_max < t_y_max) 
            y_max = t_y_max;
        end
    end
    
    %verificamos los margenes
    x_min = x_min - 5;
    y_min = y_min - 5;
    x_max = x_max + 5;
    y_max = y_max + 5;
    
    if(x_min < 1)
        x_min = 1;
    end
    if(y_min < 1) 
        y_min = 1;
    end
    if(x_max > width_frame) 
        x_max = width_frame;
    end
    if(y_max > height_frame) 
        y_max = height_frame;
    end
    
    boxes_overlapped = [x_min, y_min, x_max - x_min, y_max - y_min];
    
    %disp('INDEX FRAME');
    %disp(index_frame);
    
    %disp('INDEX SIZE width_frame');
    %disp(width_frame);
    
    %disp('INDEX SIZE height_frame');
    %disp(height_frame);
    
    %disp('BBOXES');
    %disp(bboxes);
    
    %disp('MAX_AREA');
    %disp(max_area_index);
    
    %disp('INTERCEP_INDEXS');
    %disp(intercep_index);
    
    %disp('BOX_OVERLAPPED');
    %disp(boxes_overlapped);
    
end

