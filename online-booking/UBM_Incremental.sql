

IF COL_LENGTH('mstUser','AccessToken') IS NULL 
BEGIN
	 ALTER TABLE mstUser ADD AccessToken VARCHAR(1000)
END
GO
----------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmBookingStatus]',N'U') IS NULL
BEGIN
	CREATE TABLE ubmBookingStatus(
	BookingStatusID INT  PRIMARY KEY,
	StatusName VARCHAR(40)
	)
END
GO
---------------------------------------------------------------
 IF   (SELECT COUNT(1) FROM  ubmBookingStatus ) = 0
 BEGIN
	INSERT INTO ubmBookingStatus(BookingStatusID,StatusName)
	SELECT 1,'Initiate Booking'
	UNION SELECT 2,'Sales Manger Review'
	UNION SELECT 3,'CRM Review'
	UNION SELECT 4,'Account Review'
	UNION SELECT 5,'Admin/CFO'
	UNION SELECT 6,'Confirm'
	UNION SELECT 7,'Rejected'
END
GO 
  -----------------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmMailConfigure]',N'U') IS NULL
BEGIN
	CREATE TABLE ubmMailConfigure(
	MailConfigureID INT PRIMARY KEY IDENTITY(1,1),
	GroupID DECIMAL(18,0),
	ConfigureType VARCHAR(10),
	SenderName VARCHAR(200) NULL,
	SMTPServer VARCHAR(200 )  NULL,
	UserName VARCHAR(200)  NULL,	
	Password VARCHAR(200)  NULL,	
	PerHourMail INT  NULL,
	PortNo INT  NULL, 
	SmsUrl VARCHAR(MAX)  NULL,	
	TokenWA VARCHAR(200)  NULL,	
	PhoneWA VARCHAR(200)  NULL,	 
	BasedOn VARCHAR(50)  NULL,
	Provider VARCHAR(50)  NULL,
	CreatedBy INT,
	CreatedOn SMALLDATETIME,
	UpdatedBy INT NULL,
	UpdatedOn SMALLDATETIME NULL,
	IsActive BIT
)
END
GO
 -----------------------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmDocument]',N'U') IS NULL
BEGIN
	CREATE TABLE ubmDocument(
	DocumentID INT PRIMARY KEY IDENTITY(1,1),
	GroupID DECIMAL(18,0),
	ApplicationType VARCHAR(100),
	DocumentName VARCHAR(100),
	IsMandatory BIT,
	CreatedBy INT,
	CreatedOn SMALLDATETIME,
	UpdatedBy INT NULL,
	UpdatedOn SMALLDATETIME NULL,
	IsActive BIT
)
END
GO

------------------------------------------------------------------------------------------------------------- 
IF OBJECT_ID(N'[dbo].[ubmTemplateEmbeded]',N'U') IS NULL
BEGIN
 CREATE TABLE ubmTemplateEmbeded
 (
	TemplateEmbededID INT IDENTITY(1,1) PRIMARY KEY,
	ProcessType VARCHAR(20),
	FieldName VARCHAR(100),
	IsActive BIT DEFAULT(1)	
) 
END
GO
-----------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmUsers]',N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ubmUsers](
	[ubmUserID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NULL,
	[RoleName] [varchar](20) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [smalldatetime] NULL,
	[updatedOn] [smalldatetime] NULL,
	[IsActive] [bit] NULL,
	[GroupID] DECIMAL(18,0) NULL,
)
END
GO
-----------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmUnitDetail]',N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ubmUnitDetail](
	[UnitDetailID] [int] IDENTITY(1,1) NOT NULL,
	[UnitID] [int] NULL,
	[BasicAmount] [decimal](18, 2) NULL,
	[AdditionalAmount] [decimal](18, 2) NULL,
	[DiscountAmount] [decimal](18, 2) NULL,
	[NetAmount] [decimal](18, 2) NULL,
	[minSaleAmount] [decimal](18, 2) NULL,
	[maxSaleAmount] [decimal](18, 2) NULL,
	[IntPlanID] [int] NULL,
	[PayPlanID] [int] NULL,
	[Status] [int] NULL,
	[Remarks] [varchar](500) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [smalldatetime] NULL,
	[groupID] DECIMAL(18,0) NULL,
)
END
GO
-----------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmUnitBooking]',N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ubmUnitBooking](
	[UbmID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [decimal](18, 0),
	[UnitType] [varchar](20) NULL,
	[UnitID] [int] NULL,
	[CustMobNo] [decimal](18, 0),
	[CustEmail] [varchar](100),
	[ReleaseUnitDate] [smalldatetime] NULL,
	[ApplicationType] [varchar](30),
	[BookingStatusID] [int], 
	[StatusDate] [smalldatetime],
	[CreatedBy] [int],
	[CreatedOn] [smalldatetime] 
)
END
GO

-----------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmProjectPermission]',N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ubmProjectPermission](
	[ProjectPermissionID] [int] IDENTITY(1,1) NOT NULL,
	[ubmUserID] [int] NULL,
	[ProjectID] [int] NULL,
	[TowerID] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [smalldatetime] NULL,
	[GroupID] DECIMAL(18,0) NULL
)
END
GO
-----------------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmBookedUnitPayment]',N'U') IS NULL
BEGIN

CREATE TABLE [dbo].[ubmBookedUnitPayment](
	[UbmPaymentId] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [decimal](18,0),
	[UbmID] [int] ,
	[PaymentMode] [varchar](30) NULL,
	[ChequeNo] [varchar](100) NULL,
	[ChequeDate] [smalldatetime] NULL,
	[BankName] [varchar](100) NULL,
	[BranchName] [varchar](100) NULL,
	[Amount] [decimal](18, 0) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [smalldatetime] NULL 
)
	ALTER TABLE ubmBookedUnitPayment
	ADD CONSTRAINT FK_ubmBookedUnit_Payment FOREIGN KEY (UbmID) REFERENCES ubmUnitBooking(UbmID)
END
GO

 
---------------------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID(N'[dbo].[ubmKycDocument]',N'U') IS NULL
BEGIN

CREATE TABLE ubmKycDocument(
UbmKycid int IDENTITY(1,1) Primary Key,
UbmID int,
DocID varchar(20),
DocUrl varchar(500),
CreatedBy int,
GroupID decimal(18,0),
CreatedOn smalldatetime,
)
END
GO
----------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmTemplate]',N'U') IS NULL
BEGIN


CREATE TABLE [dbo].[ubmTemplate](
	[TemplateID] [int] IDENTITY(1,1) NOT NULL,
	[GroupID] [decimal](18, 0) NULL,
	[ProjectID] [int] NULL,
	[ProcessType] [varchar](20) NULL,
	[TemplateType] [varchar](20) NULL,
	[TemplateMsg] [nvarchar](max) NULL,
	[VendorTemplateID] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [smalldatetime] NULL,
	[UpdatedBy] [int] NULL,
	[UpdatedOn] [smalldatetime] NULL,
	[IsActive] [bit] NULL
	)
	END
GO
---------------------------------------------------------------------------------------------------------------------

IF OBJECT_ID(N'[dbo].[ubmApplicantDetails]',N'U') IS NULL
BEGIN

CREATE TABLE ubmApplicantDetails(
UbmApplicantID int IDENTITY(1,1) primary key,
UbmID int,
ApplicantName varchar(100),
ApplicantType INT,
SO varchar (100),
Dob smalldatetime,
Age  DECIMAL(18,0),
Nationality varchar (100),
Occupation varchar (100),
Pan varchar (100),
Aadharno varchar (100),
Address varchar (1000),
CityId int,
StateId int,
CountryName varchar(100),
Pin varchar (1000),
Email varchar (1000),
Phone1 DECIMAL(18,0),
Phone2  DECIMAL(18,0),
NameofOrganisation varchar (1000),
Designation varchar (100),
ApplicantionDate smalldatetime,
CreatedBy int,
Flag int,
GroupID  DECIMAL(18,0),
CreatedOn smalldatetime
)
END
GO
--------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmstate]',N'U') IS NULL
BEGIN
CREATE TABLE ubmstate(
StateID int primary key,
StateName varchar(100)
)
END
GO
------------------------------------------------------
IF OBJECT_ID(N'[dbo].[ubmCity]',N'U') IS NULL
BEGIN
CREATE TABLE ubmCity(
CityID int Primary Key,
StateID int,
CityName varchar(100)
)
END
GO 

-------------------------------------------------------

IF OBJECT_ID(N'[dbo].[ubmLogs]',N'U') IS NULL
BEGIN
CREATE Table ubmLogs (
LogID int IDENTITY(1,1) primary key,
UbmID int,
BookingStatusID int,
CreatedBy int,
Remarks VARCHAR(500),
CreatedOn smalldatetime
)
END
GO 


-----------------------------------------------------------


IF OBJECT_ID(N'[dbo].[ubmCustomerLogin]',N'U') IS NULL
BEGIN
CREATE TABLE ubmCustomerLogin(
CMID INT IDENTITY(1,1) PRIMARY KEY,
CustomerEmail varchar(30),
Password varchar(100),
UbmID int,
GroupID decimal(18,0),
CreatedBy int,
CreatedAt smalldatetime,
LoginAt smalldatetime,
isSessionExpired bit
)
END
GO 



IF OBJECT_ID(N'[dbo].[ubmControlMaster]',N'U') IS NULL
BEGIN
CREATE TABLE ubmControlMaster(
MasterID int IDENTITY(1,1) PRIMARY KEY,
RoleName VARCHAR(50),
MenuType VARCHAR(50),
isTab bit,
isCreate bit,
isEdit bit,
isView bit,
isDelete bit,
isApproved bit,
GroupID DECIMAL(18,0)
)
END
GO 



--------------------------------------------STORED PROCEDURES--------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_updateToken]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_updateToken]
GO

CREATE PROC ubm_updateToken    
@userID decimal,    
@token varchar(1000),    
@groupID decimal    
AS    
BEGIN    
UPDATE mstUser SET AccessToken=@token where UserID=@userID    
END 
GO
----------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_userList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_userList]
GO
    
CREATE PROC ubm_userList              
@groupID DECIMAL(18,0),              
@roleID INT,      
@type varchar(10)              
AS              
BEGIN      
      
IF(@type='RemsUser')         
BEGIN           
SELECT mu.UserID,ISNULL(MU.UserName,'')UserName,isnull(MU.UserName,'') [Full Name],        
 MU.Password,MU.isActive,MU.RoleID,MU.email,MR.RoleName,        
 ISNULL(ubm.rolename , '-')ubRoleName,        
 ISNULL(ubm.isActive, 0 )ubStatus,        
