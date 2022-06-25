/* Assignment-5 */

/*
Factorial Function 

Create a scalar-valued function that returns the factorial of a number you gave it.
*/

CREATE FUNCTION fnc_factoriel
(
	@number INT
)
RETURNS INT
AS
BEGIN
	DECLARE
		@counter int,
		@result_fact int
	SET @counter = 1
	SET @result_fact = 1
	while @counter <= @number
		BEGIN
			SET @result_fact = @result_fact * @counter
			SET @counter += 1
		END
	RETURN @result_fact
END
;

SELECT dbo.fnc_factoriel(5) Factoriel;