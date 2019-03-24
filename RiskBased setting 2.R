setwd('/Users/armandogiovannini/Dropbox/Institute and work stuff/EFSA/EFSA Partnering grant/Work developed/SVEPM/Material')

library("coda", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

library("R2jags", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

library("rjags", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

library("runjags", lib.loc="/Library/Frameworks/R.framework/Versions/3.5/Resources/library")

#data
list(n=4072, y=1210)

# Load the data and look at it:
Random<-c(221, 3851, 4072)
NonRandom<-c(407, 1629, 2036)

#Structures:

#Random
#Positives    Negatives   Tested

#NonRandom
#Positives    Negatives   Tested

Random
NonRandom


#Parameters for test:
sea=57      #parameters for Se - 0.85 (0.70–0.95)
seb=12     
spa=1000       #parameters for Sp - 0.77 (0.49–0.96)
spb=1


modelRB <- '
model{

#If the test used in Random and Non-Random groups is the same
#It is better to have in the same model both groups,
#in order to have the results based on the same estimates
#of Se and Sp in both groups

#Random group

Random[1]~dbin(apR1, Random[3])
Random[2]~dbin(apR2,Random[3])

apR1<-p*Se+(1-p)*(1-Sp)   #Likelihood
apR2<-p*(1-Se)+(1-p)*Sp

#Non-random group

NonRandom[1]~dbin(apNR1, NonRandom[3])
NonRandom[2]~dbin(apNR2, NonRandom[3])

apNR1<-pNR*Se+(1-pNR)*(1-Sp)
apNR2<-pNR*(1-Se)+(1-pNR)*Sp


#PRIORS
p~dbeta(1,2)  #Prior for the distribution of prevalence in Random group

pNR~dbeta(1,2)  #Prior for the distribution of p in NonRandom group

#The other PRIORS

Se~dbeta(sea,seb)              #Prior for Sensitivity
Sp~dbeta(spa,spb)              #Prior for Specificity

#data# Random, NonRandom, sea, seb, spa, spb
#monitor# p, pNR, Se, Sp
#inits# p, pNR, Se, Sp, 


}

'
# The initial values we need:
p <- list(chain1=0.01, chain2=0.02, chain3=0.3, chain4=0.04)
pNR <- list(chain1=0.1, chain2=0.2, chain3=0.3, chain4=0.4)
Se <- list(chain1=0.5, chain2=0.65, chain3=0.80, chain4=0.95)
Sp <- list(chain1=0.95, chain2=0.80, chain3=0.65, chain4=0.5)



# Run the model:
resultsRB <- run.jags(modelRB, n.chains=4, burnin = 4000, sample = 10000, adapt = 1000,thin=4)

resultsRB

write.csv(summary(resultsRB), file='resultsRB.csv')

plot(resultsRB)

chains<-as.mcmc(resultsRB)

write.csv(chains,file='ChainsRB.csv')

##############################
m<-as.numeric(NA)
v<-as.numeric(NA)
alpha<-as.numeric(NA)
beta<-as.numeric(NA)

for(i in 1:4){
  
m[i]<-mean(chains[,i])
v[i]<-var(chains[,i])
alpha[i]<-((m[i]^2-m[i]^3-m[i]*v[i])/v[i])
beta[i]<-((m[i]-2*m[i]^2+m[i]^3-v[i]+m[i]*v[i])/v[i])

}



hist(chains[,1], freq = FALSE, xlim=c(0,1), col = "grey", main='p')
curve(dbeta(x,alpha[1],beta[1]),col='RED', add=TRUE)

hist(chains[,2], freq = FALSE, xlim=c(0,1), col = "grey", main='pNR')
curve(dbeta(x,alpha[2],beta[2]),col='red', add=TRUE)

hist(chains[,3], freq = FALSE, xlim=c(0,1), col = "grey", main='Se')
curve(dbeta(x,alpha[3],beta[3]),col='blue', add=TRUE)

hist(chains[,4], freq = FALSE, xlim=c(0,1), col = "grey", main='Sp')
curve(dbeta(x,alpha[4],beta[4]),col='blue', add=TRUE)


#Estimation of Odds Ratios

alphaT<-as.numeric(NA)
alphaR<-as.numeric(NA)
betaT<-as.numeric(NA)
betaR<-as.numeric(NA)
meanOR<-as.numeric(NA)
varOR<-as.numeric(NA)
sd<-as.numeric(NA)

alphaR<-alpha[1]
alphaT<-alpha[2]
betaR<-beta[1]
betaT<-beta[2]


meanOR<-alphaT*betaR/((betaT-1)*(alphaR-1))
varOR<-alphaT*(alphaT+1)*(betaR-1)*betaR/((betaT-1)*(betaT-2)*(alphaR-1)*(alphaR-2))-(alphaT*betaR/((betaT-1)*(alphaR-1)))^2

sd<-sqrt(varOR)


meanOR
varOR

ORs<-cbind(meanOR,varOR)

#write.csv(ORs,file='ORs.csv')

curve(dnorm(x,meanOR,sd),col='blue', xlim=c(-10,10))