ISNULL(MR.RoleDescription,''), ISNULL(mu.LastLoginDate,GETDATE())LastLoginDate FROM mstUser MU           
INNER JOIN mstRole MR ON MR.RoleID = MU.RoleID        
LEFT JOIN ubmUsers ubm ON ubm.userid = mu.userid          
WHERE MU.GroupID=@groupID AND  ubm.RoleName<>'Admin/CFO' -- AND @roleID = MU.RoleID           
END      
ELSE IF(@type='UBMUser')      
BEGIN      
	SELECT UU.ubmUserID,MU.UserName,UU.RoleName 
	FROM ubmUsers (NOLOCK) UU      
	INNER JOIN mstUser (NOLOCK) MU ON MU.UserID = UU.UserID      
	WHERE UU.IsActive =1 AND UU.GroupID = @groupID    AND  UU.RoleName<>'Admin/CFO'    
END      
END 
GO
----------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_userLogin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_userLogin]
GO

CREATE PROC ubm_userLogin --EXEC ubm_userLogin 'roopak.kumar@wmgpl.com','s0MjqzELKIRdNXmsWZFKGQ=='            
@userName varchar(100),              
@password varchar(100)              
AS              
BEGIN              
 DECLARE @ErrorMessage NVARCHAR(2048)         
 DECLARE @GroupID DECIMAL(18,0)      
 --EMAIL VALIDATION      
          

 IF NOT EXISTS (SELECT 1 FROM Realestate..MSTUSER WHERE UserName = @userName)              
    BEGIN              
        Set @ErrorMessage = 'UserName does not exist in Server';              
        RAISERROR(@ErrorMessage, 16, 1);              
        RETURN;              
    END        
       
  ---PASSWORD VALIDATION      
              
   IF NOT EXISTS (SELECT 1 FROM Realestate..MSTUSER WHERE UserName = @userName AND Password= @password)              
    BEGIN              
        Set @ErrorMessage = 'Password does not match with existing Email';              
        RAISERROR(@ErrorMessage, 16, 1);              
        RETURN;              
    END         
       
 SET @GroupID=(SELECT GroupID FROM Realestate..MSTUSER WHERE UserName = @userName AND Password= @password)      
       
 --- STATUS VALIDATION      
      
 IF NOT EXISTS (              
 SELECT 1 FROM Realestate..MSTUSER MU       
 INNER JOIN Realestate..ubmUsers ubm ON ubm.UserID = mu.UserID                   
 WHERE UserName = @userName AND Password= @password AND  MU.GroupID = @GroupID)              
 BEGIN              
   Set @ErrorMessage = 'User is In-active Contact to your Administrtor';              
        RAISERROR(@ErrorMessage, 16, 1);              
        RETURN;              
 END              
         
   ----ROLE IS INACTIVE IN UBM APP       
              
 IF NOT EXISTS(              
  SELECT 1 FROM Realestate..MSTUSER MU              
 INNER JOIN Realestate..ubmUsers ubm ON ubm.UserID = mu.UserID                   
 WHERE UserName = @userName AND Password= @password AND  MU.GroupID = @GroupID and ubm.IsActive = 1      
 )              
 BEGIN              
  Set @ErrorMessage = 'Role is Inactive Of above User. Contact to your Administrtor';              
        RAISERROR(@ErrorMessage, 16, 1);              
        RETURN;              
 END              
              
 ELSE              
 BEGIN         
       
    ----SUCCESSFULLY LOGIN      
         
 SELECT UBM.ubmUserID as UserID, mu.UserName,MU.RoleID, UBM.RoleName,mu.email,MU.GroupID,mu.LastLoginDate,isnull(MU.UserType,0)UserType,AU.Credential,AU.CredentialInfo,EC.DTNullError,EC.ETADLLITEVITCA       
 FROM Realestate..MSTUSER (NOLOCK)MU        
 INNER JOIN Realestate..ubmUsers (NOLOCK) UBM ON UBM.UserID= MU.UserID        
 INNER JOIN Realestate..ECNECSIL (NOLOCK) EC ON EC.GroupID = MU.GroupID       
 INNER JOIN (      
 SELECT GroupID,Credential,CredentialInfo  FROM mstUser(NOLOCK) WHERE GroupID=@GroupID AND UserType=2      
  AND UserName NOT LIKE  ('%pingasolutions.com')      
 )  AS AU ON   AU.GroupID=MU.GroupID           
 WHERE mu.UserName = @userName AND mu.Password= @password AND MU.isActive = 1      
 AND UBM.IsActive=1 AND UBM.GroupID = @GroupID       
       
 END              
END         
  GO           
        
 ---------------------------------------------------------------------------------------------------------
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddubmUser]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_AddubmUser]
GO

       
CREATE PROCEDURE ubm_AddubmUser        
    @userID int,        
    @roleName varchar(20),        
    @CreatedBy int,      
 @GroupID DECIMAL(18,0)      
AS        
BEGIN        
    DECLARE @ubmUserID int;         
        
    SELECT @ubmUserID = UserID FROM ubmUsers(NOLOCK) WHERE UserID = @userID;        
        
    IF (@ubmUserID IS NULL)        
    BEGIN        
        INSERT INTO ubmUsers (UserID, RoleName, CreatedBy, CreatedOn, isActive,GroupID)        
        VALUES (@userID, @roleName, @CreatedBy, GETDATE(), 1,@GroupID);        
    END        
    ELSE        
    BEGIN         
        UPDATE ubmUsers         
        SET RoleName = @roleName, UpdatedOn = GETDATE()         
        WHERE UserID = @userID;        
    END        
END
GO

------------------------------------------------------

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_ChangeUBMStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_ChangeUBMStatus]
GO
     
CREATE PROC ubm_ChangeUBMStatus      
@userID int,      
@groupID DECIMAL(18,0)      
AS      
BEGIN      
IF NOT EXISTS(SELECT GroupID FROM ubmUsers(NOLOCK) WHERE UserID = @userID AND GroupID = @groupID )      
BEGIN      
	RAISERROR('This User is not Exists in UBM APP, Kindly First Add it', 17,1) 
	RETURN     
END      
ELSE      
BEGIN        
	UPDATE Realestate..ubmUsers SET IsActive = CASE WHEN IsActive=0 THEN 1 ELSE 0 END WHERE UserID = @userID and GroupID= @groupID      
END      
END 
GO


------------------------------------------------

 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_getProjectDataforBooking]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_getProjectDataforBooking]
GO
 CREATE PROC ubm_getProjectDataforBooking
@groupID DECIMAL(18,0),
@ubmUserID int,
@projectID INT=NULL,
@towerID INT=NULL,
@floorID INT=NULL,
@unitID INT=NULL,
@type varchar(20)
AS
BEGIN
IF(@type='Project')
BEGIN
 select mp.projectid,mp.projectname
 from mstProject (NOLOCK) mp
 INNER JOIN ubmProjectPermission (NOLOCK) up on up.projectid=mp.projectid
 INNER JOIN mstUnit MU ON MU.ProjectID = UP.ProjectID
 INNER JOIN ubmUnitDetail (NOLOCK) UBUD ON UBUD.UnitID = MU.UnitID AND UBUD.Status = 2
 where up.groupid=@groupID and ubmuserid=@ubmUserID
 group by mp.projectid,mp.projectname
END
ELSE IF (@type='Tower')
BEGIN 

 	SELECT DISTINCT MT.BlockID AS TowerID,MT.BlockName AS TowerName
	FROM  mstBlock (NOLOCK) MT  
	INNER JOIN ubmProjectPermission (NOLOCK)UP ON UP.ProjectID = MT.ProjectID AND MT.BlockID = ISNULL(UP.TowerID,MT.BlockID)
	AND MT.ParentID IS NULL
	INNER JOIN mstBlock (NOLOCK) MB ON MB.ParentID = MT.BlockID
	INNER JOIN mstUnit MU ON MU.ProjectID = UP.ProjectID AND MB.BlockID=MU.BlockID
	INNER JOIN ubmUnitDetail (NOLOCK) UBUD ON UBUD.UnitID = MU.UnitID AND UBUD.Status = 2
	WHERE up.groupid=@groupID and ubmuserid=@ubmUserID and MB.ProjectID =@projectID
END
ELSE IF(@type='Floor')
BEGIN 
	SELECT DISTINCT MB.BlockID AS FloorID,MB.BlockName AS FloorName
	FROM mstblock (NOLOCK) MB
	INNER JOIN mstBlock (NOLOCK) MT ON MT.BlockID = MB.ParentID AND MT.ParentID IS NULL
	INNER JOIN ubmProjectPermission (NOLOCK)UP ON UP.ProjectID = MT.ProjectID AND MT.BlockID = ISNULL(UP.TowerID,MT.BlockID)
	INNER JOIN mstUnit MU ON MU.ProjectID = UP.ProjectID AND MB.BlockID=MU.BlockID
	INNER JOIN ubmUnitDetail (NOLOCK) UBUD ON UBUD.UnitID = MU.UnitID AND UBUD.Status = 2
	WHERE  up.groupid=@groupID AND ubmuserid=@ubmUserID AND MB.ParentID=@towerID
END
ELSE IF(@type ='Unit')
BEGIN
	SELECT DISTINCT MU.UnitID,UnitNo as UnitName FROM ubmProjectPermission (NOLOCK)UP
	INNER JOIN mstUnit (NOLOCK) MU ON MU.ProjectID=UP.ProjectID
	INNER JOIN ubmUnitDetail (NOLOCK) UBUD ON UBUD.UnitID = MU.UnitID AND UBUD.Status = 2
	LEFT JOIN ubmUnitBooking (NOLOCK) UB ON UB.UnitID = MU.UnitID AND UB.BookingStatusID <> 7 --OR UB.BookingStatusID=1)
	WHERE UP.GroupID=@groupID AND ubmuserid=@ubmUserID AND MU.BlockID=@floorID AND MU.Flag<>12
	AND  UB.UbmID IS  NULL OR UB.BookingStatusID=1
END
END 
GO

---------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddubmUnitBooking]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_AddubmUnitBooking]
GO     
CREATE PROC ubm_AddubmUnitBooking       
@UbookmID int=null,         
@UnitType varchar(20),          
@UnitID int=null,          
@cutomerMobileNo decimal(18,1),          
@customerEmail varchar(100),          
@releaseUnitDate smalldatetime=null,          
@applicationType varchar(20)=null,          
@createdBy int,          
@groupID decimal(18,1)          
AS          
BEGIN          
DECLARE @ubmID int   
 ---GENRATE RANDOM PASSWORD AND SET IN A VARIABLE
DECLARE @randomNum NCHAR(36)    
        SET @randomNum = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'    
        DECLARE @password NCHAR(15)    
        SET @password = SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
        + SUBSTRING(@randomNum, CAST((RAND() * LEN(@randomNum)) AS INT) + 1, 1)    
                   
      
