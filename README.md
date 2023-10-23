1. Data cleaning is executed, including gender and age categorization, and data consistency checks.

2. The `SaleDate` field is standardized, and a new field `SaleDateConverted` is added.

3. Property addresses are populated, with a focus on resolving missing data.

4. Property addresses are split into individual columns for better data organization.

5. The 'Sold as Vacant' field is updated to change 'Y' to 'Yes' and 'N' to 'No' for consistency.

6. Duplicates in the data are identified and then deleted, retaining only the minimum `UniqueID`.

7. Finally, unused columns such as `TaxDistrict`, `OwnerAddress`, and `PropertyAddress` are dropped from the dataset.
