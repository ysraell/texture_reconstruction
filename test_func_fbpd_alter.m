clear all
close all
clc
run /home/israel/Documents/ELE311/trab2/unlocbox/init_unlocbox.m;
pimage =1;

fig_file = 'concrete.jpg';
rblur = 2; %usaram 2 em algum dos experimentos
N1 = 64*64; % Seria Q, 1o§ da sec. II, recomenda 25!!!
N2 = 0.899*N1; %usaram patchs de 256x256, em geral
tau = 10; % 
omega = 0; % não consta no artigo.
lambda = 0; % tunning na mão, segundo artigo. (sec IV-B), usaram gamma = 100 num dos experimento (sec IV-C)
delta = 0.000000001; % não consta no artigo.
K=10; % K=14, segundo artigo. (sec IV-B)
Bloc_size = 5; % 5x5, segundo artigo (sec IV-B)
T=21;
as = zeros(4,1); %ones(4,1); %zeros(4,1); %recomenda usar variancia dos Lsz2, ts/t4 (sec IV-C)
CPP = 1;
partial_figuer =1;
alternative_int=1;
%[x,z1,z2,x_o,times] = func_fbpd(fig_file,rblur,N1,N2,tau,omega,lambda,delta,K,Bloc_size,T,as,CPP,partial_figuer,alternative_int);
[x,z1,z2,x_o,times] = func_fbpd_alter(fig_file,rblur,N1,N2,tau,omega,lambda,delta,K,Bloc_size,T,as,CPP,partial_figuer,alternative_int);

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
