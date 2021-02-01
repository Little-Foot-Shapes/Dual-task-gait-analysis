   %% Filter using second order low pass 3Hz
    
    fc = 10;
    fs = 128;

[b,a] = butter(2,fc/(fs/2));
xf2 = filter(b,a,x);
    % create figure
    f=figure('numbertitle', 'off','name', TT,'position', [0 0 1300 691]);
    
    %% FINDING MID-SWING
    [~,locsf2]=findpeaks(xf2*-1,'minpeakheight',0.3, 'minpeakdistance', 100);
    
    min_diffSW_peaksf2=min(diff(locsf2));
    [~,locsf2]=findpeaks(xf2*-1,'minpeakdistance', min_diffSW_peaksf2-1);
    
    
    subplot(2,1,1)
    time=(1:1:numel(xf2));
    time=time*0.007825;
    grid on
    plot(time,xf2*-1);hold on
    plot(time,xf1*-1);
    hold off
    %% FINDING HEAL-STRIKE
    
    locsf2(end:end)=[];
    locsf2(1)=[];
    hf2=table(xf2(HST),xf2(HST-1),xf2(HST-2),xf2(HST-3),xf2(HST-4),xf2(HST-5),...
        xf2(HST-6),xf2(HST-7),xf2(HST-8),xf2(HST-9),xf2(HST-10),xf2(HST-11),...
        xf2(HST-12),xf2(HST-13),xf2(HST-14),xf2(HST-15),xf2(HST-16),xf2(HST-17),...
         xf2(HST-18),xf2(HST-19),xf2(HST-20),xf2(HST-21),xf2(HST-22),xf2(HST-23),...
         xf2(HST-24),xf2(HST-25),xf2(HST-26),xf2(HST-27),xf2(HST-28));
%     ,xf2(HST-29),...
%         xf2(HST-30),xf2(HST-31),xf2(HST-32),xf2(HST-33),xf2(HST-34),xf2(HST-35),...
%         xf2(HST-36),xf2(HST-37),xf2(HST-38),xf2(HST-39),xf2(HST-40),xf2(HST-41),...
%         xf2(HST-42),xf2(HST-43),xf2(HST-44),xf2(HST-45),xf2(HST-46),xf2(HST-47),...
%         xf2(HST-48),xf2(HST-49),xf2(HST-50),xf2(HST-51),xf2(HST-52),xf2(HST-53),...
%         xf2(HST-54),xf2(HST-55),xf2(HST-56),xf2(HST-57));
    ahsf2=hf2{:,:};
    ahsf2=transpose(ahsf2);
    
    for b=1:numel(HST)
       [pkst,locstttf2]=findpeaks(ahsf2(:,b),'minpeakheight', 0);
        locsttf2(b) = locstttf2(end);
% % % %         numlocs(b)=numel(locstt);
% % % %         if numlocs(b)>1
% % % %             locsttnum1(b)=locstt(1);
% % % %             locst(b)=locsttnum1(b)-1;
% % % %         elseif numlocs(b)<=1
% % % %             xdiff=diff(a(:,b));
% % % %             [pk,diffloc(b)]=findpeaks(xdiff,'MinPeakProminence', 0.05,'NPeaks',1);%'minpeakheight',0.5,
% % % %             [pks,difflocs(b)]=findpeaks(xdiff(diffloc(b):end)*-1,'NPeaks',1);%,'minpeakheight',0.5
% % % %             location(b)=difflocs(b)+diffloc(b);%+dl
% % % %             locst(b)=location(b)-1;
% % % %         end
    end
    locsf2=transpose(locsf2);
    HSTf2=HST-locsttf2+1;
    MSmsF2=locsf2*0.007825;
    
    %% Calculating cadence
    data_time=locsf2(end)-locsf2(1);
    data_time_ms=data_time*0.007825;
    cad_ref=60/data_time_ms;
    CAD=(cad_ref*(numel(locsf2)));
    CADstr=num2str(CAD);
    
    %DISPLAY Cadence
    dim = [.15 .68 .3 .3];
    CM={'Average cadence:',CADstr};
    str=strjoin(CM);
    annotation('textbox',dim,'String',str,'FitBoxToText','on');
    
    %% FINDING TOE-OFF
       htoeofff2=table(xf2(TOT),xf2(TOT-1),xf2(TOT-2),xf2(TOT-3),xf2(TOT-4),xf2(TOT-5),...
        xf2(TOT-6),xf2(TOT-7),xf2(TOT-8),xf2(TOT-9),xf2(TOT-10),xf2(TOT-11),...
        xf2(TOT-12),xf2(TOT-13),xf2(TOT-14),xf2(TOT-15));
