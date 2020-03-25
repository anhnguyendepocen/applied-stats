data {
  int<lower=0> N;
  int<lower=0> K;
  vector[N] y;
  matrix[N,K] B;
}
parameters {
  vector[K] alpha;
  real<lower=0> sigma;
  real<lower=0> sigma_alpha;
}
transformed parameters{
  vector[N] mu;
  mu = B*alpha;
}
model {
   //likelihood
   y ~ normal(mu, sigma);
   //priors
   alpha[1] ~ normal(0, sigma_alpha);
   alpha[2:K] ~ normal(2*alpha[1:(K - 1)], sigma_alpha);
   alpha ~ normal(0,1); 
   sigma ~ normal(0,1);
   sigma_alpha ~ normal(0,1);
}


