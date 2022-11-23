# PortfolioProjects

--Covid Project

SELECT *
FROM PortfolioProject_1..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4


SELECT *
FROM PortfolioProject_1..CovidVaccinations
ORDER BY 3,4

SELECT location, date, total_cases, total_deaths, population
FROM PortfolioProject_1..CovidDeaths
ORDER BY 1, 2

--Total Cases vs Total Deaths
--Percentage of deaths by Country

SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject_1..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2

--Total Cases vs Population in United State
--Percentage of US population infected

SELECT location, date, population, total_cases, 
(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject_1..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2

--Countrry's with highest infection rate

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject_1..CovidDeaths
--WHERE location LIKE '%states%'
GROUP BY location, population
ORDER BY PercentPopulationInfected Desc

--Countries with Highest Death Count per Population

SELECT location, MAX(CAST(total_deaths AS int)) AS HighestDeathCount
FROM PortfolioProject_1..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY HighestDeathCount  Desc


SELECT continent, MAX(CAST(total_deaths AS int)) AS HighestDeathCount
FROM PortfolioProject_1..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY HighestDeathCount  Desc


SELECT location, MAX(CAST(total_deaths AS int)) AS HighestDeathCount
FROM PortfolioProject_1..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeathCount  Desc

-- Global Numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject_1..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_deaths, 
SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject_1..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2

--Total Population vs Vaccinations

SELECT*
FROM PortfolioProject_1..CovidDeaths dea
JOIN PortfolioProject_1..CovidVaccinations vac
ON  dea.location =vac.location
AND dea.date = vac.date

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_vaccinations
--(rolling_vaccinations/population)*100
FROM PortfolioProject_1..CovidDeaths dea
JOIN PortfolioProject_1..CovidVaccinations vac
ON  dea.location =vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3

--CTE
WITH PopVsVac (Continent, Location, Date, Population, new_vaccinations,
rolling_vaccinations) AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_vaccinations
--(rolling_vaccinations/population)*100
FROM PortfolioProject_1..CovidDeaths dea
JOIN PortfolioProject_1..CovidVaccinations vac
ON  dea.location =vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3
)
SELECT *, (rolling_vaccinations/population)*100 AS vaccination_percentage_population
FROM PopVsVac

--Temp Table
DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_vaccinations numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_vaccinations
--(rolling_vaccinations/population)*100
FROM PortfolioProject_1..CovidDeaths dea
JOIN PortfolioProject_1..CovidVaccinations vac
ON  dea.location =vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

SELECT *,(rolling_vaccinations/population)*100 
FROM #PercentPopulationVaccinated

--Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) AS rolling_vaccinations
--(rolling_vaccinations/population)*100
FROM PortfolioProject_1..CovidDeaths dea
JOIN PortfolioProject_1..CovidVaccinations vac
ON  dea.location =vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2, 3

SELECT *
FROM PercentPopulationVaccinated
















