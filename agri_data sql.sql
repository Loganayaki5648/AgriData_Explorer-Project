create database agri_data;
use agri_data;
create table agri_table (
Dist_Code int,
Year int,
State_Code int,
State_Name varchar(50),
Dist_Name varchar(50),
RICE_AREA_1000_ha float,
RICE_PRODUCTION_1000_tons float,
RICE_YIELD_kg_per_ha float,
WHEAT_AREA_1000_ha float,
WHEAT_PRODUCTION_1000_tons float,
WHEAT_YIELD_kg_per_ha float,
KHARIF_AREA_1000_ha float,
KHARIF_PRODUCTION_1000_tons float,
KHARIF_YIELD_kg_per_ha float,
RABI_SORGHUM_AREA_1000_ha float,
RABI_SORGHUM_PRODUCTION_1000_tons float,
RABI_SORGHUM_YIELD_kg_per_ha float,
SORGHUM_AREA_1000_ha float,
SORGHUM_PRODUCTION_1000_tons float,
SORGHUM_YIELD_kg_per_ha float,
PEARL_MILLET_AREA_1000_ha float,
PEARL_MILLET_PRODUCTION_1000_tons float,
PEARL_MILLET_YIELD_kg_per_ha float,
MAIZE_AREA_1000_ha float,
MAIZE_PRODUCTION_1000_tons float,
MAIZE_YIELD_kg_per_ha float,
FINGER_MILLET_AREA_1000_ha float,
FINGER_MILLET_PRODUCTION_1000_tons float,
FINGER_MILLET_YIELD_kg_per_ha float,
BARLEY_AREA_1000_ha float,
BARLEY_PRODUCTION_1000_tons float,
BARLEY_YIELD_kg_per_ha float,
CHICKPEA_AREA_1000_ha float,
CHICKPEA_PRODUCTION_1000_tons float,
CHICKPEA_YIELD_kg_per_ha float,
PIGEONPEA_AREA_1000_ha float,
PIGEONPEA_PRODUCTION_1000_tons float,
PIGEONPEA_YIELD_kg_per_ha float,
MINOR_PULSES_AREA_1000_ha float,
MINOR_PULSES_PRODUCTION_1000_tons float,
MINOR_PULSES_YIELD_kg_per_ha float,
GROUNDNUT_AREA_1000_ha float,
GROUNDNUT_PRODUCTION_1000_tons float,
GROUNDNUT_YIELD_kg_per_ha float,
SEASAMUM_AREA_1000_ha float,
SEASAMUM_PRODUCTION_1000_tons float,
SEASAMUM_YIELD_kg_per_ha float,
RAPESEED_AND_MUSTARD_AREA_1000_ha float,
RAPESEED_AND_MUSTARD_PRODUCTION_1000_tons float,
RAPESEED_AND_MUSTARD_YIELD_kg_per_ha float,
SAFFLOWER_AREA_1000_ha float,
SAFFLOWER_PRODUCTION_1000_tons float,
SAFFLOWER_YIELD_kg_per_ha float,
CASTOR_AREA_1000_ha float,
CASTOR_PRODUCTION_1000_tons float,
CASTOR_YIELD_kg_per_ha float,
LINSEED_AREA_1000_ha float,
LINSEED_PRODUCTION_1000_tons float,
LINSEED_YIELD_kg_per_ha float,
SUNFLOWER_AREA_1000_ha float,
SUNFLOWER_PRODUCTION_1000_tons float,
SUNFLOWER_YIELD_kg_per_ha float,
SOYABEEN_AREA_1000_ha float,
SOYABEEN_PRODUCTION_1000_tons float,
SOYABEEN_YIELD_kg_per_ha float,
OILSEED_AREA_1000_ha float,
OILSEED_PRODUCTION_1000_tons float,
OILSEED_YIELD_kg_per_ha float,
SUGARCANE_AREA_1000_ha float,
SUGARCANE_PRODUCTION_1000_tons float,
SUGARCANE_YIELD_kg_per_ha float,
COTTON_AREA_1000_ha float,
COTTON_PRODUCTION_1000_tons float,
COTTON_YIELD_kg_per_ha float,
FRUITS_AREA_1000_ha float,
VEGETABLES_AREA_1000_ha float,
FRUITS_AND_VEGETABLES_AREA_1000_ha float,
POTATOES_AREA_1000_ha float,
ONION_AREA_1000_ha float,
FODDER_AREA_1000_ha float
)
select count(*) as total_rows from agri_table;  
select * from agri_data.agri_table;

SHOW COLUMNS FROM agri_table;

*/ 1.Year-wise Trend of Rice Production Across States (Top 3) */

