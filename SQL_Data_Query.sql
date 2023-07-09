
--Truy xuất - Phân nhóm dữ liệu để thuận tiện phân tích hơn khi sử dụng các công cụ kế tiếp

/*
1. Phân nhóm khách hàng, nhóm khách hàng có người phụ thuộc, lứa tuổi, 
thời gian gắn bó với dịch vụ và sử dụng phân tích với Python.
*/*

with cus as (
SELECT telecom_customer.*, 
	CASE
		WHEN Customer_Status != 'Churned' AND Total_Revenue > avg_revenue THEN 'VIP'
		ELSE Customer_Status
	END AS Customer_rank
FROM telecom_customer
INNER JOIN (
	SELECT AVG(Total_revenue) AS avg_revenue
	FROM telecom_customer
) subquery 
ON 1=1
)
, depen as (
select *
, CASE
		WHEN Number_of_Dependents != 0 THEN 'Yes'
		ELSE 'No'
	END Depen_Group
from cus
)
, agegroup as(
select *
, CASE
		WHEN age < 36 THEN 'Youth'
		WHEN age < 66 THEN 'Middle-age'
		WHEN age >65 THEN 'Old age'
		ELSE 'No'
	END Age_Group
from depen
)
, tenure_year as (
select *
, case 
		when Tenure_in_Months between 1 and 12 then '1 year'
		when Tenure_in_Months between 13 and 24 then '2 year'
		when Tenure_in_Months between 25 and 36 then '3 year'
		when Tenure_in_Months between 37 and 48 then '4 year'
		when Tenure_in_Months between 49 and 60 then '5 year'
		when Tenure_in_Months between 61 and 72 then '6 year'
		ELSE 'No'
	END tenure_year
from agegroup
)
select * into customer from tenure_year

/*
2. Chia thành 2 bảng riêng biệt tương ứng với 2 nhóm khách hàng VIP và CHURN để kết nhối dữ liệu với Power BI.
*/

with Cus_Churn as (
select * from customer
where Customer_rank = 'churned'
)
select * into Customer_Churn from cus_churn


with Cus_VIP as (
select * from customer
where Customer_rank = 'VIP'
)
select * into Customer_VIP from cus_VIP

