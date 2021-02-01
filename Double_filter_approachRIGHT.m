%% Find healstrikes in APDM data
% This script will find midswings, healtsrikes and toe-offs based on
% rate of change of the tibia angular velocity data


% Tom, Hannah, ChrisT, Jake
%% RIGHT LEG

clear
clc
cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\Double_task_H5_files\')
h5fpath='C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\Double_task_H5_files\';

h5filespath=strcat(h5fpath,'*.h5');
h5files=dir(fullfile(h5filespath));
for VF=5%:numel(h5files)
% % %     if VF == 3
% % %         continue
% % %     end
    %% LOAD DATA
    sp='-';
    TT=strcat((h5files(VF).name),sp,'Right leg');
    TT=char(TT);
    File=strcat(h5files(VF).name);
    File=char(File);
    rx = hdf5read(File, '/SI-001206/Calibrated/Gyroscopes');
    rx=transpose(rx);
    rx=rx(:,2);
    x = rx;
    %% Check number of mid swings on raw data
       [~,locsraw]=findpeaks(x*-1,'minpeakheight',0.3, 'minpeakdistance', 100);
    
    min_diffSW_peaks=min(diff(locsraw));
    [~,locsraw]=findpeaks(x*-1,'minpeakdistance', min_diffSW_peaks-1);
    
    num_midswings = numel(locsraw);
    %% Filter using second order low pass 3Hz
    
    fc = 3;
    fs = 128;

[b,a] = butter(2,fc/(fs/2));
xf1 = filter(b,a,x);
    
    %% FINDING MID-SWING
    [~,locsf1]=findpeaks(xf1*-1,'minpeakheight',0.3, 'minpeakdistance', 100);
    
    min_diffSW_peaks=min(diff(locsf1));
    [~,locsf1]=findpeaks(xf1*-1,'minpeakdistance', min_diffSW_peaks-1);
    
   
    %% FINDING HEAL-STRIKE
    if numel(locsf1) > num_midswings
        locsf1(end:end)=[];
        locsf1(1:2)=[];
    elseif numel(locsf1) < num_midswings
        
        locsf1(1)=[];
    else
        locsf1(end:end)=[];
        locsf1(1)=[];
    end
    h=table(xf1(locsf1),xf1(locsf1+1),xf1(locsf1+2),xf1(locsf1+3),xf1(locsf1+4),xf1(locsf1+5),...
        xf1(locsf1+6),xf1(locsf1+7),xf1(locsf1+8),xf1(locsf1+9),xf1(locsf1+10),xf1(locsf1+11),...
        xf1(locsf1+12),xf1(locsf1+13),xf1(locsf1+14),xf1(locsf1+15),xf1(locsf1+16),xf1(locsf1+17),...
        xf1(locsf1+18),xf1(locsf1+19),xf1(locsf1+20),xf1(locsf1+21),xf1(locsf1+22),xf1(locsf1+23),...
        xf1(locsf1+24),xf1(locsf1+25),xf1(locsf1+26),xf1(locsf1+27),xf1(locsf1+28),xf1(locsf1+29),...
        xf1(locsf1+30),xf1(locsf1+31),xf1(locsf1+32),xf1(locsf1+33),xf1(locsf1+34),xf1(locsf1+35),...
        xf1(locsf1+36),xf1(locsf1+37),xf1(locsf1+38),xf1(locsf1+39),xf1(locsf1+40),xf1(locsf1+41),...
        xf1(locsf1+42),xf1(locsf1+43),xf1(locsf1+44),xf1(locsf1+45),xf1(locsf1+46),xf1(locsf1+47),...
        xf1(locsf1+48),xf1(locsf1+49),xf1(locsf1+50),xf1(locsf1+51),xf1(locsf1+52),xf1(locsf1+53),...
        xf1(locsf1+54),xf1(locsf1+55),xf1(locsf1+56),xf1(locsf1+57));
    a=h{:,:};
    a=transpose(a);
    
    for b=1:numel(locsf1)
        [pkst,locstt]=findpeaks(a(:,b),'minpeakheight', 0);
    end
    locsf1=transpose(locsf1);
    HST=locsf1+locstt;
    MSms=locsf1*0.007825;
    

    
    
    %% FINDING TOE-OFF
    htoeoff=table(xf1(locsf1-25),xf1(locsf1-26),xf1(locsf1-27),xf1(locsf1-28),...
        xf1(locsf1-29),xf1(locsf1-30),xf1(locsf1-31),xf1(locsf1-32),xf1(locsf1-33),xf1(locsf1-34),...
        xf1(locsf1-35),xf1(locsf1-36),xf1(locsf1-37),xf1(locsf1-38),xf1(locsf1-39),xf1(locsf1-40),...
        xf1(locsf1-41),xf1(locsf1-42),xf1(locsf1-43),xf1(locsf1-44),xf1(locsf1-45),xf1(locsf1-46),...
        xf1(locsf1-47),xf1(locsf1-48),xf1(locsf1-49),xf1(locsf1-50),xf1(locsf1-51),xf1(locsf1-52),...
        xf1(locsf1-53),xf1(locsf1-54),xf1(locsf1-55),xf1(locsf1-56),xf1(locsf1-57),xf1(locsf1-58),...
        xf1(locsf1-59),xf1(locsf1-60),xf1(locsf1-61),xf1(locsf1-62),xf1(locsf1-63),xf1(locsf1-64),...
        xf1(locsf1-65),xf1(locsf1-66),xf1(locsf1-67),xf1(locsf1-68),xf1(locsf1-69),xf1(locsf1-70),...
        xf1(locsf1-71),xf1(locsf1-72),xf1(locsf1-73),xf1(locsf1-74),xf1(locsf1-75),xf1(locsf1-76),...
        xf1(locsf1-77));
    a=htoeoff{:,:};
    a=transpose(a);
    for b=1:numel(locsf1)
        [pksto(b),locsto(b)]=findpeaks(a(:,b),'minpeakheight', 0,'minpeakdistance',4, 'npeaks',1);%'minpeakprominence', 0.1,
        hold on
    end
    
    
    TOT=locsf1-locsto-24;
   
    
    
    
   
    %% SECOND STEP ON 10 HZ FILTERED DATA
     %% Filter using second order low pass 3Hz
    
    fc = 10;
    fs = 128;

