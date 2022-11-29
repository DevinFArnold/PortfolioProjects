/*
Cleaning Data - Nasville Housing
*/

SELECT *
FROM PortfolioProject_1..NashvilleHousing

/*
Standardize Date Format
*/

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject_1..NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------

/*
Populate Property Address Data
*/

SELECT PropertyAddress
FROM PortfolioProject_1..NashvilleHousing
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject_1..NashvilleHousing a
JOIN PortfolioProject_1..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID]
WHERE  a.PropertyAddress IS NULL

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject_1..NashvilleHousing a
JOIN PortfolioProject_1..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID]
WHERE  a.PropertyAddress IS NULL


--------------------------------------------------------------------------------
/*
Separating Address into Individual Columns (Address, City, State)
*/

SELECT PropertyAddress
FROM PortfolioProject_1..NashvilleHousing
--WHERE PropertyAddress IS NULL

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM PortfolioProject_1..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

SELECT *
FROM PortfolioProject_1..NashvilleHousing

SELECT OwnerAddress
FROM PortfolioProject_1..NashvilleHousing


SELECT  
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM PortfolioProject_1..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


-------------------------------------------------------------------------------
/*
Change Y and N to Yes and No in 'Sold as Vacant' Feild
*/


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject_1..NashvilleHousing
GROUP BY  SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject_1..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END


-------------------------------------------------------------------------------
/*
Remove Duplicates
*/

WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY UniqueID
			) row_num
FROM PortfolioProject_1..NashvilleHousing
--ORDER BY ParcelID
)
DELETE
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

-----------------------------------------------------------------------------------
/*
Delete Unused Columns
*/

SELECT*
FROM PortfolioProject_1..NashvilleHousing

ALTER TABLE PortfolioProject_1..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject_1..NashvilleHousing
DROP COLUMN SaleDate
























