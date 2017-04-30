
data_fights     = csvread('HOCKEY.FIGHT_HS.1HIST.MOVE.csv');  %100 X 40
data_nofights   = csvread('HOCKEY.NOFIGHT_HS.1HIST.MOVE.csv');  %100 X 40
[mhorn_acc, mhorn_sd, mhorn_auc, mhorn_fpr, mhorn_tpr] = analisis(data_fights, data_nofights);

data_fights     = csvread('HOCKEY.FIGHT_HS.1HIST.csv');  %100 X 40
data_nofights   = csvread('HOCKEY.NOFIGHT_HS.1HIST.csv');  %100 X 40
[horn_acc, horn_sd, horn_auc, horn_fpr, horn_tpr] = analisis(data_fights, data_nofights);

%data_fights     = csvread('VIF-IRLS_peliculas_fight_100(SS-3).csv');  %100 X 40
%data_nofights   = csvread('VIF-IRLS_peliculas_no_fight_100(SS-3).csv');  %100 X 40
%[irls_acc, irls_sd, irls_auc, irls_fpr, irls_tpr] = analisis(data_fights, data_nofights);

%data_fights     = csvread('VIF-LucasKanade_peliculas_fight_100(ss-3).csv');  %100 X 40
%data_nofights   = csvread('VIF-LucasKanade_peliculas_no_fight_100(ss-3).csv');  %100 X 40
%[lucas_acc, lucas_sd, lucas_auc, lucas_fpr, lucas_tpr] = analisis(data_fights, data_nofights);


%data_fights     = csvread('VIF_HornSchunk_peliculas_peliculas_peliculas_fight(SS_3).csv');  %100 X 40
%data_nofights   = csvread('VIF_HornSchunk_peliculas_peliculas_peliculas_no_fight(SS_3).csv');  %100 X 40
%[horn_acc, horn_sd, horn_auc, horn_fpr, horn_tpr] = analisis(data_fights, data_nofights);

%data_fights     = csvread('VIF_IRLS_peliculas_peliculas_peliculas_fight(SS_3).csv');  %100 X 40
%%data_nofights   = csvread('VIF_IRLS_peliculas_peliculas_peliculas_no_fight(SS_3).csv');  %100 X 40
%[irls_acc, irls_sd, irls_auc, irls_fpr, irls_tpr] = analisis(data_fights, data_nofights);

%data_fights     = csvread('VIF_LucasKanade_peliculas_peliculas_peliculas_fight(SS_3).csv');  %100 X 40
%data_nofights   = csvread('VIF_LucasKanade_peliculas_peliculas_peliculas_no_fight(SS_3).csv');  %100 X 40
%[lucas_acc, lucas_sd, lucas_auc, lucas_fpr, lucas_tpr] = analisis(data_fights, data_nofights);

plot(horn_fpr, horn_tpr, '--', 'Color','b');
hold on
plot(mhorn_fpr, mhorn_tpr, ':', 'Color','r');
%plot(irls_fpr, irls_tpr, ':', 'Color','r')
%plot(lucas_fpr, lucas_tpr, '-.', 'Color','k')
%axis([-0.03 1.03 0 1.03])
hold off

legend('ViF','Propuesta', 'Location','SE')
xlabel('Tasa de falsos positivos'); 
ylabel('Tasa de verdaderos positivos')
%xlabel('False positive rate'); 
%ylabel('True positive rate')
%title('ROC for violence dataset with three different optic peliculas algorithms')


