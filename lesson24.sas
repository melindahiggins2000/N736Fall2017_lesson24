
* make a copy to WORK;

data helpmkh;
  set library.helpmkh;
  run;

* Encoding: UTF-8.
* =================================================.
* N736 Lesson 24 - reliability and factor analysis
*
* dated 11/20/2017
* Melinda Higgins, PhD
* =================================================.;

* look at the descriptive stats on the 20 CESD items
* each are ordinally scaled 0,1,2,3
* notice the min and max for each item
* check to see if any were skipped or missing;

proc means data=helpmkh n nmiss min max mean std;
    var f1a f1b f1c f1d f1e f1f f1g f1h f1i f1j
        f1k f1l f1m f1n f1o f1p f1q f1r f1s f1t;
run;

* reverse code the 4 items;

data help2;
  set helpmkh;
  if f1d=0 then f1dr=3;
  if f1d=1 then f1dr=2;
  if f1d=2 then f1dr=1;
  if f1d=3 then f1dr=0;
  if f1h=0 then f1hr=3;
  if f1h=1 then f1hr=2;
  if f1h=2 then f1hr=1;
  if f1h=3 then f1hr=0;
  if f1l=0 then f1lr=3;
  if f1l=1 then f1lr=2;
  if f1l=2 then f1lr=1;
  if f1l=3 then f1lr=0;
  if f1p=0 then f1pr=3;
  if f1p=1 then f1pr=2;
  if f1p=2 then f1pr=1;
  if f1p=3 then f1pr=0;
run;

* check reverse coding;

proc freq data=help2;
  table f1d f1dr f1h f1hr f1l f1lr f1p f1pr;
  run;

* compute sum using mean substitution
  compare to HELP sum cesd;

data help3;
  set help2;
  nmiss_cesd = nmiss(f1a, f1b, f1c, f1dr, f1e, f1f, f1g, f1hr, f1i, f1j,
      f1k, f1lr, f1m, f1n, f1o, f1pr, f1q, f1r, f1s, f1t);
  sum_cesd = mean(f1a, f1b, f1c, f1dr, f1e, f1f, f1g, f1hr, f1i, f1j,
      f1k, f1lr, f1m, f1n, f1o, f1pr, f1q, f1r, f1s, f1t)*20;
  sum2_cesd = sum(f1a, f1b, f1c, f1dr, f1e, f1f, f1g, f1hr, f1i, f1j,
      f1k, f1lr, f1m, f1n, f1o, f1pr, f1q, f1r, f1s, f1t);
  run;

* compare scoring approaches to cesd in original HELP dataset;

proc means data=help3 n nmiss min max mean std;
  var cesd sum_cesd sum2_cesd;
  run;

* get Cronbach's alpha from proc corr;

proc corr data=help2 alpha nocorr;
  var f1a f1b f1c f1dr f1e f1f f1g f1hr f1i f1j
      f1k f1lr f1m f1n f1o f1pr f1q f1r f1s f1t;
run;

* factor analysis with proc factor
  the options all give all output
  and plots=all give you all plots
  nfactors just looks at 1st 2 - could leave
  this off and see the other factors;

proc factor data=help2 all plots=all nfactors=2;
  var f1a f1b f1c f1dr f1e f1f f1g f1hr f1i f1j
      f1k f1lr f1m f1n f1o f1pr f1q f1r f1s f1t;
run;
