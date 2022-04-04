clear
close all

%% read image
% I_rgb = imread('~/Documents/lokuger.github.io/assets/images/fibo_box.jpg');
I_rgb = imread('~/Documents/lokuger.github.io/assets/images/fibo_couch.png');
I_r = double(squeeze(I_rgb(:,:,1))); I_g = double(squeeze(I_rgb(:,:,2))); I_b = double(squeeze(I_rgb(:,:,3)));
scale = 0.2;
I_r = imresize(I_r,scale,'bicubic'); I_g = imresize(I_g,scale,'bicubic'); I_b = imresize(I_b,scale,'bicubic');
[M,N] = size(I_r);

%% run ROF model
weights = ones(M,N);
Mu = 10.^(-1:0.3:2); nImages = length(Mu);
fig = figure();
filename = 'anim_fibo_box.gif';
for idx = 1 : nImages
	mu = Mu(idx);
	[u_r,~] = ROF_denoise_weighted_2D(I_r,weights,mu);
	[u_g,~] = ROF_denoise_weighted_2D(I_g,weights,mu);
	[u_b,~] = ROF_denoise_weighted_2D(I_b,weights,mu);
	u = cast(cat(3,u_r,u_g,u_b),'uint8');
	subplot(3,4,idx)
	imshow(u)
	drawnow
	[A,map] = rgb2ind(u,256);
	if idx == 1
		imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.2);
	else
		imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',0.2);
	end
	fprintf('mu = %f done.\n',mu)
end

%% save images as one gif
