PROC IMPORT OUT= TEST2.data1 
            DATAFILE= "C:\Study Material\Marketing Predictive Analytics\
Project\Dataset\dataset.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
