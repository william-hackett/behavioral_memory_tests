D = dir('Serial_Position_Task_Performances');
D = D(3:end);

allData_SPT = NaN(12,2,length(D));

for ii = 1:length(D)
    filename = D(ii).name;
    [SPT_data] = prepro_SPT(filename);
    allData_SPT(:,:,ii) = SPT_data;
end

D = dir('Partial_Report_Task_Performances');
D = D(3:end);
allData_PRT = NaN(1,4,length(D));

for ii = 1:length(D)
    filename = D(ii).name;
    [Times,PRT_data] = prepro_PRT(filename);
    allData_PRT(:,:,ii) = PRT_data;
end

D = dir('Mental_Scanning_Performances');
D = D(3:end);
allData_MS = NaN(1,4,length(D));

for ii = 1:length(D)
    filename = D(ii).name;
    [MS_data,dist] = prepro_MS(filename);
    allData_MS(:,:,ii) = MS_data;
end


%%%% Means of SPT
meanSPT_pos1 = mean(allData_SPT(1,2,:));
meanSPT_pos2 = mean(allData_SPT(2,2,:));
meanSPT_pos3 = mean(allData_SPT(3,2,:));
meanSPT_pos4 = mean(allData_SPT(4,2,:));
meanSPT_pos5 = mean(allData_SPT(5,2,:));
meanSPT_pos6 = mean(allData_SPT(6,2,:));
meanSPT_pos7 = mean(allData_SPT(7,2,:));
meanSPT_pos8 = mean(allData_SPT(8,2,:));
meanSPT_pos9 = mean(allData_SPT(9,2,:));
meanSPT_pos10 = mean(allData_SPT(10,2,:));
meanSPT_pos11 = mean(allData_SPT(11,2,:));
meanSPT_pos12 = mean(allData_SPT(12,2,:));

referenceResultsSPT = [61 48 38 34 35 38 45 53 62 69 82 95];
positionResults = [meanSPT_pos1,meanSPT_pos2,meanSPT_pos3,meanSPT_pos4,...
    meanSPT_pos5,meanSPT_pos6,meanSPT_pos7,meanSPT_pos8,meanSPT_pos9,...
    meanSPT_pos10,meanSPT_pos11,meanSPT_pos12];
numRects= 12; 

SPT_graph = figure;
%%% plot SPT data from all trials
plot(1:numRects,positionResults, '-o', 'LineWidth', 2,...
    'Color', [0.5 0 0],...
    'MarkerFaceColor', [0.5 0 0],...
    'MarkerEdgeColor', [0.5 0 0],...
    'MarkerSize', 7);
hold on
%%% plot reference points
plot(1:numRects,referenceResultsSPT,'-d', 'LineWidth', 2,...
    'Color', [0 0 0.5],...
    'MarkerFaceColor', [0 0 0.5],...
    'MarkerEdgeColor', [0 0 0.5],...
    'MarkerSize', 7);
hold off
xlim([0 numRects+1])
ylim([0 110])
xticks(1:numRects)
yticks([0 20 40 60 80 100])
xlabel('Position in List');
ylabel('Percent Recalled');
title('Serial Position Task Results');
legend('Your Results','Reference Results');




%%% Means of PRT
meanPRT_002sec = mean(allData_PRT(1,1,:));
meanPRT_01sec = mean(allData_PRT(1,2,:));
meanPRT_03sec = mean(allData_PRT(1,3,:));
meanPRT_1sec = mean(allData_PRT(1,4,:));


%%%% redefine Y
Y_PRT = [meanPRT_002sec meanPRT_01sec meanPRT_03sec meanPRT_1sec];
Y_r = [65 55 45 35];


%%% make graph of percentage correct data
Partial_Report_Graph = figure;
%%%% plot data from all trials
plot(Y_PRT,'-o', 'LineWidth',2,...
    'Color',[.5 0 0],...
    'MarkerEdgeColor',[.5 0 0],...
    'MarkerFaceColor',[.5 0 0],...
    'MarkerSize',7);
hold on
%%% plot reference points
plot(Y_r,'b-d', 'LineWidth',2,...
    'Color',[0 0 .5],...
    'MarkerEdgeColor',[0 0 .5],...
    'MarkerFaceColor',[0 0 .5],...
    'MarkerSize',7);
hold off
title('Partial Report Task Results');
ylim([0 100]);
xticks([0 1 2 3 4 5]);
xticklabels({'','.0200','.100', '.300', '1.00', ''})
xlabel('Time Interval Between Stimulus Display and Response Prompt(sec)');
ylabel('Percent Recalled');
legend('Your Results','Reference Results');


%%% Mean of MS
meanMS_avg20 = mean(allData_MS(1,1,:));
meanMS_avg40 = mean(allData_MS(1,2,:));
meanMS_avg60 = mean(allData_MS(1,3,:));
meanMS_avg80 = mean(allData_MS(1,4,:));

Y_MS = [meanMS_avg20 1; meanMS_avg40 1.25; meanMS_avg60 1.5; meanMS_avg80 1.75];
%%% make graph of percentage correct data
Mental_Scanning_Graph = figure;
%%%% plot data from all trials
bar(Y_MS,'grouped');
bar_name = bar(Y_MS,'grouped');
set(bar_name(1),'FaceColor',[.5 0 0])
set(bar_name(2),'FaceColor',[0 0 .5])
title('Mental Scanning Task Results');
ylim([0 4]);
xticks([0 1 2 3 4 5]);
xticklabels({'','.20','.40', '60', '80', ''})
xlabel('Distance in Pixels');
ylabel('Response Time(sec)');
legend('Your Results','Reference Results');
