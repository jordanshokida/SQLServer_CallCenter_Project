

/*STORE PROCEDURE, TRIGGERS, VISTAS*/

/* STORED PROCEDURE - crea nuevo Cliente */

CREATE PROCEDURE sp_CrearNuevoCliente @nombre varchar(50),@apellido varchar(50),@tipo_documento varchar(20),@numero_documento varchar(8), @email varchar(50), @fecNac date, @estadoCliId varchar(20), @error_code int OUTPUT, @error_description char(50) OUTPUT,@id_cliente int OUTPUT
AS
		select @error_code=0;
		select @error_description='Se agrego el nuevo cliente';
		select @id_cliente=-1;

		begin try
			if(@tipo_documento<>'DNI' AND @tipo_documento<>'LC' AND @tipo_documento<>'LE')
			BEGIN
				RAISERROR ('El tipo de documento es inválido', 15, 1);
			END;
			if(len(@numero_documento)<7 OR  isnumeric(@numero_documento)=0)
			BEGIN
				RAISERROR('El de documento es inválido. no puede ser 0, y debe ser de no menos de 7 caracteres numericos', 15, 1);
			END;
			if (len(@nombre)=0 OR len(@apellido)=0)
			BEGIN
				RAISERROR('Ni el nombre ni el apellido pueden ser nulos',11,1);
			END;
	
			/*-- Validación del email*/
			IF(@email not like '%[@]%[.]%') 
			BEGIN 
				RAISERROR('Formato de mail inválido', 15, 1); 
			END;

			/*-- Validación de la fecha de nacimiento(no futura)*/
			IF(@fecNac > CONVERT(DATE, GETDATE())) 
			BEGIN 
				RAISERROR('Fecha inválida', 15, 1); 
			END;

			/*-- Validación del estado del cliente*/
			IF(@estadoCliId <> 'PR') 
			BEGIN 
				RAISERROR('El estado inicial debe ser Prospecto', 15, 1);
			END;

				insert into CLIENTES(nombre,apellido,tipoDoc,nroDoc,email,fecNac,estadoCliId) values(@nombre,@apellido,@tipo_documento,@numero_documento,@email,@fecNac,@estadoCliId);
				seT @id_cliente=SCOPE_IDENTITY();
			END TRY
			BEGIN CATCH
				SET @id_cliente=-1;
				select @error_code=ERROR_NUMBER();
				select @error_description=ERROR_MESSAGE();
			END CATCH;

			
GO

--DROP PROCEDURE sp_CrearNuevoCliente

/*****************************************************************************************************************************************************************************************************************************/

/* STORED PROCEDURE - crea nuevo Servicio */

CREATE PROCEDURE sp_CreaNuevoServicio  
    @numero int, 
    @calle varchar(50), 
    @piso varchar(10), 
    @depto varchar(10),
    @telefono varchar(15),
    @clienteId int, 
    @tipoServ varchar(5), 
    @error_code int OUTPUT, 
    @error_description varchar(50) OUTPUT
AS
BEGIN
    DECLARE @estadoCliente varchar(5);
    DECLARE @fecInicio DATETIME = SYSDATETIME();

    BEGIN TRY
        -- Verificar si el cliente tiene email o fecha de nacimiento nulos
        IF EXISTS (
            SELECT 1
            FROM CLIENTES 
            WHERE clienteId = @clienteId 
              AND (email IS NULL OR fecNac IS NULL)
        )
        BEGIN
            RAISERROR('El email o la fecha de nacimiento son nulos', 15, 1);
        END;

        -- Validar el tipo de servicio
        IF (@tipoServ <> 'VO' AND @tipoServ <> 'IN' AND @tipoServ <> 'TF')
		BEGIN
            RAISERROR('Tipo de servicio no válido', 15, 1);
        END;
        
        -- Obtener el estado del cliente
        SELECT @estadoCliente = estadoCliId
        FROM CLIENTES
        WHERE clienteId = @clienteId;

        -- Si el estado del cliente no es 'AC', actualizarlo
        IF (@estadoCliente <> 'AC')
        BEGIN
            UPDATE CLIENTES
            SET estadoCliId = 'AC'
            WHERE clienteId = @clienteId;
        END;
        
        -- Insertar el nuevo servicio
        INSERT INTO Servicios (numero, calle, piso, depto, feclnicio, telefono, clienteld, tipoServId) 
        VALUES (@numero, @calle, @piso, @depto, @fecInicio, @telefono, @clienteId, @tipoServ);

        -- Establecer código y descripción de error por defecto (éxito)
        SET @error_code = 0;
        SET @error_description = 'Se agregó correctamente el servicio';
        
    END TRY
    BEGIN CATCH
        -- Capturar errores y establecer códigos y descripciones de error
        SET @error_code = ERROR_NUMBER();
        SET @error_description = ERROR_MESSAGE();
    END CATCH
