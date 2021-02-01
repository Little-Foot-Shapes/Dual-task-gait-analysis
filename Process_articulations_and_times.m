%% FINDING FULL ARTICULATION TIMES AND HEALSTRIKE BEFORE AND AFTER,
%% CALCULATE PERCENTAGE,IDENTIFY GAIT PHASES IN WHICH ARTICULATION HAPPENDS

clear
clc
close all
%% L0AD Art_times FILES INTO STRUCTURE
cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\')
matfpath='C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\';

matfilespath=strcat(matfpath,'*times.mat');
matfiles=dir(fullfile(matfilespath));

%% L0AD GAIT EVENT FILES INTO STRUCTURE

% % % cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\')
matfpath='C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\';

RIGHTmatfilespath=strcat(matfpath,'*-RightLeg.mat');
RIGHTmatfiles=dir(fullfile(RIGHTmatfilespath));

LEFTmatfilespath=strcat(matfpath,'*-LeftLeg.mat');
LEFTmatfiles=dir(fullfile(LEFTmatfilespath));

%% LOOP THROUGH EACH PARTICIPANT

for i=7%:numel(RIGHTmatfiles)
% % %     switch i
% % %         case 1
% % %             continue
% % %         case 3
% % %             continue
% % %         case 4
% % %             continue
% % %         case 9
% % %             continue
% % %         case 10
% % %             continue
% % %         case 18
% % %             continue
% % %     end
    i
    % Load articulation times
    cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\')

    load(matfiles(i).name)%, 'and_times','full_times')
% % %     clear and_times_perc Gait_phase_and_times Gait_phase_full_times Gait_phase_middle_times full_times_perc MEANLDS_RDS_andPERC MEANLSS_RPS_andPERC MEANLSS_RTS_andPERC...
% % %         MEANRDS_LDS_andPERC MEANRSS_LPS_andPERC MEANRSS_LTS_andPERC middle_times_perc RIGHT_HS_after_and RIGHT_HS_before_and RIGHT_HS_before_and_and_diff strides_with_and_times
    % Load gait event times RIGHT leg
     cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\')
    load(RIGHTmatfiles(i).name, 'RIGHTHSms', 'RIGHTTOTms', 'RIGHTMSms')
    % Load gait event times LEFT leg
    load(LEFTmatfiles(i).name, 'LEFTHSms', 'LEFTTOTms', 'LEFTMSms')
    
    % Convert articulation times to seconds and transpose
    if and_times(end)>150
    and_times=and_times/1000;
    full_times=full_times/1000;
    end

%     and_times=transpose(and_times);
%     full_times=transpose(full_times);
    
    
    % Calculate middle times
