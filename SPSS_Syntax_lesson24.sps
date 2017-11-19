* Encoding: UTF-8.
* ===================================.
* N736 - Lesson 24
* on Reliability and Factor Analysis
*
* Melinda Higgins, PhD
* dated Nov 19, 2017
* ===================================.

* look at the descriptive stats on the 20 CESD items
* notice the distributions - ordinal scaling
* notice the min and max for each item
* check to see if any were skipped or missing

FREQUENCIES VARIABLES=f1a f1b f1c f1d f1e f1f f1g f1h f1i f1j f1k f1l f1m f1n f1o f1p f1q f1r f1s 
    f1t
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* reverse code items 4,8,12,16

RECODE f1d f1h f1l f1p (0=3) (1=2) (2=1) (3=0) (SYSMIS=SYSMIS) (ELSE=SYSMIS) INTO f1dr f1hr f1lr 
    f1pr.
EXECUTE.

* updated labels and codes

* Define Variable Properties.
*f1dr.
VARIABLE LABELS  f1dr 'Reverse Coded CESD 4 - I felt that I was just as good as other people'.
FORMATS  f1dr(F8.0).
VALUE LABELS f1dr
  0 '5-7 days or nearly every day for 2 weeks'
  1 '3-4 days'
  2 '1-2 days'
  3 'not at all or less than 1 day'.
*f1hr.
VARIABLE LABELS  f1hr 'Reverse Coded CESD 8 - I felt hopeful about the future'.
FORMATS  f1hr(F8.0).
VALUE LABELS f1hr
  0 '5-7 days or nearly every day for 2 weeks'
  1 '3-4 days'
  2 '1-2 days'
  3 'not at all or less than 1 day'.
*f1lr.
VARIABLE LABELS  f1lr 'Reverse Coded CESD 12 - I was happy'.
FORMATS  f1lr(F8.0).
VALUE LABELS f1lr
  0 '5-7 days or nearly every day for 2 weeks'
  1 '3-4 days'
  2 '1-2 days'
  3 'not at all or less than 1 day'.
*f1pr.
VARIABLE LABELS  f1pr 'Reverse Coded CESD 16 - I enjoyed life'.
FORMATS  f1pr(F8.0).
VALUE LABELS f1pr
  0 '5-7 days or nearly every day for 2 weeks'
  1 '3-4 days'
  2 '1-2 days'
  3 'not at all or less than 1 day'.
EXECUTE.

* check reverse coding.

FREQUENCIES VARIABLES=f1d f1dr f1h f1hr f1l f1lr f1p f1pr
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* BEFORE computing the total score for the CESD
* we need to ALWAYS check the assumptions for
* how the instructions say to handle missing data
* often these instructions are missing - most instruments/qestionnaires
* assume COMPLETE answers

* Missing imputation gets VERY complicated with imputing across
* multiple items and it's relative impact on the psychometrics of the
* instrument as designed.

* However, (based on my readings), in general if <10% of the items are
* missing or skipped for < 10% of the subjects, you can use 
* mean substitution (across the items WITHIN a subject - NOT BETWEEN subjects)
* and the impact on bias is minimal.

* It turns out the CESD allows for up to 20% of the items 
* (which is 4 skipped or missing items) to use mean substitution
* the % of subjects is not specified - but the lower the better
* I'd get suspicious if more than 10-20% of the subjects are missing.

* compute the number of missing items
* and see how many people have missing items

COMPUTE nmiss_cesd=nmiss(f1a,f1b,f1c,f1dr,f1e,f1f,f1g,f1hr,f1i,f1j,f1k,f1lr,f1m,f1n,f1o,f1pr,f1q,
    f1r,f1s,f1t).
EXECUTE.

FREQUENCIES VARIABLES=nmiss_cesd
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* so 7 subjects/453 = 1.5% of the subjects are missing 1/20 (5%) items
* so we will use mean substitution to compute the total score
* to do this we compute the mean and then multiply back by the
* total number of items. In SPSS and most stats software the mean or sum
* function treats missing data as removing that item, so if 1 item is missing
* then the mean is computed out of 19 items instead of 20 items.

COMPUTE sum_cesd=mean(f1a,f1b,f1c,f1dr,f1e,f1f,f1g,f1hr,f1i,f1j,f1k,f1lr,f1m,f1n,f1o,f1pr,f1q,f1r,
    f1s,f1t) * 20.
EXECUTE.

* let's compare what we computed to what is in the HELP dataset.

FREQUENCIES VARIABLES=cesd sum_cesd
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* let's compare the 7 subjects who had missing items

USE ALL.
COMPUTE filter_$=(nmiss_cesd > 0).
VARIABLE LABELS filter_$ 'nmiss_cesd > 0 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FREQUENCIES VARIABLES=cesd sum_cesd
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

FILTER OFF.
USE ALL.
EXECUTE.

* suppose we did a simple sum without mean substitution

COMPUTE sum_cesd_simplesum=sum(f1a,f1b,f1c,f1dr,f1e,f1f,f1g,f1hr,f1i,f1j,f1k,f1lr,f1m,f1n,f1o,f1pr,
    f1q,f1r,f1s,f1t).
EXECUTE.

* compare the stats again.

FREQUENCIES VARIABLES=cesd sum_cesd sum_cesd_simplesum
  /NTILES=4
  /STATISTICS=STDDEV MINIMUM MAXIMUM MEAN
  /HISTOGRAM
  /ORDER=ANALYSIS.

* so it appears that the HELP dataset did NOT take into account skipped or missing
* items - so the skipped items were scored a 0 - how did this impact the computed totals??

* let's compute the realiability - cronbach's alpha
* take a look at the correlation matrix

RELIABILITY
  /VARIABLES=f1dr f1hr f1lr f1pr f1a f1b f1c f1e f1f f1g f1i f1j f1k f1m f1n f1o f1q f1r f1s f1t
  /SCALE("Cronabach's alpha for 20 CESD items with items 4,8,12,16 reverse coded") ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE CORR
  /SUMMARY=TOTAL MEANS VARIANCE COV CORR.

* good internal consistency is given by alpha > 0.7, closer to 1 is better.
* when reviewing the correlation matrix - ideally you do not want any negative
* correlations and most should be > 0.3.
* when looking at the item-total stats for leave-one-out 
* none should be better than the alpha  computed above.

* let's run a factor analysis - with the 4 reverse coded items.
* use PCA, no rotation, keep 2 factors - easier for plotting.

FACTOR
  /VARIABLES f1a f1b f1c f1e f1f f1g f1i f1j f1k f1m f1n f1o f1q f1r f1s f1t f1dr f1hr f1lr f1pr
  /MISSING LISTWISE 
  /ANALYSIS f1a f1b f1c f1e f1f f1g f1i f1j f1k f1m f1n f1o f1q f1r f1s f1t f1dr f1hr f1lr f1pr
  /PRINT UNIVARIATE INITIAL CORRELATION SIG DET KMO EXTRACTION FSCORE
  /PLOT EIGEN ROTATION
  /CRITERIA FACTORS(2) ITERATE(25)
  /EXTRACTION PC
  /ROTATION NOROTATE
  /METHOD=CORRELATION.

* you want the KMO stat close to 1
* bartlett's test for sphericity should be significant
* ideally the 1st eigenvalue should be much higher
* than all the others - IF there is only ONE main factor
* i.e. no subscales or multiple factors involved.
* ideally no other eigenvalues should be > 1, but the change
* between eigenvalue 1 and the rest is important
* look at the component matrix - these are the loadings
* and look at the Score Plot
* ideally all of the items should cluster together
