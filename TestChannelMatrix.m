clear all
close all
clc

disp('Example of a Channel Matrix Evaluation');


%% DEFINITION OF PHYSFAD PARAMETERS

freq = linspace(0.9,1.1,101);

    %% Dipole Properties

        %% Transmitters

        % locations

        x_tx = [0 0 0];
        y_tx = [4 4.5 5];

        if length(x_tx)~=length(y_tx)
            disp('Error: x_tx and y_tx do not have the same length.');
        else
            N_T = length(x_tx);
        end

        % dipole properties

        fres_tx = [1 1 1];
        chi_tx = [0.5 0.5 0.5];
        gamma_tx = [0 0 0];

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

        x_rx = [15 15 15 15];
        y_rx = [11 11.5 12 12.5];

        if length(x_rx)~=length(y_rx)
            disp('Error: x_rx and y_rx do not have the same length.');
        else
            N_R = length(x_rx);
        end

        % properties

        fres_rx = [1 1 1 1];
        chi_rx = [0.5 0.5 0.5 0.5];
        gamma_rx = [0 0 0 0];

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

        if length(x_env)~=length(y_env)
            disp('Error: x_env and y_env do not have the same length.');
        else
            N_E = length(x_env);
        end

        % properties

        fres_env = 10*ones(size(x_env));
        chi_env = 50*ones(size(x_env));
        gamma_env = 100*ones(size(x_env));

        if length(fres_env)~=N_E
            disp('Error: x_env and fres_env do not have the same length.');
        end
        if length(chi_env)~=N_E
            disp('Error: x_env and chi_env do not have the same length.');
        end
        if length(gamma_env)~=N_E
            disp('Error: x_env and gamma_env do not have the same length.');
        end

        %% RIS

        % locations
        load('ExampleRIS.mat','x_ris','y_ris');
        
        if length(x_ris)~=length(y_ris)
            disp('Error: x_ris and y_ris do not have the same length.');
        else
            N_RIS = length(x_ris);
        end

        % properties

        fres_ris_ON = 1;
        fres_ris_OFF = 5;
        chi_ris = 50*ones(size(x_ris));
        gamma_ris = 0*ones(size(x_ris));

        if length(chi_ris)~=N_RIS
            disp('Error: x_ris and chi_ris do not have the same length.');
        end
        if length(gamma_ris)~=N_RIS
            disp('Error: x_ris and gamma_ris do not have the same length.');
        end

        %% RIS Configuration
        
        config_ris = round(rand(1,N_RIS));
        clear fres_ris;
        for cc=1:length(config_ris)
            if config_ris(cc)==0
                fres_ris(cc) = fres_ris_OFF;
            elseif config_ris(cc)==1
                fres_ris(cc) = fres_ris_ON;
            end
        end

        if length(fres_ris)~=N_RIS
            disp('Error: x_ris and fres_ris do not have the same length.');
        end

    %% Visualize Dipole Locations

    figure, set(gcf,'pos',[489         173        1020         590]);hold on,box on,
    plot(x_tx,y_tx,'bo','displayname','TX');
    plot(x_rx,y_rx,'ro','displayname','RX');
    plot(x_env,y_env,'k.','displayname','Scat. Env.');
    plot(x_ris,y_ris,'g.','markersize',7.5,'displayname','RIS');
    axis equal;
    xlabel('x [a.u.]');
    ylabel('y [a.u.]');
    set(gca,'fontsize',15);
    xlim([min([x_tx x_rx x_env x_ris])-1 max([x_tx x_rx x_env x_ris])+1]);
    ylim([min([y_tx y_rx y_env y_ris])-1 max([y_tx y_rx y_env y_ris])+1]);
    legend('show','location','eastoutside');
    drawnow;

    
%% EVALUATE CHANNEL MATRIX

[freq,H] = getH(freq,...
                x_tx,y_tx,fres_tx,chi_tx,gamma_tx,...
                x_rx,y_rx,fres_rx,chi_rx,gamma_rx,...
                x_env,y_env,fres_env,chi_env,gamma_env,...
                x_ris,y_ris,fres_ris,chi_ris,gamma_ris);

            
