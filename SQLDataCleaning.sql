select * from SQLDataCleaning.dbo.NasvilleHousing

--standardise Date Format

select SaleDate, CONVERT(Date,SaleDate)
from SQLDataCleaning.dbo.NasvilleHousing


update NasvilleHousing
set SaleDate = CONVERT(Date,SaleDate) 


alter table NasvilleHousing
add SaleDateConverted Date;

update NasvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

select SaleDateConverted, CONVERT(Date,SaleDate)
from SQLDataCleaning.dbo.NasvilleHousing


--Populate Property Address


select PropertyAddress
from SQLDataCleaning.dbo.NasvilleHousing
where PropertyAddress is null

select *
from SQLDataCleaning.dbo.NasvilleHousing
--where PropertyAddress is null
order by ParcelID


--self join
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NasvilleHousing a
join NasvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

--when using selfjoin and updating use alias

update a 
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NasvilleHousing a
join NasvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address inti individual columns (address, city, state)


select PropertyAddress from NasvilleHousing

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

from NasvilleHousing

alter table NasvilleHousing
add PropertySplitAddress nvarchar(255);


update NasvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table NasvilleHousing
add PropertySplitCity nvarchar(255);

update NasvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

select * from NasvilleHousing





select OwnerAddress from NasvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from NasvilleHousing



alter table NasvilleHousing
add OwnerSplitAddress nvarchar(255);


update NasvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

alter table NasvilleHousing
add OwnerSplitCity nvarchar(255);

update NasvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

alter table NasvilleHousing
add OwnerSplitState nvarchar(255);

update NasvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


select * from NasvilleHousing


--change Y and N toYes and No in "sold as vacant" field

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NasvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from NasvilleHousing

update NasvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end


--Remove Duplicates

select * from NasvilleHousing



 
WITH RowNumCTE As(
select * ,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					uniqueID
				 ) row_num

from NasvilleHousing

)
Delete
from RownumCTE
where row_num > 1
--order by PropertyAddress



WITH RowNumCTE As(
select * ,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by 
					uniqueID
				 ) row_num

from NasvilleHousing

)
Select * 
from RownumCTE
where row_num > 1
--order by PropertyAddress


select * from NasvilleHousing



--Delete Unused columns

select * from NasvilleHousing


alter table NasvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


alter table NasvilleHousing
drop column SaleDate