[b,a] = butter(2,fc/(fs/2));
xf2 = filter(b,a,x);
    
    %% FINDING MID-SWING
    [~,locsf2]=findpeaks(xf2*-1,'minpeakheight',0.3, 'minpeakdistance', 100);
    
    min_diffSW_peaksf2=min(diff(locsf2));
    [~,locsf2]=findpeaks(xf2*-1,'minpeakdistance', min_diffSW_peaksf2-1);
    
    
    %% FINDING HEAL-STRIKE
    if numel(locsf2) > num_midswings
        locsf2(end:end)=[];
        locsf2(1:2)=[];
    elseif numel(locsf2) < num_midswings
        locsf2(1)=[];
    else
        locsf2(end:end)=[];
        locsf2(1)=[];
    end
    hf2=table(xf2(HST),xf2(HST-1),xf2(HST-2),xf2(HST-3),xf2(HST-4),xf2(HST-5),...
        xf2(HST-6),xf2(HST-7),xf2(HST-8),xf2(HST-9),xf2(HST-10),xf2(HST-11),...
        xf2(HST-12),xf2(HST-13),xf2(HST-14),xf2(HST-15),xf2(HST-16),xf2(HST-17),...
         xf2(HST-18),xf2(HST-19),xf2(HST-20),xf2(HST-21),xf2(HST-22),xf2(HST-23),...
         xf2(HST-24),xf2(HST-25),xf2(HST-26),xf2(HST-27),xf2(HST-28),xf2(HST-29),...
         xf2(HST-30),xf2(HST-31),xf2(HST-32),xf2(HST-33),xf2(HST-34),xf2(HST-35));%,...
