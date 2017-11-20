
* make a copy to WORK;

data helpmkh;
  set library.helpmkh;
  run;

* select 20 cases at random;

proc surveyselect data=helpmkh
   method=srs n=20 out=helpsample;
run;

* select 20 males and 20 females;

proc sort data=helpmkh;
  by female;
  run;

proc surveyselect data=helpmkh
   method=srs n=20 out=helpsampleMF;
   strata female;
run;