IF(@UbookmID IS NOT NULL)      
    BEGIN      
    UPDATE ubmUnitBooking       
    SET UnitType=@UnitType,UnitID=@UnitID,CustMobNo=@cutomerMobileNo,CustEmail=@customerEmail,releaseUnitDate=@releaseUnitDate,applicationType=@applicationType,createdBy=@createdBy,StatusDate=GETDATE()      
    where UbmID=@UbookmID      
                 
    SELECT @UbookmID AS ubmID 
	
	 IF(@UnitType='UnitBooking')    
        BEGIN    
        INSERT INTO ubmCustomerLogin(CustomerEmail,Password,UbmID,GroupID,CreatedBy,CreatedAt,isSessionExpired)    
        VALUES(@customerEmail,@password,@UbookmID,@groupID,@createdBy,GETDATE(),1)    
        END    
	        
    END      
      
ELSE IF EXISTS(SELECT 1 FROM ubmUnitBooking WHERE UnitID=@UnitID AND groupID=groupID)          
    BEGIN          
    RAISERROR('Cannot Inserted Duplicate UnitNo',17,1)          
    END          
ELSE          
    BEGIN          
    INSERT INTO ubmUnitBooking(UnitType,UnitID,CustMobNo,CustEmail,releaseUnitDate,applicationType,createdBy,groupID,BookingStatusID,CreatedOn,StatusDate)          
    VALUES(@UnitType,@UnitID,@cutomerMobileNo,@customerEmail,@releaseUnitDate,@applicationType,@createdBy,@groupID,1,GETDATE(),GETDATE())          
              
    SET @ubmID= Scope_Identity()            
     SELECT @ubmID AS ubmID   
        
    IF(@UnitType='UnitBooking')    
        BEGIN    
        INSERT INTO ubmCustomerLogin(CustomerEmail,Password,UbmID,GroupID,CreatedBy,CreatedAt,isSessionExpired)    
        VALUES(@customerEmail,@password,@ubmID,@groupID,@createdBy,GETDATE(),1)    
        END    
      
    END          
END       
GO
-----------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddPaymentDetails]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_AddPaymentDetails]
GO 
  
CREATE PROC ubm_AddPaymentDetails  
@UbmID int ,  
@PaymentMode varchar(30),  
@ChequeNo varchar(100),  
@ChequeDate smalldatetime=null,  
@BankName varchar(100)=null,  
@BranchName varchar(100)=null,  
@Amount decimal(18,0),  
@CreatedBy int,  
@GroupID  decimal(18,0)  
AS   
BEGIN  
  
IF EXISTS(SELECT * FROM ubmBookedUnitPayment(NOLOCK) WHERE GroupID =@GroupID AND UbmID=@UbmID AND ChequeNo=@ChequeNo AND Amount=@Amount)  
BEGIN  
RAISERROR('Cannot Insetred Duplaite Cheque of same paymode',17,1)  
END  
ELSE  
BEGIN  
INSERT INTO ubmBookedUnitPayment(UbmID,PaymentMode,ChequeNo,ChequeDate,BankName,BranchName,Amount,CreatedBy,GroupID,CreatedOn)  
VALUES(@UbmID,@PaymentMode,@ChequeNo,@ChequeDate,@BankName,@BranchName,@Amount,@CreatedBy,@GroupID,GETDATE())  
   
END  
END  
 GO

  -------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_getpaymentDetails]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_getpaymentDetails]
GO 
      
CREATE PROC ubm_getpaymentDetails  
@GroupID decimal(18,0),  
@ubmId int  
AS  
BEGIN  
	SELECT UbmPaymentId,UbmID,PaymentMode,ChequeNo,BranchName,Amount FROM ubmBookedUnitPayment(NOLOCK) WHERE GroupID=@GroupID AND UbmID=@ubmId  
END
GO
---------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_getProjectData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_getProjectData]
GO  
CREATE PROC ubm_getProjectData          
@Search varchar(1000),          
@type varchar(10)          
AS          
BEGIN          
    DECLARE @sql NVARCHAR(MAX)          
          
    IF(@type='Company')          
    BEGIN          
        SET @sql = N'SELECT CompanyID, CompanyName FROM RealEstate..mstcompany WHERE ' + @Search + ''          
    END          
    ELSE IF(@type = 'Location')          
    BEGIN          
        SET @sql = N'SELECT LocationID, LocationName FROM RealEstate..mstLocation WHERE ' + @Search + ''          
    END          
    ELSE IF(@type = 'Project')          
    BEGIN          
        SET @sql = N'SELECT ProjectID, ProjectName FROM RealEstate..mstProject WHERE ' + @Search + ''          
    END    
  ELSE IF(@type = 'Tower')          
    BEGIN          
        SET @sql = N'select BlockID as TowerID, BlockName as TowerName from RealEstate..mstBlock mu  
                inner join RealEstate..mstProject mp on mp.ProjectID= mu.ProjectID  
                    WHERE ' + @Search + ''          
    END           
          
    EXEC sp_executesql @sql          
END       
GO    

-------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddUpdateProjectPermission]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_AddUpdateProjectPermission]
GO  

 CREATE PROCEDURE ubm_AddUpdateProjectPermission             
    @ubmUserID int,         
    @projectPermissionID int=null,            
    @projectID int,           
    @towerID int =null,           
    @CreatedBy int,            
    @GroupID DECIMAL(18,0)    
       
AS              
BEGIN              
   DECLARE @ErrorMessage NVARCHAR(2048)             
        
 IF NOT EXISTS (SELECT 1 FROM Realestate..ubmProjectPermission(NOLOCK) WHERE ubmUserID = @ubmUserID and ProjectID= @projectID and TowerID IN(@towerID) and GroupID =@GroupID)                  
    BEGIN        
    INSERT INTO ubmProjectPermission (ubmUserID, ProjectID, TowerID,CreatedBy, CreatedOn,GroupID)              
       VALUES (@ubmUserID, @projectID,    
    CASE WHEN @towerID=0 THEN NULL ELSE @towerID END ,@CreatedBy, GETDATE(),@GroupID);    
 END        
 END 
 GO

 ----------------------------------------------------------------------------------------------
  IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetProjectList]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetProjectList]
GO 
 CREATE PROC [ubm_GetProjectList]  
 @GroupID DECIMAL(18,0)
  AS
  BEGIN 
	SELECT ProjectID, ProjectName FROM mstProject (NOLOCK)
	WHERE GroupID=@GroupID
  END
GO
 ----------------------------------------------------------
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_getProjectListByUserID]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_getProjectListByUserID]
GO  
 CREATE PROC ubm_getProjectListByUserID    
@groupID DECIMAL(18,0),    
@userID int    
AS    
BEGIN    
	SELECT ProjectPermissionID,MC.CompanyName,ML.LocationName,MP.ProjectName,ISNULL(MB.BlockName,'') AS TowerName 
	FROM ubmProjectPermission (NOLOCK) UP    
	LEFT JOIN mstBlock (NOLOCK) MB ON MB.BlockID = UP.TowerID    
	INNER JOIN mstProject (NOLOCK) MP ON MP.Projectid = UP.ProjectID    
	INNER JOIN mstLocation (NOLOCK) ML ON ML.LocationID = MP.LocationID    
	INNER JOIN mstCompany (NOLOCK) MC ON MC.CompanyID = ML.CompanyID    
	where UP.ubmUserID = @userID and up.GroupID = @groupID    
END
GO

--------------------------------------------------------------------------
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_deleteProjectPermission]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_deleteProjectPermission]
GO   
    
CREATE PROC ubm_deleteProjectPermission    
@permissionID INT,    
@groupID DECIMAL(18,0)  
AS    
BEGIN    
    
IF(@permissionID =0)    
BEGIN    
RAISERROR('Permission ID is Missing',17,1)    
return;    
END    
ELSE    
BEGIN    
DELETE FROM ubmProjectPermission WHERE ProjectPermissionID = @permissionID AND GroupID=@groupID    
END    
END    
GO

---------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_unitDetails]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_unitDetails]
GO 
  
