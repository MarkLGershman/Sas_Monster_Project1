/* MONSTER PROJECT BEGINNING. left join, stratified random sampling. Dupout is always duprecord*/
proc sort data=mar.birth 
out=mar.birthdeath
dupout=mar.duprecord 
nodup;
by crid;
run;

proc sort data=mar.death
out=mar.birthdeath1
dupout=mar.duprecord
nodup;
by crid;
run;

/* area has treatment and comparison. comparison is 5 and treatment is 2-5 */
data mar.Treatment;
set mar.birthdeath;
where area <=4;
run;

data mar.Comparison;
set mar.birthdeath;
where area =5;
run;

/* take the treatment file and do simple random sampling on data set. */

data mar.birthsampletreat;
n=1;
P=2509;
/*2509 divided by the full data set (6458. Gives you percentage. Then multiply by 650) */
do while (n <=253);
Slice=int(P*ranuni(-1));
set mar.Treatment point=slice;
output;
n=n+1;
end;
stop;
run;

data mar.birthsamplecomp;
n=1;
P=3949;
do while (n <=397);
Slice=int(P*ranuni(-1));
set mar.Comparison point=slice;
output;
n=n+1;
end;
stop;
run;

/* 	merge the combined files and check to see if 650 */
data mar.birthmerge;
set mar.Birthsamplecomp mar.Birthsampletreat;
run;

proc SQL;
create table mar.joined_birth	as
select * from mar.birthmerge left join mar.birthdeath1
on birthmerge.crid=birthdeath1.crid;
quit;
