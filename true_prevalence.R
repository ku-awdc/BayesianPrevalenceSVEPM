setwd('/Users/armandogiovannini/Dropbox/Institute and work stuff/EFSA/EFSA Partnering grant/Work developed/SVEPM/Material')

library("coda", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

library("R2jags", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

library("rjags", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

library("runjags", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

#data
n<-4072 
y<-1210

Model4TP<-
'model {
  y ~ dbin(ap, n)
  ap<-p*Se+(1-p)*(1-Sp)
  #Uniform (non-informative) prior for apparent prevalence (ap)
  p ~ dbeta(1,1)
  #Informative priors on Se and Sp
  Se ~ dbeta(25.4, 4.5)         #0.85 (0.70–0.95)
  Sp ~ dbeta(95,5)             

#data# n, y
#monitor# p, Se, Sp
#inits# p, Se, Sp, 

}
'

#initials
p <- list(chain1=0.1, chain2=0.2, chain3=0.3, chain4=0.4)
Se <- list(chain1=0.5, chain2=0.65, chain3=0.80, chain4=0.95)
Sp <- list(chain1=0.95, chain2=0.80, chain3=0.65, chain4=0.5)

# Run the model:
resultsTP <- run.jags(Model4TP, n.chains=4, burnin = 4000, sample = 10000, adapt = 1000,thin=4)

resultsTP

write.csv(summary(resultsTP), file='TP.csv')

plot(resultsTP)

chains<-as.mcmc(resultsTP)
