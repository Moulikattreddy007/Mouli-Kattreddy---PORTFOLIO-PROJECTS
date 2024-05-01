select *
from [portfolio project]..coviddeaths$
where continent is not null
order by 3,4


--select *
--from [portfolio project]..covidvaccinations$
--order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from [portfolio project]..coviddeaths$
order by 1,2

--Looking at Total cases vs Total deaths



select location, date, total_cases,  total_deaths, (total_deaths/total_cases) *100 As deathpercentage
from [portfolio project]..coviddeaths$
--where location like '%canada%'
order by 1,2


select location, date, total_cases,  total_deaths, (total_deaths/total_cases) *100 As deathpercentage
from [portfolio project]..coviddeaths$
where location like '%India'
order by 1,2


--Looking at total cases vs population
this shows waht percentage of population got infected with covid



select location, date, population, total_cases,  (total_cases/population) *100 As deathpercentage
from [portfolio project]..coviddeaths$
--where location like '%canada%'
order by 1,2


--looking at countries with highest infection rate compared to population


select location, population,MAX(total_cases) AS highestinfectedcount,  MAX(total_cases/population) *100 As percentpopulationinfected
from [portfolio project]..coviddeaths$
--where location like '%canada%'
Group by location , population
order by percentpopulationinfected desc



--showing the countries highest death count per population



select location, MAX(cast(total_deaths as int)) AS TotalDeaths 
from [portfolio project]..coviddeaths$
--where location like '%canada%'
where continent is not null
Group by location
order by TotalDeaths desc


--lets see the data by continent

--showing continents with highest deaths

select continent, MAX(cast(total_deaths as int)) AS TotalDeaths 
from [portfolio project]..coviddeaths$
--where location like '%canada%'
where continent is not null
Group by continent
order by TotalDeaths desc


--GLOBAL NUMBERS


select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases) * 100 As deathpercentage
from [portfolio project]..coviddeaths$
--where location like '%canada%'
where continent is not null
group by date 
order by 1,2



select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases) * 100 As deathpercentage
from [portfolio project]..coviddeaths$
--where location like '%canada%'
where continent is not null
--group by date 
order by 1,2





select * 
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date


--looking at total population vs vaccinations


--using cte

with PopvsVac (continent, location, date, population, new_vaccinations, rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(CONVERT(INT, vac.new_vaccinations )) over(partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (rollingpeoplevaccinated/population) * 100
from PopvsVac


--TEMP TABLE


Drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(coalesce(CONVERT(BIGINT, vac.new_vaccinations), 0 )) over(partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * , (rollingpeoplevaccinated/population) * 100
from #percentpopulationvaccinated








creating view to store data for later visualizations

create view percentpeoplevaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(coalesce(CONVERT(BIGINT, vac.new_vaccinations), 0 )) over(partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from [portfolio project]..coviddeaths$ dea
join [portfolio project]..covidvaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from percentpeoplevaccinated

















