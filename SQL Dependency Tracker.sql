/*
Run this script to create a database called (local).Northcards
Please back up your database before running this script
*/

CREATE DATABASE NorthCards
GO
USE NorthCards
GO


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Creating [dbo].[CustomerCards]'
GO
CREATE TABLE [dbo].[CustomerCards]
(
[CustomerID] [nchar] (5) COLLATE Latin1_General_CI_AS NOT NULL,
[CardType] [int] NOT NULL,
[CardNumber] [char] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[ExpiryDate] [datetime] NOT NULL,
[StartDate] [datetime] NULL,
[IssueNumber] [int] NULL,
[NameOnCard] [nvarchar] (128) COLLATE Latin1_General_CI_AS NOT NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[sp_verifycard]'
GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE dbo.sp_verifycard
@custid nchar(5) AS
SELECT CustomerCards.CardNumber FROM CustomerCards
RETURN (0)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[sp_getcardforcustomer]'
GO
CREATE PROCEDURE dbo.sp_getcardforcustomer
    @custid nchar(5)
AS
SELECT CardType, CardNumber, ExpiryDate, StartDate, IssueNumber 
FROM CustomerCards
WHERE CustomerID=@custid
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[sp_deletecustomercard]'
GO
CREATE PROCEDURE dbo.sp_deletecustomercard
    @custid nchar(5) AS
DELETE FROM CustomerCards WHERE CustomerCards.CustomerID IN
( SELECT CustomerCards.CustomerID FROM CustomerCards, Northwind..Customers
WHERE Northwind..Customers.CustomerID = CustomerCards.CustomerID
AND CustomerCards.CustomerID = @custid )
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[sp_getnamesforcard]'
GO
CREATE PROCEDURE dbo.sp_getnamesforcard
@custid nchar(5)
AS 
SELECT CustomerCards.NameOnCard, Northwind..Customers.ContactName
FROM CustomerCards, Northwind..Customers
WHERE CustomerCards.CustomerID = @custid AND CustomerCards.CustomerID = Northwind..Customers.CustomerID
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[sp_createcustomercard]'
GO
CREATE PROCEDURE dbo.sp_createcustomercard
@custid nchar(5),
@cardtype int,
@cardnumber nvarchar(255),
@expirydate datetime,
@startdate datetime,
@issuenumber int,
@nameoncard nvarchar(255) AS
SELECT * FROM CustomerCards, Northwind..Customers
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[AuditInfo]'
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TABLE [dbo].[AuditInfo]
(
[Foo] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[Bar] [char] (10) COLLATE Latin1_General_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[SurveyResults]'
GO
CREATE TABLE [dbo].[SurveyResults]
(
[SurveryNumber] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[A] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[B] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[C] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[D] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[E] [char] (10) COLLATE Latin1_General_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [dbo].[TellerInfo]'
GO
CREATE TABLE [dbo].[TellerInfo]
(
[ID] [char] (10) COLLATE Latin1_General_CI_AS NULL,
[Baz] [char] (10) COLLATE Latin1_General_CI_AS NULL
)

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
