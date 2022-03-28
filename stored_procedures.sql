DROP PROCEDURE IF EXISTS spGetCategories;
DROP PROCEDURE IF EXISTS spGetAllConsumables;
DROP PROCEDURE IF EXISTS spInsertConsumable;
DROP PROCEDURE IF EXISTS spGetAllNonConsumables;

--Creation sql for stored procedures need to be run separately one at a time

CREATE PROCEDURE spGetCategories AS
BEGIN
SET NOCOUNT ON SELECT * FROM CATEGORY
END;

CREATE PROCEDURE spGetAllConsumables AS
BEGIN
SET NOCOUNT ON
SELECT *
FROM ITEM, CONSUMABLE_ITEM
WHERE Id = Item.Id
END;

CREATE PROCEDURE spInsertConsumable (
	@NAME		VARCHAR(255),
	@C_ID		INT,
	@VAL_PER_AMT	INT = 0,
	@VAL_UNIT	VARCHAR(10) = 'pc',
	@AMT_IN		INT = 0,
	@AMT_OUT	INT = 0,
	@AMT_UNIT	VARCHAR(10) = 'set'
)
AS
BEGIN
SET NOCOUNT ON
INSERT INTO ITEM (Item_Name, Category_Id, Is_Consumable)
VALUES (@NAME, @C_ID, 1 );
DECLARE @LASTID AS INT = SCOPE_IDENTITY();
INSERT INTO CONSUMABLE_ITEM (Item_Id, Value_Per_Amt, Value_Unit, Amount_In, Amount_Out, Amount_Unit)
VALUES (@LASTID, @VAL, @VAL_UNIT, @AMT_IN, @AMT_OUT, @AMT_UNIT);
END;


CREATE PROCEDURE spGetAllNonConsumables AS
BEGIN
SET NOCOUNT ON
SELECT *, (
		CASE WHEN EXISTS (
			SELECT 1
			FROM RESERVATION R
			WHERE ITEM.Id = R.Item_Id
			AND Start_Time < GETDATE()
			AND End_Time > GETDATE()
		  ) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END
  	) AS Is_Reserved 
FROM ITEM, NONCONSUMABLE_ITEM
WHERE Id = Item.Id
END;