%     and_times=full_times-((full_times-and_times)/2);

    % Arrange data so that it starts and finishes with RIGHT HEALTSRIKE
    % with no articulation before and after respectively
    if and_times(end)>RIGHTHSms(end)
        and_times(end)=[];
    end
    
    if and_times(1)<RIGHTHSms(1)
        and_times(1)=[];
        full_times(1)=[];
    end
    
    for ft=1:numel(and_times)
        
    % Stop processing articulation times when data ends
        if and_times(ft)==0
            break
        end
        
    % Find closest RIGHT HEASTRIKE to articulation and save index into
    % variable
    [c, index(ft)] = min(abs(RIGHTHSms-and_times(ft)));
        
    end
    
    % Find gait events either side of articulation and save into variables
    for ft=1:numel(and_times)
        if and_times(ft)==0
            break
        end
        
        % If the closest RIGHT HEALSTRIKE is after the articulation, define
        % varibles like this
        if RIGHTHSms(index(ft))>and_times(ft)
            RIGHT_HS_before_and(ft)=RIGHTHSms(index(ft)-1); % Right healstrike before articulation
            if LEFTHSms(index(ft)-1)> RIGHT_HS_before_and(ft)
            LEFT_Heal_strike_and(ft)=LEFTHSms(index(ft)-1); % Left healstrike
            LEFT_toe_off_and(ft)=LEFTTOTms(index(ft)-1);% Left toe off
            LEFT_Mid_swing_and(ft)=LEFTMSms(index(ft)-1);
            else
               LEFT_Heal_strike_and(ft)=LEFTHSms(index(ft)); 
               LEFT_toe_off_and(ft)=LEFTTOTms(index(ft));% Left toe off
               LEFT_Mid_swing_and(ft)=LEFTMSms(index(ft));
            end
            RIGHT_Toe_off_and(ft)=RIGHTTOTms(index(ft)); % Right toe off
            RIGHT_Mid_swing_and(ft)=RIGHTMSms(index(ft));
            

            RIGHT_HS_after_and(ft)=RIGHTHSms(index(ft)); % Right healstrike after articulation
            
        % If the closest RIGHT HEALSTRIKE is before the articulation, define
        % varibles like this            
        else
            RIGHT_HS_before_and(ft)=RIGHTHSms(index(ft));
            if LEFTHSms(index(ft))> RIGHT_HS_before_and(ft)
                LEFT_Heal_strike_and(ft)=LEFTHSms(index(ft));
                LEFT_toe_off_and(ft)=LEFTTOTms(index(ft));
                LEFT_Mid_swing_and(ft)=LEFTMSms(index(ft));
            else
                LEFT_Heal_strike_and(ft)=LEFTHSms(index(ft)+1);
                LEFT_toe_off_and(ft)=LEFTTOTms(index(ft)+1);
                LEFT_Mid_swing_and(ft)=LEFTMSms(index(ft)+1);
            end
            RIGHT_Toe_off_and(ft)=RIGHTTOTms(index(ft)+1);
            RIGHT_Mid_swing_and(ft)=RIGHTMSms(index(ft)+1);
            
            RIGHT_HS_after_and(ft)=RIGHTHSms(index(ft)+1);
        end
        
        
        
%%  CALCULATE GAIT PHASE TIMES AND PERCENTAGES

% STRIDE TIME OF EACH STRIDE WITH ARTICULATION IN IT
        strides_with_and_times(ft)=RIGHT_HS_after_and(ft)-RIGHT_HS_before_and(ft);
% TIME DIFFERENCE BETWEEN HEALSTRIKE BEFORE AND ARTICULATION        
        RIGHT_HS_before_and_and_diff(ft)=and_times(ft)-RIGHT_HS_before_and(ft);
% PERCENTAGE OF STRIDE WHERE ARTICULATION HAPPENED        
        and_times_perc(ft)=RIGHT_HS_before_and_and_diff(ft)/strides_with_and_times(ft)*100;
% DURATION OF RDS-LDS
       RDS_LDS_and(ft)=LEFT_toe_off_and(ft)-RIGHT_HS_before_and(ft);
       RDS_LDS_andPERC(ft)=RDS_LDS_and(ft)/strides_with_and_times(ft)*100;
       
% DURATION OF RSS-LPS
       RSS_LPS_and(ft)=LEFT_Mid_swing_and(ft)-LEFT_toe_off_and(ft);
       RSS_LPS_andPERC(ft)=RSS_LPS_and(ft)/strides_with_and_times(ft)*100;
       
% DURATION OF RSS-LTS
       RSS_LTS_and(ft)=LEFT_Heal_strike_and(ft)-LEFT_Mid_swing_and(ft);
       RSS_LTS_andPERC(ft)=RSS_LTS_and(ft)/strides_with_and_times(ft)*100;
       
% DURATION OF LDS-RDS
       LDS_RDS_and(ft)=RIGHT_Toe_off_and(ft)-LEFT_Heal_strike_and(ft);
       LDS_RDS_andPERC(ft)=LDS_RDS_and(ft)/strides_with_and_times(ft)*100;
       
% DURATION OF LSS-RPS
       LSS_RPS_and(ft)=RIGHT_Mid_swing_and(ft)-RIGHT_Toe_off_and(ft);
       LSS_RPS_andPERC(ft)=LSS_RPS_and(ft)/strides_with_and_times(ft)*100;
       
