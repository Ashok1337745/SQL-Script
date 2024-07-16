USE tempdb
GO
IF  EXISTS (SELECT name FROM sys.databases 
		WHERE name = N'WidgetProduction'
)
DROP DATABASE WidgetProduction
GO

CREATE DATABASE WidgetProduction
GO
USE WidgetProduction
GO

CREATE TABLE [dbo].[WidgetPrices] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[WidgetID] [int] NULL ,
	[Price] [money] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Widgets] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WidgetReferences] (
	[WidgetID] [int] IDENTITY NOT NULL ,
	[Reference] [varchar] (50) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WidgetReferences] WITH NOCHECK ADD 
	CONSTRAINT [PK_WidgetReferences] PRIMARY KEY  NONCLUSTERED 
	(
		[WidgetID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WidgetPrices] WITH NOCHECK ADD 
	CONSTRAINT [PK_WidgetPrices] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Widgets] WITH NOCHECK ADD 
	CONSTRAINT [PK_Widgets] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO

CREATE VIEW dbo.CurrentPrices
AS
SELECT WidgetID, Price, Description
FROM Widgets INNER JOIN
    WidgetPrices ON Widgets.RecordID = WidgetPrices.WidgetID

GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO


IF  EXISTS (SELECT name FROM sys.databases 
		WHERE name = N'WidgetStaging'
)
DROP DATABASE WidgetStaging
GO

CREATE DATABASE WidgetStaging
GO
USE WidgetStaging
GO

CREATE TABLE [dbo].[WidgetPrices] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[WidgetID] [int] NULL ,
	[Price] [money] NULL ,
	[DateValidFrom] [datetime] NULL ,
	[DateValidTo] [datetime] NULL ,
	[Active] [char] (1) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Widgets] (
	[RecordID] [int] IDENTITY (1, 1) NOT NULL ,
	[Description] [varchar] (50) NULL ,
	[SKU] [varchar] (20) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WidgetReferences] (
	[WidgetID] [int] NOT NULL ,
	[Reference] [varchar] (50) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[WidgetReferences] WITH NOCHECK ADD 
	CONSTRAINT [PK_WidgetReferences] PRIMARY KEY  NONCLUSTERED 
	(
		[WidgetID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WidgetPrices] WITH NOCHECK ADD 
	CONSTRAINT [DF_WidgetPrices_DateValidFrom] DEFAULT (getdate()) FOR [DateValidFrom],
	CONSTRAINT [DF_WidgetPrices_Active] DEFAULT ('N') FOR [Active],
	CONSTRAINT [PK_WidgetPrices] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Widgets] WITH NOCHECK ADD 
	CONSTRAINT [PK_Widgets] PRIMARY KEY  NONCLUSTERED 
	(
		[RecordID]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_WidgetPrices] ON [dbo].[WidgetPrices]([WidgetID]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_WidgetPrices_1] ON [dbo].[WidgetPrices]([DateValidFrom]) ON [PRIMARY]
GO

 CREATE  INDEX [IX_WidgetPrices_2] ON [dbo].[WidgetPrices]([DateValidTo]) ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[WidgetPrices]  TO [public]
GO

DENY  REFERENCES ,  INSERT ,  DELETE ,  UPDATE  ON [dbo].[WidgetPrices]  TO [public] CASCADE 
GO

GRANT  SELECT  ON [dbo].[Widgets]  TO [public]
GO

DENY  REFERENCES ,  INSERT ,  DELETE ,  UPDATE  ON [dbo].[Widgets]  TO [public] CASCADE 
GO

ALTER TABLE [dbo].[WidgetPrices] ADD 
	CONSTRAINT [FK_WidgetPrices_Widgets] FOREIGN KEY 
	(
		[WidgetID]
	) REFERENCES [dbo].[Widgets] (
		[RecordID]
	)
GO

SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO

CREATE VIEW dbo.CurrentPrices
AS
SELECT WidgetPrices.WidgetID, WidgetPrices.Price, 
    Widgets.Description
FROM dbo.Widgets INNER JOIN
    dbo.WidgetPrices ON 
    dbo.Widgets.RecordID = dbo.WidgetPrices.WidgetID
WHERE dbo.WidgetPrices.Active = 'Y'

GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO

GRANT  SELECT  ON [dbo].[CurrentPrices]  TO [public]
GO

DENY  INSERT ,  DELETE ,  UPDATE  ON [dbo].[CurrentPrices]  TO [public] CASCADE 
GO

SET QUOTED_IDENTIFIER  ON    SET ANSI_NULLS  ON 
GO

CREATE PROCEDURE prcActivatePrices  AS

UPDATE WidgetPrices SET Active='N' WHERE GetDate()<DateValidTo OR GetDate()>DateValidFrom
UPDATE WidgetPrices SET Active='Y' WHERE GetDate()>=DateValidFrom OR GetDate()<=DateValidFrom


GO
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 
GO

DENY  EXECUTE  ON [dbo].[prcActivatePrices]  TO [public] CASCADE 
GO