END;



--DROP PROCEDURE sp_CreaNuevoServicio 

/*****************************************/

/* CREACION DE UN NUEVO TICKET*/

CREATE PROCEDURE sp_CreaNuevoTicket 
    @login VARCHAR(50),
    @tipologiald VARCHAR(5), 
    @servicioId INT,  
    @clienteld INT,
    @error_code INT OUTPUT, 
    @error_description CHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecApertura DATETIME = SYSDATETIME();
    DECLARE @estadoCliente VARCHAR(5);

    BEGIN TRY
        IF (@login IS NULL OR @tipologiald IS NULL OR @clienteld = 0)
        BEGIN
            RAISERROR ('Uno o más parámetros son nulos.', 15, 1);
            RETURN;
        END;

        SELECT @estadoCliente = estadoCliId
        FROM CLIENTES
        WHERE @clienteld = clienteId;

        IF(@estadoCliente = 'AC' AND @servicioId IS NULL)
        BEGIN
            RAISERROR ('El servicio no puede ser nulo para un cliente activo', 15, 1);
            RETURN;
        END;

        INSERT INTO TICKETS (fecApertura, login, tipologiald, serviciold, clienteld)
        VALUES (@fecApertura, @login, @tipologiald, @servicioId, @clienteld);

        SET @error_code = 0;
        SET @error_description = 'El ticket se creo satisfactoriamente';
    END TRY
    BEGIN CATCH
        SET @error_code = ERROR_NUMBER();
        SET @error_description = ERROR_MESSAGE();
    END CATCH;
END;

GO
--DROP PROCEDURE sp_CreaNuevoTicket

/*************************************************************************************************************************/

/* DESACTIVAR UN SERVICIO Y CHEQUEAR ESTADO DEL CLIENTE*/
CREATE PROCEDURE sp_DesactivarServicio @servicioId int, @clienteId int

AS
	
		declare @CantidadServiciosActivos int;

BEGIN 


			UPDATE SERVICIOS
			SET estadoServId = 'IN'
			WHERE servicioId = @servicioId
			

			 SELECT @CantidadServiciosActivos = COUNT(*)
   			 FROM Servicios
   			 WHERE clienteld = @ClienteId
 			 AND estadoServId = 'AC';


			IF (@CantidadServiciosActivos = 0)

			BEGIN
     			  UPDATE Clientes
    			  SET estadoCliId = 'IN' 
      			  WHERE ClienteId = @ClienteId;
  		  	END
END



--DROP PROCEDURE sp_DesactivarServicio

/***************************************************************/

/* MODIFICAR TICKET*/

CREATE PROCEDURE sp_ModificarTicket
    @ticketId INT,
    @login VARCHAR(50) = NULL,
    @tipologiald VARCHAR(5) = NULL,
    @serviciold INT = NULL,
    @clienteld INT = NULL
AS
BEGIN
    -- Verificar si el login corresponde al ticketId
    IF (dbo.fn_VerificarLoginTicket(@ticketId, @login) <> 1)
    BEGIN
        RAISERROR('El login no corresponde al ticket.', 16, 1);
        RETURN;
    END

    -- Actualizar los campos proporcionados
    UPDATE Tickets
    SET
        login = COALESCE(@login, login),
        tipologiald = COALESCE(@tipologiald, tipologiald),
        serviciold = COALESCE(@serviciold, serviciold),
        clienteld = COALESCE(@clienteld, clienteld)
    WHERE ticketId = @ticketId;
END

--DROP PROCEDURE sp_ModificarTicket
/****************************************************************************/

/* SP sp_ActualizarFechaCierre*/

/* Update de la fecha de cierre del ultimo registro del ticket ingresado*/



CREATE PROCEDURE sp_ActualizarFechaCierre
    @TicketId int
AS
BEGIN
   
    UPDATE REGISTROS
    SET fecCierre = GETDATE()
    FROM REGISTROS r
    INNER JOIN (
        SELECT MAX(registroId) AS UltimoRegistroId
        FROM REGISTROS
        WHERE ticketId = @TicketId
    ) AS sub
    ON r.RegistroId = sub.UltimoRegistroId;
END;


--DROP PROCEDURE sp_ActualizarFechaCierre



/* Insertar registros en la tabla REGISTROS cuando se actualiza el estado del ticket*/


