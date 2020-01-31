# Code from Andrew Gelman's example datasets:
# http://www.stat.columbia.edu/~gelman/arm/examples/radon/radon_setup.R

# Set up the radon data

# read in and clean the data

srrs2 <- read.table ("srrs2.dat", header=T, sep=",")
mn <- srrs2$state=="MN"
radon <- srrs2$activity[mn]
log.radon <- log (ifelse (radon==0, .1, radon))
floor <- srrs2$floor[mn]       # 0 for basement, 1 for first floor
n <- length(radon)
y <- log.radon
x <- floor

# get county index variable

county.name <- as.vector(srrs2$county[mn])
uniq <- unique(county.name)
J <- length(uniq)
county <- rep (NA, J)
for (i in 1:J){
  county[county.name==uniq[i]] <- i
}

# get the county-level predictor

srrs2.fips <- srrs2$stfips*1000 + srrs2$cntyfips
cty <- read.table ("cty.dat", header=T, sep=",")
usa.fips <- 1000*cty[,"stfips"] + cty[,"ctfips"]
usa.rows <- match (unique(srrs2.fips[mn]), usa.fips)
uranium <- cty[usa.rows,"Uppm"]
u <- log(uranium)

# End Gelman code
# --------------------------------------------------


uranium_df <- data.frame(
  county = 1:85,
  uranium,
  log_uranium = u
)

radon_df <- data.frame(
  floor,
  radon,
  log_radon = log.radon,
  county_idx = county,
  county_name = county.name
)

saveRDS(uranium_df, "../county-data.rds")
saveRDS(radon_df, "../house-data.rds")
