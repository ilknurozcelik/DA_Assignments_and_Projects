/*
PostCodes.csv dosyasý 4 sütundan oluþmaktadýr.

1. Postcode: 4 haneli posta kodu numarasý
2. PostcodeName: Posta kodunun adý (o bölgenin adý)
3. ValidFrom: Hangi tarihten itibaren geçerli olduðu
4. ValidTo: Hangi tarihe kadar geçerli olduðu

Bir posta kodu kapatýlabilir.
Belli bir süre askýya alýnabilir.
Bir posta kodunun adý deðiþebilir.

Ayný gün kapanýp ayný gün yeniden açýlan ve adý deðiþmemiþ posta kodlarý ayný posta kodu
olarak kabul edilir.

Hangi gün kapanýp hangi gün açýlýrsa açýlsýn bir posta kodunun adý deðiþmiþse bu durumda
eski posta kodu kapanmýþ sayýlýr.

Yeni isimli posta kodu ise ilk defa açýlmýþ farklý bir posta kodudur.
Ayný tarihte bir posta kodunun iki farklý adý olamaz.

ValidTo sütunu boþ olan kayýtlar postakodunun halen geçerli olduðunu anlamýna gelir.

Eðer bir posta kodunun adý deðiþmemiþse ve askýya alýnma tarihi ile ayný posta kodunun
yeniden açýlma tarihleri ayný ise bu satýrlarýn tek bir satýrda toplanmasý gerekmektedir.

Postcode	PostcodeName	ValidFrom	ValidTo
1		A		01.01.1999	01.02.1999
1		A		01.02.1999	

Örneðin yukarýdaki örnekte 1 numaralý Postkodu 1 Ocak 1999 tarihinde açýlmýþ ve
1 Þubat 1999 tarihinde kapatýlmýþ. Fakat ayný gün ayný posta numarasý ayný isimle
yeniden açýlmýþ ve halen de geçerli bir posta kodu. Dolayýsýyla bu iki satýr birleþtirilecektir
ve aþaðýdaki þekilde tutulacaktýr:

Postcode	PostcodeName	ValidFrom	ValidTo
1				A			01.01.1999

Eðer bu örnekte 2. satýrda yer alan posta kodu ayný gün deðil de daha sonra
açýlmýþ olsaydý bu durumda ikinci kayýt yeni bir postakodu gibi düþünelecektir.
Ve bu iki satýr birleþtirilmeyecektir.

Bir baþka örnek vermek gerekirse Postcode: 1 in adýnýn ilk önce A sonra B olduðunu varsayalým.
Bu durumda B isimli posta kodunun açýldýðý tarih A isimli posta kodunun kapandýðý tarihe eþit de
olsa farklý da olsa bu posta kodu yeni bir posta kodu olup bu tip durumlarda da satýrlar
birleþtirilmeyecektir.


*/

CREATE DATABASE POSTCODE;

SELECT *
FROM PostCodes
WHERE Postcode =8407 OR Postcode =9186 

SELECT PostCode, COUNT(PostCode)
FROM PostCodes
GROUP BY PostCode
HAVING COUNT(PostCode)>2


SELECT *,
	LAST_VALUE([ValidFrom]) OVER(PARTITION BY PostCode ORDER BY [ValidFrom] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING)
FROM [dbo].[PostCodes]
WHERE Postcode =8407 OR Postcode =9186


SELECT *,
	LAST_VALUE([ValidFrom]) OVER(PARTITION BY PostCode ORDER BY [ValidFrom] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) NEXT_DATE
	LEAD([PostcodeName]) OVER(PARTITION BY PostCode ORDER BY [PostcodeName]) NEXT_POSTCODE_NAME
FROM [dbo].[PostCodes]
--WHERE Postcode =8407 OR Postcode =9186

