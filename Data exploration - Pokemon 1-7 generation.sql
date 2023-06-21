/*
Pokemon 1st - 7th generation Data Exploration

Skills Used: Windows Functions, Aggreagate Functions, UNION Function, Creating Views, Converting Data Types

-- A Pokedex is pokemon encyclopedia that is an electronic device created to store 
and provide information from a database on various species in Pokemon (Up until 7th generation).--

*/

-- Retrive all columns of the 'Pokedex' Table --

Select *
From Pokedex

-- Data Cleaning -- Standardizing the data from large float values into 2 decimal points and changing stat numbers from tinyint to int --

Alter Table Pokedex
Alter Column height_m decimal(10,2) 

Alter Table Pokedex
Alter Column percentage_male decimal(10,2) 

Alter Table Pokedex
Alter Column weight_kg decimal(10,2) 

Alter Table Pokedex
Alter Column hp int

Alter Table Pokedex
Alter Column attack int

Alter Table Pokedex
Alter Column sp_attack int

Alter Table Pokedex
Alter Column defense int

Alter Table Pokedex
Alter Column sp_defense int

Alter Table Pokedex
Alter Column speed int

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

-- First Pokemon Chosen - (Pokedex_number) 303 -- Mawile -- Best Type Resistances & Desired Ability 'intimidate'

--  Check for the Highest Attack Pokemon and check for legendaries (Legendaries are not allowed in some tournements)

Select pokedex_number, name, attack, type1, type2, is_legendary
From Pokedex
Where is_legendary = 0
Order by attack DESC

-- Second Choice Pokemon - (Pokedex_number) 214 -- Heracross

-- Highest base total pokemon --   

Select pokedex_number, name, base_total, type1, type2, is_legendary, abilities
From Pokedex
Where is_legendary = 0
Order by base_total DESC

--Thrid Pokemon -  (Pokedex_number) 248 -- 'Tyranitar' higher stats can contribute to best offense and defenses --

-- Looking for a Balance between Speical attack and speed with the ability of speed boost --

Select pokedex_number, name, type1, type2, abilities, hp, attack, sp_attack, defense, sp_defense, speed, is_legendary, (sp_attack+speed) as 'Overall sp_attack+speed'
From pokedex
Where abilities like '%speed boost%' and is_legendary = 0
Order by 'Overall sp_attack+speed' DESC 

-- Fourth Pokemon -  (Pokedex_number) 257 -- Blaziken -- 

-- Looking for a highly defensive pokemon, high hp, defense and sp_defense with low speed -- 

Select pokedex_number, name, type1, type2, abilities, hp, attack, sp_attack, defense, sp_defense, speed, is_legendary, (hp+defense+sp_defense) AS 'Overall Defensive Stats'
From pokedex
Where abilities like '%sturdy%' and is_legendary = 0
Order by 'Overall Defensive Stats' DESC 

-- Fifth pokemon - (Pokedex_number) 213 -- Shuckle

-- Fastest Pokemon with Prankster (Give priority to any status move used by pokemon)

Select pokedex_number, name, type1, type2, abilities, hp, attack, sp_attack, defense, sp_defense, speed, is_legendary
From Pokedex
Where abilities like '%prankster%' and is_legendary = 0
Order by speed DESC

-- The final Pokemon will be (Pokedex_number) 547 -- Whimsicott -- 

-- Retieve data on the perfect pokemon team -- 

select pokedex_number, name, abilities, type1, type2, hp, attack, sp_attack, defense, sp_defense, speed, generation, is_legendary 
From Pokedex
Where pokedex_number In (303, 214, 248, 257, 213, 547)
Order by pokedex_number

-- Retieve all data on the perfect pokemon team

select *
From Pokedex
Where pokedex_number In (303, 214, 248, 257, 213, 547)
Order by pokedex_number

-- Create View of the perfect team for later use -- 


Create View ThePerfectPokemonTeam AS
select pokedex_number, name, abilities, type1, type2, hp, attack, sp_attack, defense, sp_defense, speed, generation, is_legendary 
From Pokedex
Where pokedex_number In (303, 214, 248, 257, 213, 547)

-- Creating View to store data for later visualizations -- 

Create View Pokemon_Stats AS
Select name, hp, attack, sp_attack, defense, sp_defense, speed, base_total
From Pokedex









