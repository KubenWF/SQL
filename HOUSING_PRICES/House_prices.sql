SELECT * FROM house_prices.housing; 
-- CHECKING THE RAW DATE --
-- DATA CLEANING STARTS--
ALTER TABLE house_prices.housing
ADD converted_date DATE;
-- I see that Date in the table has a string type, so i want to create a column with proper data type --
UPDATE house_prices.housing
SET converted_date = STR_TO_DATE(SaleDate, '%M %e, %Y');
-- I am converting string to a date type in this new column --
ALTER TABLE house_prices.housing
DROP COLUMN SaleDate;
-- Drop the old column --
SELECT *
FROM house_prices.housing
WHERE PropertyAddress IS NULL OR PropertyAddress = '';
-- Check the Property Address column. I see there are several rows, that are having null cells and i see that some rows, has the same parcel id and owner address, so lets check
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,a.UniqueID, b.UniqueID
FROM house_prices.housing a
JOIN house_prices.housing b
ON a.ParcelID = b.parcelID 
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null OR a.PropertyAddress = '';
-- I see that there are several uniqueid have similar parcelid and owner adress, so i decided, that i want to fill the null cells with property adress
UPDATE house_prices.housing a
SET PropertyAddress = '410  ROSEHILL CT, GOODLETTSVILLE'
WHERE UniqueID = 43076;
UPDATE house_prices.housing a
SET PropertyAddress = '141  TWO MILE PIKE, GOODLETTSVILLE'
WHERE UniqueID = 39432;
UPDATE house_prices.housing a
SET PropertyAddress = '208  EAST AVE, GOODLETTSVILLE'
WHERE UniqueID = 45290;
UPDATE house_prices.housing a
SET PropertyAddress = '1129  CAMPBELL RD, GOODLETTSVILLE'
WHERE UniqueID = 43080;
UPDATE house_prices.housing a
SET PropertyAddress = '438  W CAMPBELL RD, GOODLETTSVILLE'
WHERE UniqueID = 48731;
UPDATE house_prices.housing a
SET PropertyAddress = '2117  PAULA DR, MADISON'
WHERE UniqueID = 36531;
UPDATE house_prices.housing a
SET PropertyAddress = '222  FOXBORO DR, MADISON'
WHERE UniqueID = 36531;
UPDATE house_prices.housing a
SET PropertyAddress = '112  HILLER DR, OLD HICKORY'
WHERE UniqueID = 47293;
UPDATE house_prices.housing a
SET PropertyAddress = '213 B  LOVELL ST, MADISON'
WHERE UniqueID = 22775;
UPDATE house_prices.housing a
SET PropertyAddress = '224  HICKORY ST, MADISON'
WHERE UniqueID = 45349;
UPDATE house_prices.housing a
SET PropertyAddress = '202  KEETON AVE, OLD HICKORY'
WHERE UniqueID = 50927;
UPDATE house_prices.housing a
SET PropertyAddress = '726  IDLEWILD DR, MADISON'
WHERE UniqueID = 3299;
UPDATE house_prices.housing a
SET PropertyAddress = '2721  HERMAN ST, NASHVILLE'
WHERE UniqueID = 49886;
UPDATE house_prices.housing a
SET PropertyAddress = '815  31ST AVE N, NASHVILLE'
WHERE UniqueID = 27140;
UPDATE house_prices.housing a
SET PropertyAddress = '237  37TH AVE N, NASHVILLE'
WHERE UniqueID = 11478;
UPDATE house_prices.housing a
SET PropertyAddress = '311  35TH AVE N, NASHVILLE'
WHERE UniqueID = 32385;
UPDATE house_prices.housing a
SET PropertyAddress = '700  GLENVIEW DR, NASHVILLE'
WHERE UniqueID = 8126;
UPDATE house_prices.housing a
SET PropertyAddress = '1205  THOMPSON PL, NASHVILLE'
WHERE UniqueID = 45774;
UPDATE house_prices.housing a
SET PropertyAddress = '222  FOXBORO DR, MADISON'
WHERE UniqueID = 40678;

-- Manually feeding the null values--
ALTER TABLE house_prices.housing
ADD COLUMN owner_city VARCHAR(255),
ADD COLUMN owner_adress VARCHAR(255),
ADD COLUMN owner_state VARCHAR(255);
-- Checking owneradress column. I see that it has the adress,city and state seperated by comma and i want to separate them in separate columns. I am creating three new columns
UPDATE house_prices.housing
SET owner_city = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1),
    owner_adress = SUBSTRING_INDEX(OwnerAddress, ', ', 1),
	owner_state = SUBSTRING_INDEX(OwnerAddress, ', ', -1);
-- I am using substring in order, to divide owneradress in three columns.
ALTER TABLE house_prices.housing
DROP COLUMN PropertyAddress;
-- dropping unnecessary column
SELECT DISTINCT(SoldAsVacant) FROM house_prices.housing;
-- I see this column has 4 variables,[Y,Yes,N,No], which is not the best way to have this column. I want to have only 2 variables, Yes and No
UPDATE house_prices.housing
SET SoldAsVacant = REPLACE(SoldAsVacant, 'N', 'No')
WHERE SoldAsVacant LIKE 'N';
-- Substitute N by No -- 
UPDATE house_prices.housing
SET SoldAsVacant = REPLACE(SoldAsVacant, 'Y', 'Yes')
WHERE SoldAsVacant LIKE 'Y';
-- Substitute Y by Yes -- 
-- DATE CLEANING IS DONE--
-- 1. What are the different cities available  and their counts?
SELECT owner_city, COUNT(*) AS cities
FROM house_prices.housing
GROUP BY owner_city;

-- City and Count -- 
-- GOODLETTSVILLE	458 --
-- JOELTON	11 --
-- MADISON	1221 --
-- NASHVILLE	18968 --
-- WHITES CREEK	19 --
-- OLD HICKORY	833 --
-- HERMITAGE	1025 --
-- MOUNT JULIET	7 --
-- ANTIOCH	1284 -- 
-- BRENTWOOD	181 --
-- 2.What is the average year built for the properties
SELECT AVG(YearBuilt) AS Average
FROM house_prices.housing;

-- 1963.6496 -- 
-- 3. How many properties are included in the dataset?
SELECT COUNT(UniqueID) AS Average
FROM house_prices.housing;

-- 24007 --
-- 4.How many properties were sold as vacant vs. not vacant? What is the average SalePrice for each category?

SELECT
    SoldAsVacant,
    COUNT(*) AS NumberOfProperties,
    AVG(SalePrice) AS AverageSalePrice
FROM
    house_prices.housing
GROUP BY
    SoldAsVacant;

-- Sold as Vacant - number of properties - Average SalePrice --
-- No	23588	276610.1664 --
-- Yes	419	182635.5036 --
-- 5.What is the most common LandUse category in each TaxDistrict?

SELECT
    TaxDistrict,
    LandUse,
    COUNT(*) AS Frequency
FROM
    house_prices.housing
GROUP BY
    TaxDistrict, LandUse
    
-- Answer with TaxDistrict, Land use and Frequency -- 
-- CITY OF BELLE MEADE - SINGLE FAMILY = 214--
-- CITY OF BERRY HILL - SINGLE FAMILY = 21--
-- CITY OF FOREST HILLS - SINGLE FAMILY = 343--
-- CITY OF GOODLETTSVILLE - SINGLE FAMILY = 334--
-- CITY OF OAK HILL - SINGLE FAMILY = 342--
-- GENERAL SERVICES DISTRICT - SINGLE FAMILY = 3569--
-- URBAN SERVICES DISTRICT - SINGLE FAMILY = 16457--