CREATE PROC ubm_unitDetails        
@GroupID DECIMAL(18,0),     
@userID INT  ,
@ProjectID INT,
@TowerID INT      
AS        
BEGIN 
	IF(@ProjectID = 0)
		SET @ProjectID =NULL  
	IF(@TowerID = 0)
		SET @TowerID =NULL  
	     
	DECLARE @userType varchar(20)    
	SET @userType= (SELECT RoleName FROM ubmUsers WHERE ubmUserID=@userID AND GroupID = @GroupID)    
	DECLARE @V VARCHAR(MAX),    
        @UnitChargeID INT,    
        @Formula VARCHAR(500),    
        @V1 VARCHAR(1000)    
    
	CREATE TABLE #EVAL    
	(    
	    Value DECIMAL(18, 8)    
	)    
    
	SELECT UC.UnitChargeID, MU.UnitID, PAC.ChargeID,     
	       REPLACE(REPLACE(PAC.Formula, '[Area]', MU.Area), '[Rate]', MU.Rate) AS Formula1    
	INTO #UBMTF    
	FROM unitCharge UC    
	INNER JOIN MSTUNIT MU ON MU.UNITID = UC.UNITID    
	INNER JOIN ProjectAdditionalCharge PAC ON PAC.CHARGEID = UC.CHARGEID    
	WHERE PAC.CHARGEID <> 5001    
	    
	SELECT * INTO #UBMTF1 FROM #UBMTF    
    
	IF EXISTS(SELECT NULL FROM #UBMTF1)    
	BEGIN    
	    WHILE EXISTS(SELECT NULL FROM #UBMTF1)    
	    BEGIN    
	        DELETE FROM #EVAL    
	    
	        SELECT TOP 1 @UnitChargeID = UnitChargeID, @Formula = Formula1 FROM #UBMTF1    
	            
	        SET @V1 = 'INSERT INTO #EVAL SELECT ' + @Formula    
	        EXEC (@V1)    
	    
	        DECLARE @EvaluatedValue DECIMAL(18, 8)    
	        SELECT @EvaluatedValue = Value FROM #EVAL    
	            
	        UPDATE #UBMTF SET Formula1 = CAST(@EvaluatedValue AS VARCHAR(100))    
	        WHERE UnitChargeID = @UnitChargeID    
	            
	        DELETE FROM #UBMTF1 WHERE UnitChargeID = @UnitChargeID    
	    END    
	END    
    
	SELECT 
	mp.CompanyID,mp.LocationID,B.BlockID as FloorID,    
	T.BlockID as TowerID,T.BlockName AS TowerName,        
	B.BlockName AS FloorName,      
	MP.ProjectName,ML.LocationName,        
	MU.UnitID,MU.UnitNo,MC.CatName, CAST((mu.Area * mu.Rate) AS DECIMAL (10,2))As NetAmount,         
	ISNULL(mu.area,0)area,ISNULL(mu.Rate,0)Rate,        
	Isnull(mu.UnitSuperArea,0)UnitSuperArea,Isnull(mu.UnitSuperAreaRate,0)UnitSuperAreaRate,       
	ISNULL(mu.UnitBuiltUpArea,0)UnitBuiltUpArea,      
	ISNULL(mu.UnitBuiltUpAreaRate,0)UnitBuiltUpAreaRate,      
	ISNULL(mu.UnitTerraceArea,0)UnitTerraceArea,      
	ISNULL(mu.UnitTerraceAreaRate,0)UnitTerraceAreaRate,      
	ISNULL(mu.UnitBalconyArea,0)UnitBalconyArea,      
	ISNULL(mu.UnitBalconyAreaRate,0)UnitBalconyAreaRate,        
	ISNULL(mu.UnitCarpetArea,0)UnitCarpetArea,      
	ISNULL(MU.BasicAmount,0)BasicAmount,        
	ISNULL(ubmud.Status ,0)unitStatus,    
	ISNULL(SUM(CAST((tempUbm.Formula1) as DECIMAL(10, 2))),0)AdditionalCharge,
	ISNULL(ubmud.DiscountAmount,0)DiscountAmount,
	ISNULL(ubmud.minSaleAmount,0)minSaleAmount,
	ISNULL(ubmud.maxSaleAmount,0)maxSaleAmount,
	ISNULL(ubmud.IntPlanID,0)IntPlanID,
	ISNULL(ubmud.PayPlanID,0)PayPlanID        
	FROM mstUnit MU
	INNER JOIN mstBlock B ON B.BlockID=MU.BlockID
	INNER JOIN mstProject MP ON MP.ProjectID=B.ProjectID        
	INNER JOIN mstLocation ML ON ML.LocationID = MP.LocationID  
	INNER JOIN mstBlock T ON T.BlockID=B.ParentID   
	INNER JOIN ubmProjectPermission UP ON UP.ProjectID=T.ProjectID AND T.BlockID=ISNULL(UP.TowerID,T.BlockID) AND T.ParentID IS NULL    
	INNER JOIN mstCategory MC ON MC.CatID = MU.CatID         
	LEFT JOIN ubmUnitDetail ubmud on ubmud.UnitID=mu.UnitID      
	LEFT JOIN #UBMTF tempUbm on tempUbm.UnitID= MU.UnitID 
	WHERE up.ubmUserID = CASE WHEN @userType ='Admin/CFO' THEN up.ubmUserID ELSE @userID END 
	AND MP.ProjectID =ISNULL(@ProjectID,MP.ProjectID)
	AND T.BlockID =ISNULL(@TowerID,T.BlockID)
	AND up.GroupID =  @GroupID  AND MU.StatusID = 2 AND MU.FLAG <> 12        
	GROUP BY     
	mp.CompanyID,mp.LocationID,B.BlockID,    
	T.BlockID ,T.BlockName,        
	B.BlockName ,      
	MP.ProjectName,ML.LocationName,        
	MU.UnitID,MU.UnitNo,MC.CatName, mu.Area , mu.Rate,         
	mu.area,      
	mu.UnitSuperArea,mu.UnitSuperAreaRate,       
	mu.UnitBuiltUpArea,     
	mu.UnitBuiltUpAreaRate,     
	mu.UnitTerraceArea,     
	mu.UnitTerraceAreaRate,      
	mu.UnitBalconyArea,    
	mu.UnitBalconyAreaRate,    
	mu.UnitCarpetArea,    
	MU.BasicAmount,    
	ubmud.Status,ubmud.DiscountAmount,
	ubmud.minSaleAmount,
	ubmud.maxSaleAmount,
	ubmud.IntPlanID,
	ubmud.PayPlanID 
END        
GO   

----------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPaymentPlanByUnitBlock]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetPaymentPlanByUnitBlock]
GO
Create PROCEDURE [dbo].[GetPaymentPlanByUnitBlock]              
 -- Add the parameters for the stored procedure here              
 @BlockID ID,              
 @UnitID ID,              
 @CompanyID ID,              
 @LocationID ID              
AS              
BEGIN              
 -- SET NOCOUNT ON added to prevent extra result sets from              
 -- interfering with SELECT statements.              
 SET NOCOUNT ON;              
              
    -- Insert statements for procedure here              
          
          
SELECT distinct PayPlanID, PayPlanName, Rate into #tmp from  vw_GetPaymentPlan              
 WHERE (BlockID=@BlockID AND (UnitID=@UnitID or UnitID is null)) AND LocationID=@LocationID AND CompanyID=@CompanyID              
IF (@@rowcount>0)            
Begin          
 SELECT Null as PayplanID,'--SELECT--' as PayplanName,0 as Rate           
 Union All          
 SELECT * from #tmp            
End          
Else          
begin              
 SELECT Null as PayplanID,'--SELECT--' as PayplanName ,0 as Rate          
 Union All          
 SELECT distinct PayPlanID, PayPlanName,Rate from vw_GetPaymentPlan              
 inner join mstblock              
 on mstblock.parentid=vw_GetPaymentPlan.blockid              
  WHERE (mstblock.BlockID=@BlockID )               
end             
End               
GO  
----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFillIntrestPlan]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[GetFillIntrestPlan]
GO
CREATE PROC [dbo].[GetFillIntrestPlan]     
 @CompanyID INT,  
 @LocationID INT,  
 @GroupID DECIMAL(18,0)  
As    
 IF @CompanyID=0  
 SET @CompanyID = NULL  
 IF @LocationID=0  
 SET @LocationID=NULL  
	SELECT IntPlanID,IntPlanName FROM mstintplan(NOLOCK)   
	WHERE CompanyID = ISNULL(@CompanyID,CompanyID)   
	AND LocationID=ISNULL(@LocationID,LocationID)  
	AND GroupID=@GroupID  
	ORDER BY intplanName ASC
GO  
---------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddUnitDetails]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_AddUnitDetails]
GO  
CREATE PROC ubm_AddUnitDetails    
@UnitID int ,    
@BasicAmount decimal(18,2),    
@AdditionalAmount  decimal(18,2),    
@DiscountAmount  decimal(18,2),    
@NetAmount decimal(18,2),    
@minSaleAmount decimal(18,2),    
@maxSaleAmount decimal(18,2),    
@IntPlanID int,    
@PayPlanID int,    
@CreatedBy int,    
@groupID DECIMAL(18,0)    
AS    
BEGIN    
IF EXISTS(SELECT 1 FROM ubmUnitDetail where UnitID =@UnitID and groupID= groupID)    
BEGIN    
    UPDATE ubmUnitDetail SET BasicAmount=@BasicAmount,AdditionalAmount=@AdditionalAmount,DiscountAmount=@DiscountAmount,NetAmount=@NetAmount,minSaleAmount=@minSaleAmount,maxSaleAmount=@maxSaleAmount ,IntPlanID=@IntPlanID,     
    PayPlanID=@PayPlanID,Status=1 WHERE groupID=@groupID AND UnitID=@UnitID
END    
ELSE    
BEGIN    
	INSERT INTO ubmUnitDetail(UnitID,BasicAmount,AdditionalAmount,DiscountAmount,NetAmount,minSaleAmount,maxSaleAmount ,IntPlanID,     
		PayPlanID,Status,CreatedBy,CreatedOn,groupID)    
	VALUES(@UnitID,@BasicAmount,@AdditionalAmount,@DiscountAmount,@NetAmount,    
		@minSaleAmount,@maxSaleAmount,@IntPlanID,@PayPlanID,1,@CreatedBy,GETDATE(),@groupID)    
END    
END 
GO

----------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetProcessType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetProcessType]
GO
 CREATE PROC ubm_GetProcessType
 AS
 BEGIN
 	SELECT 1 AS ID, 'Initiate Booking' AS  ProcessType
	UNION
	SELECT 2 AS ID, 'Final Booking' AS  ProcessType
	UNION
	SELECT 3 AS ID, 'T&C'   AS  ProcessType
 END
 GO

------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_SaveAppDoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_SaveAppDoc]
GO
CREATE PROC ubm_SaveAppDoc
@DocumentID INT = 0,
@GroupID DECIMAL(18,0),
@ApplicationType VARCHAR(20),
@DocumentName VARCHAR(100),
@CreatedBy INT,
@IsMandatory BIT=0  
AS
BEGIN
	IF(@DocumentID  = 0)
	BEGIN
		IF EXISTS (SELECT 1 FROM ubmDocument(NOLOCK) WHERE ApplicationType=@ApplicationType AND DocumentName=@DocumentName AND GroupID=@GroupID)
		BEGIN
			RAISERROR('Document name aready exists for the selected category!',17,1)
			RETURN
		END
		INSERT INTO ubmDocument (GroupID,ApplicationType,DocumentName,CreatedBy,CreatedOn,IsMandatory,IsActive)
		VALUES(@GroupID,@ApplicationType,@DocumentName,@CreatedBy,GETDATE(),@IsMandatory,1)
	END
	ELSE  
	BEGIN
		IF EXISTS (SELECT 1 FROM ubmDocument(NOLOCK) WHERE ApplicationType=@ApplicationType AND DocumentName=@DocumentName
		 AND GroupID=@GroupID AND DocumentID<>@DocumentID)
		BEGIN
			RAISERROR('Document name aready exists for the selected category!',17,1)
			RETURN
		END
		UPDATE ubmDocument SET ApplicationType = @ApplicationType, DocumentName = @DocumentName ,IsMandatory =  @IsMandatory,
		UpdatedOn = GetDate(),UpdatedBy=@CreatedBy where DocumentID =  @DocumentID
	END
END
GO
------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_DeleteAppDoc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_DeleteAppDoc]
GO
CREATE PROC ubm_DeleteAppDoc
@DocumentID int = 0
AS
BEGIN
	DELETE FROM ubmDocument where DocumentID =  @DocumentID
END
GO

--------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetAppDocList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetAppDocList]
GO
CREATE PROC ubm_GetAppDocList            
@GroupID DECIMAL(18,0)
AS            
BEGIN         
	SELECT DocumentID, ApplicationType,DocumentName,CreatedBy,CreatedOn,IsMandatory 
	FROM ubmDocument(NOLOCK)    
	WHERE GroupID=@groupID       
END 
GO 
 
