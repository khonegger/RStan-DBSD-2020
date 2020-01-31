
data {
  int<lower=0> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  vector[2] beta;
  real<lower=0> sigma;
}
model {
  beta ~ normal(0, 0.1);    // Prior on beta (both coefficients)
  sigma ~ normal(0, 0.1);   // Prior on sigma
  y ~ normal(beta[1] + beta[2] * x, sigma);
}

