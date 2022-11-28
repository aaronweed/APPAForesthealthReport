devtools::install_github("graysonwhite/rFIA")

library(rFIA)
options(timeout = 3600)
cores <- parallel::detectCores() / 2

at <- getFIA(states = c('CT', 'GA', 'ME', 'MD', 'MA', 'NH', 'NJ', 'NY', 'NC', 'PA', 'TN', 'VT', 'VA'),
             dir = '../FIA',
             nCores = 8) 
