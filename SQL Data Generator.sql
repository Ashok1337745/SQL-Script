CREATE TABLE [dbo].[Employees]
(
[EmployeeID] [int] NOT NULL,
[FirstName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employees] ADD CONSTRAINT [PK__Employee__7AD04FF1DA86D751] PRIMARY KEY CLUSTERED ([EmployeeID]) ON [PRIMARY]
GO