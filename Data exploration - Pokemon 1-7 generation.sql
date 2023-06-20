/*
Pokemon 1st - 7th generation Data Exploration

Skills Used: Windows Functions, Aggreagate Functions, UNION Function, Creating Views, Converting Data Types

-- A Pokedex is pokemon encyclopedia that is an electronic device created to store 
and provide information from a database on various species in Pokemon (Up until 7th generation).--

*/

-- Retrive all columns of the 'Pokedex' Table --

Select *
From Pokedex

-- Data Cleaning -- Standardizing the data from large float values into 2 decimal points --

Alter Table Pokedex
Alter Column height_m decimal(10,2) 

Alter Table Pokedex
Alter Column percentage_male decimal(10,2) 

Alter Table Pokedex
Alter Column weight_kg decimal(10,2) 

--Data Exploration, the pokemon dataset--

-- What is the tallest pokemon? -- 

Select top 1 name, height_m
From Pokedex 
Order by height_m DESC

--Is there a strong correlation with weight of pokemon and its attack stat --

Select name, weight_kg, attack
From Pokedex
Order by weight_kg DESC 

-- How many 2 elemental Types in the 1,2,3 Generation of Pokemon--

Select Count(type2) as 'Number of Pokemon Generation 1,2,3'
From pokedex
Where generation IN (1,2,3) 

--The number of types classfied pokemon -- 

Select classfication, count(classfication) AS 'Number of Classification'
From Pokedex
Group by classfication 
Order by 'Number of Classification' DESC 

-- What is the Rarest combination of 'elemental' types -

Select TOP 5 type1, type2, COUNT(type1)+COUNT(type2) as '# of Pokemon'
From Pokedex
Group by type1, type2 
Order BY '# of Pokemon' 

-- What pokemon is the easiet to train -- 

Select name, experience_growth
From Pokedex
Order by experience_growth DESC

-- How Many Pokemon Are in Each Generation -- 

Select generation, Count(generation) AS 'Number of Pokemon'
From Pokedex
Group by generation 
Order by generation  


-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Making the Best Pokemon team>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> -- 

-- Removal of data

/* Who has the worst elemental weakness to types - What pokemon and types combinations to avoid?
(Higher the overall number indicates the pokemon is more subceptiable to elemental) */ 

Select name, type1, type2, SUM(against_bug) + SUM(against_dark) + SUM(against_dragon) + SUM(against_electric) + SUM(against_fairy) + SUM(against_fight) + SUM(against_fire) + SUM(against_flying) + SUM(against_ghost) + SUM(against_grass) + SUM(against_ground) + SUM(against_ice) + SUM(against_normal) + SUM(against_poison) + SUM(against_psychic) + SUM(against_rock) + SUM(against_steel) + SUM(against_fairy) + SUM(against_water) AS 'Weakness Exposure' 
From Pokedex
Group by name, type1, type2
Order by 'Weakness Exposure' DESC

/* Who has the best elemental resistances to types. 
(Lower the overall number indicates the pokemon is more subceptiable to elemental) */ 

Select name, type1, type2, SUM(against_bug) + SUM(against_dark) + SUM(against_dragon) + SUM(against_electric) + SUM(against_fairy) + SUM(against_fight) + SUM(against_fire) + SUM(against_flying) + SUM(against_ghost) + SUM(against_grass) + SUM(against_ground) + SUM(against_ice) + SUM(against_normal) + SUM(against_poison) + SUM(against_psychic) + SUM(against_rock) + SUM(against_steel) + SUM(against_fairy) + SUM(against_water) AS 'Weakness Exposure' 
From Pokedex
Group by name, type1, type2
Order by 'Weakness Exposure' 

-- What pokemon are both Steel and Fairy Type Pokemon for the best combination of pokemon types.

Select name, type1, type2
From Pokedex
Where (type1 = 'steel' AND type2 = 'fairy') OR (type1 = 'fairy' AND type2 = 'steel') 
Order by name

-- Seacrch for Deseriable Strong Innate Abilites - Intimidate, Protean & Pure Power -- 

Select name, type1, type2, abilities, hp, attack, sp_attack, defense, sp_defense, speed
From pokedex
Where abilities like '%intimidate%' 
Union
Select name, type1, type2, abilities, hp, attack, sp_attack, defense, sp_defense, speed
From pokedex
Where abilities like '%protean%'
Union
Select name, type1, type2, abilities, hp, attack, sp_attack, defense, sp_defense, speed
From pokedex
Where abilities like '%Pure Power%'

--Choosing an ideal pokemon from the data - Having a strong base total greater than 130, fairy & steel type with intimidate ability

Select *
From Pokedex
Where base_total > 130 AND abilities like '%intimidate%' AND ((type1 = 'steel' AND type2 = 'fairy') OR (type1 = 'fairy' AND type2 = 'steel')) 


-- Creating View to store data for later visualizations -- 
Create View Pokemon_Stats AS
Select name, hp, attack, sp_attack, defense, sp_defense, speed, base_total
From Pokedex









