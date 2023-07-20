-- Data cleaning in sql

select *
FROM [portfolioProject].[dbo].[NashvilleHousing]

--Standardize SaleDate

Select SaleDateConverted , CONVERT(date, SaleDate)
from portfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted = convert(Date, SaleDate)


-- populate property address

select *
from portfolioProject.dbo.NashvilleHousing



 -- where propertyAddress is not null
order by parcelID


select a.parcelID , a.PropertyAddress, b.parcelID, b.PropertyAddress ,ISNULL(a.propertyAddress, b.propertyAddress)
from portfolioProject.dbo.NashvilleHousing a
join portfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.parcelID  
AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.propertyAddress, b.propertyAddress)
from portfolioProject.dbo.NashvilleHousing a
join portfolioProject.dbo.NashvilleHousing b
on a.ParcelID = b.parcelID  
AND a.UniqueID <> b.UniqueID



-- Breaking out address into individual columns(Address,city,state)

select propertyAddress
from portfolioProject.dbo.NashvilleHousing
--where PropertyAddress is not null
--order by ParcelID

select 
SUBSTRING(PropertyAddress ,1, CHARINDEX(',', PropertyAddress) -1 ) as Address
 , SUBSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress) +1 ,LEN(PropertyAddress)) AS Address
from portfolioProject.dbo.NashvilleHousing

ALTER TABLE portfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update portfolioProject.dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress ,1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE portfolioProject.dbo.NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

update portfolioProject.dbo.NashvilleHousing
set PropertySplitCity = SubSTRING(PropertyAddress , CHARINDEX(',', PropertyAddress) +1 ,LEN(PropertyAddress)) 

SELECT *
FROM portfolioProject.dbo.NashvilleHousing


-- Another Method


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
from portfolioProject.dbo.NashvilleHousing


ALTER TABLE portfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);


UPDATE portfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)



ALTER TABLE portfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity NVarchar(255);

UPDATE portfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE portfolioProject.dbo.NashvilleHousing
Add OwnerSplitState NVarchar(255);

UPDATE portfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

select *
from portfolioProject.dbo.NashvilleHousing


-- Change Y and N to Yes and No in 'Sold as Vacant' field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
ORDER BY 2

select SoldAsVacant
,  CASE WHEN SoldAsVacant = 'Y' then 'Yes'
    WHEN SoldAsVacant = 'N' then 'No'
   ELSE SoldAsVacant
   end
from portfolioProject.dbo.NashvilleHousing


update portfolioProject.dbo.NashvilleHousing
set SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
    WHEN SoldAsVacant = 'N' then 'No'
   ELSE SoldAsVacant
   end


   -- Duplicates
select 
		 ParcelID,
		 PropertyAddress,
		 SaleDate,
		 SalePrice,
		 LegalReference


from portfolioProject.dbo.NashvilleHousing
Group by ParcelID,
         PropertyAddress,
		 SaleDate,
		 SalePrice,
		 LegalReference
         
having (count(BuildingValue) > 1) and 
       (count(SaleDate) > 1) and
	   (count(PropertyAddress) > 1) and
	   (count(SalePrice) > 1) and
	   (count(LegalReference) > 1) 

	 --  OR 

	  select 
		 ParcelID,
		 PropertyAddress,
		 SaleDate,
		 SalePrice,
		 LegalReference,

		 COUNT (*) AS CNT
		 FROM portfolioProject.dbo.NashvilleHousing

		 Group by ParcelID,
         PropertyAddress,
		 SaleDate,
		 SalePrice,
		 LegalReference

		 HAVING COUNT(*) > 1 ;

	   -- Deleting duplicates
	delete 
	 from portfolioProject.dbo.NashvilleHousing
		where UniqueID  not in ( 
		select min(UniqueID)
		 from portfolioProject.dbo.NashvilleHousing
		 group by  ParcelID,
                   PropertyAddress,
		           SaleDate,
		           SalePrice,
		           LegalReference
 );
 SELECT *
 FROM  portfolioProject.dbo.NashvilleHousing;
	


	-- Delete Unused Columns
	  SELECT *
 FROM  portfolioProject.dbo.NashvilleHousing;


	ALTER TABLE portfolioProject.dbo.NashvilleHousing
	DROP COLUMN TaxDistrict,
	     OwnerAddress,
		 PropertyAddress


		 --DONE!!!!