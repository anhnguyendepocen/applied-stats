data {
  int<lower=0> N;
  int<lower=0> K;
  int<lower=0> P;
  int<lower=0> S;
  vector[N] y;
  vector[N] se;
  int<lower=1> t_i[N];
  int<lower=1> c_i[N];
  matrix[P,K] B;
}
parameters {
  real<lower=0> sigma;
  matrix[K,S] alpha;
}

transformed parameters{
    matrix[P,S] mu;
    
    for(s in 1:S){
      for(p in 1:P){
          mu[p,s] = B[p,1:K]*alpha[1:K,s]; 
     }
    }
}

model {
  vector[N] y_hat;
  
  sigma ~ normal(0,1);
  
  for(s in 1:S){
     alpha[1,s] ~ normal(0, sigma);
     alpha[2:K,s] ~ normal(alpha[1:(K - 1),s], sigma);
  }
  
  for(i in 1:N){
    y_hat[i] = mu[t_i[i], c_i[i]];
  }
  y ~ normal(y_hat, se);
  
}