-------------------------------------------------------------------------------------------------------------------------------- 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetTemplateList]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetTemplateList]
GO
CREATE PROC ubm_GetTemplateList
@GroupID DECIMAL(18,0)
AS
BEGIN 
	SELECT T.TemplateID,T.GroupID,T.ProjectID,T.ProcessType,--CASE WHEN T.ProcessType =1 THEN  'Initiate Booking'  WHEN T.ProcessType =2 THEN 'Final Booking' ELSE 'T&C' END AS ProcessType,
	T.TemplateType,T.TemplateMsg,T.IsActive ,P.ProjectName,T.VendorTemplateID
	FROM ubmTemplate (NOLOCK) T
	LEFT JOIN mstProject (NOLOCK) P ON P.ProjectID= T.ProjectID AND T.ProcessType='T&C'
	WHERE T.GroupID=@GroupID
END
GO
 
---------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_SaveTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ubm_SaveTemplate
GO
CREATE PROC ubm_SaveTemplate
@TemplateID INT =0,
@GroupID DECIMAL(18,0),
@ProjectID INT=NULL,
@ProcessType VARCHAR(20),
@TemplateType VARCHAR(20)=NULL,
@TemplateMsg NVARCHAR(MAX),
@VendorTemplateID VARCHAR(100),
@CreatedBy INT
AS
BEGIN
	IF(@TemplateID=0)
	BEGIN
		IF(@ProcessType<>'T&C')
		BEGIN
			IF EXISTS (SELECT 1 FROM ubmTemplate(NOLOCK) WHERE ProcessType=@ProcessType AND TemplateType=@TemplateType AND GroupID=@GroupID)
			BEGIN
				RAISERROR('Template aready exists for the selected process!',17,1)
				RETURN
			END
		END
		ELSE
		BEGIN
			IF EXISTS (SELECT 1 FROM ubmTemplate(NOLOCK) WHERE ProcessType=@ProcessType AND ProjectID=@ProjectID AND GroupID=@GroupID)
			BEGIN
				RAISERROR('Template aready exists for the selected process!',17,1)
				RETURN
			END
		END
		INSERT INTO ubmTemplate (GroupID,ProjectID,ProcessType,TemplateType,VendorTemplateID,TemplateMsg,CreatedBy,CreatedOn,IsActive)
		VALUES (@GroupID,@ProjectID,@ProcessType,@TemplateType,@VendorTemplateID,@TemplateMsg,@CreatedBy,GETDATE(),1)
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM ubmTemplate(NOLOCK) WHERE ProcessType=@ProcessType AND TemplateType=@TemplateType 
		AND GroupID=@GroupID AND TemplateID<>@TemplateID)
		BEGIN
			RAISERROR('Template aready exists for the selected process!',17,1)
			RETURN
		END
		UPDATE ubmTemplate SET ProjectID=@ProjectID,ProcessType=@ProcessType,TemplateType=@TemplateType,TemplateMsg=@TemplateMsg,
		VendorTemplateID=@VendorTemplateID
		WHERE TemplateID=@TemplateID
	END
END
GO
----------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_DeleteTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ubm_DeleteTemplate
GO

CREATE PROC ubm_DeleteTemplate
@TemplateID INT
AS
BEGIN
	DELETE FROM ubmTemplate WHERE TemplateID=@TemplateID
END
	
GO
-----------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetAppDocs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetAppDocs]
GO
CREATE PROC ubm_GetAppDocs       
 @GroupID varchar(100),
 @ApplicationType varchar(100)
AS            
BEGIN    
  DECLARE @Count int
  DECLARE @MailBody VARCHAR(MAX), @DocList VARCHAR(MAX), @RowNo INT
  SELECT @Count = (SELECT COUNT(1) FROM ubmDocument(NOLOCK) WHERE GroupID= @groupID AND ApplicationType = @ApplicationType)
  SELECT ROW_NUMBER() OVER (ORDER BY DocumentID) ID,DocumentName INTO #Doc FROM  ubmDocument
  WHERE GroupID=@GroupID And ApplicationType = @ApplicationType
  SET @MailBody = '<html><body><ul>'
  WHILE(@Count > 0)
  BEGIN
	SELECT @DocList = DocumentName from #Doc where ID = @Count
	SET @MailBody += '<li> '+ @DocList +' </li>'
	SET @Count =  (@Count - 1)
  END
  DROP TABLE #Doc 
  SET @MailBody += '</ul></body></html>'
  SELECT @MailBody AS [DocumentName]
END 
GO


--------------------------------------------------------------------------------------------------------
 IF   (SELECT COUNT(1) FROM  ubmTemplateEmbeded ) = 0
   BEGIN
	INSERT INTO ubmTemplateEmbeded (ProcessType,FieldName)
	VALUES 
	('Initiate Booking','[|UnitNo|]'),
	('Initiate Booking','[|Email|]'),
	('Initiate Booking','[|MobileNo|]'),
	('Initiate Booking','[|BookingDate|]'),
	('Initiate Booking','[|BookingUrl|]'),
	('Initiate Booking','[|ProjectName|]'),
	('Initiate Booking','[|ProjectAddress|]'),
	('Initiate Booking','[|ApplicationType|]'),
	('Initiate Booking','[|TowerName|]'),
	('Initiate Booking','[|FloorName|]'),
	('Initiate Booking','[|Area|]'),
	('Initiate Booking','[|Rate|]'),
	('Initiate Booking','[|BasicAmount|]'),
	('Initiate Booking','[|AdditionalAmount|]'),
	('Initiate Booking','[|DiscountAmount|]'),
	('Initiate Booking','[|CarpetArea|]'),
	('Initiate Booking','[|CarpetAreaRate|]'),
	('Initiate Booking','[|UnitBalconyArea|]'),
	('Initiate Booking','[|UnitBalconyAreaRate|]'),
	('Initiate Booking','[|UnitCarpetArea|]'),
	('Initiate Booking','[|UnitCarpetAreaRate|]'),
	('Final Booking','[|BookingAmount|]'),
	('Final Booking','[|SalesPerson|]')
   END
   GO
  
  -------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetTemplateEmbList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetTemplateEmbList]
GO
 CREATE PROC ubm_GetTemplateEmbList  
 @ProcessType VARCHAR(20)
  AS
  BEGIN 
	SELECT TemplateEmbededID, FieldName FROM ubmTemplateEmbeded (NOLOCK)
	WHERE ProcessType  = CASE WHEN @ProcessType='Initiate Booking' THEN @ProcessType ELSE ProcessType END
  END
  GO
 -------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddApplicant]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_AddApplicant]
GO
CREATE PROC ubm_AddApplicant  
@AplicantID INT=NULL,
@UbmID INT,  
@ApplicantName varchar(100),  
@ApplicantType INT,  
@SO varchar (100)=NULL,  
@Dob smalldatetime=NULL,  
@Age  DECIMAL(18,0)=NULL,  
@Nationality varchar (100)=NULL,  
@Occupation varchar (100)=NULL,  
@Pan varchar (100)=NULL,  
@Aadharno varchar (100)=NULL,  
@Address varchar (1000)=NULL,  
@CityId int,  
@StateId int,  
@CountryName varchar(100)=NULL,  
@Pin varchar (1000)=NULL,  
@Email varchar (1000)=NULL,  
@Phone1 DECIMAL(18,0)=NULL,  
@Phone2  DECIMAL(18,0)=NULL,  
@NameofOrganisation varchar (1000)=NULL,  
@Designation varchar (100)=NULL,  
@ApplicantionDate smalldatetime=NULL,  
@CreatedBy int,  
@GroupID  DECIMAL(18,0)  
AS  
BEGIN  

 IF(@AplicantID IS NOT NULL)
 BEGIN
 UPDATE ubmApplicantDetails SET ApplicantName=@ApplicantName ,ApplicantType=@ApplicantType ,SO=@SO ,Dob=@Dob ,Age=@Age
   ,Nationality=@Nationality ,Occupation=@Occupation ,Pan=@Pan ,Aadharno=@Aadharno ,Address=@Address ,CityId=@CityId ,StateId= @StateId,
   CountryName=@CountryName ,Pin=@Pin ,Email=@Email ,Phone1=@Phone1 ,Phone2=@Phone2  ,NameofOrganisation=@NameofOrganisation ,Designation=@Designation ,
   ApplicantionDate=@ApplicantionDate ,CreatedBy=@CreatedBy WHERE ubmApplicantID=@AplicantID
 END
 ELSE IF EXISTS(SELECT 1 FROM ubmApplicantDetails WHERE GroupID =@GroupID AND ApplicantType=@ApplicantType AND ApplicantName=@ApplicantName)  
 BEGIN  
 RAISERROR('Above Applicant is Already Exists',17,1)  
 RETURN  
 END
 ELSE
 BEGIN  
 INSERT INTO ubmApplicantDetails(UbmID,ApplicantName ,ApplicantType ,SO ,Dob ,Age  ,Nationality ,Occupation ,Pan ,Aadharno ,Address ,CityId ,StateId ,CountryName ,Pin ,Email ,Phone1 ,Phone2  ,NameofOrganisation ,Designation ,ApplicantionDate ,CreatedBy ,GroupID ,CreatedOn,FLAG)  
 VALUES(@UbmID,@ApplicantName ,@ApplicantType ,@SO ,@Dob ,@Age  ,@Nationality ,@Occupation ,@Pan ,@Aadharno ,@Address ,@CityId ,@StateId ,@CountryName ,@Pin ,@Email ,@Phone1 ,@Phone2  ,@NameofOrganisation ,@Designation ,@ApplicantionDate ,@CreatedBy ,@GroupID,getdate(),13 )  
END
END  
GO



------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_ApplicantList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_ApplicantList]
GO
CREATE PROC ubm_ApplicantList  
@GroupID DECIMAL(18,0),  
@ApplicantType INT,  
@UbmID INT  
AS  
BEGIN  
SELECT UbmApplicantID,ApplicantName ,ApplicantType ,SO ,Dob ,Age  ,Nationality ,Occupation ,Pan ,Aadharno ,Address ,CityId ,StateId ,CountryName ,Pin ,Email ,Phone1 ,Phone2  ,ISNULL(NameofOrganisation,'')NameofOrganisation ,ISNULL(Designation,'')Designation ,ISNULL(ApplicantionDate,GETDATE())ApplicantionDate ,CreatedBy ,GroupID ,CreatedOn
  
 FROM ubmApplicantDetails WHERE GroupID =@GroupID AND UbmID=@UbmID AND  ApplicantType=@ApplicantType AND FLAG <>12  
END  
GO
--------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_DeleteApplicant]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_DeleteApplicant]
GO
CREATE PROC ubm_DeleteApplicant
@GroupID DECIMAL(18,0),
@UbmApplicantID INT
AS
BEGIN
	UPDATE ubmApplicantDetails SET FLAG=12 WHERE GroupID=@GroupID AND UbmApplicantID=@UbmApplicantID
