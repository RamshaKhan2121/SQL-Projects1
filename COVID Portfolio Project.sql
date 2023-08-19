--Sort data based on location
SELECT location,date,total_cases, new_cases,total_deaths, population
FROM table1
WHERE continent IS NOT NULL 
order by 1,2

-- Looing at Total Cases vs Total Deaths in India
-- Shows likelihood of dying if you contract covid in your country
SELECT location,date,total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) AS DeathPercentage
FROM table1 
WHERE location like '%India'
ORDER by 1,2

-- Looing at total Cases vs Population
-- Shows what Percentage of people in India have got Covid
SELECT location,date, population,total_cases, Round((total_cases/population)*100,4) as Cases_Percentage
FROM table1
WHERE location like '%India%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population,MAX(total_cases) AS highest_infection_count,MAX((total_cases/population))*100 as percent_population_infected
FROM table1
--WHERE location like '%India
GROUP BY location, population
ORDER BY Percent_Population_Infected DESC

-- Showing the countries with highest death count
SELECT location, MAX(total_deaths) as Totaldeathcount
FROM table1
WHERE continent is not null 
GROUP BY location
ORDER BY Totaldeathcount DESC

-- Continents 
-- Showing continents with highest death count per population 
SELECT continent, MAX(total_deaths) as Totaldeathcount
FROM table1
WHERE continent is not null 
GROUP BY continent
ORDER BY Totaldeathcount DESC

-- Break  Global numbers 
SELECT date,SUM(new_cases)AS Total_cases,SUM(new_deaths) as Total_deaths,
SUM(new_deaths)/SUM(new_cases)*100 AS Death_Percentage
FROM table1 
WHERE continent is not null 
GROUP by date
ORDER by 1,2

-- Let's look at Total Vaccinations Table - Table2
-- JOIN Table1(covid_deaths) and Table2(covid_vaccinations)
SELECT * FROM table1
JOIN table2 
ON table1.location = table2.location
and table1.date = table2.date

--Total Population vs Vaccination 
SELECT table1.continent, table1.location, table1.date, table1.population, table2.new_vaccinations
FROM table1
JOIN table2 
ON table1.location = table2.location
and table1.date = table2.date
WHERE table1.continent is not null 
ORDER BY 2,3

--Total Vaccinations Per Day using Partition By
SELECT table1.continent, table1.location, table1.date, table1.population, table2.new_vaccinations,
SUM(table2.new_vaccinations) OVER (Partition by table1.location, table1.date)as RollingPeopleVaccinated
FROM table1
JOIN table2 
ON table1.location = table2.location
and table1.date = table2.date
WHERE table1.continent is not null 
ORDER BY 2,3

--Check Total Population vs People Vaccinated
SELECT table1.continent, table1.location, table1.date, table1.population, table2.new_vaccinations,
SUM(table2.new_vaccinations) OVER (Partition by table1.location, table1.date)as RollingPeopleVaccinated
FROM table1
JOIN table2 
ON table1.location = table2.location
and table1.date = table2.date
WHERE table1.continent is not null 
ORDER BY 2,3

-- CREATE VIEW 
CREATE VIEW PopvsVac 
AS 
SELECT table1.continent, table1.location, table1.date, table1.population, table2.new_vaccinations,
SUM(table2.new_vaccinations) OVER (Partition by table1.location, table1.date)as RollingPeopleVaccinated
FROM table1
JOIN table2 
ON table1.location = table2.location
and table1.date = table2.date
WHERE table1.continent is not null




SELECT *, (RollingPeopleVaccinated)/(population)*100 FROM popvsvac

--TEMP TABLE 
CREATE TABLE population_vaccinated (
continent varchar(255),
lacation varchar(255),
date date,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)
INSERT INTO population_vaccinated
SELECT table1.continent, table1.location, table1.date, table1.population, table2.new_vaccinations,
SUM(table2.new_vaccinations) OVER (Partition by table1.location, table1.date)as RollingPeopleVaccinated
FROM table1
JOIN table2 
ON table1.location = table2.location
and table1.date = table2.date
WHERE table1.continent is not null 



 








































