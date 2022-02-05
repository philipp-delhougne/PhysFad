function [freq,H] = getH(freq,...
    x_tx,y_tx,fres_tx,chi_tx,gamma_tx,...
    x_rx,y_rx,fres_rx,chi_rx,gamma_rx,...
    x_env,y_env,fres_env,chi_env,gamma_env,...
    x_ris,y_ris,fres_ris,chi_ris,gamma_ris)

% constants of proportionality and constants of unity value are neglected for better readability

k       = 2*pi*freq;

%% collect dipole parameters

x     = [x_tx x_rx x_env x_ris];
y     = [y_tx y_rx y_env y_ris];
fres  = [fres_tx fres_rx fres_env fres_ris];
chi   = [chi_tx chi_rx chi_env chi_ris];
gamma = [gamma_tx gamma_rx gamma_env gamma_ris];

N_T   = length(x_tx);
N_R   = length(x_rx);
N_E   = length(x_env);
N_RIS = length(x_ris);
N     = N_T+N_R+N_E+N_RIS;

%% loop over frequencies

for ff=1:length(freq)
    
    disp(['Currently evaluating frequency point ',num2str(ff),' / ',num2str(length(freq)),'.']);
    
    %% Assemble W
    W=zeros(N,N);
    for ii=1:N
        % diagonal entries of W are the inverse polarizabilities
        inv_alpha = ((2*pi*fres(ii))^2-(2*pi*freq(ff))^2)/(chi(ii)^2) + 1i*((k(ff)^2/4) + 2*pi*freq(ff)*gamma(ii)/(chi(ii)^2));
        W(ii,ii)  = inv_alpha;
        % off-diagonal entries of W are the negative free-space Green's functions between ith and jth dipoles
        x_i = x(ii);
        y_i = y(ii);
        for jj=1:N
            if jj~=ii
                x_j = x(jj);
                y_j = y(jj);
                W(ii,jj) = 1i*(k(ff)^2/4)*besselh(0,2,k(ff)*sqrt((x_j-x_i)^2+(y_j-y_i)^2));
            end
        end
    end
    
    %% Invert W and extract H
    
    Winv = W^(-1);
    
    V = diag(diag(W))*Winv;
    
    H(ff,:,:) = V((N_T+1):(N_T+N_R),1:N_T);
    
end

end

