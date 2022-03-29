DROP PROCEDURE IF EXISTS spGetCategories;
DROP PROCEDURE IF EXISTS spProtectedGetAllConsumables;
DROP PROCEDURE IF EXISTS spPublicGetAllConsumables;
DROP PROCEDURE IF EXISTS spInsertConsumable;
DROP PROCEDURE IF EXISTS spGetAllNonConsumables;
DROP PROCEDURE IF EXISTS spInsertNonConsumable;

--Creation sql for stored procedures need to be run separately one at a time

CREATE PROCEDURE spGetCategories AS
BEGIN
SET NOCOUNT ON SELECT * FROM CATEGORY
END;

CREATE PROCEDURE spProtectedGetAllConsumables AS
BEGIN
SET NOCOUNT ON
SELECT
Id, Item_Name, Category_Id, Is_Consumable, Update_Time, Internal_Tag_Or_Status_Remarks, External_Remarks,
Value_Per_Amt, Value_Unit, Amount_In, Amount_Out, Amount_Bal, Amount_Unit, Next_In_Amt, Next_In_Date, Purchase_Date, Expiry_Date
FROM ITEM, CONSUMABLE_ITEM
WHERE Id = Item_Id
END;

CREATE PROCEDURE spPublicGetAllConsumables AS
BEGIN
SET NOCOUNT ON
SELECT
Id, Item_Name, Category_Id, Is_Consumable, External_Remarks,
Value_Per_Amt, Value_Unit, Amount_Bal, Amount_Unit, Next_In_Amt, Next_In_Date, Expiry_Date
FROM ITEM, CONSUMABLE_ITEM
WHERE Id = Item_Id
END;

CREATE PROCEDURE spInsertConsumable (
	@NAME		VARCHAR(50) = NULL,
	@INT_REMARKS	VARCHAR(255) = NULL,
	@EXT_REMARKS	VARCHAR(255) = NULL,
	@C_ID		INT,
	@VAL_PER_AMT	INT = 0,
	@VAL_UNIT	VARCHAR(10) = 'pc',
	@AMT_IN		INT = 0,
	@AMT_OUT	INT = 0,
	@AMT_UNIT	VARCHAR(10) = 'set',
	@NEXT_IN_AMT	INT = NULL,
	@NEXT_IN_DATE	DATETIME = NULL,
	@PURCHASE_DATE	DATETIME = NULL,
	@EXPIRY_DATE	DATETIME = NULL
)
AS
BEGIN
SET NOCOUNT ON
INSERT INTO ITEM (Item_Name, Internal_Tag_Or_Status_Remarks, External_Remarks, Category_Id, Is_Consumable)
VALUES (@NAME, @INT_REMARKS, @EXT_REMARKS, @C_ID, 1 );
DECLARE @LASTID AS INT = SCOPE_IDENTITY();
INSERT INTO CONSUMABLE_ITEM (Item_Id, Value_Per_Amt, Value_Unit, Amount_In, Amount_Out, Amount_Unit,
				Next_In_Amt, Next_In_Date, Purchase_Date, Expiry_Date)
VALUES (@LASTID, @VAL_PER_AMT, @VAL_UNIT, @AMT_IN, @AMT_OUT, @AMT_UNIT,
	@NEXT_IN_AMT, @NEXT_IN_DATE, @PURCHASE_DATE, @EXPIRY_DATE);
END;


CREATE PROCEDURE spProtectedGetAllNonConsumables AS
BEGIN
SET NOCOUNT ON
SELECT
Id, Item_Name, Category_Id, Is_Consumable, Update_Time, Internal_Tag_Or_Status_Remarks, External_Remarks, (
	CASE WHEN EXISTS (
		SELECT 1
		FROM RESERVATION R
		WHERE ITEM.Id = R.Item_Id
		AND Start_Time < GETDATE()
		AND End_Time > GETDATE()
	) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END
) AS Is_Reserved,
Is_Blocked, Is_OutOfOrder, Is_Faulty, Location, Brand, Model, Equipment_No, Serial_No, Assignee_Email
FROM ITEM, NONCONSUMABLE_ITEM
WHERE Id = Item.Id
END;

CREATE PROCEDURE spPublicGetAllNonConsumables AS
BEGIN
SET NOCOUNT ON
SELECT Id, Item_Name, Category_Id, Is_Consumable, External_Remarks, (
	CASE WHEN EXISTS (
		SELECT 1
		FROM RESERVATION R
		WHERE ITEM.Id = R.Item_Id
		AND Start_Time < GETDATE()
		AND End_Time > GETDATE()
	) THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT) END
) AS Is_Reserved,
Is_Blocked, Is_OutOfOrder, Is_Faulty, Location, Brand, Model
FROM ITEM, NONCONSUMABLE_ITEM
WHERE Id = Item.Id
END;

CREATE PROCEDURE spInsertNonConsumable (
	@NAME		VARCHAR(50) = NULL,
	@INT_REMARKS	VARCHAR(255) = NULL,
	@EXT_REMARKS	VARCHAR(255) = NULL,
	@C_ID		INT,
	@IS_BLOCKED	BIT = 0,
	@IS_OUT_OF_ORDER	BIT = 0,
	@IS_FAULTY	BIT = 0,
	@LOCATION	VARCHAR(50) = NULL,
	@BRAND		VARCHAR(30),
	@MODEL		VARCHAR(30),
	@EQUIPMENT_NO	VARCHAR(40),
	@SERIAL_NO	VARCHAR(40),
	@ASSIGNEE_EMAIL	VARCHAR(255) = NULL
)
AS
BEGIN
SET NOCOUNT ON
INSERT INTO ITEM (Item_Name, Internal_Tag_Or_Status_Remarks, External_Remarks, Category_Id, Is_Consumable)
VALUES (@NAME, @INT_REMARKS, @EXT_REMARKS, @C_ID, 0);
DECLARE @LASTID AS INT = SCOPE_IDENTITY();
INSERT INTO NONCONSUMABLE_ITEM (Item_Id, Is_Blocked, Is_OutOfOrder, Is_Faulty, Location, Brand, Model,
				Equipment_No, Serial_No, Assignee_Email)
VALUES (@LASTID, @IS_BLOCKED, @IS_OUT_OF_ORDER, @IS_FAULTY, @LOCATION, @BRAND, @MODEL,
	@EQUIPMENT_NO, @SERIAL_NO, @ASSIGNEE_EMAIL);
END;
