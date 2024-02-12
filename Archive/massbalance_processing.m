
% This script takes in the readings of the mass and balance and calculate cg
% positions for the aircraft. The cg of each spine is displayed in a plot
% along with the standard deviation. Two set of readings (one for the RRV
% and one for the ATV are taken in and compared)
% The data should be formatted such that the scales readings are arranged
% in the following manner
% front stations for spines 3, 1, 0, 2, 4 form the first five rows (rows 1:5)
% of any given data set. Rear stations at the same spines in the same
% order form the 7th through 11th rows (7:11) in each data set. This means
% that each reading for the X-HALE is a column vector with the entries
% (1:5) corresponding to the front scale readings and the entries (7:11)
% corresponding to the rear scales readings at the spines 3, 1, 0, 2, 4

% Note: In this script, the data for rrv is actually the 

clc;
clear;
close all;
set(0, 'DefaultAxesFontName', 'Times');

arm=18.4; % moment arm for the mass at the rear wheel
% about the front wheel (cm)

span=transpose([-2,-1,0,1,2]); % left is negative

lemac=8.1;     % distance from LE of the wing to the front wheel (cm)
mac=20;        % chord length of the wing (cm)

% load raw data file placed in the same folder for now
load('massbalancedata.txt');

% range of interest from the text file, need to know a priori
roi_rrv=22:41; % atv feb 2023 
roi_atv=6:21;  % atv may 2018

% initialize structure for saving data and calculating statistics
data_rrv=struct('front_scales',[],'rear_scales',[],'mass_spine',[],'spine_cg',[]);
stats_rrv=struct('xcg',[],'mean_cg',[],'mean_mass_front',[],'mean_mass_rear',[],'mean_mass_spine',[],'stdcg',[],'stdf',[],'stdr',[],'stdm',[]);
data_atv=struct('front_scales',[],'rear_scales',[],'mass_spine',[],'spine_cg',[]);
stats_atv=struct('xcg',[],'mean_cg',[],'mean_mass_front',[],'mean_mass_rear',[],'mean_mass_spine',[],'stdcg',[],'stdf',[],'stdr',[],'stdm',[]);

% assign data to struct
% for RRV
for i=1:length(roi_rrv)
    data_rrv.front_scales(:,i) = massbalancedata(1:5,roi_rrv(i));
    data_rrv.rear_scales(:,i) = massbalancedata(7:11,roi_rrv(i));
end

% for ATV
for i=1:length(roi_atv)
    data_atv.front_scales(:,i) = massbalancedata(1:5,roi_atv(i));
    data_atv.rear_scales(:,i) = massbalancedata(7:11,roi_atv(i));
end

% add front and rear readings to create the sum of the masses at the spine
data_rrv.mass_spine = data_rrv.front_scales + data_rrv.rear_scales;
data_atv.mass_spine = data_atv.front_scales + data_atv.rear_scales;

% calculate cg of each spine based on front and rear scale readings
data_rrv.spine_cg=(data_rrv.rear_scales*arm./data_rrv.mass_spine-lemac)/mac*100;
data_atv.spine_cg=(data_atv.rear_scales*arm./data_atv.mass_spine-lemac)/mac*100;

for i=1:5 % for each spine, calculate statistics
    stats_rrv.mean_cg(i)=mean(data_rrv.spine_cg(i,:));
    stats_rrv.mean_mass_front(i)=mean(data_rrv.front_scales(i,:));
    stats_rrv.mean_mass_rear(i)=mean(data_rrv.rear_scales(i,:));
    stats_rrv.mean_mass_spine(i)=mean(data_rrv.mass_spine(i,:));
    stats_rrv.stdcg(i)=std(data_rrv.spine_cg(i,:));
    stats_rrv.stdf(i)=std(data_rrv.front_scales(i,:));
    stats_rrv.stdr(i)=std(data_rrv.rear_scales(i,:));
    stats_rrv.stdm(i)=std(data_rrv.mass_spine(i,:));
    
    stats_atv.mean_cg(i)=mean(data_atv.spine_cg(i,:));
    stats_atv.mean_mass_front(i)=mean(data_atv.front_scales(i,:));
    stats_atv.mean_mass_rear(i)=mean(data_atv.rear_scales(i,:));
    stats_atv.mean_mass_spine(i)=mean(data_atv.mass_spine(i,:));
    stats_atv.stdcg(i)=std(data_atv.spine_cg(i,:));
    stats_atv.stdf(i)=std(data_atv.front_scales(i,:));
    stats_atv.stdr(i)=std(data_atv.rear_scales(i,:));
    stats_atv.stdm(i)=std(data_atv.mass_spine(i,:));
end

