

function [array_acc_auc] =  analisis_svm_kernel()

    data_fights     = csvread('VIF-HornSchunk_SVV_fight_70(SS-3).csv');  %100 X 40
    data_nofights   = csvread('VIF-HornSchunk_SVV_no_fight_70(SS-3).csv');  %100 X 40

    [a, b] = size(data_fights);
    [c, d] = size(data_nofights);

    X               = [data_fights; data_nofights];

    Y_fights    = ones(a,1);
    Y_nofights  = zeros(c,1);
    %Y_nofights  = Y_nofights-1;

    %Y_fights = cell(a, 1);
    %Y_fights(:) = {'fights'};
    %Y_nofights = cell(c, 1);
    %Y_nofights(:) = {'nofights'};

    Y = [Y_fights; Y_nofights];


    k=10;

    %YPerFold = cell(k,1);                   %Guarda el Y de cada fold
    %scorePerFold = cell(k,1);               %Guarda la salida del clasificador por cada fold

    cvFolds = crossvalind('Kfold', Y, k);   %# get indices of 10-fold CV

    %cp = classperf(Y);
    array_acc_auc = cell(10);
    for j = 1:10
        
        
        
    
        CorrectR = [];
        AUC_array = [];

        Y_all = [];
        pred_all = []; 

        models = cell(k);

        for i = 1:k                                  %# for each fold
            testIdx = (cvFolds == i);                %# get indices of test instances
            trainIdx = ~testIdx;                     %# get indices training instances

            options.MaxIter = 1000000;
            svmModel = svmtrain(X(trainIdx,:), Y(trainIdx), 'Options', options, 'kernel_function', 'polynomial', 'polyorder', j);
            models{i} = svmModel;
            %svmModel = svmtrain(X(trainIdx,:), Y(trainIdx));

            %# test using test instances
            pred = svmclassify(svmModel, X(testIdx,:));

            %YPerFold{i} = Y(testIdx,:);
            %scorePerFold{i} = pred;

            Y_all = [ Y_all; Y(testIdx,:) ]; %guardamos todos los Y
            pred_all = [ pred_all; pred ]; %guardamos todas las pedicciones de los modelos

            CorrectR  = [ CorrectR;  sum(Y(testIdx,:) == pred) / length(Y(testIdx,:)) ];
            %CorrectR  = [ CorrectR;  sum(  strcmp( Y(testIdx,:), pred )   ) / length(Y(testIdx,:)) ];

            %classperf(cp, pred, testIdx); % se incluye esto xq se quiere validar que classperf.corectrate es lo mismo que nuestro corerct rate calculado

        end

        %[FPR, TPR, Thr, AUC, OPTROCPT]  = perfcurve(Y(testIdx,:), pred, 1);
        %[FPR, TPR, Thr, AUC, OPTROCPT]  = perfcurve(Y_all, pred_all, 1); %procesamos, esto genera un AUC igual al accuracy

        %buscamos el mejor modelo para procsar el auc y roc
        [max_acc, idx] = max(CorrectR);
        max_model = models{idx};
        testIdx = (cvFolds == idx);  
        pred = svmclassify(max_model, X(testIdx,:));
        [FPR, TPR, Thr, AUC, OPTROCPT]  = perfcurve(Y(testIdx,:), pred, 1);
        %pred = svmclassify(max_model, X);
        %[FPR, TPR, Thr, AUC, OPTROCPT]  = perfcurve(Y, pred, 1);
        %plot(FPR, TPR);
        %xlabel('False positive rate'); ylabel('True positive rate')
        %title('ROC for classification SVM')

        auc = AUC;
        acc = mean(CorrectR);
        sd = std(CorrectR);
        fpr = FPR;
        tpr = TPR;
        %acc_cp = cp.CorrectRate

        
        array_acc_auc{j} = strcat(num2str(acc), '+-', num2str(sd), ' ; ', num2str(auc));
        array_acc_auc{j}
        
    end

    
end

