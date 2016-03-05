Use Test_Dexpress_Schedule

/* Creando Tabla Grupo de usuarios */

Create Table GruposUsuarios
(
  ID_GrupoUsuario Int not null Identity(1,1),
  NombreGrupo     Varchar(50) not null,
  Primary Key(ID_GrupoUsuario) 

)

Go

/* Creando Tabla Roles */

Create Table Roles 
(
  ID_Rol          Int not null Identity(1,1),
  NombreRol       Varchar(50) not null,
  ID_GrupoUsuario Int not null,
  Primary key(ID_Rol),
  Foreign key(ID_GrupoUsuario) REFERENCES GruposUsuarios(ID_GrupoUsuario)
  On delete cascade
  on update cascade,
  )
  Go
/* Creando Tabla Usuarios */

Create Table Usuarios 
(
  ID_Usuario Int not null Identity(1,1),
  Nombre      Varchar(50) not null,
  Apellido    Varchar(50),
  Usuario     Varchar(50) not null,
  Contraseña  Varchar(50) not null,
  ID_Rol      int,
  Primary Key(ID_Usuario),
  Foreign Key(ID_Rol) REFERENCES Roles(ID_Rol)
  On delete cascade
  on update cascade,
)
Go
/* Creando Tabla Perfiles */

Create  table Perfiles
(
  ID_Perfil    Int not null Identity(1,1),
  NombrePerfil Varchar(50) not null,
  ID_Usuario   Int,
  Primary key(ID_perfil),
  Foreign Key(ID_Usuario) REFERENCES Usuarios(ID_Usuario)
  On delete cascade
  on update cascade,
  
)
Go

/* Creando Tabla Opciones */

Create Table Opciones 
(
 ID_Opcion int not null Identity(1,1),
 Opcion    Varchar(50) not null, 
 Estado    Bit not null,
 ID_Perfil int
 Primary Key(ID_Opcion),
 Foreign Key(ID_Perfil) REFERENCES Perfiles(ID_Perfil) 
 On delete cascade
 on update cascade,
 
 )
  GO
  
  /* Creando Tabla Funciones */

Create Table Funciones 
(
  ID_Funcion Int not null Identity(1,1),
  Funcion    Varchar(50) not null,
  Estado     Bit not null, 
  ID_Opcion  int ,
  Primary Key(ID_Funcion),
  Foreign Key(ID_Opcion) REFERENCES Opciones(ID_Opcion)
   On delete cascade
   On update cascade,
)
GO


/********** Probando Base de datos nivel de seguridad *****************************/

Select Nombre,Apellido ,NombreRol , NombrePerfil , Opcion , NombreGrupo from GruposUsuarios As ad 
inner join Roles On ad.ID_GrupoUsuario = Roles.ID_GrupoUsuario 
inner join usuarios on usuarios.ID_Rol = Roles.ID_Rol
inner join Perfiles on Perfiles.ID_Usuario = usuarios.ID_Usuario
right join Opciones on  Opciones.ID_Perfil = Perfiles.ID_Perfil 

Select Nombre,Apellido,NombrePerfil from Usuarios As ad 
inner join Perfiles On Perfiles.ID_Usuario = ad.ID_Usuario 


/************** Probando  la encriptaccion  ****************************************/

/* Store procedure de encriptacioin */

Create Procedure IngresarUsuario
  @Nombre nvarchar(50),
  @Apellido nvarchar(50),
  @Usuario nvarchar(50),
  @Pass nvarchar(300),
  @ID_Rol int

 AS
Begin
    Insert Into Usuarios
    (
        Nombre,Apellido,Usuario,Contraseña,ID_Rol
    )
    Values
    (
        @Nombre,@Apellido,@Usuario,ENCRYPTBYPASSPHRASE('password', @Pass),@ID_Rol
        
      
    )
End
Go

Drop procedure IngresarUsuario

/* * Stored Procedure Ingresar Usuario COn hash de pass * */
CREATE PROCEDURE IngresarUsuario
  @Nombre  as nvarchar(50),
  @Apellido as nvarchar(50),
  @Usuario as nvarchar(50),
  @Pass as nvarchar(300),
  @ID_Rol as int
AS 
BEGIN
    DECLARE @hash varchar(4000);
    SET @hash = HASHBYTES('SHA1', @Pass);  --Pass editada
End

BEGIN
   Insert Into Usuarios
    (
        Nombre,Apellido,Usuario,Contraseña,ID_Rol
    )
    Values
    (
        @Nombre,@Apellido,@Usuario,@hash,@ID_Rol
        
      
    )
END
GO


/* *--- Fin ---* */

/* Ejecutando el Store Proceedure */

Execute IngresarUsuario 'julio','Manzueta','Ezequiel','123',2

Select * from Usuarios;

/* Comparaccion de la contrase;a */ 

Create Procedure LoginUsuario
    @Usuario AS nvarchar(50),
    @Pass AS nvarchar(50),
    @Result AS bit Output
As
    Declare @PassEncode As nvarchar(300)
    Declare @PassDecode As nvarchar(50)
Begin
    Select @PassEncode = Contraseña From usuarios Where Usuario = @Usuario
    Set @PassDecode = DECRYPTBYPASSPHRASE('password', @PassEncode)
End
 
Begin
    If @PassDecode = @Pass
        Set @Result = 1
    Else
        Set @Result = 0
End
 
Go

/* * Stored Procedure Ingresar Usuario COn hash de pass * */
Create Procedure LoginUsuario
    @Usuario AS nvarchar(50),
    @Pass AS nvarchar(50),
    @Result AS bit Output
As
     DECLARE @PassWord as Varchar(4000);
     DECLARE @hash varchar(4000);
     SET @hash = HASHBYTES('SHA1', @Pass);  --Pass editada
Begin
    Select @passWord = Contraseña From usuarios Where Usuario = @Usuario
End
 
Begin
    If @hash = @PassWord
        Set @Result = 1
    Else
        Set @Result = 0
End
 
Go
------------------------------------------------------------------------
Drop procedure LoginUsuario

/************ Ejecuntando Store procedure de prueba ********************/

  /** Variable  que recibira la salida **/
 Declare @resultadoSalida  as Bit 
    /* Se ejecuta  el store procedure diciendole que la variable dentro del procedore sera instanciada desde fuera como resultado salida */
 Execute LoginUsuario 'ezequiel','123',@result = @resultadoSalida OUTPUT

 Select @resultadoSalida as 'resultado'
 go

Select *  from usuarios




Alter table usuarios
 alter column  Contraseña nvarchar(4000) not null


