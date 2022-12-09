select * from project.dbo.data1;

select*from project.dbo.data2;

 -- number of columns into dataset

 select count(*) from project. .data1;
 select COUNT(*) from project. .data2;

-- dataset for jharkhand and bihar

select * from project ..data1 where state in ('jharkhand','bihar');

-- population of india

select sum(population) as population from project..data1;

--avg growth]

select avg(growth) as avg_growth from project. .data2;


select state,avg(growth)*100  avg_growth from project. .data2 group by state;


select state,round (avg(sex_ratio),0) avg_sex_ratio from project. .data2 group by state;
select state,round (avg(sex_ratio),0) avg_sex_ratio from project. .data2 group by state order by avg_sex_ratio desc;



--avg literacy rate
select state,round (avg(literacy),0) avg_literacy_ratio from project. .data2 
group by state;

select state,round (avg(literacy),0) avg_literacy_ratio from project. .data2
group by state order by avg_literacy_ratio desc;

--order of query is important having should get prioritybthan the desc

select state,round (avg(literacy),0) avg_literacy_ratio from project. .data2
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc;

--top 3 states showing highest growth ratio


select top 3 state,avg(growth)*100 avg_growth from project. .data2
group by state order by avg_growth desc;

--bottom 3 states showing lowest  sex ratio

select top 3 state,round (avg(sex_ratio),0) avg_sex_ratio from project. .data2
group by state order by avg_sex_ratio asc;

--top and bottom 3 states in the literacy state
drop table if exists #topstate;
create table #topstate
(
state nvarchar(225),
topstate float
)
insert into #topstate
select  state,round (avg(Literacy),0) avg_Literacy_ratio from project. .data2
group by state order by avg_Literacy_ratio desc;
 
 select top 3 *from #topstate order by #topstate.topstate desc;
 
 --bootom states

 drop table if exists #bottomstate;
create table #bottomstate
(
state nvarchar(225),
bottomstate float
)
insert into #bottomstate
select  state,round (avg(Literacy),0) avg_Literacy_ratio from project. .data2
group by state order by avg_Literacy_ratio asc;
 
 select top 3 *from #bottomstate order by #bottomstate.bottomstate asc;

 --unionn operator

 select* from(

 select top 3 *from #topstate order by #topstate.topstate desc) a
 union
 select* from (
 select top 3 *from #bottomstate order by #bottomstate.bottomstate asc) b;

 --states starting with letter a

 select distinct  state from project. .data1 where lower(state) like'a%' or lower(state) like'a%' or lower(state) like'b%'

 select distinct  state from project. .data1 where lower(state) like'a%' or lower(state) like'a%' and lower(state) like'b%'

--joinin the table

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project..data2 a inner join project..data1 b on a.district=b.district ) c) d
group by d.state;

-- total literacy rate


select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from project..data2 a 
inner join project..data1 b on a.district=b.district) d) c
group by c.state

-- population in previous census


select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from project..data2 a inner join project..data1 b on a.district=b.district) d) e
group by e.state)m


