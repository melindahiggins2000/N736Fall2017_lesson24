library(tidyverse)
library(haven)

helpdat <- haven::read_spss("helpmkh.sav")

# select 20 cases at random
# sample without replacement
set.seed(1234)
helpsample <- helpdat[sample(1:nrow(helpdat), 20,
                             replace=FALSE),]

# suppose we want 20 random males
# and 20 random females
# separate males and females
helpdat.m <- helpdat %>%
  filter(female==0)
helpdat.f <- helpdat %>%
  filter(female==1)

# get a random sample in each subset
helpsample.m <- helpdat.m[sample(1:nrow(helpdat.m), 20,
                             replace=FALSE),]
helpsample.f <- helpdat.f[sample(1:nrow(helpdat.f), 20,
                             replace=FALSE),]

# merge the samples back together
helpsample.mf <- dplyr::bind_rows(helpsample.m,
                                  helpsample.f)