END
GO

-----------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetState]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetState]
GO
CREATE PROC ubm_GetState
AS
BEGIN
	SELECT StateID,StateName FROM  ubm_state(NOLOCK)
END
GO
-----------------------------------------------------------------------------------------------------
-----------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetCity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetCity]
GO
CREATE PROC ubm_GetCity
@StateID int 
AS
BEGIN
	SELECT CityID,StateID,CityName FROM ubmCity(NOLOCK) WHERE StateID =@StateID 
END
GO
---------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_ApplicantDocList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_ApplicantDocList]
GO
CREATE PROC ubm_ApplicantDocList
@GroupID varchar(100),
@UbmID INT
AS
BEGIN
	SELECT ISNULL(UbmKycid,0)UbmKycid,UD.DocumentID,DocumentName,ub.GroupID,IsMandatory, ISNULL(DocUrl,'')DocUrl,UB.CustMobNo,UB.UnitID 
	FROM ubmUnitBooking (NOLOCK) UB
	LEFT JOIN ubmDocument (NOLOCK) UD on UD.ApplicationType = UB.ApplicationType
	LEFT JOIN ubmKycDocument (NOLOCK) UKD ON UKD.UbmID =UB.UbmID AND UKD.DocID = ud.DocumentID 
	WHERE UB.GroupID =@GroupID AND UB.UbmID =@UbmID 
END
GO
--------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_AddApplicantKYCDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_AddApplicantKYCDocuments]
GO
CREATE PROC ubm_AddApplicantKYCDocuments
@UbmID int,
@DocID int,
@DocUrl varchar(1000),
@GroupID varchar(20)
AS
BEGIN
	IF EXISTS( SELECT * FROM ubmKycDocument(NOLOCK) WHERE GroupID=@GroupID AND UbmID=@UbmID AND DocID=@DocID)
	BEGIN
		RAISERROR('Above Documents is Already Exits', 17,1)
		RETURN
	END
 
	INSERT INTO ubmKycDocument(UbmID,DocID,DocUrl,GroupID,CreatedOn)
	VALUES(@UbmID,@DocID,@DocUrl,@GroupID,GETDATE())
 
END
GO

----------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetMailConfigure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ubm_GetMailConfigure 
GO

 CREATE PROC ubm_GetMailConfigure
@GroupID DECIMAL(18,0),
@ProjectID INT
AS
BEGIN
	SELECT TOP 1 MailConfigureID,Type,SenderEmailID,SenderName,SMTPServer,UserName,Password,PerHourMail,URL,[From] MailFrom,Port,isSSL,
	TokenWA,PhoneWA,TypeWA,	BasedOn	,EmailProvider
	FROM MailConfigure(NOLOCK) WHERE GroupID=@GroupID 
	AND ProjectID = CASE WHEN ProjectID=0 THEN ProjectID ELSE @ProjectID END  AND IsActive=1 AND Type='Email'
	UNION
	SELECT TOP 1 MailConfigureID,Type,SenderEmailID,SenderName,SMTPServer,UserName,Password,PerHourMail,URL,[From] MailFrom,Port,isSSL,
	TokenWA,PhoneWA,TypeWA,	BasedOn	,EmailProvider
	FROM MailConfigure(NOLOCK) WHERE GroupID=@GroupID 
	AND ProjectID = CASE WHEN ProjectID=0 THEN ProjectID ELSE @ProjectID END  AND IsActive=1 AND Type='SMS'
	UNION
	SELECT TOP 1 MailConfigureID,Type,SenderEmailID,SenderName,SMTPServer,UserName,Password,PerHourMail,URL,[From] MailFrom,Port,isSSL,
	TokenWA,PhoneWA,TypeWA,	BasedOn	,EmailProvider
	FROM MailConfigure(NOLOCK) WHERE GroupID=@GroupID 
	AND ProjectID = CASE WHEN ProjectID=0 THEN ProjectID ELSE @ProjectID END  AND IsActive=1 AND Type='WhatsApp'
END 
GO
----------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetNotificationTemplate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].ubm_GetNotificationTemplate 
GO

 CREATE PROC ubm_GetNotificationTemplate
@GroupID DECIMAL(18,0),
@ProcessType  VARCHAR(30)
AS
BEGIN
	 SELECT TemplateID,TemplateMsg,VendorTemplateID,TemplateType
	 FROM ubmTemplate(NOLOCK) WHERE ProcessType=@ProcessType AND GroupID=@GroupID
END 
GO

---------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetCustomerUnitDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetCustomerUnitDetail] 
GO
CREATE PROC ubm_GetCustomerUnitDetail
@BookingID INT
AS
BEGIN 
	SELECT UB.UbmID,UB.UnitID, UB.CustEmail,Ub.CustMobNo,U.UnitNo,UD.AdditionalAmount,
	UD.BasicAmount,UD.DiscountAmount,U.Area,U.Rate,U.UnitBalconyArea,U.UnitBalconyAreaRate ,U.UnitCarpetArea,
	U.UnitCarpetAreaRate,P.ProjectName,P.Address1 +' '+ ISNULL(P.Address2,'') AS ProjectAddress, '' AS BookingUrl,
	UB.ApplicationType,F.BlockName AS FloorName,T.BlockName AS TowerName,'' AS SalesPerson,0 BookingAmount
	FROM  ubmUnitBooking (NOLOCK) UB
	INNER JOIN mstUnit (NOLOCK) U ON UB.UnitID=U.UnitID
	INNER JOIN ubmUnitDetail (NOLOCK) UD ON UD.UnitID=U.UnitID
	INNER JOIN mstProject (NOLOCK) P ON P.ProjectID=U.ProjectID
	INNER JOIN mstBlock (NOLOCK) F ON F.BlockID=U.BlockID
	INNER JOIN mstBlock (NOLOCK) T ON T.BlockID=F.ParentID AND T.ParentID IS NULL
	--INNER JOIN mstUser US ON US.UserID = UD.
	WHERE UB.UbmID=@BookingID  
END
GO

---------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetUnitBookingList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ubm_GetUnitBookingList] 
GO
CREATE PROC ubm_GetUnitBookingList    
@GroupID decimal(18,0),    
@ubmUserID int    
AS    
BEGIN    
DECLARE @RoleName VARCHAR(20)
SET @RoleName= (SELECT RoleName FROM ubmUsers WHERE ubmUserID =@ubmUserID AND GroupID=@GroupID)

select mb.UbmID,ISNULL(mb.UnitID,0)UnitID,ISNULL(mu.unitno,'E.O.I')unitno,ISNULL(uad.ApplicantName,'')ApplicantName,ISNULL(mp.ProjectName,'E.I.O')ProjectName,
mb.BookingStatusID AS Status,mb.CustEmail,mb.CustMobNo,MB.UnitType,mb.ReleaseUnitDate,ISNULL(mb.ApplicationType,'')ApplicationType,MP.ProjectID,PB.BlockID AS TowerID,B.BlockID as FloorID,
CASE 
    WHEN  @RoleName='Sales Manager' THEN CASE WHEN mb.BookingStatusID=2 THEN 1 ELSE 0 END
	WHEN  @RoleName= 'CRM' THEN CASE WHEN mb.BookingStatusID=3 THEN 1 ELSE 0 END
	WHEN  @RoleName ='Account' THEN CASE WHEN mb.BookingStatusID=4 THEN 1 ELSE 0 END
	ELSE CASE WHEN mb.BookingStatusID=5 THEN 1 ELSE 0 END END AS isVisible
FROM ubmUnitBooking mb    
LEFT join mstunit (NOLOCK) mu on mu.UnitID =  mb.UnitID    
LEFT join mstProject (NOLOCK) mp on mp.ProjectID = mu.ProjectID
LEFT JOIN mstBlock (NOLOCK) B ON mp.ProjectID=B.ProjectID AND  B.BlockID = mu.BlockID 
LEFT JOIN mstBlock (NOLOCK) PB ON PB.BlockID=B.ParentID AND PB.ParentID IS NULL
LEFT JOIN ubmProjectPermission (NOLOCK) PP ON PP.ProjectID=PB.ProjectID AND PB.BlockID =ISNULL(PP.TowerID,PB.BlockID) 
LEFT join ubmApplicantDetails (NOLOCK) uad on uad.ubmid=mb.ubmid and uad.applicantType= 1  
where mb.GroupID=@GroupID and PP.ubmUserID=@ubmUserID OR mb.UnitID IS NULL     
ORDER BY MB.createdon desc
END
GO





