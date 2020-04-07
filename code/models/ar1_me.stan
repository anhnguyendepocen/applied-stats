data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  real<lower = -1, upper = 1> rho;
  vector[N] mu;
  real<lower=0> sigma;
  real<lower=0> sigma_y;
}
model {
   
   y ~ normal(mu, sigma_y);
   mu[1] ~ normal(0, sigma/sqrt((1-rho^2)));
   mu[2:N] ~ normal(rho * mu[1:(N - 1)], sigma);
   
   //priors
   rho ~ uniform(-1,1);
   sigma ~ normal(0,1);
   sigma_y ~ normal(0,1);
}

