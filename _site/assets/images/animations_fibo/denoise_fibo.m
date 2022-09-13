clear
close all
addpath(genpath('~/NextcloudFAUMADS/codes/BregmanIterations'));

%% read image
% I_rgb = imread('~/Documents/lokuger.github.io/assets/images/fibo_box.jpg');
I_rgb = imread('~/Documents/lokuger.github.io/assets/images/fibo_couch.png');
I_r = double(squeeze(I_rgb(:,:,1))); I_g = double(squeeze(I_rgb(:,:,2))); I_b = double(squeeze(I_rgb(:,:,3)));
scale = 0.2;
I_r = imresize(I_r,scale,'bicubic'); I_g = imresize(I_g,scale,'bicubic'); I_b = imresize(I_b,scale,'bicubic');

%% run Bregman Gaussian denoising algorithm
mu = 0.005;
delta = [5000, 4000, 3000, 2500, 2100, 1700, 1400, 1200, 1000, 850, 750, 650];
showIts = true;

[U_r,~] = denoise_Bregman_ROF_2D(I_r,mu,delta,'showIts',showIts,'verbose',true);
[U_g,~] = denoise_Bregman_ROF_2D(I_g,mu,delta,'showIts',showIts,'verbose',true);
[U_b,~] = denoise_Bregman_ROF_2D(I_b,mu,delta,'showIts',showIts,'verbose',true);

%% save as gif
filename = '../anim_fibo_couch.gif';
for idx = length(delta) : -1 : 1
	u = cast(cat(3,squeeze(U_r(:,:,idx)),squeeze(U_g(:,:,idx)),squeeze(U_b(:,:,idx))),'uint8');
	[A,map] = rgb2ind(u,256);
	if idx == length(delta)
		imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.4);
	else
		imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.4);
	end
end


%% save images as one gif
