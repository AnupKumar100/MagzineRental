USE [MagzineCet]
GO
/****** Object:  StoredProcedure [dbo].[insertRental]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[insertRental](
@cust_id int,
@mag_id int
)
as
Begin
 insert into Rental values(@cust_id, @mag_id, GETDATE(), null);
 update Magzine set NumberAvailable = NumberAvailable - 1 where Id = @mag_id
End

GO
/****** Object:  StoredProcedure [dbo].[usp_deleteMagz]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_deleteMagz] (@Id int)
as 
Begin
	delete from Magzine where Id = @Id;
End

GO
/****** Object:  StoredProcedure [dbo].[usp_deleteRecord]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_deleteRecord] (@Id int)
as
Begin
	delete from customer where Id = @Id;
End

GO
/****** Object:  StoredProcedure [dbo].[usp_getCustomer]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getCustomer] as
Begin
	select c.Id, c.Name,c.Birthdate, c.IsSubscribedToNewsLetter, Isnull(m.Id,0) as MemberId, Isnull(m.name,'') as Membername,
	m.DiscountRate
    from customer c left join MembershipType m on c.MembershipId = m.id
End

GO
/****** Object:  StoredProcedure [dbo].[usp_getGenre]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getGenre] as
Begin
 select Id, Name from Genre order by 1
End

GO
/****** Object:  StoredProcedure [dbo].[usp_getMagzine]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_getMagzine] as

Begin

select m.Id, m.Name, m.GenreId,m.NumberInStock,m.NumberAvailable, g.Name as GenreName  from Magzine m Left join Genre g on m.GenreId = g.Id;

End

GO
/****** Object:  StoredProcedure [dbo].[usp_getMembership]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getMembership] as
begin
 select Id, Name from MembershipType order by 1
End

GO
/****** Object:  StoredProcedure [dbo].[usp_getOneCustomer]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_getOneCustomer] (@Id int)
as
Begin
	select c.Id, c.Name, c.Birthdate, c.IsSubscribedToNewsLetter, Isnull(m.Id,0) as MemberId, Isnull(m.name,'') as Membername,
	m.DiscountRate
    from customer c left join MembershipType m on c.MembershipId = m.id where c.Id = @Id;
End

GO
/****** Object:  StoredProcedure [dbo].[usp_getOneMagz]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_getOneMagz] (@Id int)
as 
Begin
	select Id, Name, GenreId, ReleaseDate, NumberInStock from Magzine where Id = @Id;
End

GO
/****** Object:  StoredProcedure [dbo].[usp_insert_update_customer]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_insert_update_customer] 
(@Id int,
 @name varchar(255),
 @memberid int,
 @Birthdate datetime = null,
 @IsSubscribe bit
)
as
Begin
  if(@Id = 0)
	insert into customer values(@name, @memberid, @Birthdate, @IsSubscribe);
  Else
    update customer set Name =@name, MembershipId =@memberid, Birthdate = @Birthdate, IsSubscribedToNewsLetter = @IsSubscribe where Id = @Id;
  
End

GO
/****** Object:  StoredProcedure [dbo].[usp_insert_update_magz]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_insert_update_magz] 
(@Id int,
 @name varchar(255),
 @genreid int,
 @realeasedate datetime = null,
 @stock smallint
)
as
Begin
declare @Toadd int

  if(@Id = 0)
	insert into Magzine values(@name, @genreid, @realeasedate,getdate(), @stock, @stock);
  Else
    select @Toadd = (NumberAvailable + (@stock - NumberInStock))  from Magzine where Id = @id
    update Magzine set Name =@name, GenreId =@genreid, ReleaseDate = @realeasedate, NumberInStock = @stock, NumberAvailable = @Toadd where Id = @Id;
  
End






GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[customer]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[MembershipId] [int] NULL,
	[Birthdate] [datetime] NULL,
	[IsSubscribedToNewsLetter] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Genre]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Genre](
	[Id] [int] NOT NULL,
	[Name] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Magzine]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Magzine](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[GenreId] [int] NULL,
	[ReleaseDate] [datetime] NULL,
	[DateAdded] [datetime] NULL,
	[NumberInStock] [int] NULL,
	[NumberAvailable] [int] NULL,
 CONSTRAINT [PK__Magzine__3214EC0775DEE584] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MembershipType]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MembershipType](
	[Id] [int] NOT NULL,
	[name] [varchar](50) NULL,
	[singupfee] [int] NULL,
	[DurationInMonths] [int] NULL,
	[DiscountRate] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[passwordtable]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[passwordtable](
	[name] [varchar](120) NULL,
	[passwords] [varchar](120) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rental]    Script Date: 28-02-2022 12:34:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rental](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Customer_id] [int] NULL,
	[Magzine_id] [int] NULL,
	[DateRented] [datetime] NULL,
	[DateReturned] [datetime] NULL
) ON [PRIMARY]

GO
INSERT [dbo].[__MigrationHistory] ([MigrationId], [ContextKey], [Model], [ProductVersion]) VALUES (N'202201180256068_InitialCreate', N'MyVivdly.Models.ApplicationDbContext', 0x1F8B0800000000000400DD5CDB6EE338127D5F60FF41D0D3EC2263E5B2DDE80D9C19649C6436D8CE05ED7463DE1AB4443B424B9446A2320916FB65FB309F34BFB04589BAF0A68BADD8CEA0814644164F158B45B2582CFA8FFFFD3EFDF1390CAC279CA47E44CEECA3C9A16D61E2469E4F5667764697DF7FB07FFCE1AF7F995E7AE1B3F5A5A43B6174D092A467F623A5F1A9E3A4EE230E513A097D3789D26849276E143AC88B9CE3C3C37F3A47470E06081BB02C6BFA2923D40F71FE019FB388B838A6190A6E220F07292F879A798E6ADDA210A73172F1997DF3F2C57FF2829749416A5BE7818F408C390E96B685088928A220E4E9E714CF691291D53C8602143CBCC418E89628483117FEB426EFDB8FC363D60FA76E5842B9594AA37020E0D109578C23375F4BBD76A53850DD25A898BEB05EE7EA3BB3AF3D9C177D8A025080CCF07416248C18345CB1384FE35B4C2765C34901799500DC6F51F26DD2443CB07AB73BA80CE97872C8FE1D58B32CA05982CF08CE68828203EB3E5B04BEFB6FFCF2107DC3E4ECE468B13CF9F0EE3DF24EDEFF039FBC6BF614FA0A74420114DD27518C13900D2FABFEDB9623B673E48655B3469B422B604B30276CEB063D7FC464451F61B61C7FB0AD2BFF197B650937AECFC48729048D6892C1E76D16046811E0AADE69E5C9FE6FE17AFCEEFD285C6FD193BFCA875EE20F13278179F50907796DFAE8C7C5F412C6FB2B27BB4AA2907D8BF655D47E9D4759E2B2CE4446920794AC3015A59B3AB5F1F632690635BE5997A8FB6FDA4C52D5BCB5A4AC43EBCC8492C5B6674329EFEBF2ED6D71E7710C83979B16D348ABC1893BD5446A0A56C5096AA339EA6B34043AF3675E032F43E407232C823DB880F3B1F4931057BDFC2902934364B0CCF7284D610DF0FE85D2C716D1E1CF11449F63374BC034E71485F1AB73BB7F8C08BECDC205B3F8EDF11A6D681E7E8BAE904BA3E492B0561BE37D8CDC6F51462F89778128FE4CDD12907D3EF8617F8051C439775D9CA65760CCD89B45E05B9780D7849E1C0F8663ABD3AE9D905980FC50EF8548EBE8D792B4F644F4148A376220D379246DA27E8C563EE9276A496A16B5A0E81495930D159581F59394539A05CD093AE52CA846F3F1F2111ADFC9CB61F7DFCBDB6CF336AD050D35CE6185C43F63821358C6BC7B44294E483D027DD68D5D380BF9F031A6AFBE37E59CBEA0201B9BD55AB3215F04C69F0D39ECFECF865C4C287EF23DE695F438FA94C400DF8B5E7FAAEA9E739264DB9E0E4237B7CD7C3B6B8069BA9CA769E4FAF92CD004BD78C842941F7C38AB3B7E51F4468E8140C7C0D07DB6E54109F4CD968DEA8E5CE000536C9DBB45507086521779AA1AA143DE00C1CA1D5523581D0B1185FBBBC2132C1D27AC116287A01466AA4FA83A2D7CE2FA310A3AB524B5ECB985B1BE573CE49A0B1C63C218766AA20F737DE8830950F19106A54B4353A76171ED8668F05A4D63DEE5C2D6E3AE4424B662931DBEB3C12EB9FFF62A86D9AEB12D1867BB4AFA08600CE3EDC240F959A5AF01C807977D3350E9C4643050EE526DC540458DEDC0404595BC39032D8EA87DC75F3AAFEE9B798A07E5ED6FEBADEADA816D0AFAD833D32C7C4F6843A1054E54F3BC58B04AFC4C35873390939FCF52EEEACA26C2C0E7988A219BDADFD5FAA14E3B886C446D80B5A17580F20B400548995003842B6379ADD2712F62006C19776B85E56BBF04DBB00115BB7911DA20345F97CAC6D9EBF451F5ACB206C5C87B1D161A381A8390172FB1E33D94628ACBAA8AE9E30B0FF1861B1DE383D1A2A00ECFD5A0A4B233A36BA934CD6E2DE91CB2212ED9465A92DC278396CACE8CAE256EA3DD4AD2380503DC828D54246EE1234DB632D251ED3655DDD42992A378C1D43164514D6F501CFB64D5C8AAE225D6BC48A99A7D3F1F9E6E1416188E9B6AB28E2A692B4E344AD00A4BB5C01A24BDF293945E208A1688C579665EA89069F756C3F25FB26C6E9FEA2096FB4049CDFE2E5AC8D7F6C246AB7A221CE00ABA173277268FA16B065FDFDC62296E284089266C3F8B822C2466EFCADCBAB8BC6BB62F4A5484A923C9AF784F8AAA141F57D47BAF515167C4182354792EEB8F9219C2A4EBD2EF6C6ADBE48B9A51CAD05413C514AEDAD9A8995C98FE2325BB86C307AA13E1756614CF476902F0A281188D940605AC51D71F55CC3A69628A35FD11A5D49226A4543540CA6602892064B3622D3C8346F514FD39A829234D74B5B63FB22679A409ADA95E035B23B35CD71F55935FD204D654F7C7AE934DE415748FF72CE38165BD4DAB38D06EB66B19305E67391C67D36BDCDB37811AC503B1F8CDBC02C6CBF7D2948CA7BAF54CA908626C664A060CF39A235C778B4B4EEB1DBD1953B8C31696F5B63B7C33DE30837D55B3504E743249C5BD3AD94927B8293F4D753F96518E5705896D956A842DFD25A5389C3082C9FCD76016F8982DE025C10D22FE12A7B4C8DBB08F0F8F8EA52737FBF3FCC549532FD09C464D6F60C431DB420A16794289FB881235216283272235A8126BBE261E7E3EB3FF93B73ACDC316ECAFBCF8C0BA4E3F13FFD70C2A1E920C5BFF55133CC749996F3F5BEDE90387FE5ABDFEE56BD1F4C0BA4B60C69C5A87922ED71961F1D9C320698AA61B48B3F66388B73BA184F7065A546942ACFFBC60E1D3519E1694527E17A2E7BF0D154DFB7C602344CD1381B1F04651A1E909C03A58C6F47F0F3E699EFE3FACB3FAE700EB88667C0AE093E160F24380FECB50D972875B8DE640B48D2529D7736722F5465995BBDE9B947CEB8D26BA9A533D006E83BCE9352CE38DA51C8FB63B6A328A47C3DEA569BF7A1AF1BE640ED7391DBB4D18DE668E70CB6DD09F2A35780F92D934C939BB4F00DEB6AD9982B87B9E45392CCD77CF8C8DA76CED3E9977DBC6660AF3EEB9B10D4AD9DD335BDBD5FEB9634BEBBD85EE3C0157CD25325CC6E862C15D09B645E01C4EF88B088CA0F0288B7791FA8CAEB66CD40E86358999A939954C66AC4C1C85AF42D1CE76585FF986DFDA594ED3CED69080D9C69BAFFFADBC394D3B6F435AE32E5283B58985BA74ED8E75AC2DF7E92DA5020B3DE9C83CEFF2595B6FD6DF52E6EF284A11668FE18EF8ED24FA8EA29231A7CE80C45EF5BA17F6CEC62F28C2FE9DFAAB1A82FD9E22C1AEB06B5634D76419959BB72451492245686E30451E6CA9E709F597C8A550CD62CCF9C3EE3C6EC76E3A16D8BB2677198D330A5DC6E12210025ECC0968E39F672F8B324FEFE2FC374AC6E80288E9B3D8FC1DF929F303AF92FB4A1313324030EF824774D9585216D95DBD5448B711E909C4D55739450F388C03004BEFC81C3DE1756403F3FB8857C87DA923802690EE8110D53EBDF0D12A4161CA31EAF6F00936EC85CF3FFC1FD19BEBEE48540000, N'6.1.3-40302')
INSERT [dbo].[AspNetRoles] ([Id], [Name]) VALUES (N'cd2309b3-6080-40b3-882a-7a2e941247ac', N'Admin')
INSERT [dbo].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (N'ffaae305-4109-42cf-86aa-cf9574c0a8d4', N'cd2309b3-6080-40b3-882a-7a2e941247ac')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'7a58b073-3103-4daa-a1aa-69c5940a4164', N'Staff@magzinecent.com', 0, N'AFqJIsrWYS1Cg20Ht3FqQONlRSleatqdOxYpYhhLSJzrJSXdTsSpZyQwB0uB2YHcPQ==', N'e9eced5d-92bd-484f-9058-1d350c5de1a7', NULL, 0, 0, NULL, 1, 0, N'Staff@magzinecent.com')
INSERT [dbo].[AspNetUsers] ([Id], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName]) VALUES (N'ffaae305-4109-42cf-86aa-cf9574c0a8d4', N'Admin@magzinecent.com', 0, N'AOoZz56kxRcUFf0I9DqB5i0rSEq4w3EQsyBeje4Its+RoPZdKahxQZh9WVOGI+3SsQ==', N'12f4c31c-a459-4611-a0e9-eeb89abef726', NULL, 0, 0, NULL, 1, 0, N'Admin@magzinecent.com')
SET IDENTITY_INSERT [dbo].[customer] ON 

INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (1, N'Anup', 3, CAST(0x000080A700000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (4, N'Joe Smite', 2, CAST(0x0000861E00000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (21, N'Rohit', 3, CAST(0x000090B300000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (23, N'Rohit kumar', 1, NULL, 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (24, N'Anup Kumar', 4, CAST(0x000080A700000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (25, N'Mohan parsad', 1, CAST(0x000088F800000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (36, N'hiilie koi', 1, NULL, 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (39, N'hari lii', 4, CAST(0x0000910100000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (40, N'Anup First', 3, CAST(0x000080A700000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (42, N'Joe Smite senti', 2, CAST(0x0000861E00000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (43, N'anup kumar1', 2, CAST(0x0000861E00000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (44, N'Natinl kioln', 2, CAST(0x0000940800000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (45, N'jeneba', 4, CAST(0x0000944600000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (48, N'jenny jenny', 4, CAST(0x000090B300000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (49, N'jenny jenny 2', 2, CAST(0x000088F800000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (50, N'kotiln', 2, CAST(0x0000940800000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (52, N'mollieu hallan', 2, CAST(0x000093DC00000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (54, N'stananty', 2, CAST(0x000093DC00000000 AS DateTime), 1)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (56, N'phenix', 2, CAST(0x0000852000000000 AS DateTime), 0)
INSERT [dbo].[customer] ([Id], [Name], [MembershipId], [Birthdate], [IsSubscribedToNewsLetter]) VALUES (57, N'jinniy', 2, CAST(0x000090B300000000 AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[customer] OFF
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (1, N'Automotive')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (2, N'Business')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (3, N'Children')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (4, N'Entertainment')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (5, N'Fashion')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (6, N'Gadgets & Technology')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (7, N'Health, Mind & Soul')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (8, N'Home & Interiors')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (9, N'News & Education')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (10, N'Sports')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (11, N'Travel')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (12, N'Women''s Interest')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (13, N'Lifestyle')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (14, N'Industry')
INSERT [dbo].[Genre] ([Id], [Name]) VALUES (15, N'Spiritual')
SET IDENTITY_INSERT [dbo].[Magzine] ON 

INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (1, N'Auto Today', 1, CAST(0x0000AE3000000000 AS DateTime), CAST(0x0000AE470105AE47 AS DateTime), 3, 3)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (2, N'Car India', 1, CAST(0x0000AE1100000000 AS DateTime), CAST(0x0000AE470105D971 AS DateTime), 9, 9)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (3, N'India Business Journal', 2, CAST(0x0000ACDF00000000 AS DateTime), CAST(0x0000AE47010633AD AS DateTime), 4, 4)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (4, N'Champak Hindi', 3, CAST(0x0000AE3200000000 AS DateTime), CAST(0x0000AE4701067811 AS DateTime), 4, 3)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (5, N'Pinki English', 3, CAST(0x0000AD3D00000000 AS DateTime), CAST(0x0000AE470106A267 AS DateTime), 7, 7)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (6, N'Nandan Hindi', 3, CAST(0x0000AD0000000000 AS DateTime), CAST(0x0000AE470106C73A AS DateTime), 9, 7)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (7, N'Filmfare', 4, CAST(0x0000ACC200000000 AS DateTime), CAST(0x0000AE470106FD14 AS DateTime), 3, 3)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (8, N'Global Movie', 4, CAST(0x0000AE3000000000 AS DateTime), CAST(0x0000AE470107BBF4 AS DateTime), 5, 5)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (9, N'Fhm fit', 5, CAST(0x0000AD7900000000 AS DateTime), CAST(0x0000AE470107F6D4 AS DateTime), 5, 5)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (10, N'Data Quest', 6, CAST(0x0000ACC600000000 AS DateTime), CAST(0x0000AE4701082C12 AS DateTime), 3, 3)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (11, N'Dq channel', 6, CAST(0x0000AD7000000000 AS DateTime), CAST(0x0000AE4701086923 AS DateTime), 7, 7)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (12, N'Sadhana Path', 7, CAST(0x0000AE2F00000000 AS DateTime), CAST(0x0000AE470108B864 AS DateTime), 4, 4)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (13, N'Reader''s Digest', 7, CAST(0x0000AE2F00000000 AS DateTime), CAST(0x0000AE470108D929 AS DateTime), 4, 3)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (14, N'Better Interiors', 8, CAST(0x0000ABCF00000000 AS DateTime), CAST(0x0000AE4701092058 AS DateTime), 4, 4)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (15, N'Treands', 8, CAST(0x0000ADDB00000000 AS DateTime), CAST(0x0000AE4701094766 AS DateTime), 2, 2)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (16, N'Pratiyogita Darpan', 9, CAST(0x0000AE2F00000000 AS DateTime), CAST(0x0000AE4701098675 AS DateTime), 9, 8)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (17, N'India Today Hindi', 9, CAST(0x0000AE1000000000 AS DateTime), CAST(0x0000AE470109B188 AS DateTime), 3, 2)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (18, N'BCC Knowledge', 9, CAST(0x0000A8B600000000 AS DateTime), CAST(0x0000AE470109E4E3 AS DateTime), 2, 2)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (19, N'Cricket today', 10, CAST(0x0000AE4000000000 AS DateTime), CAST(0x0000AE47010A17B6 AS DateTime), 2, 2)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (20, N'Outlook Travler', 11, CAST(0x0000ADB600000000 AS DateTime), CAST(0x0000AE47010A47E2 AS DateTime), 4, 4)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (21, N'Grih laxmi', 12, CAST(0x0000ACC200000000 AS DateTime), CAST(0x0000AE47010A7CBC AS DateTime), 6, 6)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (22, N'Apparel', 13, CAST(0x0000ACA900000000 AS DateTime), CAST(0x0000AE47010AB867 AS DateTime), 1, 1)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (23, N'Digital studio', 14, CAST(0x0000AB5400000000 AS DateTime), CAST(0x0000AE47010AF8BC AS DateTime), 7, 7)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (24, N'Isha Forest Flower', 15, CAST(0x0000AD6300000000 AS DateTime), CAST(0x0000AE47010B3640 AS DateTime), 4, 4)
INSERT [dbo].[Magzine] ([Id], [Name], [GenreId], [ReleaseDate], [DateAdded], [NumberInStock], [NumberAvailable]) VALUES (25, N'Women Era', 5, CAST(0x0000ADF700000000 AS DateTime), CAST(0x0000AE47010C024D AS DateTime), 5, 3)
SET IDENTITY_INSERT [dbo].[Magzine] OFF
INSERT [dbo].[MembershipType] ([Id], [name], [singupfee], [DurationInMonths], [DiscountRate]) VALUES (1, N'Pay as You Go', 0, 0, 0)
INSERT [dbo].[MembershipType] ([Id], [name], [singupfee], [DurationInMonths], [DiscountRate]) VALUES (2, N'Monthly', 30, 1, 10)
INSERT [dbo].[MembershipType] ([Id], [name], [singupfee], [DurationInMonths], [DiscountRate]) VALUES (3, N'Quarterly', 90, 3, 15)
INSERT [dbo].[MembershipType] ([Id], [name], [singupfee], [DurationInMonths], [DiscountRate]) VALUES (4, N'Annual', 300, 12, 20)
INSERT [dbo].[passwordtable] ([name], [passwords]) VALUES (N'this is custom table for store password', N'by anup -manually')
INSERT [dbo].[passwordtable] ([name], [passwords]) VALUES (N'Admin@magzinecent.com', N'Admin@1900')
INSERT [dbo].[passwordtable] ([name], [passwords]) VALUES (N'Staff@magzinecent.com', N'Staff@1')
SET IDENTITY_INSERT [dbo].[Rental] ON 

INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (1, 21, 5, CAST(0x0000AE430151899C AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (2, 21, 6, CAST(0x0000AE43015189B7 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (3, 24, 17, CAST(0x0000AE47010E0DFE AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (4, 24, 4, CAST(0x0000AE47010E0E03 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (5, 24, 6, CAST(0x0000AE47010E0E03 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (6, 24, 16, CAST(0x0000AE47010E0E03 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (7, 24, 13, CAST(0x0000AE47010E0E04 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (8, 44, 6, CAST(0x0000AE4A00C9C613 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (9, 44, 25, CAST(0x0000AE4A00C9C624 AS DateTime), NULL)
INSERT [dbo].[Rental] ([Id], [Customer_id], [Magzine_id], [DateRented], [DateReturned]) VALUES (10, 1, 25, CAST(0x0000AE4A00CA5E3C AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[Rental] OFF
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[customer]  WITH CHECK ADD  CONSTRAINT [costomerMember] FOREIGN KEY([MembershipId])
REFERENCES [dbo].[MembershipType] ([Id])
GO
ALTER TABLE [dbo].[customer] CHECK CONSTRAINT [costomerMember]
GO
ALTER TABLE [dbo].[Magzine]  WITH CHECK ADD  CONSTRAINT [FK__Magzine__GenreId__22AA2996] FOREIGN KEY([GenreId])
REFERENCES [dbo].[Genre] ([Id])
GO
ALTER TABLE [dbo].[Magzine] CHECK CONSTRAINT [FK__Magzine__GenreId__22AA2996]
GO
