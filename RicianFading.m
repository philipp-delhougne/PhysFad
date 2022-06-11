clear all
close all
clc

disp('Example of generating physics-compliant realizations of Rician fading');

% The transparency of the ENV dipoles determines the Rician K-factor (see Fig. 5b).
fres_env_value = 45;

% number of desired realizations
rea_max = 150;

% decide if the dipole locations shall be plotted in a figure (1=yes; 0=no).
displaychoice = 0;%1;%

%% DEFINITION OF PHYSFAD PARAMETERS

freq = 1;

    %% Dipole Properties

        %% Transmitters

        % locations

        x_tx = [0];
        y_tx = [4.5];

        if length(x_tx)~=length(y_tx)
            disp('Error: x_tx and y_tx do not have the same length.');
        else
            N_T = length(x_tx);
        end

        % dipole properties

        fres_tx = [1];
        chi_tx = [0.5];
        gamma_tx = [0];

        if length(fres_tx)~=N_T
            disp('Error: x_tx and fres_tx do not have the same length.');
        end
        if length(chi_tx)~=N_T
            disp('Error: x_tx and chi_tx do not have the same length.');
        end
        if length(gamma_tx)~=N_T
            disp('Error: x_tx and gamma_tx do not have the same length.');
        end



        %% Receivers

        % locations

        x_rx = [15];
        y_rx = [11];

        if length(x_rx)~=length(y_rx)
            disp('Error: x_rx and y_rx do not have the same length.');
        else
            N_R = length(x_rx);
        end

        % properties

        fres_rx = [1];
        chi_rx = [0.5];
        gamma_rx = [0];

        if length(fres_rx)~=N_R
            disp('Error: x_rx and fres_rx do not have the same length.');
        end
        if length(chi_rx)~=N_R
            disp('Error: x_rx and chi_rx do not have the same length.');
        end
        if length(gamma_rx)~=N_R
            disp('Error: x_rx and gamma_rx do not have the same length.');
        end


        %% Scattering Environment

        % locations
        load('ComplexEnclosure.mat')
        x_cav = x_env; clear x_env;
        y_cav = y_env; clear y_env;
    
    
%% LOOP TO GENERATE RICIAN CHANNEL REALIZATIONS

H_list = nan(rea_max,N_R,N_T);

for rea=1:rea_max
    
    disp(['Working on realization ',num2str(rea),' of ',num2str(rea_max),'.']);    
    
        %% UPDATE Scattering Environment with respect to its dynamic dipoles

        Curliness = 1;

        x1=[]; y1=[]; x2=[]; y2=[]; x3=[]; y3=[]; x4=[]; y4=[]; x5=[]; y5=[]; x6=[]; y6=[]; x7=[]; y7=[]; x8=[]; y8=[];

        % stirrer 1
        L1 = 5;
        xc1 = 1;
        yc1 = 10;
        th1 = rand*180;
        step = 0.25;
        [x1,y1] = getCURLYscatGadf(L1,th1,xc1,yc1,step,Curliness);

        % stirrer 2
        L2 = 5;3;
        xc2 = 9;7;
        yc2 = 9;11;
        th2 = rand*180;
        step = 0.25;
        [x2,y2] = getCURLYscatGadf(L2,th2,xc2,yc2,step,Curliness);

        % stirrer 3
        L3 = 5;
        xc3 = 12;
        yc3 = 4;
        th3 = rand*180;
        step = 0.25;
        [x3,y3] = getCURLYscatGadf(L3,th3,xc3,yc3,step,Curliness);

        % stirrer 4
        L4 = 5;
        xc4 = 4;
        yc4 = 4;
        th4 = rand*180;
        step = 0.25;
        [x4,y4] = getCURLYscatGadf(L4,th4,xc4,yc4,step,Curliness);

        % stirrer 5
        L5 = 4;
        xc5 = 6;
        yc5 = 6;
        th5 = -45;
        step = 0.25;
        [x5,y5] = getlinscatGadf(L5,th5,xc5,yc5,step);

        % stirrer 6
        L6 = 3;
        xc6 = -3;
        yc6 = 3;
        th6 = rand*180;
        step = 0.25;
        [x6,y6] = getCURLYscatGadf(L6,th6,xc6,yc6,step,Curliness);

        % stirrer 7
        L7 = 3;
        xc7 = -2;
        yc7 = 13.5;
        th7 = rand*180;
        step = 0.25;
        [x7,y7] = getCURLYscatGadf(L7,th7,xc7,yc7,step,Curliness);

        % stirrer 8
        L8 = 3;
        xc8 = 17;
        yc8 = 2;
        th8 = rand*180;
        step = 0.25;
        [x8,y8] = getCURLYscatGadf(L8,th8,xc8,yc8,step,Curliness);

        x_env = [x_cav x1 x2 x3 x4 x5 x6 x7 x8];
        y_env = [y_cav y1 y2 y3 y4 y5 y6 y7 y8];

        if length(x_env)~=length(y_env)
            disp('Error: x_env and y_env do not have the same length.');
        else
            N_E = length(x_env);
        end

        % dipole properties

        fres_env = fres_env_value*ones(size(x_env));%10%2
        chi_env = 50*ones(size(x_env));
        gamma_env = 0*ones(size(x_env));

        if length(fres_env)~=N_E
            disp('Error: x_env and fres_env do not have the same length.');
        end
        if length(chi_env)~=N_E
            disp('Error: x_env and chi_env do not have the same length.');
        end
        if length(gamma_env)~=N_E
            disp('Error: x_env and gamma_env do not have the same length.');
        end
    

        %% Visualize Dipole Locations (if desired)

        if displaychoice==1
            figure(1), clf(1); set(gcf,'pos',[489         173        1020         590]);hold on,box on,
            plot(x_tx,y_tx,'bo','displayname','TX');
            plot(x_rx,y_rx,'ro','displayname','RX');
            plot(x_env,y_env,'k.','displayname','Scat. Env.');
            axis equal;
            xlabel('x [a.u.]');
            ylabel('y [a.u.]');
            set(gca,'fontsize',15);
            xlim([min([x_tx x_rx x_env])-1 max([x_tx x_rx x_env])+1]);
            ylim([min([y_tx y_rx y_env])-1 max([y_tx y_rx y_env])+1]);
            legend('show','location','eastoutside');
            drawnow;
        end

        %% EVALUATE CHANNEL MATRIX

        [freq,H] = getH(freq,...
                        x_tx,y_tx,fres_tx,chi_tx,gamma_tx,...
                        x_rx,y_rx,fres_rx,chi_rx,gamma_rx,...
                        x_env,y_env,fres_env,chi_env,gamma_env,...
                        [],[],[],[],[]);

        %% COLLECT DATA

        H_list(rea) = squeeze(H);
    
end

%% Brief analysis of results

clc


figure,hold on, box on,
plot([-1 1]*max(abs(H_list)),[0 0],'k');
plot([0 0],[-1 1]*max(abs(H_list)),'k');
plot(real(H_list),imag(H_list),'.','markersize',10);
axis equal;
xlim([-1 1]*max(abs(H_list)));
ylim([-1 1]*max(abs(H_list)));
xlabel('Real(H)');
ylabel('Imag(H)');
set(gca,'fontsize',15);

K = abs(mean(H_list))^2 / (2*std(H_list)^2);
disp(['K = ',num2str(10*log10(K)),' dB with f_{res}^{Scat.Env} = ',num2str(fres_env_value)]);

title(['K = ',num2str(10*log10(K)),' dB with f_{res}^{Scat.Env} = ',num2str(fres_env_value)]);
drawnow
        
