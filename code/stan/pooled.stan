
data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;

  // add prior values to data block //
  real beta_prior_center;           
  real sigma_prior_center;
  real<lower=0> beta_prior_scale;
  real<lower=0> sigma_prior_scale;

  // binary indicator to fit model or sample from the prior PD //
  int<lower=0,upper=1> do_fitting;
}

parameters {
  vector[2] beta;
  real<lower=0> sigma;
}

model {
  beta ~ normal(beta_prior_center, beta_prior_scale);
  sigma ~ normal(sigma_prior_center, sigma_prior_scale);

  // Now we only do fitting when indicated //
  if(do_fitting == 1) {
    y ~ normal(beta[1] + beta[2] * x, sigma);
  }

}

generated quantities {
  vector[N] y_rep;
  vector[N] log_lik;  // NEW //

  for (n in 1:N) {
      y_rep[n] = normal_rng(beta[1] + beta[2] * x[n], sigma);
      log_lik[n] = normal_lpdf(y[n] | beta[1] + beta[2] * x[n], sigma);  // NEW //
  }
}