%     ,xf2(TOT-16),xf2(TOT-17),...
%         xf2(TOT-18),xf2(TOT-19),xf2(TOT-20),xf2(TOT-21),xf2(TOT-22),xf2(TOT-23),...
%         xf2(TOT-24),xf2(TOT-25),xf2(TOT-26),xf2(TOT-27),xf2(TOT-28),xf2(TOT-29),...
%         xf2(TOT-30),xf2(TOT-31),xf2(TOT-32),xf2(TOT-33));
    atof2=htoeofff2{:,:};
    atof2=transpose(atof2);
    for b=1:numel(TOT)
       [pksto(b),locstof2(b)]=findpeaks(atof2(:,b),'minpeakheight', 0,'minpeakdistance',4, 'npeaks',1);%'minpeakprominence', 0.1,
        hold on
    end
    
    
    TOTf2=TOT-locstof2+1;
    TOTf2ms=TOTf2*0.007825;
    locsmsf2=HSTf2*0.007825;
    
    RIGHTTOTf2ms=TOTf2ms;
    RIGHTHSmsf2=locsmsf2;
    RIGHTMSmsF2=MSmsF2;
    
    
    subplot(2,1,1)
    time=(1:1:numel(xf2));
    time=time*0.007825;
    plot(time(locsf2(1):locsf2(end)),xf2(locsf2(1):locsf2(end))*-1);
    
    ax1=gca;
    if numel(xf2)>15000
        ax1.XTick = [1:10:numel(xf2)];
    else ax1.XTick = [1:2:numel(xf2)];
    end
    
    
    
    %TIME DIFFERENCS
    strl=diff(locsmsf2);
    TOstrl=diff(TOTf2ms);
    M=mean(strl);
    MS=num2str(M);
    STD=std(strl);
    STDs=num2str(STD);
    
    % calculate swing and stance times
    ALL=[TOTf2;HSTf2;MSmsF2];%(1:ME)(1:ME)
    SW=(ALL(2,:)-ALL(1,:));
    SWms=SW*0.007825;
    RIGHTSWms=SWms;
    
    STms=strl-SWms(1:numel(strl));
    RIGHTSTms=STms;
    
    RIGHTPREINISWms=(ALL(3,:)-ALL(1,:)*0.007825);
    RIGHTTERMSWms=(ALL(2,:)*0.007825-ALL(3,:));
    
    RIGHTSTRTms=strl;
    l=num2str(locsmsf2);
    
    
    % calculating mean and std for swing and stance
    MSWNG=mean(SWms);
    MSSWNG=num2str(MSWNG);
    STDSWNG=std(SWms);
    STDSWNGstr=num2str(STDSWNG);
    
    MSTNC=mean(STms);
    MSSTNC=num2str(MSTNC);
    STDSTNC=std(STms);
    STDSTNCstr=num2str(STDSTNC);
    title('Shank angular velocity')
    xlabel('Time in seconds')
    ylabel('Angular velocity (rad/s)')
    
    
    plot(locsmsf2, xf2(HSTf2)*-1,'r*')
    plot(TOTf2ms, xf2(TOTf2)*-1,'b*')
    
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
    filenameonly=h5files(VF).name(1:end-3);
    pathfilename=strcat('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\STDATA\RIGHT_LEG\',filenameonly,sp,'RightLeg');
    
    %     savefig(f,pathfilename);
    %
    %     close all;
    %
    %     RIGHTHSms=RIGHTHSms.';
    %     RIGHTTOTf2ms=RIGHTTOTf2ms.';
    %     RIGHTMSmsF2=RIGHTMSmsF2.';
    %     RIGHTSWms=RIGHTSWms.';
    %     RIGHTSTms=RIGHTSTms.';
    %     RIGHTPREINISWms=RIGHTPREINISWms.';
    %     RIGHTSTRTms=RIGHTSTRTms.';
    %     RIGHTTERMSWms=RIGHTTERMSWms.';
    %
    %     save(pathfilename, 'RIGHTHSms','RIGHTTOTf2ms','RIGHTMSmsF2', 'RIGHTSWms','RIGHTSTms', 'RIGHTPREINISWms','RIGHTSTRTms', 'RIGHTTERMSWms');
    
    
    %     clear