SELECT *FROM (SELECT`Year`,`State Name`, SUM(`RICE PRODUCTION (1000 tons)`) AS total_rice_production,
        RANK() OVER (PARTITION BY `Year` ORDER BY SUM(`RICE PRODUCTION (1000 tons)`) DESC) AS rank_state
    FROM agri_table
    GROUP BY `Year`, `State Name`
) ranked_data
WHERE rank_state <= 3
ORDER BY `Year`, rank_state;

*/ 2.Top 5 Districts by Wheat Yield Increase Over the Last 5 Years */
SELECT `Dist Name`, MAX(`WHEAT YIELD (Kg per ha)`) - MIN(`WHEAT YIELD (Kg per ha)`) AS Yield_Increase FROM agri_table
WHERE `Year` BETWEEN 2012 AND 2016
GROUP BY `Dist Name`
ORDER BY Yield_Increase DESC
LIMIT 5;

*/ States with the Highest Growth in Oilseed Production (5-Year Growth Rate) */
SELECT t1.`State Name`,
    ROUND(((t2.total_prod - t1.total_prod) / NULLIF(t1.total_prod, 0)) * 100, 2) AS growth_rate_percent
FROM (SELECT `State Name`, SUM(`OILSEEDS PRODUCTION (1000 tons)`) AS total_prod
    FROM agri_table
    WHERE Year = 2013
    GROUP BY `State Name`) t1
JOIN (SELECT `State Name`, SUM(`OILSEEDS PRODUCTION (1000 tons)`) AS total_prod
    FROM agri_table
    WHERE Year = 2017
    GROUP BY `State Name` ) t2 ON t1.`State Name` = t2.`State Name`
ORDER BY growth_rate_percent DESC
LIMIT 5;

*/ .District-wise Correlation Between Area and Production for Major Crops (Rice, Wheat, and Maize) */
(
SELECT `Dist Name`, 'Rice' AS Crop, `RICE AREA (1000 ha)` AS Area, `RICE PRODUCTION (1000 tons)` AS Production
FROM agri_table
LIMIT 5
)
UNION ALL
(
SELECT `Dist Name`, 'Wheat' AS Crop, `WHEAT AREA (1000 ha)` AS Area, `WHEAT PRODUCTION (1000 tons)` AS Production
FROM agri_table
LIMIT 5
)
UNION ALL
(
SELECT `Dist Name`, 'Maize' AS Crop, `MAIZE AREA (1000 ha)` AS Area, `MAIZE PRODUCTION (1000 tons)` AS Production
FROM agri_table
LIMIT 5
);

*/ 5.Yearly Production Growth of Cotton in Top 5 Cotton Producing States */

SELECT a.`State Name`,
       a.Year,
       a.`COTTON PRODUCTION (1000 tons)`
FROM agri_table a
JOIN (
    SELECT `State Name` FROM agri_table
    GROUP BY `State Name`
    ORDER BY SUM(`COTTON PRODUCTION (1000 tons)`) DESC
    LIMIT 5
) top5 ON a.`State Name` = top5.`State Name`
ORDER BY a.`State Name`, a.Year;

*/ 6.Districts with the Highest Groundnut Production in 2020 */

SELECT `Dist Name`, `State Name`, `GROUNDNUT PRODUCTION (1000 tons)`
FROM agri_table
WHERE `Year` = 2017
ORDER BY `GROUNDNUT PRODUCTION (1000 tons)` DESC
LIMIT 5;

*/ 7.Annual Average Maize Yield Across All States */

SELECT Year,ROUND(AVG(`MAIZE YIELD (Kg per ha)`), 2) AS avg_maize_yield
FROM agri_table
GROUP BY Year
ORDER BY Year;

*/ 8.Total Area Cultivated for Oilseeds in Each State */

SELECT `State Name`,SUM(`OILSEEDS AREA (1000 ha)`) AS total_oilseeds_area
FROM agri_table
GROUP BY `State Name`
ORDER BY total_oilseeds_area DESC;

*/ 9.Districts with the Highest Rice Yield */

SELECT `Dist Name`, AVG(`RICE YIELD (kg per ha)`) AS highest_rice_yield from agri_table
GROUP BY `Dist Name`
ORDER BY highest_rice_yield DESC
LIMIT 10;

*/ 10.Compare the Production of Wheat and Rice for the Top 5 States Over 10 Years */

SELECT `State Name`, 
    SUM(`WHEAT PRODUCTION (1000 tons)`) AS total_wheat_prod, 
    SUM(`RICE PRODUCTION (1000 tons)`) AS total_rice_prod
FROM agri_table
WHERE `Year` BETWEEN 2008 AND 2017
GROUP BY `State Name`
ORDER BY (total_wheat_prod + total_rice_prod) DESC
LIMIT 5;
















