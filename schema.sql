CREATE TABLE PERSON
(	id		VARCHAR(32) 	NOT NULL,
	displayName	VARCHAR(255),
	email	    	VARCHAR(255),
	faculty	  	VARCHAR(50),
	phone		VARCHAR(15),
PRIMARY KEY (id)); 

CREATE TABLE MANAGEMENT_ROLE
(	id		VARCHAR(32)		NOT NULL,
	roleName	VARCHAR(255)		NOT NULL,
	updateTime	DATETIME	  	NOT NULL,
PRIMARY KEY (id),
UNIQUE (roleName));

CREATE TABLE ITEM
(	id		INT		NOT NULL,
	itemName  	VARCHAR(255)	NOT NULL,
	categoryId	INT,
	updateTime	DATETIME	NOT NULL,
PRIMARY KEY (id));

CREATE TABLE CATEGORY
(	id		INT			NOT NULL,
	categoryName	VARCHAR(255)		NOT NULL,
	parentId	INT,
	updateTime	DATETIME		NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (parentId) REFERENCES CATEGORY(id)
	ON DELETE NO ACTION	  ON UPDATE NO ACTION);

ALTER TABLE ITEM
  ADD FOREIGN KEY (categoryId) REFERENCES CATEGORY(id) UPDATE CASCADE;

CREATE TABLE OVERLOOKS
(	roleId		VARCHAR(32)	NOT NULL,
	categoryId	INT		NOT NULL,
PRIMARY KEY (roleId, categoryId),
FOREIGN KEY (roleId) REFERENCES MANAGEMENT_ROLE(id)
	ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (categoryId) REFERENCES CATEGORY(id)
	ON DELETE CASCADE ON UPDATE CASCADE);

CREATE TABLE RESERVATION
(	id		INT		NOT NULL,
	personId	INT		NOT NULL,
	itemId		INT		NOT NULL,
	startTime	DATETIME	NOT NULL,
	endTime		DATETIME	NOT NULL,
	responderId	VARCHAR(32),
	respondTime	DATETIME,
	creationTime	DATETIME	NOT NULL,
PRIMARY KEY (id),
FOREIGN KEY (itemId) REFERENCES ITEM(id)
	ON UPDATE CASCADE,
FOREIGN KEY (responderId) REFERENCES PERSON(id)
	ON UPDATE CASCADE);
