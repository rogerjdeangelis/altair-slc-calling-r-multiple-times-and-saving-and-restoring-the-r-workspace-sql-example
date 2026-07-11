%let pgm=altair-slc-calling-r-multiple-times-and-saving-and-restoring-the-r-workspace-sql-example;

%stop_submission;

altair slc calling r multiple times and saving and restoring the r workspace sql example

This is like creating permanent sas libraries for continued use.

Too long to post, see
https://github.com/rogerjdeangelis/altair-slc-calling-r-multiple-times-and-saving-and-restoring-the-r-workspace-sql-example

PROBLEM; For lab mouse 1 and lab mouse 2 find the dose date closest but before remission

THIS IS WHAT WE WANT total obs=2
       LAB        DOSE_     REMISSION   CLOSEST BEFORE
Obs    MOUSE      DATE         DATE      DOSE

 1       1      20220104     20220105     18
 2       2      20220103     20220104     19

CONTENTS
   1 Input
   2 Proc r save r workspace with inputs and configuartion variables.
      Note: This can save
            individual variables
             r dataframes and lists for later use, like a pemanent sas work library
   3 load workspace and solve
   4 updated utl_submit_r64x macro see
     https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

Related repos
https://github.com/rogerjdeangelis/utl-indentify-the-dose-and-dose-date-before-and-closest-to-remission-date-using-sas-r-python-sql
https://stackoverflow.com/questions/78990103/identify-value-in-one-dataset-whose-date-is-closest-to-a-date-in-another-dataset
https://github.com/rogerjdeangelis/utl-merging-inner-join-dataframes-based-on-single-primary-key-in-wps-r-python-sql-nosql

/*   _                   _
/ | (_)_ __  _ __  _   _| |_
| | | | `_ \| `_ \| | | | __|
| | | | | | | |_) | |_| | |_
|_| |_|_| |_| .__/ \__,_|\__|
            |_|
*/

libname workx "d:/wpswrkx";
libname workx sas7bdat "d:/wpswrkx";

/*--- DOSE DATES ---*/

options validvarname=upcase;

data workx.master;
 input mouse dose_date dose ;
cards4;
1 20220101 16
1 20220102 25
1 20220103 21
1 20220104 18
1 20220105 18
2 20220101 18
2 20220102 22
2 20220103 19
2 20220104 16
2 20220105 18
;;;;
run;quit;

/*--- REMISSION DATES ---*/

data workx.trans;
 input mouse remission;
cards4;
1 20220105
2 20220104
3 20220103
4 20220102
5 20220101
6 20220105
7 20220104
8 20220103
;;;;
run;quit;

/***************************************************************************************************************************/
/*        INPUTS                                                                                                           */
/*        =====                                                                                                            */
/* SD1.MASTER                                                                                                              */
/*                                                                                                                         */
/* Obs   MOUSE  DOSE_DATE DOSE                                                                                             */
/*                                                                                                                         */
/*   1     1    20220101   16                                                                                              */
/*   2     1    20220102   25                                                                                              */
/*   3     1    20220103   21                                                                                              */
/*   4     1    20220104   18                                                                                              */
/*   5     1    20220105   18                                                                                              */
/*   6     2    20220101   18                                                                                              */
/*   7     2    20220102   22                                                                                              */
/*   8     2    20220103   19                                                                                              */
/*   9     2    20220104   16                                                                                              */
/*  10     2    20220105   18                                                                                              */
/*                                                                                                                         */
/* SD1.TRANS total obs=8                                                                                                   */
/*                                                                                                                         */
/* Obs   MOUSE  REMISSION                                                                                                  */
/*                                                                                                                         */
/*  1      1    20220105                                                                                                   */
/*  2      2    20220104                                                                                                   */
/*  3      3    20220103                                                                                                   */
/*  4      4    20220102                                                                                                   */
/*  5      5    20220101                                                                                                   */
/*  6      6    20220105                                                                                                   */
/*  7      7    20220104                                                                                                   */
/*  8      8    20220103                                                                                                   */
/*                                                                                                                         */
/***************************************************************************************************************************/

/*___                                                  _
|___ \   ___  __ ___   _____   _ ____      _____  _ __| | __
  __) | / __|/ _` \ \ / / _ \ | `__\ \ /\ / / _ \| `__| |/ /
 / __/  \__ \ (_| |\ V /  __/ | |   \ V  V / (_) | |  |   <
|_____| |___/\__,_| \_/ \___| |_|    \_/\_/ \___/|_|  |_|\_\

*/

