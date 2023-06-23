\c sql_exercices
CREATE SCHEMA cd;

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

CREATE TABLE cd.facilities (
  facid INT NOT NULL, 
  name VARCHAR (100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL, 
  CONSTRAINT facilities_pk PRIMARY KEY (facid)
);

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

--INSERT INTO cd.members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) VALUES
--(0, 'GUEST', 'GUEST', 'GUEST', 0, '(000) 000-0000', NULL, '2012-07-01 00:00:00'),
--(1, 'Smith', 'Darren', '8 Bloomsbury Close, Boston', 4321, '555-555-5555', NULL, '2012-07-02 12:02:05'),
--(2, 'Smith', 'Tracy', '8 Bloomsbury Close, New York', 4321, '555-555-5555', NULL, '2012-07-02 12:08:23'),
--(3, 'Rownam', 'Tim', '23 Highway Way, Boston', 23423, '(844) 693-0723', NULL, '2012-07-03 09:32:15'),
--(4, 'Joplette', 'Janice', '20 Crossing Road, New York', 234, '(833) 942-4710', 1, '2012-07-03 10:25:05'),
--(5, 'Butters', 'Gerald', '1065 Huntingdon Avenue, Boston', 56754, '(844) 078-4130', 1, '2012-07-09 10:44:09');

--INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES
--(0, 'Tennis Court 1', 5, 25, 10000, 200),
--(1, 'Tennis Court 2', 5, 25, 8000, 200),
--(2, 'Badminton Court', 0, 15.5, 4000, 50),
--(3, 'Table Tennis', 0, 5, 320, 10),
--(4, 'Massage Room 1', 35, 80, 4000, 3000),
--(5, 'Massage Room 2', 35, 80, 4000, 3000);

--INSERT INTO cd.bookings (bookid, facid, memid, starttime, slots) VALUES
--(0, 3, 1, '2012-07-03 11:00:00', 2),
--(1, 4, 1, '2012-07-03 08:00:00', 2),
--(2, 2, 0, '2012-07-03 18:00:00', 2),
--(3, 5, 1, '2012-07-03 19:00:00', 2),
--(4, 2, 1, '2012-07-03 10:00:00', 1),
--(5, 5, 1, '2012-07-03 15:00:00', 1);

---Query1
INSERT INTO cd.facilities (
  facid, name, membercost, guestcost,
  initialoutlay, monthlymaintenance
)
VALUES
  (9, 'Spa', 20, 30, 100000, 800);

---Query2
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

---Query3
  select
    facid,
    SUM(slots) AS "Total Slots"
  From
    cd.bookings
  Group by
    facid
  Order by
    facid;

---Query4
select
  facid,
  sum(slots) AS "Total Slots"
From
  cd.bookings
where
  starttime >= '2012-09-01'
  and starttime < '2012-10-01'
Group by
  facid
Order by
  sum(slots);

 ---query5
 select
   count(distinct memid) as count
 from
   cd.bookings
 where
   facid is not null;

 ---query6 (window function)
 select
   (
     select
       count (*)
     from
       cd.members
   ) as count,
   firstname,
   surname
 from
   cd.members
 order by
   joindate;
---query7 (window function)
select
  count(*) over(
    order by
      joindate
  ),
  firstname,
  surname
from
  cd.members
order by
  joindate;