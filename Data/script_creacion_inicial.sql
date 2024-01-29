USE GD2C2022
GO

--DROP PREVENTIVO DE TABLAS-------------------------
/*
En estas sentencias lo que hacemos es eliminar la tabla si existe para luego crearla con la informacion que queremos sin problemas
*/
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_envio')
DROP TABLE QUERY_DIFICUL.tipo_envio
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'envio')
DROP TABLE QUERY_DIFICUL.envio
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'canal')
DROP TABLE QUERY_DIFICUL.canal
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon')
DROP TABLE QUERY_DIFICUL.cupon
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'concepto_descuento')
DROP TABLE QUERY_DIFICUL.concepto_descuento
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'medio_de_pago')
DROP TABLE QUERY_DIFICUL.medio_de_pago
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto')
DROP TABLE QUERY_DIFICUL.producto
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'tipo_variante')
DROP TABLE QUERY_DIFICUL.tipo_variante
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'variante')
DROP TABLE QUERY_DIFICUL.variante
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'producto_variante')
DROP TABLE QUERY_DIFICUL.producto_variante
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'provincia')
DROP TABLE QUERY_DIFICUL.provincia
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'proveedor')
DROP TABLE QUERY_DIFICUL.proveedor
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'localidad')
DROP TABLE QUERY_DIFICUL.localidad
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cliente')
DROP TABLE QUERY_DIFICUL.cliente
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'venta')
DROP TABLE QUERY_DIFICUL.venta
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'cupon_venta')
DROP TABLE QUERY_DIFICUL.cupon_venta
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'compra')
DROP TABLE QUERY_DIFICUL.compra
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'descuento_venta')
DROP TABLE QUERY_DIFICUL.descuento_venta
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'descuento_compra')
DROP TABLE QUERY_DIFICUL.descuento_compra
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'detalle_compra')
DROP TABLE QUERY_DIFICUL.detalle_compra
IF EXISTS (SELECT name FROM sys.tables WHERE name = 'detalle_venta')
DROP TABLE QUERY_DIFICUL.detalle_venta
--DROP PREVENTIVO DE SCHEMA-------------------------
/*
En esta sentencia lo que hacemos es eliminar el schema con el nombre de nuestro grupo (si es que existe) para luego crearlo nuevamente
sin inconvenientes
*/
IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'QUERY_DIFICUL')
DROP SCHEMA QUERY_DIFICUL
GO

--CREACIÓN DE SCHEMA--------------------------------
/*
Creamos el schema con el nombre del grupo. Es donde iran las tablas de nuestro modelo
*/
CREATE SCHEMA QUERY_DIFICUL;
GO

--CREACIÓN DE TABLAS--------------------------------
/*
Creamos las tablas de nuestro modelo con los datos que deben estar en cada una
*/
CREATE TABLE QUERY_DIFICUL.tipo_envio (
id int PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(2555) not null
);


