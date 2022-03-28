DROP PROCEDURE IF EXISTS spGetCategories;
DROP PROCEDURE IF EXISTS spGetConsumables;
DROP PROCEDURE IF EXISTS spGetNonConsumables;

--Creation sql for stored procedures need to be run separately one at a time

CREATE PROCEDURE spGetCategories AS
BEGIN
SET NOCOUNT ON
SELECT * FROM CATEGORY
END;

CREATE PROCEDURE spGetConsumables AS
BEGIN
SET NOCOUNT ON
SELECT *,
  (CASE WHEN EXISTS (
				SELECT 1
				FROM RESERVATION R
			  WHERE ITEM.Id = R.Item_Id
        AND Start_Time < GETDATE()
        AND End_Time > GETDATE()
		  )
		THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT)
	END) AS Is_Reserved 
FROM ITEM, CONSUMABLE_ITEM
WHERE Id = Item.Id
END;

CREATE PROCEDURE spGetNonConsumables AS
BEGIN
SET NOCOUNT ON
SELECT *,
  (CASE WHEN EXISTS (
				SELECT 1
				FROM RESERVATION R
			  WHERE ITEM.Id = R.Item_Id
        AND Start_Time < GETDATE()
        AND End_Time > GETDATE()
		  )
		THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT)
	END) AS Is_Reserved 
FROM ITEM, NONCONSUMABLE_ITEM
WHERE Id = Item.Id
END;