%         xf2(HST-36),xf2(HST-37),xf2(HST-38),xf2(HST-39),xf2(HST-40),xf2(HST-41),...
%         xf2(HST-42),xf2(HST-43),xf2(HST-44),xf2(HST-45),xf2(HST-46),xf2(HST-47),...
%         xf2(HST-48),xf2(HST-49),xf2(HST-50),xf2(HST-51),xf2(HST-52),xf2(HST-53),...
%         xf2(HST-54),xf2(HST-55),xf2(HST-56),xf2(HST-57));
    ahsf2=hf2{:,:};
    ahsf2=transpose(ahsf2);
    
    for b=1:numel(HST)
       [pkst,locstttf2]=findpeaks(ahsf2(:,b),'minpeakheight', 0);
        locsttf2(b) = locstttf2(end);
    end
    locsf2=transpose(locsf2);
    HSTf2=HST-locsttf2+1;
    MSmsF2=locsf2*0.007825;
    
   
    
    %% FINDING TOE-OFF
       htoeofff2=table(xf2(TOT),xf2(TOT-1),xf2(TOT-2),xf2(TOT-3),xf2(TOT-4),xf2(TOT-5),...
        xf2(TOT-6),xf2(TOT-7),xf2(TOT-8),xf2(TOT-9),xf2(TOT-10),xf2(TOT-11),...
        xf2(TOT-12),xf2(TOT-13),xf2(TOT-14),xf2(TOT-15),xf2(TOT-16),xf2(TOT-17),...
         xf2(TOT-18),xf2(TOT-19),xf2(TOT-20));
     %,xf2(TOT-21),xf2(TOT-22),xf2(TOT-23),...
%         xf2(TOT-24),xf2(TOT-25),xf2(TOT-26),xf2(TOT-27),xf2(TOT-28),xf2(TOT-29),...
%         xf2(TOT-30),xf2(TOT-31),xf2(TOT-32),xf2(TOT-33));
    atof2=htoeofff2{:,:};
    atof2=transpose(atof2);
    for b=1:numel(TOT)
       [pksto(b),locstof2(b)]=findpeaks(atof2(:,b),'minpeakheight', 0,'minpeakdistance',4, 'npeaks',1);%'minpeakprominence', 0.1,
        hold on
    end
    
    
    TOTf2=TOT-locstof2+1;
    
    
    
    
    %% THIRD STEP UNFILTERED
       xf3 = x;
    % create figure
    f=figure('numbertitle', 'off','name', TT,'position', [0 0 1300 691]);
    
    %% FINDING MID-SWING
    [~,locsf3]=findpeaks(xf3*-1,'minpeakheight',0.3, 'minpeakdistance', 100);
    
    min_diffSW_peaksf3=min(diff(locsf3));
    [~,locsf3]=findpeaks(xf3*-1,'minpeakdistance', min_diffSW_peaksf3-1);
    
    
    subplot(2,1,1)
    time=(1:1:numel(xf3));
    time=time*0.007825;
    grid on
    plot(time,xf3*-1);hold on
%     plot(time,xf1*-1);
%     plot(time,xf2*-1);
    hold off
    %% FINDING HEAL-STRIKE
    
    locsf3(end:end)=[];
    locsf3(1)=[];
    hf3=table(xf3(HSTf2),xf3(HSTf2-1),xf3(HSTf2-2),xf3(HSTf2-3),xf3(HSTf2-4),xf3(HSTf2-5),...
        xf3(HSTf2-6),xf3(HSTf2-7),xf3(HSTf2-8),xf3(HSTf2-9),xf3(HSTf2-10),xf3(HSTf2-11),...
        xf3(HSTf2-12),xf3(HSTf2-13),xf3(HSTf2-14));
