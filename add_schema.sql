DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS CONSUMABLE_ITEM;
DROP TABLE IF EXISTS NONCONSUMABLE_ITEM;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS CATEGORY;
DROP TABLE IF EXISTS PERSON;

CREATE TABLE PERSON --to prevent needless bloating, only record the person's info after he/she has made a booking request
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Graph_Id	VARCHAR(32),
	Display_Name	VARCHAR(255),
	Email	    	VARCHAR(255)	NOT NULL,
	Faculty	  	VARCHAR(50),
	Phone		VARCHAR(15)
);

CREATE TABLE CATEGORY
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Category_Name	VARCHAR(50)	NOT NULL UNIQUE,
	Parent_Id	INT,
	Update_Time	DATETIME	NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (Parent_Id) REFERENCES CATEGORY(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION);

CREATE TABLE ITEM
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Item_Name  	VARCHAR(50)	NOT NULL,
 	Internal_Tag_Or_Status_Remarks
 			VARCHAR(255),
 	External_Remarks
 			VARCHAR(255),
	Category_Id	INT		NOT NULL,
 	Is_Consumable	BIT		NOT NULL,
	Update_Time	DATETIME	NOT NULL DEFAULT GETDATE(),
FOREIGN KEY (Category_Id) REFERENCES CATEGORY(Id)
 	ON DELETE NO ACTION	ON UPDATE CASCADE);

CREATE TABLE CONSUMABLE_ITEM
(	Item_Id		INT		NOT NULL,
	Value_Per_Amt	INT		NOT NULL DEFAULT 0,
	Value_Unit	VARCHAR(10)	NOT NULL DEFAULT 'pc',
	Amount_In	INT		NOT NULL DEFAULT 0,
	Amount_Out	INT		NOT NULL DEFAULT 0,
	Amount_Bal	AS		(Amount_In - Amount_Out),
	Amount_Unit	VARCHAR(10)	NOT NULL DEFAULT 'set',
	Next_In_Amt	INT,
	Next_In_Date	DATETIME,
	Purchase_Date	DATETIME,
	Expiry_Date	DATETIME,
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON DELETE CASCADE	ON UPDATE CASCADE);

CREATE TABLE NONCONSUMABLE_ITEM
(	Item_Id		INT		NOT NULL,
	--Is_Reserved calculated in stored procedure
	Is_Blocked	BIT		NOT NULL DEFAULT 0,
	Is_OutOfOrder	BIT		NOT NULL DEFAULT 0,
	Is_Faulty	BIT		NOT NULL DEFAULT 0,
	Location	VARCHAR(50),
	Brand		VARCHAR(30),
	Model		VARCHAR(30),
	Equipment_No	VARCHAR(40),
	Serial_No	VARCHAR(40),
	Assignee_Email	VARCHAR(255),
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON DELETE CASCADE	ON UPDATE CASCADE);

CREATE TABLE RESERVATION
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Item_Id		INT		NOT NULL,
 	Loan_Location	VARCHAR(50),
	Start_Time	DATETIME	NOT NULL DEFAULT GETDATE(),
 	Is_Released	BIT		NOT NULL DEFAULT 0,
	End_Time	DATETIME	NOT NULL,
 	Is_Returned	BIT		NOT NULL DEFAULT 0,
 	Person_Id	INT		NOT NULL,
 	Supervisor_Email	VARCHAR(255)	NOT NULL,
 	Responder_Id_A	INT,
 	Responder_Id_B	INT,
 	Is_Pending	BIT		NOT NULL DEFAULT 1,
 	Is_Approved_Sup	BIT		NOT NULL DEFAULT 0,
 	Is_Approved_A	BIT		NOT NULL DEFAULT 0,
 	Is_Approved_B	BIT		NOT NULL DEFAULT 0,
	Creation_Time	DATETIME	NOT NULL DEFAULT (GETDATE()),
	Update_Time	DATETIME,
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON UPDATE CASCADE,
FOREIGN KEY (Responder_Id_A) REFERENCES PERSON(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION,
FOREIGN KEY (Responder_Id_B) REFERENCES PERSON(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION);

EXEC spInsertCategory @NAME='Sample Category A';
EXEC spInsertCategory @NAME='Sample Category B';
EXEC spInsertCategory @NAME='Sample Category C';
EXEC spInsertConsumable
	@NAME		='Sample Item w/ All Details',
	@INT_REMARKS	='Only the admin can see this; Note @NEXT_IN_AMT @NEXT_IN_DATE, @PURCHASE_DATE, @EXPIRY_DATE params also available',
	@EXT_REMARKS	='All can see this',
	@C_ID		=0,
	@VAL_PER_AMT	=100,
	@VAL_UNIT	='pc',
	@AMT_IN		=20,
	@AMT_OUT	=5,
	@AMT_UNIT	='set'
EXEC spInsertConsumable @NAME='Sample Consumable Item w/ Minimal Details', @C_ID=0;
EXEC spInsertNonConsumable @NAME='Sample Non-Consumable Item w/ Minimal Details', @C_ID=0;
EXEC spGetCategories;
--EXEC spPublicGetAllConsumables;
EXEC spPublicGetAllNonConsumables;