-------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_DashboardSummary]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_DashboardSummary] 
GO
CREATE PROC [ubm_DashboardSummary]
@GroupID DECIMAL(18,0),
@ubmUserID INT,
@YearMonth VARCHAR(10)=NULL
AS
BEGIN
	DECLARE @RoleName VARCHAR(20)
	SELECT @RoleName=RoleName FROM ubmUsers WHERE ubmUserID=1 AND GroupID=@GroupID

	SELECT  TotalUnit=COUNT(1) , SoldUnit=ISNULL(SUM(CASE WHEN UB.BookingStatusID=6 THEN 1 ELSE 0 END),0),
	ProgressUnit=ISNULL(SUM(CASE WHEN UB.BookingStatusID NOT IN(6,7) THEN 1 ELSE 0 END),0),
	CancelsUnit=ISNULL(SUM(CASE WHEN UB.BookingStatusID =7 THEN 1 ELSE 0 END),0)
	FROM ubmProjectPermission PP(NOLOCK) 
	INNER JOIN mstBlock B (NOLOCK) ON PP.ProjectID=B.ProjectID AND  B.ParentID =ISNULL( PP.TowerID,B.ParentID) AND B.ParentID IS NOT NULL
	INNER JOIN mstUnit U (NOLOCK) ON  U.ProjectID=B.ProjectID AND U.BlockID=B.BlockID
	INNER JOIN ubmUnitDetail UD (NOLOCK)  ON UD.UnitID=U.UnitID 
	LEFT JOIN ubmUnitBooking UB (NOLOCK) ON UB.UnitID=UD.UnitID 
	AND UB.CreatedBy=CASE WHEN @RoleName='Admin/CFO' THEN UB.CreatedBy ELSE @ubmUserID END
	WHERE PP.GroupID=@GroupID AND PP.ubmUserID=CASE WHEN @RoleName='Admin/CFO' THEN PP.ubmUserID ELSE @ubmUserID END;

	SELECT MAX(DATENAME(MM,StatusDate)) AS SaleMonth, COUNT(1) AS TotalUnit
	FROM ubmUnitBooking  (NOLOCK) 
	WHERE GroupID=@GroupID AND CreatedBy=CASE WHEN @RoleName='Admin/CFO' THEN CreatedBy ELSE @ubmUserID END
	GROUP BY MONTH(StatusDate)
	 

	--SELECT  MAX(DATENAME(MM,UB.StatusDate)) AS CollectionMonth, ISNULL(SUM(BUP.Amount),0) AS Amount
	--FROM  ubmUnitBooking (NOLOCK) UB
	--INNER JOIN  ubmBookedUnitPayment (NOLOCK)  BUP ON UB.UbmID=BUP.UbmID
	SELECT  MAX(DATENAME(MM,UB.StatusDate)) AS CollectionMonth, ISNULL(SUM(UD.NetAmount),0) AS Amount
	FROM  ubmUnitBooking (NOLOCK) UB
	INNER JOIN  ubmUnitDetail (NOLOCK)  UD ON UB.UnitID=UD.UnitID
	WHERE UB.GroupID=@GroupID AND UB.CreatedBy=CASE WHEN @RoleName='Admin/CFO' THEN UB.CreatedBy ELSE @ubmUserID END
	GROUP BY MONTH(UB.StatusDate)

	SELECT TOP 10 P.ProjectName,U.UnitNo,UB.UnitType AS BookingType,ISNULL(US.FirstName,'') +' '+ISNULL(US.LastName,'') SalesPersonName,
	SUM(ISNULL(BUP.Amount,0)) AS BookingAmount,FORMAT(UB.StatusDate,'dd-MMM-yyyy') AS StatusDate,BS.StatusName
	FROM ubmUnitBooking (NOLOCK)UB
	INNER JOIN mstUnit (NOLOCK)U ON U.UnitID=UB.UnitID
	INNER JOIN mstProject (NOLOCK) P  ON P.ProjectID=U.ProjectID
	INNER JOIN ubmUsers (NOLOCK) UU ON UU.ubmUserID = UB.CreatedBy
	INNER JOIN mstUser (NOLOCK) US ON US.UserID = UU.UserID
	INNER JOIN ubmBookingStatus (NOLOCK) BS ON BS.BookingStatusID=UB.BookingStatusID
	LEFT JOIN ubmBookedUnitPayment (NOLOCK) BUP ON UB.UbmID= BUP.UbmID	
	WHERE UB.GroupID=@GroupID AND UB.CreatedBy=CASE WHEN @RoleName='Admin/CFO' THEN UB.CreatedBy ELSE @ubmUserID END
	GROUP BY P.ProjectName,U.UnitNo,UB.UnitType,UB.StatusDate,BS.StatusName,US.FirstName,US.LastName,UB.CreatedOn
	ORDER BY UB.CreatedOn DESC
END
GO 
---------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ChangeUbmStatus]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ChangeUbmStatus] 
GO
CREATE PROC ChangeUbmStatus
@UbmID int,
@GroupID decimal(18,0),
@BookingStatusID int,
@CreatedBy int,
@Remarks varchar(500)=NULL
AS
BEGIN
UPDATE ubmUnitBooking SET BookingStatusID =@BookingStatusID WHERE UbmID=@UbmID AND GroupID=@GroupID
INSERT INTO ubmLogs(UbmID,BookingStatusID,CreatedBy,CreatedOn,Remarks)
VALUES(@UbmID,@BookingStatusID,@CreatedBy,GETDATE(),@Remarks)
END
GO
 

 ---------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_ChangeUbmAuthorization]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_ChangeUbmAuthorization] 
GO

CREATE PROC ubm_ChangeUbmAuthorization
@UbmID int,
@GroupID decimal(18,0),
@CreatedBy int,
@Remarks varchar(500) = NULL,
@AuthorizationDropdown varchar(10)
AS
BEGIN

DECLARE @RoleName VARCHAR(20)
DECLARE @NewBookingStatusID INT

-- Get the role name of the user
SET @RoleName = (SELECT RoleName FROM ubmUsers WHERE ubmUserID = @CreatedBy AND GroupID = @GroupID)

-- Determine the new booking status based on the role and authorization
IF (@RoleName = 'Sales Manager')
    SET @NewBookingStatusID = CASE WHEN @AuthorizationDropdown = 'Approved' THEN 3 ELSE 1 END
ELSE IF (@RoleName = 'CRM')
    SET @NewBookingStatusID = CASE WHEN @AuthorizationDropdown = 'Approved' THEN 4 ELSE 2 END
ELSE IF (@RoleName = 'Account')
    SET @NewBookingStatusID = CASE WHEN @AuthorizationDropdown = 'Approved' THEN 5 ELSE 3 END
ELSE IF (@RoleName = 'Admin/CFO')
    SET @NewBookingStatusID = CASE WHEN @AuthorizationDropdown = 'Approved' THEN 6 ELSE 4 END

-- Update the booking status
UPDATE ubmUnitBooking 
SET BookingStatusID = @NewBookingStatusID 
WHERE UbmID = @UbmID AND GroupID = @GroupID

-- Insert into the logs
INSERT INTO ubmLogs (UbmID, BookingStatusID, CreatedBy, CreatedOn, Remarks)
VALUES (@UbmID, @NewBookingStatusID, @CreatedBy, GETDATE(), @Remarks)

END
GO

---------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_ChangeUbmAuthorizationClient]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_ChangeUbmAuthorizationClient] 
GO
CREATE PROC ubm_ChangeUbmAuthorizationClient  
@UbmID int,  
@GroupID decimal(18,0),  
@CreatedBy int,  
@Remarks varchar(500) = NULL  
AS  
BEGIN  
  
-- Update the booking status  
UPDATE ubmUnitBooking   
SET BookingStatusID = 2   
WHERE UbmID = @UbmID AND GroupID = @GroupID  
  
-- Insert into the logs  
INSERT INTO ubmLogs (UbmID, BookingStatusID, CreatedBy, CreatedOn, Remarks)  
VALUES (@UbmID, 2, @CreatedBy, GETDATE(), @Remarks)  

---CHANGE THE STATUS OF SESSION
UPDATE ubmCustomerLogin SET isSessionExpired =0 where UbmID =@UbmID and GroupID=@GroupID
END  
GO


--------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_CustomerLogin]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_CustomerLogin] 
GO
CREATE PROC ubm_CustomerLogin --EXEC ubm_userLogin 'roopak.kumar@wmgpl.com','s0MjqzELKIRdNXmsWZFKGQ=='                
@email varchar(100),                  
@password varchar(100)                  
AS                  
BEGIN                  
  
IF NOT EXISTS(SELECT TOP 1 * FROM ubmCustomerLogin WHERE CustomerEmail= @email ORDER BY CreatedAt DESC)  
      BEGIN  
        RAISERROR('You are Entered Wrong Email Address', 17,1)  
        RETURN 
      END  
ELSE IF NOT EXISTS(SELECT TOP 1 * FROM ubmCustomerLogin WHERE CustomerEmail= @email AND Password =@password ORDER BY CreatedAt DESC)  
      BEGIN  
        RAISERROR('You are Entered Wrong Password', 17,1)  
        RETURN 
      END  

ELSE IF NOT EXISTS(SELECT TOP 1 * FROM ubmCustomerLogin WHERE CustomerEmail= @email AND Password =@password AND isSessionExpired =1)
     BEGIN
       RAISERROR('Session is Expired. Please Contact with Administrator', 17,1) 
       RETURN  
     END
ELSE   
   BEGIN  
   SELECT TOP 1 * FROM ubmCustomerLogin WHERE CustomerEmail= @email AND Password =@password ORDER BY CreatedAt DESC   
   UPDATE ubmCustomerLogin SET LoginAt = GETDATE() WHERE CustomerEmail= @email AND Password =@password   
   END            
END  
GO

----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetDetailsByUnitID]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetDetailsByUnitID] 
GO

CREATE PROC ubm_GetDetailsByUnitID      
@GroupID decimal(18,0),      
@ubmID int      
AS      
BEGIN      

select mb.UbmID,ISNULL(mb.UnitID,0)UnitID,ISNULL(mu.unitno,'E.O.I')unitno,ISNULL(uad.ApplicantName,'')ApplicantName,ISNULL(mp.ProjectName,'E.I.O')ProjectName,  
mb.BookingStatusID AS Status,mb.CustEmail,mb.CustMobNo,MB.UnitType,mb.ReleaseUnitDate,ISNULL(mb.ApplicationType,'')ApplicationType,MP.ProjectID,PB.BlockID AS TowerID, PB.BlockName as TowerName, B.BlockID as FloorID,B.BlockName as FloorName
FROM ubmUnitBooking mb      
LEFT join mstunit (NOLOCK) mu on mu.UnitID =  mb.UnitID      
LEFT join mstProject (NOLOCK) mp on mp.ProjectID = mu.ProjectID  
LEFT JOIN mstBlock (NOLOCK) B ON mp.ProjectID=B.ProjectID AND  B.BlockID = mu.BlockID   
LEFT JOIN mstBlock (NOLOCK) PB ON PB.BlockID=B.ParentID AND PB.ParentID IS NULL  
LEFT join ubmApplicantDetails (NOLOCK) uad on uad.ubmid=mb.ubmid and uad.applicantType= 1    
where mb.GroupID=@GroupID and mb.ubmID=@ubmID       
END
GO

--------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetUserProjects]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetUserProjects] 
GO
CREATE PROC ubm_GetUserProjects
@GroupID DECIMAL(18,2),
@ubmUserID INT
AS
BEGIN
	DECLARE @RoleName VARCHAR(20)
	SET @RoleName = (SELECT RoleName FROM ubmUsers WHERE ubmUserID =@ubmUserID AND GroupID=@GroupID)
	SELECT DISTINCT P.ProjectID,P.ProjectName
	FROM ubmProjectPermission UPP (NOLOCK)
	INNER JOIN mstProject P(NOLOCK) ON UPP.ProjectID=P.ProjectID
	WHERE P.GroupID=@GroupID AND UPP.UbmUserID =CASE WHEN @RoleName ='Admin/CFO' THEN UPP.ubmUserID ELSE @ubmUserID END
END
GO
----------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetTowerByProjectId]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetTowerByProjectId] 
GO
CREATE PROC ubm_GetTowerByProjectId
@GroupID DECIMAL(18,2),
@ProjectID INT,
@ubmUserID INT
AS
BEGIN
	DECLARE @RoleName VARCHAR(20)
	SET @RoleName = (SELECT RoleName FROM ubmUsers WHERE ubmUserID = @ubmUserID AND GroupID=@GroupID)
	
	SELECT DISTINCT B.BlockID,B.BlockName
	FROM ubmProjectPermission UPP (NOLOCK)
	INNER JOIN mstProject P(NOLOCK) ON UPP.ProjectID=P.ProjectID
	INNER JOIN mstBlock B (NOLOCK) ON B.ProjectID=P.ProjectID AND B.BlockID =ISNULL(UPP.TowerID,B.BlockID)
	WHERE P.GroupID=@GroupID AND UPP.UbmUserID = CASE WHEN @RoleName ='Admin/CFO' THEN UPP.ubmUserID ELSE @ubmUserID END
	AND B.ParentID IS NULL
