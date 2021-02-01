%% FINDING FULL ARTICULATION TIMES AND HEALSTRIKE BEFORE AND AFTER,
%% CALCULATE PERCENTAGE,IDENTIFY GAIT PHASES IN WHICH ARTICULATION HAPPENDS

clear
clc
% close all
%% L0AD Art_times FILES INTO STRUCTURE
cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\')
matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\';

matfilespath=strcat(matfpath,'*.mat');
matfiles=dir(fullfile(matfilespath));

%% L0AD GAIT EVENT FILES INTO STRUCTURE

cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\')
matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\';

RIGHTmatfilespath=strcat(matfpath,'*-RightLeg.mat');
RIGHTmatfiles=dir(fullfile(RIGHTmatfilespath));

LEFTmatfilespath=strcat(matfpath,'*-LeftLeg.mat');
LEFTmatfiles=dir(fullfile(LEFTmatfilespath));

%% LOOP THROUGH EACH PARTICIPANT

for i=1:21
    switch i
        case 1
            continue
        case 4
            continue
        case 7
            continue
        case 10
            continue
        case 12
            continue
        case 19
            continue
    end
    % Load articulation times
    load(matfiles(i).name, 'and_times','full_times')
    % Load gait event times RIGHT leg
    load(RIGHTmatfiles(i).name)
    % Load gait event times LEFT leg
    load(LEFTmatfiles(i).name)
    
    % Convert articulation times to seconds and transpose
    and_times=and_times/1000;
    full_times=full_times/1000;
    
    and_times=transpose(and_times);
    full_times=transpose(full_times);
    
    
    % Calculate middle times
    middle_times=full_times-((full_times-and_times)/2);
    
    % Arrange data so that it starts and finishes with RIGHT HEALTSRIKE
    % with no articulation before and after respectively
    if middle_times(end)>RIGHTHSms(end)
        middle_times(end)=[];
    end
    
    if middle_times(1)<RIGHTHSms(1)
        middle_times(1)=[];
    end
    
    for ft=1:numel(middle_times)
        
        % Stop processing articulation times when data ends
        if middle_times(ft)==0
            break
        end
        
        % Find closest RIGHT HEASTRIKE to articulation and save index into
        % variable
        [c, index(ft)] = min(abs(RIGHTHSms-middle_times(ft)));
        
    end
    
    % Find gait events either side of articulation and save into variables
    for ft=1:numel(middle_times)
        if middle_times(ft)==0
            break
        end
        
        % If the closest RIGHT HEALSTRIKE is after the articulation, define
        % varibles like this
        if RIGHTHSms(index(ft))>middle_times(ft)
            RIGHT_HS_before(ft)=RIGHTHSms(index(ft)-1); % Right healstrike before articulation
            %             LEFT_toe_off(ft)=RIGHT_HS_before(ft)+RDoubleStance(index(ft)-1); % Left toe off
            if LEFTHSms(index(ft)-1)> RIGHT_HS_before(ft)
                LEFT_Heal_strike(ft)=LEFTHSms(index(ft)-1); % Left healstrike
                LEFT_toe_off(ft)=LEFTTOTms(index(ft)-1);% Left toe off
                LEFT_Mid_swing(ft)=LEFTMSms(index(ft)-1);
            else
                LEFT_Heal_strike(ft)=LEFTHSms(index(ft));
                LEFT_toe_off(ft)=LEFTTOTms(index(ft));% Left toe off
                LEFT_Mid_swing(ft)=LEFTMSms(index(ft));
            end
            RIGHT_Toe_off(ft)=RIGHTTOTms(index(ft)); % Right toe off
            RIGHT_Mid_swing(ft)=RIGHTMSms(index(ft));
            
            
            RIGHT_HS_after(ft)=RIGHTHSms(index(ft)); % Right healstrike after articulation
            
            % If the closest RIGHT HEALSTRIKE is before the articulation, define
            % varibles like this
        else
            RIGHT_HS_before(ft)=RIGHTHSms(index(ft));
            %             LEFT_toe_off(ft)=RIGHT_HS_before(ft)+RDoubleStance(index(ft));
            if LEFTHSms(index(ft))> RIGHT_HS_before(ft)
                LEFT_Heal_strike(ft)=LEFTHSms(index(ft));
                LEFT_toe_off(ft)=LEFTTOTms(index(ft));
                LEFT_Mid_swing(ft)=LEFTMSms(index(ft));
            else
                LEFT_Heal_strike(ft)=LEFTHSms(index(ft)+1);
                LEFT_toe_off(ft)=LEFTTOTms(index(ft)+1);
                LEFT_Mid_swing(ft)=LEFTMSms(index(ft)+1);
            end
            RIGHT_Toe_off(ft)=RIGHTTOTms(index(ft)+1);
            RIGHT_Mid_swing(ft)=RIGHTMSms(index(ft)+1);
            
            RIGHT_HS_after(ft)=RIGHTHSms(index(ft)+1);
        end
        
        
        
        %%  CALCULATE GAIT PHASE TIMES AND PERCENTAGES
        
        % STRIDE TIME OF EACH STRIDE WITH ARTICULATION IN IT
        strides_with_middle_times(ft)=RIGHT_HS_after(ft)-RIGHT_HS_before(ft);
        % TIME DIFFERENCE BETWEEN HEALSTRIKE BEFORE AND ARTICULATION
        RIGHT_HS_before_diff(ft)=middle_times(ft)-RIGHT_HS_before(ft);
        % PERCENTAGE OF STRIDE WHERE ARTICULATION HAPPENED
        middle_times_perc(ft)=RIGHT_HS_before_diff(ft)/strides_with_middle_times(ft)*100;
        % DURATION OF RDS-LDS
        RDS_LDS(ft)=LEFT_toe_off(ft)-RIGHT_HS_before(ft);
        RDS_LDSPERC(ft)=RDS_LDS(ft)/strides_with_middle_times(ft)*100;
        
        % DURATION OF RSS-LPS
        RSS_LPS(ft)=LEFT_Mid_swing(ft)-LEFT_toe_off(ft);
        RSS_LPSPERC(ft)=RSS_LPS(ft)/strides_with_middle_times(ft)*100;
        
        % DURATION OF RSS-LTS
        RSS_LTS(ft)=LEFT_Heal_strike(ft)-LEFT_Mid_swing(ft);
        RSS_LTSPERC(ft)=RSS_LTS(ft)/strides_with_middle_times(ft)*100;
        
        % DURATION OF LDS-RDS
        LDS_RDS(ft)=RIGHT_Toe_off(ft)-LEFT_Heal_strike(ft);
        LDS_RDSPERC(ft)=LDS_RDS(ft)/strides_with_middle_times(ft)*100;
        
        % DURATION OF LSS-RPS
        LSS_RPS(ft)=RIGHT_Mid_swing(ft)-RIGHT_Toe_off(ft);
        LSS_RPSPERC(ft)=LSS_RPS(ft)/strides_with_middle_times(ft)*100;
        
        % DURATION OF LSS-RTS
        LSS_RTS(ft)=RIGHT_HS_after(ft)-RIGHT_Mid_swing(ft);
        LSS_RTSPERC(ft)=LSS_RTS(ft)/strides_with_middle_times(ft)*100;
        
        
        %%
        if middle_times(ft)<RIGHT_Toe_off(ft)&& middle_times(ft)>LEFT_Heal_strike(ft)
            Gait_phase(ft)=11;
            
        elseif middle_times(ft)<RIGHT_Mid_swing(ft)&& middle_times(ft)>RIGHT_Toe_off(ft)
            Gait_phase(ft)=32;
            
        elseif middle_times(ft)<RIGHT_HS_after(ft)&& middle_times(ft)>RIGHT_Mid_swing(ft);
            Gait_phase(ft)=42;
            
        elseif middle_times(ft)<LEFT_toe_off(ft)&& middle_times(ft)>RIGHT_HS_before(ft)
            Gait_phase(ft)=110;
            
        elseif middle_times(ft)<LEFT_Mid_swing(ft)&& middle_times(ft)>LEFT_toe_off(ft)
            Gait_phase(ft)=23;
            
        elseif middle_times(ft)<LEFT_Heal_strike(ft)&& middle_times(ft)>LEFT_Mid_swing(ft);
            Gait_phase(ft)=24;
        end
    end
    %% CALCULATE MEANS
    MEANRDS_LDSPERC=mean(RDS_LDSPERC);
    MEANRSS_LPSPERC=mean(RSS_LPSPERC);
    MEANRSS_LTSPERC=mean(RSS_LTSPERC);
    MEANLDS_RDSPERC=mean(LDS_RDSPERC);
    MEANLSS_RPSPERC=mean(LSS_RPSPERC);
    MEANLSS_RTSPERC=mean(LSS_RTSPERC);
    
    %% SAVE NEW VARIABLES
    
    Gait_phase_middle_times=Gait_phase;
    
