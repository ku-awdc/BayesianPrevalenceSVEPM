### Basic code for a JAGS model
## Produced for SVEPM workshop on Bayesian tools for diagnostic test evaluation
## Matt Denwood, 2018-03-21

## Define the BUGS model including statements about what data to retrieve from R,
## and what variable(s) to automatically monitor:
bugs_model <- "
	
	model{
		Positives ~ dbin(apparent_prevalence, TotalTested)
		apparent_prevalence ~ dbeta(1,1)
		
		#data# Positives, TotalTested
		#monitor# apparent_prevalence
	}

"

## Load the runjags package:
library('runjags')

## Define the data in the R working environment:
Positives <- 1210
TotalTested <- 4072

## Run the model:
results <- run.jags(bugs_model, n.chains=2, burnin=5000, sample=10000)

## Check convergence visually:
plot(results)

## Examine the results:
results

## For further information:
?runjags

## To e.g. extract the underlying Markov chains as a list of MCMC chains:
library('coda')
chains <- as.mcmc.list(results)
summary(chains)
head(chains[[1]])




### Example code for a Metropolis algorithm using the same model
## Produced for SVEPM workshop on Bayesian tools for diagnostic test evaluation
## Matt Denwood, 2018-03-21
### NOTE for participants:  You are not expected to run this code, it is just provided for interest

log_posterior_fun <- function(parameter){
	if(parameter < 0 || parameter > 1) return(-Inf)
	log_likelihood <- dbinom(1210,size=4072,prob=parameter,log=TRUE)
	log_prior <- dbeta(parameter,1,1,log=TRUE)
	return(log_likelihood + log_prior)
}

iters <- 1000
#iters <- 10050
#iters <- 100050
sigma <- 0.01

## Ensure repeatability:
set.seed(2019-03-21)

parameter <- numeric(iters)
log_post <- numeric(iters)

parameter[1] <- 0.25
log_post[1] <- log_posterior_fun(parameter[1]) 
log_post[1]

new_par <- rnorm(1, mean=parameter[1], sd=sigma)
new_par 
new_lpost <- log_posterior_fun(new_par)
new_lpost

parameter[2] <- new_par
log_post[2] <- new_lpost

new_par <- rnorm(1, mean=parameter[2], sd=sigma)
new_par 
new_lpost <- log_posterior_fun(new_par)
new_lpost

probability_ratio <- exp(new_lpost - log_post[2])
probability_ratio
accept <- rbinom(1, 1, probability_ratio)
accept

parameter[3] <- parameter[2]
log_post[3] <- log_post[2]


for(i in 4:iters){
	new_par <- rnorm(1, mean=parameter[i-1], sd=sigma)
	new_lpost <- log_posterior_fun(new_par)
	if(new_lpost > -Inf && (new_lpost > log_post[i-1] || rbinom(1,1,exp(new_lpost-log_post[i-1])))){
		log_post[i] <- new_lpost
		parameter[i] <- new_par
	}else{
		log_post[i] <- log_post[i-1]
		parameter[i] <- parameter[i-1]
	}		
}


plot(parameter, type='l', main='Trace plot of parameter values')
plot(51:iters,parameter[-(1:50)], type='l', main='Trace plot of stationary chain',xlab='Index',xlim=c(0,iters))
if(iters==1000){
hist(parameter[-(1:50)], breaks='fd', main='Histogram of 950 sampled values')
}else if(iters==10050){
hist(parameter[-(1:50)], breaks='fd', main='Histogram of 10000 sampled values')
}else if(iters==10050){
hist(parameter[-(1:50)], breaks='fd', main='Histogram of 100k sampled values')
}
print(coda::effectiveSize(coda::as.mcmc(parameter[-(1:50)])))


### Do we obtain the same summary statistics as for the JAGS model?
summary(coda::as.mcmc(parameter[-(1:50)]))
summary(coda::as.mcmc.list(results))
## Yes: the mean, SD, and quantiles are the same (within tolerance of Monte Carlo error)
