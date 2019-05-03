-- https://stackoverflow.com/questions/7417017/sql-server-group-by-datetime-ignore-hour-minute-and-a-select-with-a-date-and-sum
-- Haftanın gününü int olarak almak: DATEPART(dw, [OrderDate])
-- Haftanın gününü upper string olarak almak: DATENAME(dw, [OrderDate])

;with dateGroupTable as(
select 
    cast([OrderDate] As date) UtcDay, 
	--DATEPART(hour, [OrderDate]) UtcHour, 
	count(*) As Counts,
	Avg(Freight) As [AvgPrice],
	min(Freight) As [MinPrice],
	max(Freight) As [MaxPrice],
	sum(Freight) As [TotalPrice]
from [Northwind].[dbo].[Orders] cd 
where 
	(DATEPART(dw, [OrderDate]) = 5) and -- Haftanın günü filtreleniyor
	(OrderDate BETWEEN '1998-01-01 00:00:00.000' AND '1998-01-15 19:35:59.000') -- Tarih aralığının fitlrelenmesi
	(convert(varchar(8), [OrderDate], 108) Between '00:00:00' And '01:59:59') -- Saat aralığına göre filtreleme
group by
    cast([OrderDate] as date) -- Filtrelenen verilere uyanlar tarihe göre gruplanıyor
)

-- Üstte oluşturulan geçici tabladan istenen verilerin çekilip listelenmesi
select
	Cast(UtcDay As datetime) + Cast('19:35:59.000' As datetime) As [DateTime], --dateadd(hour, Utchour, cast(Utcday as date)) as UTCDateHour, 
	Counts,
	AvgPrice,
	MinPrice,
	MaxPrice, 
	TotalPrice
from dateGroupTable
order by UtcDay desc