% % %     save(matfiles(i).name,'middle_times_perc',  'MEANRDS_LDSPERC' , 'MEANRSS_LPSPERC',...
% % %         'MEANRSS_LTSPERC', 'MEANLDS_RDSPERC', 'MEANLSS_RPSPERC', 'MEANLSS_RTSPERC',...
% % %         'Gait_phase_middle_times','-append');
    
    
    
    
    
    %% HISTOGRAMS
    
    edges=[0 MEANRDS_LDSPERC (MEANRDS_LDSPERC+MEANRSS_LPSPERC)...
        (MEANRDS_LDSPERC+MEANRSS_LPSPERC+MEANRSS_LTSPERC)...
        (MEANRDS_LDSPERC+MEANRSS_LPSPERC+MEANRSS_LTSPERC+MEANLDS_RDSPERC)...
        (MEANRDS_LDSPERC+MEANRSS_LPSPERC+MEANRSS_LTSPERC+MEANLDS_RDSPERC+MEANLSS_RPSPERC) 100];
    
    h=histogram(middle_times_perc, edges,'Normalization','countdensity');%,
    countvalues_middle_times(1:6)=h.Values;
    %    CVand=table(countvalues_and_times.');
    %    sheet=i;
    %    xlswrite('CVand.xls',countvalues_and_times,i)
    
    if i==2
        ALL_countvalues_middle_times=countvalues_middle_times;
    else
        load('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_middle_times')
        ALL_countvalues_middle_times=[ALL_countvalues_middle_times; countvalues_middle_times];
    end
    save('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_middle_times',...
        'ALL_countvalues_middle_times')
    %     Gait_phase_middle_times=Gait_phase;
    %     C = categorical(Gait_phase_middle_times,[11 32 42 110 23 24],{'LDS-RDS','LSS-RPS','LSS-RTS','RDS-LDS','RSS-LPS','RSS-LTS'});
    %     figure
    %     h=histogram(C);
    %
    %
    %     % Make the edges of the histogram the percentages for each gait phase
    %
    %     edges=[0  MeanRDoubleStancePerc  MeanRightStancePerc (MeanRightPreSwingPerc+MeanRightStancePerc) 100];
    %
    % Create histogram data normalized to gait phase time length
    %     [LN,edges] = histcounts(C);%
    %     RIGHTLegHistCounts_middle_times=LN;
    %
    %
    % Transpose variables in order to be able to export to csv
    %     middle_times=middle_times.';
    %     middle_times_perc=middle_times_perc.';
    %     Gait_phase_middle_times=Gait_phase_middle_times.';
    %     C=C.';
    % Create a table for the new transposed variables
    %     TT=table([Gait_phase_middle_times]);%middle_times; middle_times_perc;
    %     TTC=table(C);
    %     RIGHTLegHistCounts_middle_times=table(RIGHTLegHistCounts_middle_times);
    % Sheet number: 1 sheet\participant
    %     sheet=i;
    %
    % Export tables into xls files
    %         writetable(TT,'COMBINED_MIDDLE_TIMES_GAIT_PHASES.xls','Sheet',sheet)
    %         writetable(TTC,'COMBINED_MIDDLE_TIMES_GAIT_PHASES_TEXT.xls','Sheet',sheet)
    
    %     writetable(RIGHTLegHistCounts_middle_times,'RIGHT_middle_times_HISTOGRAM.xls','Sheet',sheet)
    
    %%    Clear the workspace
    clear
    
    %% L0AD Art_times FILES INTO STRUCTURE
    cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\')
    matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\';
    
    matfilespath=strcat(matfpath,'*.mat');
    matfiles=dir(fullfile(matfilespath));
    
    %% L0AD GAIT EVENT FILES INTO STRUCTURE
    
    cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\')
    matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\';
    
    RIGHTmatfilespath=strcat(matfpath,'*-RightLeg.mat');
    RIGHTmatfiles=dir(fullfile(RIGHTmatfilespath));
    
    LEFTmatfilespath=strcat(matfpath,'*-LeftLeg.mat');
    LEFTmatfiles=dir(fullfile(LEFTmatfilespath));
    
    
end
load('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_middle_times')

[p, t, stats]=anova1(ALL_countvalues_middle_times);

multcompare(stats,'CType','bonferroni');