WITH T1 AS(
SELECT *,
	LAST_VALUE([ValidFrom]) OVER(PARTITION BY PostCode ORDER BY [ValidFrom] ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) NEXT_DATE,
	LEAD([PostcodeName]) OVER(PARTITION BY PostCode ORDER BY [PostcodeName])NEXT_POSTCODE_NAME
FROM [dbo].[PostCodes]
), T2 AS (
SELECT  [Postcode], [PostcodeName],[ValidFrom],[ValidTo], NEXT_DATE ,NEXT_POSTCODE_NAME,
	CASE
		WHEN [PostcodeName] = NEXT_POSTCODE_NAME AND [ValidTo] = NEXT_DATE THEN 1
		--WHEN [PostcodeName] != NEXT_POSTCODE_NAME THEN 2
		--WHEN [PostcodeName] = NEXT_POSTCODE_NAME AND [ValidTo] != NEXT_DATE THEN 3
	END SELECT_POSTCODE
FROM T1
)
SELECT * --DISTINCT PostCode, [PostcodeName],[ValidFrom], [ValidTo] = 0
FROM T2
-- WHERE SELECT_POSTCODE = 1 --OR SELECT_POSTCODE = 2 OR SELECT_POSTCODE = 3





-- LAG ile çözüm:
--Posta kodu ayný, ismi ayný ve askýya alýnma ve yeniden açýlma tarihleri ayný olanlarý bulalým
CREATE VIEW POST_CODE_SELECTOR AS
WITH T2 AS (
SELECT *,
	LAG([ValidTo]) OVER(PARTITION BY PostCode ORDER BY [ValidFrom]) NEXT_DATE,
	LAG([PostcodeName]) OVER(PARTITION BY PostCode ORDER BY [PostcodeName])NEXT_POSTCODE_NAME
FROM [dbo].[PostCodes]
)
SELECT  [Postcode], [PostcodeName],[ValidFrom],[ValidTo], NEXT_DATE ,NEXT_POSTCODE_NAME,
	CASE
		WHEN [PostcodeName] = NEXT_POSTCODE_NAME AND [ValidFrom] = NEXT_DATE THEN 0
		ELSE 1
	END SELECT_POSTCODE
FROM T2

--tablodan silinmesi gerekenler (ancak ValidTo deðerleri tabloda kalmasý gerekenler kýsmýna aktarýlacak)
SELECT DISTINCT [Postcode], [PostcodeName], [ValidTo]
FROM POST_CODE_SELECTOR
WHERE SELECT_POSTCODE = 0


-- Tabloda kalmasý gerekneler
SELECT DISTINCT [Postcode], [PostcodeName], [ValidTo]
FROM POST_CODE_SELECTOR
WHERE SELECT_POSTCODE = 1


--Tabloda kalmasý gerekneler için temporary table oluþturma
SELECT [Postcode], [PostcodeName], [ValidFrom], [ValidTo]
INTO POST_CODE_TEMP
FROM POST_CODE_SELECTOR
WHERE SELECT_POSTCODE = 1



SELECT DISTINCT [Postcode], [PostcodeName], [ValidTo] = ( SELECT [ValidTo]
						FROM POST_CODE_SELECTOR
						WHERE SELECT_POSTCODE = 0)
FROM POST_CODE_TEMP
WHERE [Postcode] IN (SELECT DISTINCT [Postcode]
						FROM POST_CODE_SELECTOR
						WHERE SELECT_POSTCODE = 0)


UPDATE POST_CODE_TEMP
SET [ValidTo] = (SELECT [ValidTo]
						FROM POST_CODE_SELECTOR
						WHERE SELECT_POSTCODE = 0)
WHERE [Postcode] IN (SELECT DISTINCT [Postcode]
						FROM POST_CODE_SELECTOR
						WHERE SELECT_POSTCODE = 0)


SELECT *
FROM POST_CODE_SELECTOR
WHERE SELECT_POSTCODE = 1




--WHERE Postcode =8407 OR Postcode =9186



