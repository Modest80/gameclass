USE [GameClass]
GO
/****** Объект:  Trigger [dbo].[ServicesRunpadAutoUpdate]    Дата сценария: 01/22/2013 19:00:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[ServicesRunpadAutoUpdate] ON [dbo].[ServicesRunpad] 
FOR INSERT, UPDATE, DELETE 
AS 
BEGIN 
DECLARE @idI INT 
DECLARE @idD INT 
DECLARE @idAction INT 
DECLARE @isdeleted INT 
DECLARE IDcursor CURSOR FOR SELECT I.id AS [idI], D.id AS [idD] 
FROM INSERTED AS I 
FULL OUTER JOIN DELETED AS D ON I.id = D.id 
OPEN IDcursor 
FETCH NEXT FROM IDcursor INTO @idI, @idD 
WHILE @@FETCH_STATUS = 0 
BEGIN 
IF NOT(@idI IS NULL) AND (@idD IS NULL) 
SET @idAction = 1 --Insert 
IF (@idI IS NULL) AND NOT(@idD IS NULL) 
SET @idAction = 2 --Delete 
IF NOT(@idI IS NULL) AND NOT(@idD IS NULL) 
SET @idAction = 3 --Update 
INSERT AutoUpdate(idTable, idAction, idRecord) VALUES(5/*ServicesRunpad*/, @idAction, ISNULL(@idI,@idD)) 
FETCH NEXT FROM IDcursor INTO @idI, @idD 
END 
CLOSE IDcursor 
DEALLOCATE IDcursor 
END 
