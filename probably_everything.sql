DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS CONSUMABLE_ITEM;
DROP TABLE IF EXISTS NONCONSUMABLE_ITEM;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS CATEGORY;
DROP TABLE IF EXISTS PERSON;

CREATE TABLE PERSON --to prevent needless bloating, only record the person's info after he/she has made a booking request
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Graph_Id	VARCHAR(32)	UNIQUE,
	Display_Name	VARCHAR(255),
	Email	    	VARCHAR(255)	NOT NULL,
	Faculty	  	VARCHAR(50),
	Phone		VARCHAR(15)
);

CREATE TABLE CATEGORY
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Category_Name	VARCHAR(50)	NOT NULL UNIQUE,
	Parent_Id	INT,
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
	Update_Time	DATETIME	NOT NULL,
FOREIGN KEY (Category_Id) REFERENCES CATEGORY(Id)
 	ON DELETE NO ACTION	ON UPDATE CASCADE);

CREATE TABLE CONSUMABLE_ITEM
(	Item_Id		INT		NOT NULL,
	Value_Per_Amt	INT		NOT NULL,
	Value_Unit	VARCHAR(10)	NOT NULL,
	Amount_In	INT		NOT NULL,
	Amount_Out	INT		NOT NULL,
	--Amount_Bal to be derived
	Amount_Unit	VARCHAR(10)	NOT NULL,
	Next_In_Amt	INT,
	Next_In_Date	DATETIME,
	Purchase_Date	DATETIME,
	Expiry_Date	DATETIME,
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON DELETE CASCADE	ON UPDATE CASCADE);

CREATE TABLE NONCONSUMABLE_ITEM
(	Item_Id		INT		NOT NULL,
	--Is_Avalable to be derived
	Is_Blocked	BIT		DEFAULT 0,
	Is_OutOfOrder	BIT		DEFAULT 0,
	Is_Faulty	BIT		DEFAULT 1,
	Location	VARCHAR(50),
	Brand		VARCHAR(30)	NOT NULL,
	Model		VARCHAR(30)	NOT NULL,
	Equipment_No	VARCHAR(40)	NOT NULL,
	Serial_No	VARCHAR(40)	NOT NULL,
	Assignee_Email	VARCHAR(255),
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON DELETE CASCADE	ON UPDATE CASCADE);

CREATE TABLE RESERVATION
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Item_Id		INT		NOT NULL,
 	Loan_Location	VARCHAR(50),
	Start_Time	DATETIME	NOT NULL,
 	Is_Released	BIT		DEFAULT 0,
	End_Time	DATETIME	NOT NULL,
 	Is_Returned	BIT		DEFAULT 0,
 	Person_Id	INT		NOT NULL,
 	Supervisor_Email	VARCHAR(255)	NOT NULL,
 	Responder_Id_A	INT,
 	Responder_Id_B	INT,
 	Is_Pending	BIT		DEFAULT 1,
 	Is_Approved_Sup	BIT		DEFAULT 0,
 	Is_Approved_A	BIT		DEFAULT 0,
 	Is_Approved_B	BIT		DEFAULT 0,
	Creation_Time	DATETIME	NOT NULL,
	Update_Time	DATETIME,
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON UPDATE CASCADE,
FOREIGN KEY (Responder_Id_A) REFERENCES PERSON(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION,
FOREIGN KEY (Responder_Id_B) REFERENCES PERSON(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION);

DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS CONSUMABLE_ITEM;
DROP TABLE IF EXISTS NONCONSUMABLE_ITEM;
DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS CATEGORY;
DROP TABLE IF EXISTS PERSON;

CREATE TABLE PERSON --to prevent needless bloating, only record the person's info after he/she has made a booking request
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Graph_Id	VARCHAR(32)	UNIQUE,
	Display_Name	VARCHAR(255),
	Email	    	VARCHAR(255)	NOT NULL,
	Faculty	  	VARCHAR(50),
	Phone		VARCHAR(15)
);

CREATE TABLE CATEGORY
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Category_Name	VARCHAR(50)	NOT NULL UNIQUE,
	Parent_Id	INT,
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
	Update_Time	DATETIME	NOT NULL,
FOREIGN KEY (Category_Id) REFERENCES CATEGORY(Id)
 	ON DELETE NO ACTION	ON UPDATE CASCADE);

CREATE TABLE CONSUMABLE_ITEM
(	Item_Id		INT		NOT NULL,
	Value_Per_Amt	INT		NOT NULL,
	Value_Unit	VARCHAR(10)	NOT NULL,
	Amount_In	INT		NOT NULL,
	Amount_Out	INT		NOT NULL,
	--Amount_Bal to be derived
	Amount_Unit	VARCHAR(10)	NOT NULL,
	Next_In_Amt	INT,
	Next_In_Date	DATETIME,
	Purchase_Date	DATETIME,
	Expiry_Date	DATETIME,
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON DELETE CASCADE	ON UPDATE CASCADE);

CREATE TABLE NONCONSUMABLE_ITEM
(	Item_Id		INT		NOT NULL,
	--Is_Avalable to be derived
	Is_Blocked	BIT		DEFAULT 0,
	Is_OutOfOrder	BIT		DEFAULT 0,
	Is_Faulty	BIT		DEFAULT 1,
	Location	VARCHAR(50),
	Brand		VARCHAR(30)	NOT NULL,
	Model		VARCHAR(30)	NOT NULL,
	Equipment_No	VARCHAR(40)	NOT NULL,
	Serial_No	VARCHAR(40)	NOT NULL,
	Assignee_Email	VARCHAR(255),
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON DELETE CASCADE	ON UPDATE CASCADE);

CREATE TABLE RESERVATION
(	Id		INT		IDENTITY(0,1)	PRIMARY KEY,
	Item_Id		INT		NOT NULL,
 	Loan_Location	VARCHAR(50),
	Start_Time	DATETIME	NOT NULL,
 	Is_Released	BIT		DEFAULT 0,
	End_Time	DATETIME	NOT NULL,
 	Is_Returned	BIT		DEFAULT 0,
 	Person_Id	INT		NOT NULL,
 	Supervisor_Email	VARCHAR(255)	NOT NULL,
 	Responder_Id_A	INT,
 	Responder_Id_B	INT,
 	Is_Pending	BIT		DEFAULT 1,
 	Is_Approved_Sup	BIT		DEFAULT 0,
 	Is_Approved_A	BIT		DEFAULT 0,
 	Is_Approved_B	BIT		DEFAULT 0,
	Creation_Time	DATETIME	NOT NULL,
	Update_Time	DATETIME,
FOREIGN KEY (Item_Id) REFERENCES ITEM(Id)
	ON UPDATE CASCADE,
FOREIGN KEY (Responder_Id_A) REFERENCES PERSON(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION,
FOREIGN KEY (Responder_Id_B) REFERENCES PERSON(Id)
	ON DELETE NO ACTION	ON UPDATE NO ACTION);

INSERT INTO CATEGORY (Category_Name) VALUES ('Sample Category');
INSERT INTO CATEGORY (Category_Name) VALUES ('Sample Category 2');