CREATE PROCEDURE sp_InsertarRegistro
    @estadoTicketId VARCHAR(5),  @ticketId int
AS
BEGIN
     
    INSERT INTO REGISTROS (FecInicio, EstadoTicketId, TicketId)
    VALUES(
        GETDATE(),
        @estadoTicketId, 
        @ticketId);
        
END;
GO

--DROP PROCEDURE sp_InsertarRegistro

/*************************************************************************************************/
/* StoreProcedure que reasigna el Ticket a otro usuario como dueño**/

CREATE PROCEDURE sp_ReasignarTicket
    @TicketId INT,
    @LoginActual VARCHAR(50),
    @NuevoLogin VARCHAR(50)
AS
BEGIN

    DECLARE @PropietarioActual VARCHAR(50);

    BEGIN TRY
        -- Verificar si @NuevoLogin existe en la tabla Empleados.login
        IF NOT EXISTS (SELECT 1 FROM Empleados WHERE login = @NuevoLogin AND estadoEmpId <> 'IN')
        BEGIN
            RAISERROR ('El nuevo login no existe en la tabla Empleados o se encuentra Inactivo', 15, 1);
            RETURN;
        END;

        -- Obtener el propietario actual del ticket
        SELECT @PropietarioActual = login
        FROM Tickets
        WHERE ticketId = @TicketId;   

        -- Verificar si el usuario actual es el propietario del ticket
        IF (dbo.fn_VerificarLoginTicket(@TicketId, @LoginActual) <> 1)
        BEGIN
            RAISERROR ('Solo el dueño del ticket puede modificarlo', 15, 1);
            RETURN;
        END;

        -- Actualizar el ticket con el nuevo propietario
        UPDATE Tickets
        SET login = @NuevoLogin
        WHERE ticketId = @TicketId;

     

        -- Mensaje de éxito (no es necesario asignarlo a una variable)
        PRINT 'Se reasignó el ticket correctamente.';
    END TRY
    BEGIN CATCH
        -- Capturar y manejar el error
        DECLARE @ErrorMessage NVARCHAR(4000);
        SELECT @ErrorMessage = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH;
END;

DROP PROCEDURE sp_ReasignarTicket;

/******************************************************************************/

/* SP para cambiar el estado del ticket a uno distinto con sus correspondientes validaciones*/

CREATE PROCEDURE sp_CambiarEstadoTicket @login VARCHAR(255), @ticketId int, @nuevoEstado VARCHAR(5), @error_code int OUTPUT, @error_description char(50) OUTPUT

AS
	
		select @error_code=0;
		select @error_description='Se cambio el estado del ticket correctamente';
		declare @TicketLogin VARCHAR(255);
		declare @estadoTicketId VARCHAR(5);
		

		begin try
			
			IF (dbo.fn_VerificarLoginTicket(@ticketId, @login) <> 1)

        			BEGIN
			          RAISERROR ('Solo el dueño del ticket puede modificarlo', 15, 1);
			        END;

			SELECT @estadoTicketId = estadoTicketId
			FROM TICKETS
    			WHERE @ticketId = ticketId

			IF NOT EXISTS (
      			  SELECT 1 
			  FROM TransicionesEstados 
		          WHERE EstadoActual = @estadoTicketId AND EstadoSiguiente = @nuevoEstado
		        )

			      BEGIN
       				 RAISERROR('No es posible cambiar a ese estado', 16, 1);
			      RETURN;
			      END

			/* EJECUTO EL SP PARA ACTUALIZAR LA FECHA DE CIERRE DEL ULTIMO REGISTRO*/

			

			EXEC dbo.sp_ActualizarFechaCierre @ticketId

			
			/* EJECUTO EL SP PARA GENERAR UN NUEVO REGISTRO*/
			/* elegimos Sp en vez de Trigger para evitar conflictos al hacer UPDATE sobre los Registros anteriores*/

			IF @NuevoEstado = 'RE'
			    BEGIN
       
  			      EXEC sp_InsertarRegistro @NuevoEstado, @TicketId

  			      -- Actualizar el estado del ticket y la fecha de resolución
   			     UPDATE TICKETS
 			       SET EstadoTicketId = @NuevoEstado,
   			         fecReso = GETDATE()
			        WHERE TicketId = @TicketId;
			    END
			
			    ELSE IF @NuevoEstado = 'CE'
			    BEGIN
			        -- Actualizar el estado del ticket y la fecha de cierre
			        UPDATE TICKETS
			        SET EstadoTicketId = @NuevoEstado,
			            fecCierre = GETDATE()
			        WHERE TicketId = @TicketId;
			    END
			    ELSE
			    BEGIN
			        -- Ejecutar procedimiento almacenado para insertar registro
			        EXEC sp_InsertarRegistro @NuevoEstado, @TicketId
			
			        -- Actualizar solo el estado del ticket
			        UPDATE TICKETS
			        SET EstadoTicketId = @NuevoEstado
			        WHERE TicketId = @ticketId;
			    END
	
		END TRY
		BEGIN CATCH
			select @error_code=ERROR_NUMBER();
			select @error_description=ERROR_MESSAGE();
		END CATCH;

