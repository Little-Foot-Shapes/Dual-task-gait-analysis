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
    plot(time,xf1*-1);
    plot(time,xf2*-1);
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
    
    RIGHTTOTf3ms=TOTf3ms;
    RIGHTHSmsf3=locsmsf3;
    RIGHTMSmsF3=MSmsF3;
    
    
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
    filenameonly=h5files(VF).name(1:end-3);
    pathfilename=strcat('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\STDATA\RIGHT_LEG\',filenameonly,sp,'RightLeg');
    
    %     savefig(f,pathfilename);
    %
    %     close all;
    %
    %     RIGHTHSms=RIGHTHSms.';
    %     RIGHTTOTf2f2ms=RIGHTTOTf2f2ms.';
    %     RIGHTMSmsF2=RIGHTMSmsF2.';
    %     RIGHTSWms=RIGHTSWms.';
    %     RIGHTSTms=RIGHTSTms.';
    %     RIGHTPREINISWms=RIGHTPREINISWms.';
    %     RIGHTSTRTms=RIGHTSTRTms.';
    %     RIGHTTERMSWms=RIGHTTERMSWms.';
    %
    %     save(pathfilename, 'RIGHTHSms','RIGHTTOTf2f2ms','RIGHTMSmsF2', 'RIGHTSWms','RIGHTSTms', 'RIGHTPREINISWms','RIGHTSTRTms', 'RIGHTTERMSWms');
    
    
    %     clear