END
GO

----------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_ChangeUnitStatus]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_ChangeUnitStatus] 
GO
CREATE PROC ubm_ChangeUnitStatus
@GroupID decimal(18,0),
@unitID int,
@status int
AS
BEGIN

IF NOT EXISTS(SELECT TOP 1 * FROM ubmUnitDetail  WHERE UnitID=@unitID AND groupID= @GroupID)
	BEGIN
	RAISERROR('Invalid Unit No',17,1)
	END
ELSE
	BEGIN
	UPDATE ubmUnitDetail SET Status = @status WHERE UnitID=@unitID AND groupID= @GroupID
	END
END
GO
--------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetPaymentPlanByUnitBlock]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetPaymentPlanByUnitBlock] 
GO

CREATE PROCEDURE [dbo].[ubm_GetPaymentPlanByUnitBlock]              
 -- Add the parameters for the stored procedure here              
 @BlockID ID,              
 @UnitID ID,              
 @CompanyID ID,              
 @LocationID ID              
AS              
BEGIN              
 -- SET NOCOUNT ON added to prevent extra result sets from              
 -- interfering with SELECT statements.              
 SET NOCOUNT ON;              
              
    -- Insert statements for procedure here              
          
          
	SELECT distinct PayPlanID, PayPlanName, Rate into #tmp from  vw_GetPaymentPlan              
	WHERE (BlockID=@BlockID AND (UnitID=@UnitID or UnitID is null)) AND LocationID=@LocationID AND CompanyID=@CompanyID              
	IF (@@rowcount>0)            
	Begin   
		SELECT * from #tmp            
	End          
	Else          
	begin              
      
		SELECT distinct PayPlanID, PayPlanName,Rate from vw_GetPaymentPlan              
		inner join mstblock              
		on mstblock.parentid=vw_GetPaymentPlan.blockid              
		WHERE (mstblock.BlockID=@BlockID )               
	end             
End   
GO
-----------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_deleteBookingAmount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_deleteBookingAmount] 
GO

CREATE PROC ubm_deleteBookingAmount
@groupID decimal(18,0),
@paymentID decimal(18,0)
AS
BEGIN
	IF NOT EXISTS(SELECT TOP 1 * FROM ubmBookedUnitPayment WHERE UbmPaymentId = @paymentID AND GroupID=@groupID)
	BEGIN 
	RAISERROR('Invalid Input Details',17,1)
	RETURN;
    END
ELSE
BEGIN
	DELETE FROM ubmBookedUnitPayment WHERE UbmPaymentId = @paymentID AND GroupID=@groupID
END
END
GO

-----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetApplicationDocument]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetApplicationDocument] 
GO

CREATE PROC ubm_GetApplicationDocument
@GroupID DECIMAL(18,0),
@ApplicationType VARCHAR(30)
AS
BEGIN
	SELECT DocumentName FROM ubmDocument WHERE ApplicationType=@ApplicationType AND GroupID=@GroupID
END
GO

--------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_deleteKYCDocuments]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_deleteKYCDocuments] 
GO

CREATE PROC ubm_deleteKYCDocuments  
@UbmKycid INT,  
@GroupID DECIMAL  
AS  
BEGIN  
IF NOT EXISTS(SELECT TOP 1 * FROM ubmKycDocument WHERE GroupID=@GroupID AND UbmKycid= @UbmKycid)  
	BEGIN  
	RAISERROR('Attachments doesnt exists in Server',17,1)  
	RETURN;
END  
ELSE  
	BEGIN  
	DELETE FROM ubmKycDocument WHERE GroupID=@GroupID AND UbmKycid= @UbmKycid  
END  
END
GO
---------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetUnitDetails]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_GetUnitDetails] 
GO
CREATE PROC ubm_GetUnitDetails
@GroupID DECIMAL(18,0),
@UnitID INT
AS 
BEGIN
	SELECT UnitNo,UnitTypeName,ISNULL(UnitCarpetArea,0)  AS UnitCarpetArea,B.BlockName  FROM mstUnit(NOLOCK) U
	INNER JOIN mstBlock(NOLOCK) B ON B.BlockID = U.BlockID  WHERE UnitID=@UnitID
	AND B.ParentID IS NOT NULL
END
GO

--------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_TNCTemplate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_TNCTemplate] 
GO
CREATE PROC ubm_TNCTemplate    
@groupID INT,    
@ubmID DECIMAL    
AS    
BEGIN  
 SELECT TemplateMsg FROM ubmUnitBooking UBM (NOLOCK)  
 INNER JOIN mstUnit MU (NOLOCK) ON MU.UnitID = UBM.UnitID  
 INNER JOIN ubmTemplate (NOLOCK) UT ON UT.ProjectID= MU.ProjectID  
 WHERE UBM.UbmID =@ubmID  AND UBM.GroupID = @groupID AND ProcessType = 'T&C'  
END
GO
------------------------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_SaveMailConfigure]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_SaveMailConfigure] 
GO
CREATE PROC ubm_SaveMailConfigure
@MailConfigureID INT,
@GroupID DECIMAL(18,0),
@ConfigureType VARCHAR(10),
@SenderName VARCHAR(200) NULL,
@SMTPServer VARCHAR(200 )  NULL,
@UserName VARCHAR(200)  NULL,	
@Password VARCHAR(200)  NULL,
@PerHourMail INT =NULL,
@PortNo INT  NULL,
@SmsUrl VARCHAR(MAX)  NULL,	
@TokenWA VARCHAR(200)  NULL,	
@PhoneWA VARCHAR(200)  NULL, 
@BasedOn VARCHAR(50)  NULL,
@Provider VARCHAR(50)  NULL,
@CreatedBy INT,
@IsActive BIT
AS 
BEGIN	
	IF(@MailConfigureID = 0)
	BEGIN 
		IF EXISTS( SELECT 1 FROM ubmMailConfigure  WHERE GroupID=@GroupID AND ConfigureType=@ConfigureType AND IsActive=@IsActive)
		BEGIN
			RAISERROR('Configuration exists already for the selected type.',17,1)
			RETURN
		END
		 
		INSERT INTO ubmMailConfigure (GroupID,ConfigureType,SenderName,SMTPServer,UserName,Password,PortNo,
		SmsUrl,TokenWA,PhoneWA,BasedOn,[Provider],CreatedBy,CreatedOn,IsActive)
		VALUES(@GroupID,@ConfigureType,@SenderName,@SMTPServer,@UserName,@Password,@PortNo,
		@SmsUrl,@TokenWA,@PhoneWA,@BasedOn,@Provider,@CreatedBy,GETDATE(),@IsActive)
	END
	ELSE
	BEGIN
		IF EXISTS( SELECT 1 FROM ubmMailConfigure WHERE GroupID=@GroupID AND ConfigureType=@ConfigureType 
		AND IsActive=@IsActive AND MailConfigureID<>@MailConfigureID)
		BEGIN
			RAISERROR('Configuration exists already for the selected type.',17,1)
			RETURN
		END
		IF(@IsActive =1)
		BEGIN
			UPDATE ubmMailConfigure SET IsActive=0 WHERE ConfigureType=@ConfigureType AND GroupID=@GroupID
		END
		UPDATE ubmMailConfigure SET ConfigureType=@ConfigureType,SenderName=@SenderName,SMTPServer=@SMTPServer,UserName=@UserName,
		Password=@Password,PortNo=@PortNo,SmsUrl=@SmsUrl,TokenWA=@TokenWA,PhoneWA=@PhoneWA,
		BasedOn=@BasedOn,[Provider]=@Provider,IsActive=@IsActive
		WHERE  MailConfigureID=@MailConfigureID
	END
	  
END
GO

------------------------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_DeleteMailConfigure]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].ubm_DeleteMailConfigure 
GO
CREATE PROC ubm_DeleteMailConfigure 
@MailConfigureID INT
AS
BEGIN
	DELETE FROM ubmMailConfigure WHERE MailConfigureID=@MailConfigureID
END
GO
--------------------------------------------------------------------------------------------------------------------


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_GetMailConfigure]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].ubm_GetMailConfigure 
GO
CREATE PROC ubm_GetMailConfigure 
@GroupID DECIMAL(18,0)
AS
BEGIN
	SELECT MailConfigureID, GroupID,ConfigureType,CASE WHEN SenderName ='' OR SenderName IS NULL THEN PhoneWA ELSE SenderName END  AS SenderName,SMTPServer,UserName,Password,
	ISNULL(PerHourMail,0) AS PerHourMail,PortNo,
	SmsUrl,TokenWA,PhoneWA,BasedOn,[Provider],IsActive
	FROM ubmMailConfigure WHERE GroupID=@GroupID
END
GO

----------------------------------------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_getControlMaster]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ubm_getControlMaster] 
GO
CREATE PROC ubm_getControlMaster    
@GroupID DECIMAL(18,0),    
@UserID int,  
@pageType VARCHAR(30)=NULL   
AS    
BEGIN    
	DECLARE @RoleName VARCHAR(20)    
	SET @RoleName = (SELECT RoleName FROM ubmUsers WHERE ubmUserID =@UserID AND GroupID=@GroupID)      
	SELECT RoleName,MenuType,isTab,isCreate,isEdit,isView,isDelete,isApproved FROM ubmControlMaster   
	WHERE RoleName =@RoleName and GroupID=@GroupID  
	AND MenuType= CASE WHEN @pageType IS NOT NULL THEN @pageType ELSE MenuType END  
END 
GO
-----------------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ubm_getUbmUnitLogs]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].ubm_getUbmUnitLogs
GO
CREATE PROC ubm_getUbmUnitLogs
@GroupID DECIMAL(18,0),
@ubmID INT
AS
BEGIN
	SELECT US.StatusName,UL.Remarks,FORMAT(UL.CreatedOn,'dd-MMM-yyyy, hh:mm tt')CreatedOn,MU.UserName FROM ubmLogs (Nolock) UL
	INNER JOIN ubmBookingStatus (Nolock) US ON US.BookingStatusID=UL.BookingStatusID
	INNER JOIN ubmunitbooking (Nolock) UBM on UBM.UbmID=UL.UbmID
	INNER JOIN UbmUsers (Nolock) UU on UU.ubmUserID=UL.CreatedBy
	INNER JOIN MstUser (Nolock) MU on MU.UserID= UU.UserID
	where UL.ubmid=@ubmID and UBM.GroupID=@GroupID
END
GO