CREATE TABLE QUERY_DIFICUL.canal (
id int PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(2555) not null,
costo decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.cupon (
id int PRIMARY KEY IDENTITY(1,1),
codigo nvarchar(2555) not null,
valor decimal(18,2) not null,
tipo nvarchar(50) not null,
fecha_desde date not null,
fecha_hasta date not null
);

CREATE TABLE QUERY_DIFICUL.concepto_descuento (
id int PRIMARY KEY IDENTITY(1,1),
concepto nvarchar(255) not null,
importe decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.medio_de_pago (
id int PRIMARY KEY IDENTITY(1,1),
medio nvarchar(255) not null,
costo decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.producto (
id int PRIMARY KEY IDENTITY(1,1),
codigo nvarchar(50) not null,
nombre nvarchar(50) not null,
descripcion nvarchar(50) default null,
material nvarchar(50) not null,
marca nvarchar(255) not null,
categoria nvarchar(255) not null,
);

CREATE TABLE QUERY_DIFICUL.tipo_variante (
id int PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(50) not null
);

CREATE TABLE QUERY_DIFICUL.variante (
id int PRIMARY KEY IDENTITY(1,1),
tipo_id int REFERENCES QUERY_DIFICUL.tipo_variante not null,
valor nvarchar(50) not null
);

CREATE TABLE QUERY_DIFICUL.producto_variante (
id int PRIMARY KEY IDENTITY(1,1),
codigo nvarchar(50) not null,
producto_id int REFERENCES QUERY_DIFICUL.producto not null,
variante_id int REFERENCES QUERY_DIFICUL.variante not null,
precio_unitario_venta decimal(18,2),
precio_unitario_compra decimal(18,2)
);

CREATE TABLE QUERY_DIFICUL.provincia (
id int PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(50) not null
);

CREATE TABLE QUERY_DIFICUL.proveedor (
id int PRIMARY KEY IDENTITY(1,1),
razon_social nvarchar(50) not null,
domicilio nvarchar(50) not null,
mail nvarchar(50) default null,
provincia_id int REFERENCES QUERY_DIFICUL.provincia not null
);

CREATE TABLE QUERY_DIFICUL.localidad (
id int PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(255) not null,
cod_postal decimal(18,0) not null,
provincia_id int REFERENCES QUERY_DIFICUL.provincia not null
);

CREATE TABLE QUERY_DIFICUL.envio (
id int PRIMARY KEY IDENTITY(1,1),
tipo_envio_id int REFERENCES QUERY_DIFICUL.tipo_envio not null,
localidad_id int REFERENCES QUERY_DIFICUL.localidad not null,
precio decimal(18,2) not null,
tiempo_estimado decimal(18,0) DEFAULT null
);

CREATE TABLE QUERY_DIFICUL.cliente (
id int PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(255) not null,
apellido nvarchar(255) not null,
dni decimal(18,0) not null,
direccion nvarchar(255) not null,
telefono decimal(18,0) not null,
mail nvarchar(255) not null,
fecha_nacimiento date not null,
localidad_id int REFERENCES QUERY_DIFICUL.localidad not null
);

CREATE TABLE QUERY_DIFICUL.venta (
id int PRIMARY KEY IDENTITY(1,1),
codigo decimal(19,0) not null,
fecha date not null,
canal_id int REFERENCES QUERY_DIFICUL.canal not null,
costo_canal decimal(18,2) not null,
cliente_id int REFERENCES QUERY_DIFICUL.cliente not null,
envio_id int REFERENCES QUERY_DIFICUL.envio not null,
costo_envio decimal(18,2) not null,
medio_de_pago_id int REFERENCES QUERY_DIFICUL.medio_de_pago not null,
costo_medio_de_pago decimal(18,2) not null,
total decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.cupon_venta (
id int PRIMARY KEY IDENTITY(1,1),
total_descuento_cupon decimal(18,2) default null,
cupon_id int REFERENCES QUERY_DIFICUL.cupon not null,
venta_id int REFERENCES QUERY_DIFICUL.venta not null
);

CREATE TABLE QUERY_DIFICUL.compra (
id int PRIMARY KEY IDENTITY(1,1),
numero decimal(19,0) not null,
fecha date not null,
proveedor_id int REFERENCES QUERY_DIFICUL.proveedor not null,
medio_de_pago_id int REFERENCES QUERY_DIFICUL.medio_de_pago not null,
total decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.descuento_venta (
id int PRIMARY KEY IDENTITY(1,1),
venta_id int REFERENCES QUERY_DIFICUL.venta not null,
concepto_descuento_id int REFERENCES QUERY_DIFICUL.concepto_descuento not null,
importe decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.descuento_compra (
id int PRIMARY KEY IDENTITY(1,1),
compra_id int REFERENCES QUERY_DIFICUL.compra not null,
codigo decimal(19,0) not null,
valor decimal(18,2) not null
);

CREATE TABLE QUERY_DIFICUL.detalle_compra (
id int PRIMARY KEY IDENTITY(1,1),
producto_variante_id int REFERENCES QUERY_DIFICUL.producto not null,
compra_id int REFERENCES QUERY_DIFICUL.compra not null,
precio decimal(18,2) not null,
cantidad decimal(18,0) not null
);

CREATE TABLE QUERY_DIFICUL.detalle_venta (
id int PRIMARY KEY IDENTITY(1,1),
producto_variante_id int REFERENCES QUERY_DIFICUL.producto not null,
venta_id int REFERENCES QUERY_DIFICUL.venta not null,
precio decimal(18,2) not null,
cantidad decimal(18,0) not null
);

--CREACIÓN DE STORED PROCEDURES PARA MIGRACIÓN------
/*
Creamos los procedimientos para migrar los datos de la tabla maestra a sus respectivas tablas en el modelo que creamos
*/
IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_tipo_envio')
	DROP PROCEDURE migrar_tipo_envio
GO

CREATE PROCEDURE migrar_tipo_envio
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.tipo_envio(nombre)
	SELECT DISTINCT VENTA_MEDIO_ENVIO
	FROM gd_esquema.Maestra
	WHERE VENTA_MEDIO_ENVIO IS NOT NULL
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_canal')
    DROP PROCEDURE migrar_canal
GO

CREATE PROCEDURE migrar_canal
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.canal (nombre,costo)
        SELECT DISTINCT VENTA_CANAL,VENTA_CANAL_COSTO
        FROM gd_esquema.Maestra
        WHERE VENTA_CANAL IS NOT NULL
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_cupon')
    DROP PROCEDURE migrar_cupon
GO

CREATE PROCEDURE migrar_cupon
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.cupon (codigo,valor,tipo,fecha_desde,fecha_hasta)
        SELECT DISTINCT VENTA_CUPON_CODIGO,VENTA_CUPON_VALOR,VENTA_CUPON_TIPO,
        VENTA_CUPON_FECHA_DESDE,VENTA_CUPON_FECHA_HASTA
        FROM gd_esquema.Maestra
        WHERE VENTA_CUPON_CODIGO IS NOT NULL
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_concepto_descuento')
	DROP PROCEDURE migrar_concepto_descuento
GO

CREATE PROCEDURE migrar_concepto_descuento
AS
	BEGIN
		INSERT INTO QUERY_DIFICUL.concepto_descuento (concepto,importe)
		SELECT DISTINCT VENTA_DESCUENTO_CONCEPTO,CONVERT(DECIMAL(6,2), ROUND((AVG((VENTA_DESCUENTO_IMPORTE*100)/(VENTA_TOTAL-VENTA_ENVIO_PRECIO))/100), 2))
		FROM gd_esquema.Maestra
		WHERE VENTA_DESCUENTO_CONCEPTO IS NOT NULL
		GROUP BY VENTA_DESCUENTO_CONCEPTO
	END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_medio_de_pago')
    DROP PROCEDURE migrar_medio_de_pago
GO

CREATE PROCEDURE migrar_medio_de_pago
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.medio_de_pago (medio,costo)
        SElECT DISTINCT VENTA_MEDIO_PAGO,VENTA_MEDIO_PAGO_COSTO
        FROM gd_esquema.Maestra
        WHERE VENTA_MEDIO_PAGO IS NOT NULL
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_producto')
	DROP PROCEDURE migrar_producto
GO

CREATE PROCEDURE migrar_producto
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.producto (codigo, nombre, descripcion, material, marca, categoria)
	SELECT DISTINCT PRODUCTO_CODIGO, PRODUCTO_NOMBRE, PRODUCTO_DESCRIPCION, PRODUCTO_MATERIAL, PRODUCTO_MARCA, PRODUCTO_CATEGORIA
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_CODIGO IS NOT NULL
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_tipo_variante')
	DROP PROCEDURE migrar_tipo_variante
GO

CREATE PROCEDURE migrar_tipo_variante
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.tipo_variante (nombre)
	SELECT DISTINCT PRODUCTO_TIPO_VARIANTE
	FROM gd_esquema.Maestra m
	WHERE PRODUCTO_TIPO_VARIANTE IS NOT NULL
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_variante')
	DROP PROCEDURE migrar_variante
GO

CREATE PROCEDURE migrar_variante
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.variante (tipo_id, valor)
	SELECT DISTINCT tp.id, PRODUCTO_VARIANTE
	FROM gd_esquema.Maestra m
	JOIN QUERY_DIFICUL.tipo_variante tp ON tp.nombre=m.PRODUCTO_TIPO_VARIANTE
  END
GO


IF EXISTS (SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_producto_variante')
	DROP PROCEDURE migrar_producto_variante
GO

CREATE PROCEDURE migrar_producto_variante
 AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.producto_variante (codigo, producto_id, variante_id,precio_unitario_compra,precio_unitario_venta)
        SELECT DISTINCT m.PRODUCTO_VARIANTE_CODIGO, p.id, v.id,

		(select top 1 B.COMPRA_PRODUCTO_PRECIO 
		FROM gd_esquema.Maestra B
		where B.PRODUCTO_VARIANTE_CODIGO = m.PRODUCTO_VARIANTE_CODIGO
		order by B.COMPRA_FECHA DESC)precio_unitario_compra,

		(SELECT TOP 1 A.VENTA_PRODUCTO_PRECIO 
		FROM gd_esquema.Maestra A
		where A.PRODUCTO_VARIANTE_CODIGO = m.PRODUCTO_VARIANTE_CODIGO
		order by A.VENTA_FECHA DESC) precio_unitario_venta
        FROM gd_esquema.Maestra m
        JOIN QUERY_DIFICUL.producto p ON p.codigo = m.PRODUCTO_CODIGO
        JOIN QUERY_DIFICUL.variante v ON v.valor = m.PRODUCTO_VARIANTE
        WHERE PRODUCTO_VARIANTE_CODIGO IS NOT NULL

    END
GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_provincia')
    DROP PROCEDURE migrar_provincia
GO

CREATE PROCEDURE migrar_provincia
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.provincia(nombre)
        SELECT *
        FROM (
        SELECT DISTINCT CLIENTE_PROVINCIA
        FROM gd_esquema.Maestra
        WHERE CLIENTE_PROVINCIA is not null
        UNION 
        SELECT DISTINCT PROVEEDOR_PROVINCIA
        FROM gd_esquema.Maestra
        WHERE PROVEEDOR_PROVINCIA is not null
        ) provincias
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_proveedor')
	DROP PROCEDURE migrar_proveedor
GO

CREATE PROCEDURE migrar_proveedor
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.proveedor (razon_social, domicilio, mail, provincia_id)
	SELECT DISTINCT PROVEEDOR_RAZON_SOCIAL, PROVEEDOR_DOMICILIO, PROVEEDOR_MAIL, pr.id
	FROM gd_esquema.Maestra m
	JOIN QUERY_DIFICUL.provincia pr ON pr.nombre = m.PROVEEDOR_PROVINCIA 
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_localidad')
    DROP PROCEDURE migrar_localidad
GO

CREATE PROCEDURE migrar_localidad
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.localidad(nombre, cod_postal, provincia_id)
        SELECT l.localidad, l.cod_postal, p.id
        FROM (
        SELECT DISTINCT CLIENTE_LOCALIDAD localidad, CLIENTE_CODIGO_POSTAL cod_postal, CLIENTE_PROVINCIA provincia
        FROM gd_esquema.Maestra
        WHERE CLIENTE_LOCALIDAD is not null
        UNION 
        SELECT DISTINCT PROVEEDOR_LOCALIDAD, PROVEEDOR_CODIGO_POSTAL, PROVEEDOR_PROVINCIA
        FROM gd_esquema.Maestra
        WHERE PROVEEDOR_LOCALIDAD is not null
        ) l
        JOIN QUERY_DIFICUL.provincia p ON p.nombre = l.provincia
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_envio')
	DROP PROCEDURE migrar_envio
GO

CREATE PROCEDURE migrar_envio
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.envio (tipo_envio_id, localidad_id, precio)
    SELECT DISTINCT t.id, l.id, VENTA_ENVIO_PRECIO
    FROM gd_esquema.Maestra
    JOIN QUERY_DIFICUL.tipo_envio t ON t.nombre=VENTA_MEDIO_ENVIO
	JOIN QUERY_DIFICUL.localidad l ON (l.nombre = CLIENTE_LOCALIDAD AND l.cod_postal = CLIENTE_CODIGO_POSTAL)
    WHERE VENTA_MEDIO_ENVIO IS NOT NULL
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_cliente')
	DROP PROCEDURE migrar_cliente
GO

CREATE PROCEDURE migrar_cliente
 AS
  BEGIN
    INSERT INTO QUERY_DIFICUL.cliente (nombre, apellido, dni, direccion, telefono, mail, fecha_nacimiento, localidad_id)
	SELECT DISTINCT UPPER(LEFT(CLIENTE_NOMBRE,1))+LOWER(SUBSTRING(CLIENTE_NOMBRE,2,LEN(CLIENTE_NOMBRE))), CLIENTE_APELLIDO, CLIENTE_DNI, CLIENTE_DIRECCION, CLIENTE_TELEFONO, CLIENTE_MAIL, CLIENTE_FECHA_NAC, l.id
	FROM gd_esquema.Maestra m
	JOIN QUERY_DIFICUL.localidad l ON (l.nombre = m.CLIENTE_LOCALIDAD AND l.cod_postal = m.CLIENTE_CODIGO_POSTAL) 
  END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_venta')
    DROP PROCEDURE migrar_venta
GO

CREATE PROCEDURE migrar_venta
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.venta (codigo, fecha, canal_id, costo_canal, cliente_id, envio_id, costo_envio, medio_de_pago_id, costo_medio_de_pago, total)
        SELECT DISTINCT m.VENTA_CODIGO, m.VENTA_FECHA, ca.id, ca.costo, c.id, e.id, e.precio, mp.id, mp.costo, m.VENTA_TOTAL
        FROM  GD2C2022.gd_esquema.Maestra m
        JOIN QUERY_DIFICUL.canal ca ON (ca.nombre = m.VENTA_CANAL)
        JOIN QUERY_DIFICUL.tipo_envio tp ON (tp.nombre = m.VENTA_MEDIO_ENVIO)
		JOIN QUERY_DIFICUL.localidad l ON (l.nombre = CLIENTE_LOCALIDAD AND l.cod_postal = CLIENTE_CODIGO_POSTAL)
		JOIN QUERY_DIFICUL.cliente c ON (c.dni = m.CLIENTE_DNI AND c.mail = m.CLIENTE_MAIL AND c.localidad_id = l.id)
        JOIN QUERY_DIFICUL.envio e ON (e.tipo_envio_id = tp.id AND e.localidad_id = l.id AND e.precio = m.VENTA_ENVIO_PRECIO)
        JOIN QUERY_DIFICUL.medio_de_pago mp ON (mp.medio = m.VENTA_MEDIO_PAGO)
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_cupon_venta')
	DROP PROCEDURE migrar_cupon_venta
GO

CREATE PROCEDURE migrar_cupon_venta
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.cupon_venta(total_descuento_cupon,cupon_id,venta_id)
        SELECT DISTINCT VENTA_CUPON_IMPORTE,c.id,v.id
        FROM gd_esquema.Maestra m 
		JOIN QUERY_DIFICUL.cupon c ON c.codigo=VENTA_CUPON_CODIGO
		JOIN QUERY_DIFICUL.venta v ON v.codigo=VENTA_CODIGO
        WHERE VENTA_CUPON_CODIGO IS NOT NULL AND VENTA_CODIGO IS NOT NULL
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_compra')
	DROP PROCEDURE migrar_compra
GO

CREATE PROCEDURE migrar_compra
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.compra (numero,fecha,proveedor_id,medio_de_pago_id,total)
        SELECT DISTINCT COMPRA_NUMERO,COMPRA_FECHA,prv.id,mp.id,COMPRA_TOTAL
        FROM gd_esquema.Maestra m 
        JOIN QUERY_DIFICUL.proveedor prv ON prv.razon_social=PROVEEDOR_RAZON_SOCIAL
		JOIN QUERY_DIFICUL.medio_de_pago mp ON mp.medio=COMPRA_MEDIO_PAGO
        WHERE COMPRA_NUMERO IS NOT NULL 
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_descuento_venta')
    DROP PROCEDURE migrar_descuento_venta
GO

CREATE PROCEDURE migrar_descuento_venta
AS
    BEGIN
        INSERT INTO QUERY_DIFICUL.descuento_venta (venta_id,importe, concepto_descuento_id)
        SELECT v.id,VENTA_DESCUENTO_IMPORTE, cd.id
        FROM gd_esquema.Maestra m 
        JOIN QUERY_DIFICUL.venta v ON (v.codigo = m.VENTA_CODIGO)
		JOIN QUERY_DIFICUL.concepto_descuento cd ON (cd.concepto = m.VENTA_DESCUENTO_CONCEPTO)
        WHERE m.VENTA_CODIGO IS NOT NULL
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_descuento_compra')
    DROP PROCEDURE migrar_descuento_compra
GO

CREATE PROCEDURE migrar_descuento_compra
AS 
    BEGIN 
        INSERT INTO QUERY_DIFICUL.descuento_compra (compra_id,codigo,valor)
        SELECT DISTINCT c.id, m.DESCUENTO_COMPRA_CODIGO, m.DESCUENTO_COMPRA_VALOR * m.COMPRA_TOTAL 
        FROM gd_esquema.Maestra m
        JOIN QUERY_DIFICUL.compra c ON (c.numero = m.COMPRA_NUMERO)
        WHERE DESCUENTO_COMPRA_CODIGO IS NOT NULL
    END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_detalle_compra')
	DROP PROCEDURE migrar_detalle_compra
GO

CREATE PROCEDURE migrar_detalle_compra
AS
	BEGIN
		INSERT INTO QUERY_DIFICUL.detalle_compra(producto_variante_id, compra_id, precio, cantidad)
		SELECT pv.id,c.id,COMPRA_PRODUCTO_PRECIO,COMPRA_PRODUCTO_CANTIDAD
		FROM gd_esquema.Maestra
		JOIN QUERY_DIFICUL.producto_variante pv ON pv.codigo = PRODUCTO_VARIANTE_CODIGO
		JOIN QUERY_DIFICUL.compra c ON c.numero=COMPRA_NUMERO
		WHERE COMPRA_NUMERO IS NOT NULL AND PRODUCTO_VARIANTE_CODIGO IS NOT NULL
	END
GO


IF EXISTS(SELECT [name] FROM sys.procedures WHERE [name] = 'migrar_detalle_venta')
	DROP PROCEDURE migrar_detalle_venta
GO

CREATE PROCEDURE migrar_detalle_venta
AS
	BEGIN
		INSERT INTO QUERY_DIFICUL.detalle_venta(producto_variante_id,venta_id,precio,cantidad)
		SELECT pv.id,v.id,VENTA_PRODUCTO_PRECIO,VENTA_PRODUCTO_CANTIDAD
		FROM gd_esquema.Maestra
		JOIN QUERY_DIFICUL.producto_variante pv ON pv.codigo = PRODUCTO_VARIANTE_CODIGO
		JOIN QUERY_DIFICUL.venta v on v.codigo = VENTA_CODIGO
		WHERE VENTA_CODIGO IS NOT NULL AND PRODUCTO_VARIANTE_CODIGO IS NOT NULL
	END
GO

--EJECUCIÓN DE STORED PROCEDURES: MIGRACION---------
/*
Ejecutamos los procedimientos creados anteriormente para efectivizar la migracion de datos
*/
 BEGIN TRANSACTION
 BEGIN TRY
	EXECUTE migrar_tipo_envio
	EXECUTE migrar_canal
	EXECUTE migrar_cupon
	EXECUTE migrar_concepto_descuento
	EXECUTE migrar_medio_de_pago
	EXECUTE migrar_producto
	EXECUTE migrar_tipo_variante
	EXECUTE migrar_variante
	EXECUTE migrar_producto_variante
	EXECUTE migrar_provincia
	EXECUTE migrar_proveedor
	EXECUTE migrar_localidad
	EXECUTE migrar_envio
	EXECUTE migrar_cliente
	EXECUTE migrar_venta
	EXECUTE migrar_cupon_venta
	EXECUTE migrar_compra
	EXECUTE migrar_descuento_venta
	EXECUTE migrar_descuento_compra
	EXECUTE migrar_detalle_compra
	EXECUTE migrar_detalle_venta
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
	THROW 50001, 'Error al migrar las tablas, verifique que las nuevas tablas se encuentren vacías o bien ejecute un DROP de todas las nuevas tablas y vuelva a intentarlo.',1;
END CATCH

   IF (EXISTS (SELECT 1 FROM QUERY_DIFICUL.tipo_envio)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.envio)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.canal)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.cupon)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.concepto_descuento)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.medio_de_pago)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.producto)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.tipo_variante)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.variante)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.producto_variante)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.provincia)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.proveedor)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.localidad)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.cliente)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.venta)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.cupon_venta)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.compra)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.descuento_venta)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.descuento_compra)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.detalle_compra)
   AND EXISTS (SELECT 1 FROM QUERY_DIFICUL.detalle_venta)
   )
   BEGIN
	PRINT 'Tablas migradas correctamente.';
	COMMIT TRANSACTION;
   END
	 ELSE
   BEGIN
    ROLLBACK TRANSACTION;
	THROW 50002, 'Hubo un error al migrar una o más tablas. Todos los cambios fueron deshechos, ninguna tabla fue cargada en la base.',1;
   END