%     ,xf3(HSTf2-15),xf3(HSTf2-16),xf3(HSTf2-17),...
%         xf3(HSTf2-18),xf3(HSTf2-19),xf3(HSTf2-20),xf3(HSTf2-21),xf3(HSTf2-22),xf3(HSTf2-23),...
%         xf3(HSTf2-24),xf3(HSTf2-25),xf3(HSTf2-26),xf3(HSTf2-27),xf3(HSTf2-28));
%     ,xf3(HSTf2-29),...
%         xf3(HSTf2-30),xf3(HSTf2-31),xf3(HSTf2-32),xf3(HSTf2-33),xf3(HSTf2-34),xf3(HSTf2-35),...
%         xf3(HSTf2-36),xf3(HSTf2-37),xf3(HSTf2-38),xf3(HSTf2-39),xf3(HSTf2-40),xf3(HSTf2-41),...
%         xf3(HSTf2-42),xf3(HSTf2-43),xf3(HSTf2-44),xf3(HSTf2-45),xf3(HSTf2-46),xf3(HSTf2-47),...
%         xf3(HSTf2-48),xf3(HSTf2-49),xf3(HSTf2-50),xf3(HSTf2-51),xf3(HSTf2-52),xf3(HSTf2-53),...
%         xf3(HSTf2-54),xf3(HSTf2-55),xf3(HSTf2-56),xf3(HSTf2-57));
    ahsf3=hf3{:,:};
    ahsf3=transpose(ahsf3);
    
    for b=1:numel(HSTf2)
       [pkst,locstttf3]=findpeaks(ahsf3(:,b),'minpeakheight', 0);
        locsttf3(b) = locstttf3(end);
    end
    locsf3=transpose(locsf3);
    HSTf3=HSTf2-locsttf3+1;
    MSmsF3=locsf3*0.007825;
    
    %% Calculating cadence
    data_time=locsf3(end)-locsf3(1);
    data_time_ms=data_time*0.007825;
    cad_ref=60/data_time_ms;
    CAD=(cad_ref*(numel(locsf3)));
    CADstr=num2str(CAD);
    
    %DISPLAY Cadence
    dim = [.15 .68 .3 .3];
    CM={'Average cadence:',CADstr};
    str=strjoin(CM);
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    
    %% FINDING TOE-OFF
       htoeofff3=table(xf3(TOTf2),xf3(TOTf2-1),xf3(TOTf2-2),xf3(TOTf2-3),xf3(TOTf2-4),xf3(TOTf2-5),...
        xf3(TOTf2-6),xf3(TOTf2-7),xf3(TOTf2-8),xf3(TOTf2-9),xf3(TOTf2-10),xf3(TOTf2-11),...
        xf3(TOTf2-12),xf3(TOTf2-13),xf3(TOTf2-14),xf3(TOTf2-15));