%symdel
   protocol
   statplan
   date
   closedate;

%utlfkil(d:/rda/rwork.rdata);

%let protocol = M0123 Mouse Remission;
%let statplan = M0123 Statistical Plan;
%let date     = Stomach Cancer;
%let closedate= 20260710;

/*--- you cannot use double quotes in your r script. Use bactics ---*/
/*--- double quotes are used in the macro                        ---*/

%slc_submit_r64x(
    '
    library(haven);

    master<-read_sas(`d:/wpswrkx/master.sas7bdat`);
    trans<-read_sas (`d:/wpswrkx/trans.sas7bdat`);

    print(trans);

    protocol  <- `&protocol`;
    statplan  <- `&statplan`;
    date      <- `&date`;
    closedate <- `&closedate`;

    print(closedate);

    ls();
    save.image(`d:/rda/rwork.rdata`);
   '
   ,resolve=Y
    );

/**************************************************************************************************************************/
/*  Altair SLC                                                                                                            */
/* LIST: 14:14:40                                                                                                         */
/*                                                                                                                        */
/* R SCRIPT                                                                                                               */
/* > library(haven);                                                                                                      */
/*   master<-read_sas('d:/wpswrkx/master.sas7bdat');                                                                      */
/*   trans<-read_sas ('d:/wpswrkx/trans.sas7bdat');                                                                       */
/*   print(trans);                                                                                                        */
/*   protocol  <- 'M0123 Mouse Remission';                                                                                */
/*   statplan  <- 'M0123 Statistical Plan';                                                                               */
/*   date      <- 'Stomach Cancer';                                                                                       */
/*   closedate <- '20260710';                                                                                             */
/*   print(closedate);                                                                                                    */
/*   ls();                                                                                                                */
/*   save.image('d:/rda/rwork.rdata');                                                                                    */
/*                                                                                                                        */
/* MASTER DATAFRAME                                                                                                       */
/* # A tibble: 8 Ã— 2                                                                                                     */
/*   MOUSE REMISSION                                                                                                      */
/*   <dbl>     <dbl>                                                                                                      */
/* 1     1  20220105                                                                                                      */
/* 2     2  20220104                                                                                                      */
/* 3     3  20220103                                                                                                      */
/* 4     4  20220102                                                                                                      */
/* 5     5  20220101                                                                                                      */
/* 6     6  20220105                                                                                                      */
/* 7     7  20220104                                                                                                      */
/* 8     8  20220103                                                                                                      */
/*                                                                                                                        */
/* [1] "20260710"                                                                                                         */
/*                                                                                                                        */
/* All objects in workspace (saved)                                                                                       */
/* [1] "closedate" "date"      "master"    "protocol"  "statplan"  "trans"                                                */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC           14:24 Friday, July 10, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library wpdx assigned as follows:
      Engine:        WPD
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp


LOG:  14:24:27
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.031
      cpu time  : 0.000


NOTE: Format num2mis output
NOTE: Format $chr2mis output
NOTE: Procedure format step took :
      real time : 0.000
      cpu time  : 0.015


NOTE: AUTOEXEC processing completed

1         %symdel
2            protocol
3            statplan
4            date
5            closedate;
WARNING: Attempt to delete macro variable protocol failed. No global variable of that name
WARNING: Attempt to delete macro variable statplan failed. No global variable of that name
WARNING: Attempt to delete macro variable date failed. No global variable of that name
WARNING: Attempt to delete macro variable closedate failed. No global variable of that name
6
7         %utlfkil(d:/rda/rwork.rdata);
8
9         %let protocol = M0123 Mouse Remission;
10        %let statplan = M0123 Statistical Plan;
11        %let date     = Stomach Cancer;
12        %let closedate= 20260710;
13
14        /*--- you cannot use double quotes in your r script. Use bactics ---*/
15        /*--- double quotes are used in the macro                        ---*/
16
17        %slc_submit_r64x(
18            '
19            library(haven);
20
21            master<-read_sas(`d:/wpswrkx/master.sas7bdat`);
22            trans<-read_sas (`d:/wpswrkx/trans.sas7bdat`);
23
24            print(trans);
25
26            protocol  <- `&protocol`;
27            statplan  <- `&statplan`;
28            date      <- `&date`;
29            closedate <- `&closedate`;
30
31            print(closedate);
32
33            ls();
34            save.image(`d:/rda/rwork.rdata`);
35           '
36           ,resolve=Y
37            );

