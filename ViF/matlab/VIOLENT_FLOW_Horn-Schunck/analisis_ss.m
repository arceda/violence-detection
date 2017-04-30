
data_fights     = csvread('VIF-HornSchunk_peliculas_fight_100(SS-1).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_peliculas_no_fight_100(SS-1).csv');  %100 X 40
[peliculas_acc1, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_peliculas_fight_100(SS-2).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_peliculas_no_fight_100(SS-2).csv');  %100 X 40
[peliculas_acc2, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_peliculas_fight_100(SS-3).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_peliculas_no_fight_100(SS-3).csv');  %100 X 40
[peliculas_acc3, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_peliculas_fight_100(SS-6).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_peliculas_no_fight_100(SS-6).csv');  %100 X 40
[peliculas_acc6, ~, ~, ~, ~] = analisis(data_fights, data_nofights);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


data_fights     = csvread('VIF-HornSchunk_hockey_fight_500(SS-1).csv');  %500 X 40
data_nofights   = csvread('VIF-HornSchunk_hockey_no_fight_500(SS-1).csv');  %500 X 40
[hockey_acc1, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_hockey_fight_500(SS-2).csv');  %500 X 40
data_nofights   = csvread('VIF-HornSchunk_hockey_no_fight_500(SS-2).csv');  %500 X 40
[hockey_acc2, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_hockey_fight_500(SS-3).csv');  %500 X 40
data_nofights   = csvread('VIF-HornSchunk_hockey_no_fight_500(SS-3).csv');  %500 X 40
[hockey_acc3, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_hockey_fight_500(SS-6).csv');  %500 X 40
data_nofights   = csvread('VIF-HornSchunk_hockey_no_fight_500(SS-6).csv');  %500 X 40
[hockey_acc6, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


data_fights     = csvread('VIF-HornSchunk_flow_fight_123(SS-1).csv');  %123 X 40
data_nofights   = csvread('VIF-HornSchunk_flow_no_fight_123(SS-1).csv');  %123 X 40
[flow_acc1, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_flow_fight_123(SS-2).csv');  %123 X 40
data_nofights   = csvread('VIF-HornSchunk_flow_no_fight_123(SS-2).csv');  %123 X 40
[flow_acc2, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_flow_fight_123(SS-3).csv');  %123 X 40
data_nofights   = csvread('VIF-HornSchunk_flow_no_fight_123(SS-3).csv');  %123 X 40
[flow_acc3, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_flow_fight_123(SS-6).csv');  %123 X 40
data_nofights   = csvread('VIF-HornSchunk_flow_no_fight_123(SS-6).csv');  %123 X 40
[flow_acc6, ~, ~, ~, ~] = analisis(data_fights, data_nofights);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


data_fights     = csvread('VIF-HornSchunk_SVV_fight_100(SS-1).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_SVV_no_fight_100(SS-1).csv');  %100 X 40
[SVV_acc1, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_SVV_fight_100(SS-2).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_SVV_no_fight_100(SS-2).csv');  %100 X 40
[SVV_acc2, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_SVV_fight_100(SS-3).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_SVV_no_fight_100(SS-3).csv');  %100 X 40
[SVV_acc3, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

data_fights     = csvread('VIF-HornSchunk_SVV_fight_100(SS-6).csv');  %100 X 40
data_nofights   = csvread('VIF-HornSchunk_SVV_no_fight_100(SS-6).csv');  %100 X 40
[SVV_acc6, ~, ~, ~, ~] = analisis(data_fights, data_nofights);

resumen = [peliculas_acc1, peliculas_acc2, peliculas_acc3, peliculas_acc6 ; hockey_acc1, hockey_acc2, hockey_acc3, hockey_acc6 ; flow_acc1, flow_acc2, flow_acc3, flow_acc6 ; SVV_acc1, SVV_acc2, SVV_acc3, SVV_acc6];

dlmwrite('resumen_ss.csv', resumen, ',');