%     ,xf3(TOTf2-16),xf3(TOTf2-17),...
%         xf3(TOTf2-18),xf3(TOTf2-19),xf3(TOTf2-20),xf3(TOTf2-21),xf3(TOTf2-22),xf3(TOTf2-23),...
%         xf3(TOTf2-24),xf3(TOTf2-25),xf3(TOTf2-26),xf3(TOTf2-27),xf3(TOTf2-28),xf3(TOTf2-29),...
%         xf3(TOTf2-30),xf3(TOTf2-31),xf3(TOTf2-32),xf3(TOTf2-33));
    atof3=htoeofff3{:,:};
    atof3=transpose(atof3);
    for b=1:numel(TOTf2)
       [pksto(b),locstof3(b)]=findpeaks(atof3(:,b),'minpeakheight', 0,'minpeakdistance',4, 'npeaks',1);%'minpeakprominence', 0.1,
        hold on
    end
    
    
    TOTf3=TOTf2-locstof3+1;
    TOTf3ms=TOTf3*0.007825;
    locsmsf3=HSTf3*0.007825;
    
    RIGHTTOTms=TOTf3ms;
    RIGHTHSms=locsmsf3;
    RIGHTMSms=MSmsF3;
    
    
    subplot(2,1,1)
    time=(1:1:numel(xf3));
    time=time*0.007825;
    plot(time(locsf3(1):locsf3(end)),xf3(locsf3(1):locsf3(end))*-1);
    
    ax1=gca;
    if numel(xf3)>15000
        ax1.XTick = [1:10:numel(xf3)];
    else ax1.XTick = [1:2:numel(xf3)];
    end
    
    
    
    %TIME DIFFERENCS
    strl=diff(locsmsf3);
    TOstrl=diff(TOTf3ms);
    M=mean(strl);
    MS=num2str(M);
    STD=std(strl);
    STDs=num2str(STD);
    
    MEAN_STRIDETIME(VF) = M;
    STD_STRIDETIME(VF) = STD;
    
    % calculate swing and stance times
    ALL=[TOTf3;HSTf3;MSmsF3];%(1:ME)(1:ME)
    SW=(ALL(2,:)-ALL(1,:));
    SWms=SW*0.007825;
    RIGHTSWms=SWms;
    
    STms=strl-SWms(1:numel(strl));
    RIGHTSTms=STms;
    
    RIGHTPREINISWms=(ALL(3,:)-ALL(1,:)*0.007825);
    RIGHTTERMSWms=(ALL(2,:)*0.007825-ALL(3,:));
    
    RIGHTSTRTms=strl;
    l=num2str(locsmsf3);
    
    
    % calculating mean and std for swing and stance
    MSWNG=mean(SWms);
    MSSWNG=num2str(MSWNG);
    STDSWNG=std(SWms);
    STDSWNGstr=num2str(STDSWNG);
    
    MEAN_SWING(VF) = MSWNG;
    STD_SWING(VF) = STDSWNG;
    
    MSTNC=mean(STms);
    MSSTNC=num2str(MSTNC);
    STDSTNC=std(STms);
    STDSTNCstr=num2str(STDSTNC);
    
    MEAN_STANCE(VF) = MSTNC;
    STD_STANCE(VF) = STDSTNC;
    
    title('Shank angular velocity')
    xlabel('Time in seconds')
    ylabel('Angular velocity (rad/s)')
    
    
    plot(locsmsf3, xf3(HSTf3)*-1,'r*')
    plot(TOTf3ms, xf3(TOTf3)*-1,'b*')
    
    grid on
    
    subplot(2,1,2)
    
    %DISPLAY SWING AVERAGE TIME
    dim = [.05 .25 .3 .3];
    CM={'Average swing time:',MSSWNG};
    str=strjoin(CM);
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    CS={'Standard Deviation:',STDSWNGstr};
    strstd=strjoin(CS);
    dimstd = [.05 .2 .3 .3];
    annotation('textbox',dimstd,'String',strstd,'FitBoxToText','on');% plot(strl)
    
    dim = [.25 .25 .3 .3];
    CM={'Average stance time:',MSSTNC,};
    str=strjoin(CM);
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    CS={'Standard Deviation:',STDSTNCstr};
    strstd=strjoin(CS);
    dimstd = [.25 .2 .3 .3];
    annotation('textbox',dimstd,'String',strstd,'FitBoxToText','on');% plot(strl)
    plot(strl);
    hold on
    plot(SWms)
    hold on
    plot(STms)
    
    grid on
    ax2=gca;
    ax2.YTick = [0:0.1:1.2];
    if numel(strl)>50
        ax2.XTick = [1:10:numel(strl)];
    else
        ax2.XTick = [1:2:numel(strl)];
    end
    legend('Stride times in seconds','Swing times in seconds','Stance times in seconds','Location','best')
    
    %STRIDE AVERAGE TIME
    
    dim = [.6 .25 .3 .3];
    CM={'Average stride times:',MS,};
    str=strjoin(CM);
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    CS={'Standard Deviation:',STDs};
    strstd=strjoin(CS);
    dimstd = [.6 .2 .3 .3];
    annotation('textbox',dimstd,'String',strstd,'FitBoxToText','on');% plot(strl)
    
    title('Stride times in seconds')
    xlabel('Stride number')
    ylabel('Stride time (s)')
    
    % Save data
    filenameonly=h5files(VF).name(1:end-3);
    pathfilename=strcat('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\',filenameonly,sp,'RightLeg');

    save(pathfilename, 'RIGHTHSms','RIGHTTOTms','RIGHTMSms', 'RIGHTSWms','RIGHTSTms', 'RIGHTPREINISWms','RIGHTSTRTms', 'RIGHTTERMSWms');

   clearvars -except MEAN_SWING MEAN_STRIDETIME MEAN_STANCE STD_SWING STD_STRIDETIME STD_STANCE 
    
    %% LOAD FILE NAMES INTO STRUCTURE
%     clear
    cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\Double_task_H5_files\')
    h5fpath='C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\Double_task_H5_files\';
    
    h5filespath=strcat(h5fpath,'*.h5');
    h5files=dir(fullfile(h5filespath));
end