% DURATION OF LSS-RTS       
       LSS_RTS_and(ft)=RIGHT_HS_after_and(ft)-RIGHT_Mid_swing_and(ft);
       LSS_RTS_andPERC(ft)=LSS_RTS_and(ft)/strides_with_and_times(ft)*100;
   
    end
%% CALCULATE MEANS
MEANRDS_LDS_andPERC=mean(RDS_LDS_andPERC);
MEANRSS_LPS_andPERC=mean(RSS_LPS_andPERC);    
MEANRSS_LTS_andPERC=mean(RSS_LTS_andPERC);
MEANLDS_RDS_andPERC=mean(LDS_RDS_andPERC);  
MEANLSS_RPS_andPERC=mean(LSS_RPS_andPERC);
MEANLSS_RTS_andPERC=mean(LSS_RTS_andPERC);
    
%% SAVE NEW VARIABLES
clear RIGHTHSms RIGHTMSms RIGHTTOTms LEFTHSms LEFTMSms LEFTTOTms
% % % cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\')
% % % 
% % % save(matfiles(i).name)%,'RIGHT_HS_before_and_and_diff','RIGHT_HS_after_and','strides_with_and_times','RIGHT_HS_before_and','and_times_perc',  'MEANRDS_LDS_andPERC' , 'MEANRSS_LPS_andPERC',...
% % %    'MEANRSS_LTS_andPERC', 'MEANLDS_RDS_andPERC', 'MEANLSS_RPS_andPERC', 'MEANLSS_RTS_andPERC',...
% % %    '-append');

%% HISTOGRAMS 
   
edges=[0 MEANRDS_LDS_andPERC (MEANRDS_LDS_andPERC+MEANRSS_LPS_andPERC)...
(MEANRDS_LDS_andPERC+MEANRSS_LPS_andPERC+MEANRSS_LTS_andPERC)...
(MEANRDS_LDS_andPERC+MEANRSS_LPS_andPERC+MEANRSS_LTS_andPERC+MEANLDS_RDS_andPERC)...
(MEANRDS_LDS_andPERC+MEANRSS_LPS_andPERC+MEANRSS_LTS_andPERC+MEANLDS_RDS_andPERC+MEANLSS_RPS_andPERC) 100];

% Create histogram data and figures
h=figure('numbertitle', 'off','name', num2str(i));
h=histogram(and_times_perc, edges,'Normalization','countdensity');%,
countvalues_and_times(1:6)=h.Values;
ax = gca;
ax.YLim=[0 0.8];


% % %    if i==1
% % %        ALL_countvalues_and_times=countvalues_and_times;
% % %        save('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_and_times',...
% % %            'ALL_countvalues_and_times')
% % %    else
% % %        load('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_and_times')
% % %        ALL_countvalues_and_times=[ALL_countvalues_and_times; countvalues_and_times];
% % %        save('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_and_times',...
% % %         'ALL_countvalues_and_times')
% % %    end
   

%%    Clear the workspace
% % %     clear
    
% % % %% L0AD Art_times FILES INTO STRUCTURE
% % % cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\')
% % % matfpath='C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\';
% % % 
% % % matfilespath=strcat(matfpath,'*times.mat');
% % % matfiles=dir(fullfile(matfilespath));
% % % 
% % % %% L0AD GAIT EVENT FILES INTO STRUCTURE
% % % 
% % % cd('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\')
% % % matfpath='C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\';
% % % 
% % % RIGHTmatfilespath=strcat(matfpath,'*-RightLeg.mat');
% % % RIGHTmatfiles=dir(fullfile(RIGHTmatfilespath));
% % % 
% % % LEFTmatfilespath=strcat(matfpath,'*-LeftLeg.mat');
% % % LEFTmatfiles=dir(fullfile(LEFTmatfilespath));
% %     
    
    
    
end
% % %  load('C:\Users\mv100\OneDrive - University of Brighton\MATLAB\Articulation\DATA\Art_times\Gait_phases_and_hist_data\countvalues_and_times')
% % % [p, t, stats]=anova1(ALL_countvalues_and_times);
% % % 
% % % multcompare(stats,'ctype','bonferroni')