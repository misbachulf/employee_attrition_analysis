--Preview dataset
select * from employee limit 20

--Q1. Berapa total karyawan dan berapa Persentase Attrition (Tingkat Keluar) secara keseluruhan?
select
	count(*) as total_employees,
	sum(attrition_num) as total_attrition,
	round(avg(attrition_num)*100, 2) as attrition_rate
from employee

--Q2. Berapa rata-rata Umur, Rata-rata Gaji (Monthly Income), dan Rata-rata Lama Bekerja (YearsAtCompany) berdasarkan status Attrition?
select attrition,
	round(avg(age), 0) as avg_age,
	round(avg(monthlyincome), 2) as avg_income,
	round(avg(yearsatcompany), 1) as avg_duration
from employee
group by attrition;

--Q3. Departemen mana yang memiliki jumlah karyawan keluar (Attrition = 'Yes') terbanyak?
select department,
	count(*) as total_employees,
	sum(attrition_num) as attrition_count,
	round(avg(attrition_num)* 100, 2) as attrition_rate
from employee
group by department
order by attrition_count desc;

--Q4. Bagaimana distribusi Gaji (MonthlyIncome) berdasarkan Education Field?
select educationfield,
	count (*) as total_employees,
	round(avg(monthlyincome), 2) as avg_income,
	min(monthlyincome) as min_income,
	max(monthlyincome) as max_income
from employee
group by educationfield
order by avg_income desc;

--Q5. Analisis "Flight Risk" berdasarkan Umur (Buat Grouping Umur di SQL).
select age_group,
	count(*) as total_employees,
	sum(attrition_num) as attrition_count,
	round(avg(attrition_num) * 100, 2) as attrition_rate
from employee
group by 1
order by 1;

--Q6. Apakah karyawan yang sering Lembur (OverTime = 'Yes') memiliki tingkat Attrition lebih tinggi dibandingkan yang tidak lembur?
select overtime,
	count(*) as total_employee,
	sum(attrition_num) as attrition_count,
	round(avg(attrition_num)* 100, 2) as attrition_rate
from employee
group by overtime
order by attrition_rate desc;

--Q7. Berapa rata-rata kenaikan gaji (PercentSalaryHike) bagi karyawan dengan PerformanceRating tinggi vs rendah?
select performancerating,
	count(*) total_employess,
	round(avg(percentsalaryhike), 2) as avg_hikepercent,
	round(avg(attrition_num)* 100, 2) as attrition_rate
from employee
group by performancerating
order by performancerating asc;

--Q8. Siapa saja 3 karyawan dengan Gaji Tertinggi di Setiap Job Role?
with income_rank as (
	select employeenumber, jobrole, monthlyincome,
	rank() over(partition by jobrole order by monthlyincome desc) as ranking
	from employee
)
select *
from income_rank
where ranking <= 3;

--Q9. Identifikasi karyawan yang "Stagnan": Siapa saja karyawan yang sudah bekerja lebih dari 5 tahun, tidak pernah dipromosikan dalam 5 tahun terakhir, tapi masih bertahan?
select employeenumber, department, jobrole, yearsatcompany,
		yearssincelastpromotion, monthlyincome, performancerating
from employee
where attrition_num = 0
	and yearsatcompany >= 5
	and yearssincelastpromotion >= 5
order by yearssincelastpromotion desc;

---Berdasarkan jabatan yang banyak stagnan
select jobrole,
	count(*) as stagnan_employee
from employee
where attrition_num = 0
	and yearsatcompany >= 5
	and yearssincelastpromotion >= 5
group by jobrole
order by stagnan_employee desc;

--Q10. Analisis kepuasan kerja (JobSatisfaction): Hitung berapa banyak karyawan di setiap level kepuasan (1-4) dan berapa % dari mereka yang keluar di setiap level tersebut?
select jobsat_label,
	count(*) as total_employee,
	sum(attrition_num) as attrition_count,
	round(avg(attrition_num)* 100,2) as attrition_rate
from employee
group by 1
order by 1;