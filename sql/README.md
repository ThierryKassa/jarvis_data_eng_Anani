# Introduction
This SQL project  is for a newly created country club, with a set of members, facilities such as tennis courts, and booking history for those facilities. Amongst other things, the club wants to understand how they can use their information to analyse facility usage/demand. 
The following tables are created in database named "sql_exercices" through PostgreSQL instance using docker.  

# SQL Queries

###### Table Setup (DDL)

```sql
CREATE TABLE cd.members(
  memid INT NOT NULL,
  surname VARCHAR (200) NOT NULL,
  firstname VARCHAR (200) NOT NULL,
  address VARCHAR (300) NOT NULL,
  zipcode INT NOT NULL,
  telephone VARCHAR (20) NOT NULL,
  recommendedby INT,
  joindate timestamp NOT NULL,
  CONSTRAINT members_pk PRIMARY KEY (memid),
  CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby) REFERENCES cd.members(memid) ON DELETE
  SET
    NULL
);
```

```
CREATE TABLE cd.facilities (
  facid INT NOT NULL, 
  name VARCHAR (100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL, 
  CONSTRAINT facilities_pk PRIMARY KEY (facid)
);
```

```
CREATE TABLE cd.bookings (
  bookid INT NOT NULL, 
  facid INT NOT NULL, 
  memid INT NOT NULL, 
  starttime timestamp NOT NULL, 
  slots INT NOT NULL, 
  CONSTRAINT bookings_pk PRIMARY KEY (bookid), 
  CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid), 
  CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
```
###### Question 1: The club is adding a new facility - a spa.
We need to add it into the facilities table. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

###### Solution 1:
```
INSERT INTO cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
VALUES 
  (9, 'Spa', 20, 30, 100000, 800);
```
###### Question 2: Let's try adding the spa to the facilities table again.
This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

###### Solution 2:
```
insert into cd.facilities (
  facid, name, membercost, guestcost, 
  initialoutlay, monthlymaintenance
) 
select 
  (
    select 
      max(facid) 
    from 
      cd.facilities
  )+ 1, 
  'Spa', 
  20, 
  30, 
  100000, 
  800;
```
###### Discussion 2:
This sql could not need to exist by simply change the type of `facid` into 'SERIAL' instead of 'INT'. Doing so, the column `facid` will be generated automatically whenever we insert a new data in the facilities table.

###### Question 3: We want to alter the price of the second tennis court so that it costs 10% more than the first one. 
Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.

###### Solution 3:
```
UPDATE 
  cd.facilities 
SET 
  membercost =(
    select 
      membercost * 1.1 
    from 
      cd.facilities 
    where 
      facid = 0
  ), 
  guestcost =(
    select 
      guestcost * 1.1 
    from 
      cd.facilities 
    where 
      facid = 0
  ) 
WHERE 
  facid = 1;
 ```
###### Question 4: Produce a count of the number of recommendations each member has made. Order by member ID.

###### Solution 4:
```
select 
  recommendedby, 
  COUNT(memid) AS count 
from 
  cd.members 
where 
  recommendedby is not null 
group by 
  recommendedby 
order by 
  recommendedby;
```

###### Question 5: Produce a list of the total number of slots booked per facility per month in the year of 2012. Produce an output table consisting of facility id and slots, sorted by the id and month.

###### Solution 5:
```
select 
  facid, 
  extract(
    month 
    from 
      starttime
  ) as month, 
  sum(slots) AS "Total Slots" 
From 
  cd.bookings 
where 
  extract (
    year 
    from 
      starttime
  )= 2012 
Group by 
  facid, 
  month 
Order by 
  facid, 
  month;

```
###### Discussion 5:
The `EXTRACT` function for the date is very useful and helps to use the sub-part of date we want to manipulate.

###### Question 6: Produce a list of each member name, id, and their first booking after September 1st 2012. Order by member ID.

###### Solution 6:
```
select 
  mem.surname, 
  mem.firstname, 
  mem.memid, 
  min(bks.starttime) as starttime 
from 
  cd.members mem 
  inner join cd.bookings bks on mem.memid = bks.memid 
where 
  starttime > '2012-09-01' 
group by 
  mem.surname, 
  mem.firstname, 
  mem.memid 
order by 
  mem.memid;

```
###### Discussion 6:
This query need to be break in small pieces for better understanding.
>1- List of each member using the attribute surname, firstname, memid
>2- Their first booking after September 1st 2012 means not only the booking after September 1st but the first which is equavalent to the use of the function `min()`
>3- It is important to group by the attributes since there is an order by member ID.

###### Question 7: Output the facility id that has the highest number of slots booked. Ensure that in the event of a tie, all tieing results get output.

###### Solution 7:
```
select 
  facid, 
  sum(slots) as total 
from 
  cd.bookings 
group by 
  facid 
having 
  sum(slots) = (
    select 
      max(sum2.secondtotal) 
    from 
      (
        select 
          sum(slots) as secondtotal 
        from 
          cd.bookings 
        group by 
          facid
      ) as sum2
  );

```
###### Discussion 7:
The above solution can be improved by using windows function, with less nested subqueries.

```
select 
  facid, 
  total 
from 
  (
    select 
      facid, 
      sum(slots) total, 
      rank() over (
        order by 
          sum(slots) desc
      ) rank 
    from 
      cd.bookings 
    group by 
      facid
  ) as ranked 
where 
  rank = 1
```
