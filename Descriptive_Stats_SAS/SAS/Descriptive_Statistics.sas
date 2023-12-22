/******************
Input: diabetes.sav
Output: Diabetes_descriptive_stats
Written by:Tingwei Adeck
Date: Sep 11 2022
Description: Modify data in SAS by converting from sav to csv so that it can be used on a remote computer for projects
Requirements: Need library called umkc2, diabetes.sav file.
Dataset description: Data obtained from Dr. Gaddis (medium sized dataset)
Input: diabetes.sav (SPSS file input)
Output: Diabetes_descriptive_stats.pdf
******************/

%let path=/home/u40967678/sasuser.v94;


libname project
    "&path/sas_umkc/input";
    
filename diabetes
    "&path/sas_umkc/input/diabetes.sav";   

ods pdf file=
    "&path/sas_umkc/output/Diabetes_descriptive_stats.pdf";
    
options papersize=(8in 4in) nonumber nodate;

proc import file= diabetes
	out=umkc2.diabetes
	dbms=sav
	replace;
run;

/* PROC MEANS for descriptive stats of numeric variables*/
title "Descriptive statistics numeric continuous variables";
proc means data=umkc2.diabetes
    NMISS mean std min max;
run;

/* PROC FREQ for descriptive stats of categorical or count variables*/
title "Descriptive statistics for categorical variables";
proc freq 
	data=umkc2.diabetes;
    tables race treatment_location / missing;
run;

/*generate 95% confidence interval for population mean*/
/*proc ttest data=umkc2.diabetes alpha=0.05;
    var Glucose;
run;*/

title 'Get confidence intervals';
ods select BasicIntervals; /*restricts the output to the Basicintervals table*/
proc univariate data=umkc2.diabetes cibasic(alpha=.05);
run;

title 'Skewness and Kurtosis table';
proc means data=umkc2.diabetes SKEWNESS KURTOSIS;
run;

title 'Diabetes Data';
proc print data=umkc2.diabetes (obs=5);
run;

ods pdf close;
