library(tidyverse)
library(rstan)
library(here)

# load in data
ds <- read_rds(here("data","births_2017_sample.RDS"))
head(ds)
ds <- ds %>% 
  rename(birthweight = dbwt, gest = combgest) %>% 
  mutate(preterm = ifelse(gest<32, "Y", "N")) %>% 
  filter(ilive=="Y",gest< 99, birthweight<9.999)

# Calculate scaled gestational length
log_gest_c <- (log(ds$gest) - mean(log(ds$gest)))/sd(log(ds$gest))
N <- length(log_gest_c)

# load in model output for Model 1

load(here("output", "mod1.Rda"))
fit <- extract(mod1)

nsims <- dim(fit$beta)[1]

beta0_s <- fit$beta[,1]
beta1_s <- fit$beta[,2]
sigma_s <- fit$sigma

log_weight_rep <- matrix(NA, nrow = N, ncol = nsims)

for(i in 1:N){
  log_weight_rep[i,] <- rnorm(nsims, mean = beta0_s+beta1_s*log_gest_c[i], sd = sigma_s)
}


colnames(log_weight_rep) <- 1:nsims

dr <- as_tibble(log_weight_rep)
dr <- dr %>% bind_cols(i = 1:N, log_weight_obs = log(ds$birthweight))

dr <- dr %>% 
  pivot_longer(`1`:`1000`, names_to = "sim", values_to = "log_weight_rep")

