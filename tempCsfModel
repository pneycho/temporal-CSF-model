%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimates the spatio-Temporal JND profile of video frames
% 
% Personal implementation of 
% "Spatio-Temporal Just Noticeable Distortion Profile
% for Grey Scale Image/Video in DCT Domain" by Zhenyu Wei and King N. Ngan
% IEEE TRANSACTIONS ON CIRCUITS AND SYSTEMS FOR VIDEO TECHNOLOGY, VOL. 19, NO. 3, MARCH 2009  
% 
% INPUT:
% I = video frame in question, I(t) [can be either grayscale or rgb]
% I2 = Next video frame, I(t+1) [ can be either grayscale or rgb]
% fr = frame rate of the video
% p = search parameter for block based motion estimation
%
%OUTPUT:
% T_JND = Temporal Threshold values of the video frame I(t)
% T_JND_s = Spatial threshold values for frame I(t)
%
% Written by Shreyan Sanyal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
function [T_JND_s, T_JND] = tempCsfModel(I, I2, fr, p)

% mbSize = 8 %macro-block size
% R_iv = 3
% P_ich = 768

%%

if size(I,3) > 1
    I = rgb2ycbcr(I);
end
if size(I2,3) > 1
    I2 = rgb2ycbcr(I2);
end
    
I =  I(:,:,1);
I2 = I2(:,:,1);

func = @(block_struct) dct2(block_struct.data)
I_dct = blockproc(I,[8 8],func);

%% Luminance adaptation effect

func = @(block_struct) (mean2(block_struct.data));
F_lum0 = blockproc(I,[8 8],func);
F_lum =  ones(size(F_lum0));

for i = 1 : size(F_lum0,1)
    for j = 1: size(F_lum0,2)
        if F_lum0(i,j) <= 60
            F_lum(i,j) = (60 - F_lum0(i,j))/150 +1;
        end
        if F_lum0(i,j) >= 170
            F_lum(i,j) = (F_lum(i,j) - 170)/425 +1;
        end
    end
end

func = @(block_struct) ((block_struct.data) * ones(8));
F_lum = blockproc(F_lum,[1 1], func);

%%
theta_h = 2.* atand(1/(2*3*768));

for i = 0 : 7
            for j = 0: 7
      
        omega_i0 = (j)/(16*theta_h);
        omega_j0 = (i)/(16*theta_h);
        omega_ij(i+1,j+1) = (1/(2*8))*sqrt(((i).^2 + (j).^2)/(theta_h.^2));
         
        psi_ij = (asind(2.*omega_i0.*omega_j0/omega_ij(i+1,j+1).^2));
        
        if i==0
        phi_i = sqrt(1/8);
        else
            phi_i = 0.5;
        end
        
        if j==0
        phi_j = sqrt(1/8);
        else
            phi_j = 0.5;
        end
        
        T_2(i+1,j+1) =  exp(0.18*omega_ij(i+1,j+1))/((1.33 + 0.11*omega_ij(i+1,j+1)).*phi_i.*phi_j.*(0.6+0.4*(cos(psi_ij).^2)));
    end
        end


T_ = ones(size(F_lum0));
func = @(block_struct) T_2
T_ = blockproc(T_,[1 1],func);

T_basic = 0.25.*T_;

%% Contrast masking based on block classification

I_edge = edge(I,'canny');
psi = zeros(size(I_edge));

func = @(block_struct) ...
   (nnz(block_struct.data)/8.^2) * ones(size(block_struct.data)) ;
rho_edge = blockproc(I_edge,[8 8],func);
psi = ones(size(I_edge));

psi(rho_edge > 0.2) = 9;
F_contr = zeros(size(psi));

for i = 1:size(I,1)
        for j = 1: size(I,2)

                if psi(i,j) == 1 && ((i-1).^2 + (j-1).^2) <= 16
						F_contr(i,j) = 1;

			elseif psi(i,j) == 1  && ((i-1).^2 + (j-1).^2) > 16
				F_contr(i,j) = 1.*min(4,max(1,(abs(I_dct(i,j)/(T_basic(i,j).*F_lum(i,j))).^0.36)));
				

            elseif psi(i,j) == 9 && ((i-1).^2 + (j-1).^2) <= 16
                F_contr(i,j) = 2.25.* min(4,max(1,(abs(I_dct(i,j)/(T_basic(i,j).*F_lum(i,j))).^0.36)));

            elseif psi(i,j) == 9  && ((i-1).^2 + (j-1).^2) > 16
                F_contr(i,j) = 1.25.* min(4,max(1,(abs(I_dct(i,j)/(T_basic(i,j).*F_lum(i,j))).^0.36)));
            end
        end
end




%% Temporal JND Calculation

[MV, SS4Computations] = motionEstARPS(I2, I, 8, 7)

c = 1;

for u = 1:8: size(I,1)-8 + 1 
    for v = 1:8: size(I,2)-8+ 1
        motionVect(u:u+8,v:v+8) = sqrt(MV(1,c).^2 + MV(2,c).^2);
        c = c+1;
    end
end
motionVect = motionVect(1:size(I,1),1:size(I,2));

for i = 1:size(I_dct,1)
        for j = 1: size(I_dct,2)
            
        v_Ih = fr .* motionVect(i,j) .*theta_h;
        v_eh = min((0.98.*v_Ih) + 0.15, 80);

        v_h = v_Ih - v_eh;

        f_sx = i/(16.*theta_h);
        f_sy = j/ (16.*theta_h);

        f_t(i,j) = (f_sx + f_sy).*v_h;
        end
end

for i  = 1: size(f_t,1)
    for j = 1: size(f_t,2)
        
        if (I_dct(i,j) < 5 & f_t(i,j) < 10)
            FT(i,j) = 1;
        elseif (I_dct(i,j) < 5 & f_t(i,j) >= 10)
            FT(i,j) = 1.07.^(f_t(i,j)-10);
        else
            FT(i,j) = 1.07.^f_t(i,j);
        end
    end
end

%% Final calculations

Fm = F_contr .* F_lum;
T_JND_s = (T_basic .* Fm);

T_JND_s(isnan(T_JND_s))=0;

T_JND = (T_JND_s .* FT);
T_JND(isnan(T_JND))=0;
