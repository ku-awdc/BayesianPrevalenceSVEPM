# BayesianPrevalenceSVEPM
Repository for the 2019 SVEPM workshop: Bayesian tools for the estimation of the true disease prevalence

## Software requirements
In terms of software you will have two options for this workshop. You can use either JAGS or OpenBUGS. Please note that you need to download software and check that it is running in advance.

### JAGS
If you want to use JAGS you need to do the following:

1)  Install a recent version of R from http://cran.r-project.org

2)  We also suggest installing RStudio from https://www.rstudio.com/products/rstudio/download/ but this is optional

3)  Install JAGS from https://sourceforge.net/projects/mcmc-jags/files/JAGS/4.x/ 

4)  Install the CRAN packages runjags and rjags (including their dependencies) from within R

5)  Test your installation from within R using the following two lines of code:

library(‘runjags’)

testjags()

You should see text saying ‘JAGS version xxxx found successfully’

### OpenBUGS

If you want to use OpenBUGS you need to go to  http://www.openbugs.net/w/FrontPage and download the setup program corresponding to your computer operating system.

It may seem that OpenBUGS has only one step but it has a lot of "clicking" when running the codes. There is an option for running OpenBUGS through R but we are not doing this. If you are at least mildly familiar with writing code it may be best to go for JAGS. If you don't feel comfortable, go for OpenBUGS. Whatever your choice, we will run identical examples on both JAGS and OpenBUGS.

## Examples on this repository

Each of the examples that we will run through has two versions:  the .R files are for JAGS, and the .odc files are for OpenBUGS.  We recommend that you download these files in advance of the workshop.

## Advert

Some of the material covered during this workshop is taken from a 5-day course on Bayesian modelling (with emphasis on MCMC) that will be next run in Glasgow, Scotland from 11th-15th November 2019.  For more information, see:

https://www.prstatistics.com/course/applied-bayesian-modelling-for-ecologists-and-epidemiologists-abme05/
