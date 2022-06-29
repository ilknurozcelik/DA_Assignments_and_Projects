/*
PostCodes.csv dosyas� 4 s�tundan olu�maktad�r.

1. Postcode: 4 haneli posta kodu numaras�
2. PostcodeName: Posta kodunun ad� (o b�lgenin ad�)
3. ValidFrom: Hangi tarihten itibaren ge�erli oldu�u
4. ValidTo: Hangi tarihe kadar ge�erli oldu�u

Bir posta kodu kapat�labilir.
Belli bir s�re ask�ya al�nabilir.
Bir posta kodunun ad� de�i�ebilir.

Ayn� g�n kapan�p ayn� g�n yeniden a��lan ve ad� de�i�memi� posta kodlar� ayn� posta kodu
olarak kabul edilir.

Hangi g�n kapan�p hangi g�n a��l�rsa a��ls�n bir posta kodunun ad� de�i�mi�se bu durumda
eski posta kodu kapanm�� say�l�r.

Yeni isimli posta kodu ise ilk defa a��lm�� farkl� bir posta kodudur.
Ayn� tarihte bir posta kodunun iki farkl� ad� olamaz.

ValidTo s�tunu bo� olan kay�tlar postakodunun halen ge�erli oldu�unu anlam�na gelir.

E�er bir posta kodunun ad� de�i�memi�se ve ask�ya al�nma tarihi ile ayn� posta kodunun
yeniden a��lma tarihleri ayn� ise bu sat�rlar�n tek bir sat�rda toplanmas� gerekmektedir.

Postcode	PostcodeName	ValidFrom	ValidTo
1		A		01.01.1999	01.02.1999
1		A		01.02.1999	

�rne�in yukar�daki �rnekte 1 numaral� Postkodu 1 Ocak 1999 tarihinde a��lm�� ve
1 �ubat 1999 tarihinde kapat�lm��. Fakat ayn� g�n ayn� posta numaras� ayn� isimle
yeniden a��lm�� ve halen de ge�erli bir posta kodu. Dolay�s�yla bu iki sat�r birle�tirilecektir
ve a�a��daki �ekilde tutulacakt�r:

Postcode	PostcodeName	ValidFrom	ValidTo
1				A			01.01.1999

E�er bu �rnekte 2. sat�rda yer alan posta kodu ayn� g�n de�il de daha sonra
a��lm�� olsayd� bu durumda ikinci kay�t yeni bir postakodu gibi d���nelecektir.
Ve bu iki sat�r birle�tirilmeyecektir.

Bir ba�ka �rnek vermek gerekirse Postcode: 1 in ad�n�n ilk �nce A sonra B oldu�unu varsayal�m.
Bu durumda B isimli posta kodunun a��ld��� tarih A isimli posta kodunun kapand��� tarihe e�it de
olsa farkl� da olsa bu posta kodu yeni bir posta kodu olup bu tip durumlarda da sat�rlar
birle�tirilmeyecektir.


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





-- LAG ile ��z�m:
--Posta kodu ayn�, ismi ayn� ve ask�ya al�nma ve yeniden a��lma tarihleri ayn� olanlar� bulal�m
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

--tablodan silinmesi gerekenler (ancak ValidTo de�erleri tabloda kalmas� gerekenler k�sm�na aktar�lacak)
SELECT DISTINCT [Postcode], [PostcodeName], [ValidTo]
FROM POST_CODE_SELECTOR
WHERE SELECT_POSTCODE = 0


-- Tabloda kalmas� gerekneler
SELECT DISTINCT [Postcode], [PostcodeName], [ValidTo]
FROM POST_CODE_SELECTOR
WHERE SELECT_POSTCODE = 1


--Tabloda kalmas� gerekneler i�in temporary table olu�turma
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



