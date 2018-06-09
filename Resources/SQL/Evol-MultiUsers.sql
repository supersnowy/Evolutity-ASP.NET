/*** www.evolutility.com - (c) 2008 Olivier Giulieri  ***/
/*    SQL script using Evolutility in a multi-user environment     */


/* --- Users --- */

CREATE TABLE [Evol_User] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[UserID] AS ([ID]) ,
	[Publish] [int] NULL ,
	[Login] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[TagLine] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Firstname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Lastname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[URL] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[email] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[phone] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[intro] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[lastvisit] [datetime] NULL ,
	[nbVisits] [int] NULL ,
	[creationdate] [datetime] NULL ,
	[CommentCount] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [Evol_User] WITH NOCHECK ADD 
	CONSTRAINT [PK_Evol_User] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [Evol_User] WITH NOCHECK ADD 
	CONSTRAINT [DF_Evol_User_Login] DEFAULT ('Anonymous') FOR [Login],
	CONSTRAINT [DF_Evol_User_Password] DEFAULT ('') FOR [Password],
	CONSTRAINT [DF_Evol_User_nbVisits] DEFAULT (0) FOR [nbVisits],
	CONSTRAINT [DF_Evol_User_CommentCount] DEFAULT (0) FOR [CommentCount],
	CONSTRAINT [DF_EVOL_User_creationdate] DEFAULT (getdate()) FOR [creationdate]
GO


INSERT INTO Evol_User (Publish, Login, TagLine, Password, Firstname, Lastname, URL, email, phone, intro)
  VALUES (1, 'John', 'DB guru', 'john', 'John', 'Smith', 'http://www.evolutility.com', 'info@evolutility.com', '', 'Contact me if you have any database questions');
INSERT INTO Evol_User (Publish, Login, TagLine, Password, Firstname, Lastname, URL, email, phone, intro)
  VALUES (1, 'Mary', 'Hi', 'mary', 'Mary', 'Johnson', '', 'mary@evolutility.com', '', 'I do not know what to say');

GO

/* --- User Login --- */

CREATE PROCEDURE EvoSP_Login  (@Login  nvarchar(50),	@Password nvarchar(50))
AS

DECLARE @userid INT
SELECT @userid =  ID FROM [Evol_User] WHERE login= @Login AND password= @Password
IF (@userid>0)
  BEGIN
    	UPDATE [Evol_User] SET lastvisit=getdate(), nbvisits=nbvisits+1  WHERE  ID= @userid
    	SELECT ID, login, firstname, 'Welcome ' + firstname AS welcome FROM [Evol_User]  WHERE  ID= @userid
  END
  
GO

/* --- User comments --- */

CREATE TABLE [Evol_Comment] (
	[ID] [int] IDENTITY (1, 1) NOT NULL ,
	[FormID] [int] NULL ,
	[ItemID] [int] NULL ,
	[UserID] [int] NULL ,
	[creationdate] [smalldatetime] NULL ,
	[message] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [Evol_Comment] WITH NOCHECK ADD 
	CONSTRAINT [PK_Evol_Comment] PRIMARY KEY  CLUSTERED 
	(
		[ID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [Evol_Comment] WITH NOCHECK ADD 
	CONSTRAINT [DF_Evol_Comments_cdate] DEFAULT (getdate()) FOR [creationdate]
GO

 CREATE  INDEX [IDX_UserID] ON [Evol_Comment]([UserID]) ON [PRIMARY]
GO

 CREATE  INDEX [IDX_ItemID] ON [Evol_Comment]([ItemID]) ON [PRIMARY]
GO


