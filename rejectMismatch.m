function [ results ] = rejectMismatch( Pos1,Pos2 )
%% set RANSAC parameter
% number of points
N = 300;
% inilers percentage
p = 0.25;
% noise
sigma = 1;

options.epsilon = 1e-6;
options.P_inlier = 1-1e-4;
options.sigma = sigma;
options.validateMSS_fun = @validateMSS_homography;
options.est_fun = @estimate_homography;
options.man_fun = @error_homography;
options.mode = 'MSAC';
% options.mode = 'RANSAC';

options.Ps = [];
options.notify_iters = [];
options.min_iters = 1000;
options.fix_seed = false;
options.reestimate = true;
options.stabilize = false;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% form the input data pairs
Pos1 =Pos1';
Pos2 = Pos2';
X = [Pos1; Pos2];
% run RANSAC
[results, options] = RANSAC(X, options);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Results Visualization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = reshape(results.Theta, 3, 3);

Pos1_map = homo2cart(H*cart2homo(Pos1));
Pos2_map = homo2cart(H\cart2homo(Pos2));
% 
% figure;
% 
% subplot(1,2,1)
% hold on
% plot(Pos2_map(1, results.CS), Pos2_map(2, results.CS), 'sg', 'MarkerFaceColor', 'g')
% plot(Pos1(1, :), Pos1(2, :), '+r')
% 
% axis equal tight
% xlabel('x');
% ylabel('y');
% 
% legend('Estimated Inliers', 'Data Points')
% 
% subplot(1,2,2)
% hold on
% plot(Pos1_map(1, results.CS), Pos1_map(2, results.CS), 'sg', 'MarkerFaceColor', 'g')
% plot(Pos2(1, :), Pos2(2, :), '+r')
% 
% axis equal tight
% xlabel('x');
% ylabel('y');
% 
% legend('Estimated Inliers', 'Data Points')

end