-- DROP PROCEDURE sp_cambiarEstadoTicket


/***************************************************************************************/

/* SP para modificar el ticket sólo en el caso de ser el dueño de dicho ticket*/

CREATE PROCEDURE sp_ModificarTicket
    @ticketId INT,
    @login VARCHAR(50) = NULL,
    @tipologiald VARCHAR(5) = NULL,
    @serviciold INT = NULL,
    @clienteld INT = NULL
AS
BEGIN
    -- Verificar si el login corresponde al ticketId
    IF (dbo.fn_VerificarLoginTicket(@ticketId, @login) <> 1)
    BEGIN
        RAISERROR('El login no corresponde al ticket.', 16, 1);
        RETURN;
    END

    -- Actualizar los campos proporcionados
    UPDATE Tickets
    SET
        login = COALESCE(@login, login),
        tipologiald = COALESCE(@tipologiald, tipologiald),
        serviciold = COALESCE(@serviciold, serviciold),
        clienteld = COALESCE(@clienteld, clienteld)
    WHERE ticketId = @ticketId;
END



-- DROP PROCEDURE sp_ModificarTicket

/***************************************************************************************/


CREATE PROCEDURE sp_ModificarCliente
    @clienteId INT,
    @nombreNuevo VARCHAR(50) = NULL,
    @apellidoNuevo VARCHAR(50) = NULL,
    @fecNacNueva DATE = NULL
AS
BEGIN
    -- Verificar si el cliente es activo
    IF EXISTS (SELECT 1 FROM Clientes WHERE clienteId = @clienteId AND estadoCliId = 'AC')
    BEGIN
        -- Si el cliente es activo, solo se puede actualizar la fecha de nacimiento
        IF @nombreNuevo IS NOT NULL OR @apellidoNuevo IS NOT NULL
        BEGIN
            RAISERROR('No se puede modificar el nombre o apellido de un cliente activo.', 16, 1);
            RETURN;
        END
        ELSE IF @fecNacNueva IS NOT NULL
        BEGIN
            RAISERROR('No se puede modificar la fecha de nacimiento de un cliente activo.', 16, 1);
            RETURN;
        END
    END

    -- Actualizar los campos proporcionados
    UPDATE Clientes
    SET 
        nombre = ISNULL(@nombreNuevo, nombre),
        apellido = ISNULL(@apellidoNuevo, apellido),
        fecNac = ISNULL(@fecNacNueva, fecNac)
    WHERE clienteId = @clienteId;
END;


SELECT * FROM Clientes

 DROP PROCEDURE sp_ModificarCliente

/***************************************************************************************/







/*********************************FUNCTION*******************************************************/

/* Funcion que verifica si el login ingresado es el mismo que el del ticket*/

