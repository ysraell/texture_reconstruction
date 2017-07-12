clear all
close all
clc
run /home/israel/Documents/ELE311/trab2/unlocbox/init_unlocbox.m;
pimage =1;

fig_file = 'concrete.jpg';
rblur = 2; %usaram 2 em algum dos experimentos
N1 = 256*256; % Seria Q, 1o§ da sec. II, recomenda 25!!!
N2 = 128*128; %usaram patchs de 256x256, em geraldelta = 0.00000000001; % não consta no artigo.
K=10; % K=14, segundo artigo. (sec IV-B)
Bloc_size = 5; % 5x5, segundo artigo (sec IV-B)

    pimage = false;
    patch_Rand = false;
    [z1,z2,~,l_pos,c_pos] = func_genFIG(fig_file,rblur,N1,N2,0,patch_Rand,pimage);
    z1 = double(z1);
    z2 = double(z2);


CPP = 1;
delta = 0.000001;

disp('Calculating w_ij for i = 1,...,N1 and j = 1,...,K.')
    
    if CPP 
        [W,J] = func_WJcpp(z2,z1,K,delta,Bloc_size);
    else
        [W,J] = func_WJ(z2,z1,K,delta,Bloc_size);
    end

T=21;
as = [1 0 0 1]; %ones(4,1); %zeros(4,1); %recomenda usar variancia dos Lsz2, ts/t4 (sec IV-C)

    
tau = 1; % 
omega = 1; % não consta no artigo.
lambda_x = 1; % tunning na mão, segundo artigo. (sec IV-B), usaram gamma = 100 num dos experimento (sec IV-C)
lambda_y = 1; 


partial_figuer =1;
alternative_int=0;
alternative_prox=1;
pimage =1;


[x,z1,z2,x_o,times] = func_fbpd_alter2(fig_file,rblur,N1,N2,tau,omega,lambda_x,lambda_y,K,T,as,W,partial_figuer,alternative_int,alternative_prox);

if pimage
    
    figure;
    subplot(2,2,1)
    imagesc(x_o)
    colormap gray;
    subplot(2,2,2)
    imagesc(x)
    colormap gray;
    subplot(2,2,3)
    imagesc(z2)
    colormap gray;
    subplot(2,2,4)
    imagesc(z1)
    colormap gray;
end
