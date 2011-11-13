function dist = KLdiv(mu1, cov1, mu2, cov2)
% DIST = KLDIV(MU1, COV1, MU2, COV2)
%
%   - KL Divergence -
% Distance function for songs
% Dist_kl(p, q) = KL(p||q)+KL(q||p), where p and q are multivariate
% gaussian distributions from mu1,cov1 and mu2,cov2.
%
% See also: knn.m 
%

% load testdat

d = length(mu1);  % dimension of multivariate gaussian

% X1 = mvnrnd(mu1, cov1, d); 
% X2 = mvnrnd(mu2, cov2, d); 
% P = mvnpdf(X1, mu1, cov1);
% Q = mvnpdf(X2, mu2, cov2);

if det(cov1) == 0 || det(cov2) == 0
    logcov_pq = 0;  % prevent NaN (div by 0) and -Inf (log 0)
    logcov_qp = 0;
else 
    logcov_pq = log(det(cov2)/det(cov1));
    logcov_qp = log(det(cov1)/det(cov2));
end

trcov_pq = trace(cov2\cov1);
trcov_qp = trace(cov1\cov2);
musq_pq = (mu1-mu2)*(cov2\(mu1-mu2)');
musq_qp = (mu2-mu1)*(cov1\(mu2-mu1)');

twoKL_pq = logcov_pq + trcov_pq + musq_pq - d;
twoKL_qp = logcov_qp + trcov_qp + musq_qp - d;

dist = 0.5*(twoKL_pq + twoKL_qp);