CREATE FUNCTION fn_VerificarLoginTicket (
    @TicketId INT,
    @Login VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    DECLARE @TicketLogin VARCHAR(255);
    DECLARE @Result BIT;
   
    SELECT @TicketLogin = Login
    FROM TICKETS
    WHERE TicketId = @TicketId;
    
    IF @TicketLogin IS NULL
    BEGIN
        RETURN 0; -- El TicketId no existe
    END
    
    IF @TicketLogin = @Login 
    BEGIN
        SET @Result = 1; 
    END
    ELSE
    BEGIN
        SET @Result = 0; 
    END
    
    RETURN @Result;
END;

--DROP FUNCTION fn_VerificarLoginTicket


/*****************************************************************************************/

/* La funcion calcularPendienteCliente obtiene todos los registros PC de un Ticket y realiza la sumatoria de sus tiempos de inicio y cierre*/

/* Calcula la sumatoria de Registros en Estado Pendiente Cliente y la devuelve*/

CREATE FUNCTION fn_CalcularPendienteCliente (@ticketId INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalPC INT = 0;
    DECLARE @demoraPC INT;
    DECLARE @fecInicio DATETIME;
    DECLARE @fecCierre DATETIME;

    DECLARE pendienteClienteCursor CURSOR FOR
    SELECT fecInicio, fecCierre
    FROM Registros
    WHERE ticketId = @ticketId AND estadoTicketId = 'PC';

    OPEN pendienteClienteCursor;

    FETCH NEXT FROM pendienteClienteCursor INTO @fecInicio, @fecCierre;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @demoraPC = DATEDIFF(HOUR, @fecInicio, @fecCierre);
        SET @totalPC += @demoraPC;

        FETCH NEXT FROM pendienteClienteCursor INTO @fecInicio, @fecCierre;
    END;

    CLOSE pendienteClienteCursor;
    DEALLOCATE pendienteClienteCursor;

    RETURN @totalPC;
END;
GO

--DROP FUNCTION fn_CalcularPendienteCliente

/*********************************************************************************************************/



/* Esta funcion calcula la diferencia entre el total del tiempo que estuvo abierto el TC menos el tiempo PC */

CREATE FUNCTION fn_CalcularSlaTicket(@ticketId INT)
RETURNS INT
AS
BEGIN
    DECLARE @fecApertura DATETIME;
    DECLARE @fecReso DATETIME;
    DECLARE @totalDemora INT;
    DECLARE @pendienteCliente INT;

    SELECT @fecApertura = fecApertura, @fecReso = fecReso
    FROM Tickets
    WHERE ticketId = @ticketId;

    SET @totalDemora = DATEDIFF(HOUR, @fecApertura, @fecReso);
    SET @pendienteCliente = dbo.fn_CalcularPendienteCliente(@ticketId);

    RETURN @totalDemora - @pendienteCliente;
END;

--DROP FUNCTION fn_CalcularSlaTicket

/*****************************************************************************************/

/*******************TRIGGERS********************************/


/* Inserta registros en la tabla NOTIFICACIONES cuando se actualiza un ticket */

CREATE TRIGGER tr_GenerarNotificacionMail
ON TICKETS
AFTER UPDATE
AS
BEGIN
	
    INSERT INTO NOTIFICACIONES (fecEnvio, email,ticketId)
    SELECT 
		SYSDATETIME(),
         c.email,
        i.ticketId   
    FROM inserted i
    JOIN CLIENTES c ON i.clienteld = c.clienteId;

END;

--DROP TRIGGER tr_GenerarNotificacionMail



/************************************VISTAS***********************************************/


/*VISTA Servicios Activos del cliente */

CREATE VIEW vw_Servicios_Activos_Cliente AS

SELECT 
    c.clienteId AS IdCliente,
    c.Nombre,
    c.Apellido,
    COUNT(s.servicioId) AS [Servicios Activos]
FROM 
    CLIENTES c
JOIN 
    Servicios s ON c.clienteId = s.clienteld
WHERE 
    s.estadoServId = 'AC'
GROUP BY 
    c.clienteId, 
    c.Nombre, 
    c.Apellido;

--DROP VIEW vw_Servicios_Activos_Cliente
--SELECT * FROM vw_Servicios_Activos_Cliente


/* VISTA QUE MUESTRA EL ID DEL TICKET , EL SLA TOTAL, EL SLA ESPERADO Y LA DIFERENCIA ENTRE AMBOS*/

CREATE VIEW vw_TicketsSLA AS
SELECT 
    t.ticketId AS TicketId,
	c.nombre AS Nombre,
	c.apellido AS Apellido,
    dbo.fn_CalcularSlaTicket (t.ticketId) AS SLATotal,
	tip.sla AS SLA_Permitido,
	(dbo.fn_CalcularSlaTicket(t.ticketId) - tip.sla )  AS Diferencia

FROM 
    Tickets t
INNER JOIN 
    Tipologias tip ON t.tipologiald = tip.tipologiaId
INNER JOIN 
	Clientes c ON c.clienteId = t.clienteld
WHERE
t.estadoTicketId = 'RE' OR 
t.estadoTicketId = 'CE' 

--DROP VIEW vw_TicketsSLA
SELECT * FROM vw_TicketsSLA

/******************************************************************************/

/* VISTA Ticket_Nombre_CantRegistros*/
/* Vista que trae los Servicios de cada Cliente*/

CREATE VIEW vw_Servicios_Por_Cliente AS

SELECT 
    c.clienteId AS IdCliente,
    c.Nombre AS Nombre,
    c.Apellido AS Apellido,
    s.servicioId AS ServiciosID,
	s.tipoServId AS TipodeServicio,
	s.estadoServId AS EstadoServicio

FROM 
    CLIENTES c
JOIN 
    Servicios s ON c.clienteId = s.clienteld




--DROP VIEW vw_Servicios_Por_Cliente
SELECT * FROM vw_Servicios_Por_Cliente













































