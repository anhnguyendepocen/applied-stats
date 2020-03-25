data {
  int<lower=0> N;
  int<lower=0> K;
  vector[N] y;
  matrix[N,K] B;
}
parameters {
  vector[K] alpha;
  real<lower=0> sigma;
}

transformed parameters{
  vector[N] mu;
  mu = B*alpha;
}

model {
   
   //likelihood
   y ~ normal(mu, sigma);
   
   //priors
   alpha ~ normal(0,1); 
   sigma ~ normal(0,1);
  
}


