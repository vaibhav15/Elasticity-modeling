*Elasticity;

libname test2 'C:\Study Material\Marketing Predictive Analytics\Project\Dataset'; run;

data test2.modified2;
set test2.data1;
t_r=NUM_1D_RNTLS+2*NUM_2D_RNTLS+3*NUM_3D_RNTLS+4*NUM_4D_RNTLS+5*NUM_5D_RNTLS+6*NUM_GT5D_RNTLS;
price=revenue/t_r;
run;


proc standard DATA = test2.modified2 mean=0 std=1 out=test2.standard ;
var
NUM_1D_RNTLS	NUM_2D_RNTLS	NUM_3D_RNTLS	
NUM_4D_RNTLS	NUM_5D_RNTLS	NUM_GT5D_RNTLS
EDUCATION_MODEL LENGTH_OF_RESIDENCE  EARNED_PTS price;
run;


proc fastclus data = test2.standard replace = random random = 100
maxclusters = 6 out = test2.clust (keep = htz_custid cluster);
var
NUM_1D_RNTLS	NUM_2D_RNTLS	NUM_3D_RNTLS	
NUM_4D_RNTLS	NUM_5D_RNTLS	NUM_GT5D_RNTLS	
EDUCATION_MODEL	LENGTH_OF_RESIDENCE  EARNED_PTS price
;
run;


proc sort data = test2.clust; by HTZ_CUSTID; run;

PROC SORT DATA = test2.modified2;  BY HTZ_CUSTID; RUN;

data test2.final;
merge test2.modified2 test2.clust; by HTZ_CUSTID ; run;

proc sort data = test2.final; by cluster; run;

proc means data = test2.final; by cluster; 
output out = means; run;

proc discrim data= test2.final out=test2.output scores = x method=normal anova;
   class cluster ;
   priors prop;
   id htz_custid;
   var  
NUM_1D_RNTLS	NUM_2D_RNTLS	NUM_3D_RNTLS	
NUM_4D_RNTLS	NUM_5D_RNTLS	NUM_GT5D_RNTLS	
EDUCATION_MODEL	LENGTH_OF_RESIDENCE  EARNED_PTS REVENUE	
;
run;



proc sort data = test2.final; by cluster; run;






data test2.final;
set test2.final;
pricesq = price*price;
run;


proc reg data = test2.final; by cluster;
model t_r = LENGTH_OF_RESIDENCE General_Merch_buyer GPR_ENROLL_DATE EARNED_PTS price
;
output out = resid p = PUNITS r = RUNITS student = student;
run;quit;

proc means data = test2.modified2; by cluster;
var price t_r; run;


proc reg data = test2.final; by cluster;
model AP_RNTLS = LENGTH_OF_RESIDENCE General_Merch_buyer GPR_ENROLL_DATE EARNED_PTS price Political_Contributor 
Religious_Contributor Opportunity_seeker ;
output out = resid p = PUNITS r = RUNITS student = student;
run;quit;



proc reg data = test2.final; by cluster;
model revenue = LENGTH_OF_RESIDENCE General_Merch_buyer GPR_ENROLL_DATE EARNED_PTS AP_RNTLS OAP_RNTLS Political_Contributor 
Religious_Contributor Opportunity_seeker ;
output out = resid p = PUNITS r = RUNITS student = student;
run;quit;