% Calculate mean xcg based on xcg calculated over the measurements
stats_rrv.xcg=mean(((sum(data_rrv.rear_scales(1:5,:))*arm)./sum(data_rrv.mass_spine(1:5,:))-lemac)/mac);
stats_atv.xcg=mean(((sum(data_atv.rear_scales(1:5,:))*arm)./sum(data_atv.mass_spine(1:5,:))-lemac)/mac);

% assign text so error bars and data labels are shown properly in the plot
% for cg
text_std_cg_rrv=num2str(round(stats_rrv.stdcg,1)');
text_mean_cg_rrv=num2str(round(stats_rrv.mean_cg,1)');
txt_cg_rrv=[[' ';' ';' ';' ';' '],text_mean_cg_rrv,[',';',';',';',';','],text_std_cg_rrv];
text_std_cg_atv=num2str(round(stats_atv.stdcg,1)');
text_mean_cg_atv=num2str(round(stats_atv.mean_cg,1)');
txt_cg_atv=[[' ';' ';' ';' ';' '],text_mean_cg_atv,[',';',';',';',';','],text_std_cg_atv];

% for mass
text_std_mass_rrv=num2str(round(stats_rrv.stdm,1)');
text_mean_mass_rrv=num2str(round(stats_rrv.mean_mass_spine,1)');
txt_mass_rrv=[[' ';' ';' ';' ';' '],text_mean_mass_rrv,[',';',';',';',';','],text_std_mass_rrv];
text_std_mass_atv=num2str(round(stats_atv.stdm,1)');
text_mean_mass_atv=num2str(round(stats_atv.mean_mass_spine,1)');
txt_mass_atv=[[' ';' ';' ';' ';' '],text_mean_mass_atv,[',';',';',';',';','],text_std_mass_atv];

% plot
% cg and its standard deviation
h1=figure('color','white','units','inches','outerposition',[1 1 9 7]);

subplot(2,1,1)
errorbar(span,stats_atv.mean_cg,stats_atv.stdcg,'r.','LineWidth',2);
% title(['RRV Config 2 w/foam (average XCG = ',num2str(stats_atv.xcg*100),' %) ']);
title(['Original ATV (average cg as a percent of chord = ',num2str(stats_atv.xcg*100),' %) ']);
ylabel('CG Position in % of Chord');
xlabel('Station number on the craft');
xlim([-3,3]), ylim([0,100]);
set(gca,'Ydir','reverse');
set(gca,'FontSize',20);
set(gca,'Xticklabel',{' ','3','1','0','2','4'});
text(span,stats_atv.mean_cg,txt_cg_atv,'HorizontalAlignment','left','FontSize',20)

subplot(2,1,2)
errorbar(span,stats_rrv.mean_cg,stats_rrv.stdcg,'r.','LineWidth',2);
title(['Updated ATV (average cg as a percent of chord = ',num2str(stats_rrv.xcg*100),' %) ']);
ylabel('CG Position in % of Chord');
xlabel('Station number on the craft');
xlim([-3,3]), ylim([0,100]);
set(gca,'Ydir','reverse');
set(gca,'FontSize',20);
set(gca,'Xticklabel',{' ','3','1','0','2','4'});
text(span,stats_rrv.mean_cg,txt_cg_rrv,'HorizontalAlignment','left','FontSize',20)

% mass and its standard deviation
h2=figure('color','white','units','inches','outerposition',[1 1 9 7]);

subplot(2,1,1)
errorbar(span,stats_atv.mean_mass_spine,stats_atv.stdm,'r.','LineWidth',2);
% title(['RRV config 2 w/foam (average total mass = ',num2str(round(sum(stats_atv.mean_mass_spine)),5),' g) ']);
title(['ATV 2018 (average total mass = ',num2str(round(sum(stats_atv.mean_mass_spine)),5),' g) ']);
ylabel('Mass of spine in grams');
xlabel('Station # on the craft');
xlim([-3,3]);
set(gca,'Ydir','reverse');
set(gca,'Xticklabel',{' ','3','1','0','2','4'});
text(span,stats_atv.mean_mass_spine,txt_mass_atv,'HorizontalAlignment','left')

subplot(2,1,2)
errorbar(span,stats_rrv.mean_mass_spine,stats_rrv.stdm,'r.','LineWidth',2);
title(['ATV Feb. 2023 (average total mass = ',num2str(round(sum(stats_rrv.mean_mass_spine)),5),' g) ']);
ylabel('Mass of spine in grams');
xlabel('Station # on the craft');
xlim([-3,3]);
set(gca,'Ydir','reverse');
set(gca,'Xticklabel',{' ','3','1','0','2','4'});
text(span,stats_rrv.mean_mass_spine,txt_mass_rrv,'HorizontalAlignment','left')




