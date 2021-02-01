%% FINDING FULL ARTICULATION TIMES AND HEALSTRIKE BEFORE AND AFTER,
%% CALCULATE PERCENTAGE,IDENTIFY GAIT PHASES IN WHICH ARTICULATION HAPPENDS

clear
clc
close all
%% L0AD Art_times FILES INTO STRUCTURE
cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\')
matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\';

matfilespath=strcat(matfpath,'*times.mat');
matfiles=dir(fullfile(matfilespath));

%% L0AD GAIT EVENT FILES INTO STRUCTURE

cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\')
matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\';

RIGHTmatfilespath=strcat(matfpath,'*-RightLeg.mat');
RIGHTmatfiles=dir(fullfile(RIGHTmatfilespath));

LEFTmatfilespath=strcat(matfpath,'*-LeftLeg.mat');
LEFTmatfiles=dir(fullfile(LEFTmatfilespath));

%% LOOP THROUGH EACH PARTICIPANT

for i=1:numel(matfiles)
    % % %     switch i
    % % %         case 1
    % % %             continue
    % % %         case 2
    % % %             continue
    % % %         case 4
    % % %             continue
    % % %         case 5
    % % %             continue
    % % %         case 8
    % % %             continue
    % % %         case 12
    % % %             continue
    % % %         case 19
    % % %             continue
    % % %         case 21
    % % %             continue
    % % %     end
    
    %% Load articulation times
    % Change directory
    cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\')
    
    load(matfiles(i).name);
    
    %% Load gait event times RIGHT leg
    % Change directory
    cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\')
    load(RIGHTmatfiles(i).name, 'RIGHTHSms', 'RIGHTTOTms', 'RIGHTMSms')
    
    %% Load gait event times LEFT leg
    load(LEFTmatfiles(i).name, 'LEFTHSms', 'LEFTTOTms', 'LEFTMSms')
    
    %% Convert articulation times to seconds (if needed) and transpose
    if and_times(end)>150
        
        and_times=and_times/1000;
        full_times=full_times/1000;
    end
    
    % % %     full_times=transpose(full_times);
    % % %     full_times=transpose(full_times);
    
    %%
    
    % Calculate middle times
    %     full_times=full_times-((full_times-full_times)/2);
    %%
    % Arrange data so that it starts and finishes with RIGHT HEALTSRIKE
    % with no articulation before and after respectively
    if full_times(end)>RIGHTHSms(end)
        full_times(end)=[];
    end
    
    if full_times(1)<RIGHTHSms(1)
        full_times(1)=[];
    end
    
    for ft=1:numel(full_times)
        
        % Stop processing articulation times when data ends
        if full_times(ft)==0
            break
        end
        
        % Find closest RIGHT HEASTRIKE to articulation and save index into
        % variable
        [c, index(ft)] = min(abs(RIGHTHSms-full_times(ft)));
        
    end
    
    % Find gait events either side of articulation and save into variables
    for ft=1:numel(full_times)
        if full_times(ft)==0
            break
        end
        
        % If the closest RIGHT HEALSTRIKE is after the articulation, define
        % varibles like this
        if RIGHTHSms(index(ft))>full_times(ft)
            RIGHT_HS_before_full(ft)=RIGHTHSms(index(ft)-1); % Right healstrike before articulation
            %                         LEFT_toe_off_full(ft)=RIGHT_HS_before_full(ft)+RDoubleStance(index(ft)-1); % Left toe off
            if LEFTHSms(index(ft)-1)> RIGHT_HS_before_full(ft)
                LEFT_Heal_strike_full(ft)=LEFTHSms(index(ft)-1); % Left healstrike
                LEFT_toe_off_full(ft)=LEFTTOTms(index(ft)-1);% Left toe off
                LEFT_Mid_swing_full(ft)=LEFTMSms(index(ft)-1);
            else
                LEFT_Heal_strike_full(ft)=LEFTHSms(index(ft));
                LEFT_toe_off_full(ft)=LEFTTOTms(index(ft));% Left toe off
                LEFT_Mid_swing_full(ft)=LEFTMSms(index(ft));
            end
            RIGHT_Toe_off_full(ft)=RIGHTTOTms(index(ft)); % Right toe off
            RIGHT_Mid_swing_full(ft)=RIGHTMSms(index(ft));
            
            
            RIGHT_HS_after_full(ft)=RIGHTHSms(index(ft)); % Right healstrike after articulation
            
            % If the closest RIGHT HEALSTRIKE is before the articulation, define
            % varibles like this
        else
            RIGHT_HS_before_full(ft)=RIGHTHSms(index(ft));
            %                         LEFT_toe_off_full(ft)=RIGHT_HS_before_full(ft)+RDoubleStance(index(ft));
            if LEFTHSms(index(ft))> RIGHT_HS_before_full(ft)
                LEFT_Heal_strike_full(ft)=LEFTHSms(index(ft));
                LEFT_toe_off_full(ft)=LEFTTOTms(index(ft));
                LEFT_Mid_swing_full(ft)=LEFTMSms(index(ft));
            else
                LEFT_Heal_strike_full(ft)=LEFTHSms(index(ft)+1);
                LEFT_toe_off_full(ft)=LEFTTOTms(index(ft)+1);
                LEFT_Mid_swing_full(ft)=LEFTMSms(index(ft)+1);
            end
            RIGHT_Toe_off_full(ft)=RIGHTTOTms(index(ft)+1);
            RIGHT_Mid_swing_full(ft)=RIGHTMSms(index(ft)+1);
            
            RIGHT_HS_after_full(ft)=RIGHTHSms(index(ft)+1);
        end
        
        
        
        %%  CALCULATE GAIT PHASE TIMES AND PERCENTAGES
        
        % STRIDE TIME OF EACH STRIDE WITH ARTICULATION IN IT
        strides_with_full_times(ft)=RIGHT_HS_after_full(ft)-RIGHT_HS_before_full(ft);
        % TIME DIFFERENCE BETWEEN HEALSTRIKE BEFORE AND ARTICULATION
        RIGHT_HS_before_full_diff(ft)=full_times(ft)-RIGHT_HS_before_full(ft);
        % PERCENTAGE OF STRIDE WHERE ARTICULATION HAPPENED
        full_times_perc(ft)=RIGHT_HS_before_full_diff(ft)/strides_with_full_times(ft)*100;
        % DURATION OF RDS-LDS
        RDS_LDS_full(ft)=LEFT_toe_off_full(ft)-RIGHT_HS_before_full(ft);
        RDS_LDS_fullPERC(ft)=RDS_LDS_full(ft)/strides_with_full_times(ft)*100;
        
        % DURATION OF RSS-LPS
        RSS_LPS_full(ft)=LEFT_Mid_swing_full(ft)-LEFT_toe_off_full(ft);
        RSS_LPS_fullPERC(ft)=RSS_LPS_full(ft)/strides_with_full_times(ft)*100;
        
        % DURATION OF RSS-LTS
        RSS_LTS_full(ft)=LEFT_Heal_strike_full(ft)-LEFT_Mid_swing_full(ft);
        RSS_LTS_fullPERC(ft)=RSS_LTS_full(ft)/strides_with_full_times(ft)*100;
        
        % DURATION OF LDS-RDS
        LDS_RDS_full(ft)=RIGHT_Toe_off_full(ft)-LEFT_Heal_strike_full(ft);
        LDS_RDS_fullPERC(ft)=LDS_RDS_full(ft)/strides_with_full_times(ft)*100;
        
        % DURATION OF LSS-RPS
        LSS_RPS_full(ft)=RIGHT_Mid_swing_full(ft)-RIGHT_Toe_off_full(ft);
        LSS_RPS_fullPERC(ft)=LSS_RPS_full(ft)/strides_with_full_times(ft)*100;
        
        % DURATION OF LSS-RTS
        LSS_RTS_full(ft)=RIGHT_HS_after_full(ft)-RIGHT_Mid_swing_full(ft);
        LSS_RTS_fullPERC(ft)=LSS_RTS_full(ft)/strides_with_full_times(ft)*100;
        
        
        %%
        
    end
    %% CALCULATE MEANS
    MEANRDS_LDS_fullPERC=mean(RDS_LDS_fullPERC);
    MEANRSS_LPS_fullPERC=mean(RSS_LPS_fullPERC);
    MEANRSS_LTS_fullPERC=mean(RSS_LTS_fullPERC);
    MEANLDS_RDS_fullPERC=mean(LDS_RDS_fullPERC);
    MEANLSS_RPS_fullPERC=mean(LSS_RPS_fullPERC);
    MEANLSS_RTS_fullPERC=mean(LSS_RTS_fullPERC);
    
    %% SAVE NEW VARIABLES
    
    % % % clear RIGHTHSms RIGHTMSms RIGHTTOTms LEFTHSms LEFTMSms LEFTTOTms
    % % % cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\')
    % % %
    % % % save(matfiles(i).name,'-append');
    
    %% HISTOGRAMS
    
    % Create histogram bin edges
    
    edges=[0 MEANRDS_LDS_fullPERC (MEANRDS_LDS_fullPERC+MEANRSS_LPS_fullPERC)...
        (MEANRDS_LDS_fullPERC+MEANRSS_LPS_fullPERC+MEANRSS_LTS_fullPERC)...
        (MEANRDS_LDS_fullPERC+MEANRSS_LPS_fullPERC+MEANRSS_LTS_fullPERC+MEANLDS_RDS_fullPERC)...
        (MEANRDS_LDS_fullPERC+MEANRSS_LPS_fullPERC+MEANRSS_LTS_fullPERC+MEANLDS_RDS_fullPERC+MEANLSS_RPS_fullPERC) 100];
    
    % Create histogram data and figures
    
    h=histogram(full_times_perc, edges, 'Normalization','countdensity');%,,'Normalization','countdensity'
    countvalues_full_times(1:6)=h.Values;
    ax = gca;
    ax.YLim=[0 0.8];
    
    % Save histogram data
    if i==1
        ALL_countvalues_full_times=countvalues_full_times;
        save('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_full_times',...
            'ALL_countvalues_full_times')
    else
        load('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_full_times')
        ALL_countvalues_full_times=[ALL_countvalues_full_times; countvalues_full_times];
        save('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_full_times',...
            'ALL_countvalues_full_times')
    end
    
    
    
    %%    Clear the workspace
    clear
    %
    %% L0AD Art_times FILES INTO STRUCTURE
    cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\')
    matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\';
    
    matfilespath=strcat(matfpath,'*times.mat');
    matfiles=dir(fullfile(matfilespath));
    
    %% L0AD GAIT EVENT FILES INTO STRUCTURE
    
    cd('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\')
    matfpath='C:\Users\mv100\Documents\MATLAB\Articulation\DATA\';
    
    RIGHTmatfilespath=strcat(matfpath,'*-RightLeg.mat');
    RIGHTmatfiles=dir(fullfile(RIGHTmatfilespath));
    
    LEFTmatfilespath=strcat(matfpath,'*-LeftLeg.mat');
    LEFTmatfiles=dir(fullfile(LEFTmatfilespath));
    
end
load('C:\Users\mv100\Documents\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_full_times')

[p, t, stats]=anova1(ALL_countvalues_full_times);

multcompare(stats,'CType','bonferroni');