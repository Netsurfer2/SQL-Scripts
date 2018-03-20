
/*
I'm currently trying to build logic that will independently
total each day of the week for the current week given the day
the report is run. I need to figure out how to build a query
to aggregate each day (and the total weekly sum) as separate columns.
*/

;WITH cte AS (
    SELECT
       DATENAME(dw,releasetime) as DayOfWeekName
       ,COUNT(*) OVER () as TotalCount
    FROM
       @release
    WHERE
       releasetime >= DATEADD(DAY,- DATEPART(dw,GETDATE()) +
	                            1,CAST(GETDATE() AS DATE)) 
       AND releasetime < DATEADD(DAY,7 - DATEPART(dw,GETDATE()) +
	                                 1,CAST(GETDATE() AS DATE))
)

SELECT *
FROM
    cte
    PIVOT (
       COUNT(DayOfWeekName)
       FOR DayOfWeekName IN (Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday)
    ) p


/*
I have this table:

id  ID  Date    Cumulative
--------------------------
1   x   Jan-10      10
3   x   Feb-10      40
7   x   Apr-10      60
9   x   May-10     100
2   y   Jan-10      20
6   y   Mar-10      40
8   y   Apr-10      60
10  y   May-10     100
I need to Reverse the "Cumulative" in MS SQL Server Query to be as the following

id  ID  Date    Cumulative  Reversed
------------------------------------
1   x   Jan-10      10        10
3   x   Feb-10      40        30
7   x   Apr-10      60        20
9   x   May-10     100        40
2   y   Jan-10      20        20
6   y   Mar-10      40        20
8   y   Apr-10      60        20
10  y   May-10     100        40
Note: query is for SQL Server 2012
*/

/*
For below Sql server 2012 using recursive CTE for reverse running total.
*/

declare @t table(id int,IDs varchar(20),Dates varchar(20),Cumulative int)
insert into @t values
(1,'x','Jan-10',  10)
,(3,'x','Feb-10',  40)
,(7,'x','Apr-10',  60)
,(9,'x','May-10', 100)
,(2,'y','Jan-10',  20)
,(6,'y','Mar-10',  40)
,(8,'y','Apr-10',  60)
,(10,'y','May-10',100)

;With CTE as
(select *,row_number()over(partition by ids order by id)rn 
from @t
)
,CTE1 as
(select id,ids,dates, Cumulative,rn,Cumulative Reversed 
from cte where rn=1
union all
select c.id,c.ids,c.Dates,c.Cumulative,c.rn 
,c.Cumulative-c1.Cumulative
from cte c
inner join cte c1 on c.ids=c1.ids
where c.rn=c1.rn+1
)
select * from cte1


/*
You can use lag to get the value in the previous row and
subtract from the current row's value to get the reversed value.
*/
select t.*, cumulative - coalesce(lag(cumulative) over(partition by id order by date),0) as reversed
from tablename t

/*
From @Gordon Linoff's comment.. you can use lag(cumulative,1,0) instead of coalesce.
*/
select t.*, cumulative-lag(cumulative,1,0) over(partition by id order by date) as reversed
from tablename t