NOTE: The file _clp is:
      Clipboard

NOTE: 1 record was written to file _clp
      The minimum record length was 1
      The maximum record length was 1
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000



NOTE: The file r_pgm is:
      Filename='c:\temp\r_pgm.txt',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=13:58:19 Jul 10 2026,
      Last Accessed=14:24:26 Jul 10 2026,
      Last Modified=14:24:26 Jul 10 2026,
      Lrecl=32766, Recfm=V

library(haven);
master<-read_sas('d:/wpswrkx/master.sas7bdat');
trans<-read_sas ('d:/wpswrkx/trans.sas7bdat');
print(trans);
protocol  <- 'M0123 Mouse Remission';
statplan  <- 'M0123 Statistical Plan';
date      <- 'Stomach Cancer';    c
losedate <- '20260710';
print(closedate);    ls();
save.image('d:/rda/rwork.rdata');

NOTE: 1 record was written to file r_pgm
      The minimum record length was 345
      The maximum record length was 345
NOTE: The data step took :
      real time : 0.004
      cpu time  : 0.015

NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=C:\Progra~1\R\R-4.5.2\bin\r.exe --vanilla --quiet --no-save < c:/temp/r_pgm.txt,
      Lrecl=32756, Recfm=V

NOTE: 16 records were written to file PRINT

NOTE: 15 records were read from file rut
      The minimum record length was 2
      The maximum record length was 347
NOTE: The data step took :
      real time : 1.180
      cpu time  : 0.000

NOTE: Submitted statements took :
      real time : 1.345
      cpu time  : 0.109


/*____   _                 _                            _
|___ /  | | ___   __ _  __| |  _ __ __      _____  _ __| | _____ _ __   __ _  ___ ___
  |_ \  | |/ _ \ / _` |/ _` | | `__|\ \ /\ / / _ \| `__| |/ / __| `_ \ / _` |/ __/ _ \
 ___) | | | (_) | (_| | (_| | | |    \ V  V / (_) | |  |   <\__ \ |_) | (_| | (_|  __/
|____/  |_|\___/ \__,_|\__,_| |_|     \_/\_/ \___/|_|  |_|\_\___/ .__/ \__,_|\___\___|
                                                                |_|
*/

options validvarname=v7;
options set=RHOME "C:\Progra~1\R\R-4.5.2\bin\r";
proc r;
submit;

library(sqldf);
load("d:/rda/rwork.rdata")
ls()

cat("\n","protocol", protocol  ,"\n")
cat("statplan", statplan  ,"\n")
cat("date",     date      ,"\n")
cat("closedate",closedate ,"\n")

want<-sqldf('
  select
     l.mouse        as mouse
    ,l.dose_date    as dose_date
    ,r.remission    as remission
    ,l.dose
  from
    master as l left join trans as r
  on
             l.mouse     = r.mouse
        and  l.dose_date < r.remission
  group
    by r.mouse
  having
    (r.remission-l.dose_date)
       = min(r.remission-l.dose_date)
  ');

want;

endsubmit;
import data=workx.want r=want;
run;



/**************************************************************************************************************************/
/* R                                                                 | SLC                                                */
/* LIST: 14:27:10                                                    |                                                    */
/*                                                                   |   Up to 40 obs from WORKX.WANT total obs=2 10JU    */
/* Altair SLC                                                        |                     dose_                          */
/* WORKSPACE OBJECTS                                                 |   Obs    mouse      date      remission    DOSE    */
/* [1] "closedate" "date" "master" "protocol" "statplan" "trans" */  |                                                    */
/*                                                                   |    1       1      20220104     20220105     18     */
/* protocol M0123 Mouse Remission                                    |    2       2      20220103     20220104     19     */
/* statplan M0123 Statistical Plan                                   |                                                    */
/* date Stomach Cancer                                               |                                                    */
/* closedate 20260710                                                |                                                    */
/*                                                                   |                                                    */
/*   mouse dose_date remission DOSE                                  |                                                    */
/* 1     1  20220104  20220105   18                                  |                                                    */
/* 2     2  20220103  20220104   19                                  |                                                    */
/**************************************************************************************************************************/
 

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
