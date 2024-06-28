
/************************** PRUEBAS ****************************************/

/*Caso de Prueba: Alta de un nuevo Cliente como Prospecto*/
/*El cliente se debe generar como Prospecto*/

-- Precondición: No hay cliente con nombre 'Alan Moreno' en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE nombre = 'Alan' AND apellido = 'Moreno';

/*Ejecución: Crear Cliente Alan Moreno */
DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = 'Alan', 
    @apellido = 'Moreno', 
    @tipo_documento = 'DNI', 
    @numero_documento = '37170624', 
    @email = 'alan.moreno@hotmail.com', 
    @fecNac = '1992-11-08', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente, @error_code, @error_description;

SELECT * FROM CLIENTES;

--Postcondición: Verificar que se agregó correctamente el cliente 'Alan Moreno'
SELECT * FROM CLIENTES WHERE nombre = 'Alan' AND apellido = 'Moreno';

/*Caso de Prueba: Intentar dar de alta un cliente (prospecto) sin datos mínimos requeridos o erróneos*/
/*Se debe devolver el error correspondiente*/

--Precondición: No hay cliente con nombre vacío en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE nombre = '';

---Ejecución: Se intenta dar de alta un cliente sin nombre
DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = '', 
    @apellido = 'Perez', 
    @tipo_documento = 'DNI', 
    @numero_documento = '35232555', 
    @email = 'juan.perez@example.com', 
    @fecNac = '1990-01-01', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente, @error_code, @error_description;

-- Postcondición: No debería haber cambios en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE nombre = '';

-- /*Caso de Prueba: Intentar dar de alta un cliente (prospecto) sin datos mínimos requeridos o erróneos*/
/*Se debe devolver el error correspondiente*/

--Precondición: No hay cliente con nombre vacío en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE apellido = '';

---Ejecución: se intenta dar de alta un cliente sin Apellido
DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = 'Pedro', 
    @apellido = '', 
    @tipo_documento = 'DNI', 
    @numero_documento = '35232555', 
    @email = 'juan.perez@example.com', 
    @fecNac = '1990-01-01', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente, @error_code, @error_description;

-- Postcondición: No debería haber cambios en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE apellido = '';



-- /*Caso de Prueba: Intentar dar de alta un cliente con numero de documento inválido*/

--Precondición: No hay cliente con numero de documento inválido en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE nroDoc = '';

---Ejecución: se intenta dar de alta un cliente sin numero de documento

DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = 'Pedro', 
    @apellido = 'Perez', 
    @tipo_documento = 'DNI', 
    @numero_documento = '', 
    @email = 'juan.perez@example.com', 
    @fecNac = '1990-01-01', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente, @error_code, @error_description;


--Postcondición: No debería haber cambios en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE nroDoc = '';


-- /*Caso de Prueba: Intentar dar de alta un cliente con Tipo de documento inválido*/

--Precondición: No hay cliente con tipo de documento inválido en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE tipoDoc = 'DNI1';

---Ejecución: se intenta dar de alta un cliente con Tipo de documento inválido

DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_crearNuevoCliente 
    @nombre = 'Pedro', 
    @apellido = 'Perez', 
    @tipo_documento = 'DNI1', 
    @numero_documento = '12345678', 
    @email = 'juan.perez@example.com', 
    @fecNac = '1990-01-01', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente, @error_code, @error_description;

--Postcondición: No debería haber cambios en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE tipoDoc = 'DNI1';


-- /*Caso de Prueba: Intentar dar de alta un cliente con email invalido*/

--Precondición: No hay cliente con email inválido en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE email = 'emailinvalido.com';

---Ejecución: se intenta dar de alta un cliente con con email invalido

DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = 'Juan', 
    @apellido = 'Perez', 
    @tipo_documento = 'DNI', 
    @numero_documento = '35232555', 
    @email = 'emailinvalido.com', 
    @fecNac = '1990-01-01', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente AS 'ID Cliente', @error_code AS 'Código de Error', @error_description AS 'Descripción de Error';

-- Postcondición: No debería haber cambios en la tabla CLIENTES
SELECT * FROM CLIENTES WHERE email = 'emailinvalido.com';

--/* Caso de prueba: Creación de un nuevo servicio para el cliente Gabriel Umansky (ClienteID: 5)*/

/* Creo un Cliente 'PR' para el siguiente caso de uso*/

DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = 'Gabriel', 
    @apellido = 'Umansky', 
    @tipo_documento = 'DNI', 
    @numero_documento = '32189764', 
    @email = 'gabriel.umansky@ort.com', 
    @fecNac = '1982-11-11', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente, @error_code, @error_description;

/* Precondición: Mostrar el estado actual del cliente */

/*Crear un nuevo servicio a un Prospecto*/
/*Debe crearse el servicio, cambiarse el cliente a Activo*/

SELECT estadoCliId
FROM Clientes
WHERE clienteId = 5;

/* Utilizo el cliente ClienteID:5 de Gabriel Umansky*/
/* Ejecutar la creación del nuevo servicio */

DECLARE @error_code int;
DECLARE @error_description varchar(50);

EXEC sp_CreaNuevoServicio  
    @numero = 3363, 
    @calle = 'Primera Junta', 
    @piso = '', 
    @depto = '',
    @telefono = '1132032247',
    @clienteId = 5, 
    @tipoServ = 'VO', 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;

SELECT @error_code AS ErrorCode, @error_description AS ErrorDescription;

/* Postcondición: Verificar que el cliente pasa a estado 'AC' al tener un servicio activo */
SELECT estadoCliId
FROM Clientes
WHERE clienteId = 5;


-- Precondición: Mostrar el estado actual del cliente antes de crear el servicio

SELECT estadoCliId
FROM Clientes
WHERE clienteId = 3;

SELECT * FROM CLIENTES

-- Ejecutar la creación del nuevo servicio para un cliente inactivo
DECLARE @error_code INT, @error_description CHAR(50);
EXEC sp_CreaNuevoServicio 
    @numero = 9060, 
    @calle = 'Iguazu', 
    @piso = '', 
    @depto = '', 
    @telefono = '6669993', 
    @clienteId = 3, 
    @tipoServ = 'IN', 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @error_code AS 'Código de Error', @error_description AS 'Descripción de Error';

-- Mostrar el estado actual del cliente después de intentar crear el servicio
SELECT estadoCliId
FROM Clientes
WHERE clienteId = 3;

-- Mostrar todos los servicios del cliente después de la operación
/**************************************************************************************************************************/
SELECT * FROM vw_Servicios_Por_Cliente WHERE idCliente = 3;

/*Intentar crear un servicio a un prospecto sin email o fecha de nacimiento*/
/*Debe devolver un error*/
/*ClienteId = 6 no existe */
SELECT *
FROM Clientes
WHERE clienteId = 6

/* Creo un Cliente para el siguiente caso de uso*/

DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_CrearNuevoCliente 
    @nombre = 'Antonella', 
    @apellido = 'Rossi', 
    @tipo_documento = 'DNI', 
    @numero_documento = '38190069', 
    @email = null, 
    @fecNac = null, 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @error_code AS ErrorCode, @error_description AS ErrorDescription;

-- Mostrar el nuevo cliente
SELECT clienteId,nombre,apellido,estadoCliId
FROM Clientes 
WHERE clienteId = 6

-- Ejecutar la creación de un nuevo servicio para el cliente recién creado
DECLARE @error_code_servicio INT, @error_description_servicio CHAR(50);
EXEC sp_CreaNuevoServicio 
    @numero = 3323, 
    @calle = 'San Martin', 
    @piso = '3', 
    @depto = 'C', 
    @telefono = '111222333', 
    @clienteId = 6, 
    @tipoServ = 'VO', 
    @error_code = @error_code_servicio OUTPUT, 
    @error_description = @error_description_servicio OUTPUT;
SELECT @error_code_servicio AS ErrorCode, @error_description_servicio AS ErrorDescription;

-- Mostrar los servicios asociados al cliente después del intento de creación
SELECT * FROM vw_Servicios_Por_Cliente WHERE idCLiente = 6;


/*Inactivar un Servicio a un cliente con un solo servicio activo*/
/*-- Caso de prueba: Inactivación de servicio y cliente (ClienteID: 5, ServicioID: 3)*/

/* Precondición: Mostrar el estado actual del servicio y cliente antes de la desactivación */
SELECT servicioId,estadoServId
FROM Servicios 
WHERE servicioId = 3

SELECT clienteId,estadoCliId
FROM Clientes 
WHERE clienteId = 5


EXEC sp_DesactivarServicio 
    @servicioId = 3, 
    @clienteId = 5;

/* Postcondición: Mostrar el estado actual después de la desactivación */
SELECT servicioId,estadoServId
FROM Servicios 
WHERE servicioId = 3

/*Verificar la vista de servicios por cliente después de la desactivación */
SELECT * FROM vw_Servicios_Por_Cliente WHERE IdCLiente = 5;


/*Caso de prueba: Inactivar un servicio a un cliente con más de un servicio activo (ClienteID: 1, ServicioID: 1)*/

/* Precondición: Mostrar el estado actual del cliente Carlos Perez y sus servicios antes de agregar el nuevo servicio */

SELECT * FROM CLIENTES WHERE clienteId = 1;
SELECT * FROM Servicios WHERE clienteld = 1;
/* Agrego un servicio a Carlos Perez con ID:1*/

DECLARE @error_code int;
DECLARE @error_description varchar(50);
EXEC sp_CreaNuevoServicio  
    @numero = 1212, 
    @calle = 'Juncal', 
    @piso = '1', 
    @depto = 'F',
    @telefono = '1132032247',
    @clienteId = 1, 
    @tipoServ = 'TF', 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @error_code AS ErrorCode, @error_description AS ErrorDescription;

SELECT * FROM vw_Servicios_Por_Cliente WHERE idCLiente = 1;

/* Desactivo el ultimo Servicio Agregado a Carlos Perez idCliente:1 y idServicio:6 */

EXEC sp_desactivarServicio 
    @servicioId = 6, 
    @clienteId = 1;

/* Postcondición: Mostrar el estado actualizado del cliente y sus servicios después de la desactivación */
SELECT * FROM vw_Servicios_Por_Cliente WHERE idCLiente = 1;


 /*Generar un nuevo ticket para el servicioId: 4 de Jose Martinez (ClienteID: 3)*/

/* Precondición: Mostrar el estado actual de los servicios por cliente antes de generar el nuevo ticket */
SELECT * FROM vw_Servicios_Por_Cliente WHERE idCLiente = 3;

DECLARE @error_code INT;
DECLARE @error_description CHAR(50);
EXEC sp_CreaNuevoTicket 
    @login = 'jbadia',
    @tipologiald = 'MUDSE',
    @servicioId = 4,
    @clienteld = 3,
    @error_code = @error_code OUTPUT,
    @error_description = @error_description OUTPUT;
SELECT @error_code AS ErrorCode, @error_description AS ErrorDescription;

/* Mostrar el estado de todos los tickets después de generar el nuevo ticket */
select * from tickets

/* Postcondición: Mostrar el estado actualizado de los tickets y detalles del cliente después de generar el nuevo ticket */
SELECT t.ticketId, t.clienteld, t.estadoTicketId, t.fecApertura, t.fecReso, t.fecCierre, C.nombre, C.apellido 
FROM Tickets t
INNER JOIN Registros r ON t.ticketId = r.ticketId
INNER JOIN Clientes C ON C.clienteId = t.clienteld
ORDER BY t.clienteld;


/*Cambiar el estado de un ticket (TicketID: 3) a 'En Progreso'*/

/* Precondición: Mostrar el estado actual del ticket antes del cambio */
SELECT * FROM Tickets WHERE ticketId = 3;

DECLARE @error_code INT, @error_description CHAR(50);
	EXEC sp_CambiarEstadoTicket 
	 @login = 'JCabral', 
	 @ticketId = 3,
	 @nuevoEstado = 'EP',
	 @error_code = @error_code OUTPUT, 
	 @error_description = @error_description OUTPUT;
	 SELECT @error_code, @error_description;

 /* Mostrar el estado actualizado del ticket después del cambio */
SELECT * FROM Tickets WHERE ticketId = 3;

	/* Mostrar el registro del cambio de estado con la fecha y hora actual */
	SELECT * FROM Registros WHERE ticketId = 3;
	/* Mostrar las notificaciones enviadas al cliente por el cambio de estado */
	SELECT * FROM Notificaciones WHERE ticketId = 3;
	/* Mostrar todas las notificaciones generadas */
	SELECT * FROM Notificaciones;


-- Insertar registro en la tabla de emails (se controla por TRIGGUER/UPDATE/TICKETS)
/*SELECT * FROM Notificaciones*/
	SELECT * FROM Notificaciones;

/*Cambiar el estado de un Ticket a Resuelto*/
/* Para que un ticket pueda pasar a estado resuelto previamente debe estar en estado 'EP'*/
/* Utilizamos el TicketId: 3 para este ejemplo*/
/*Mostrar el estado actual del ticket antes del cambio */
SELECT * FROM Tickets WHERE ticketId = 3;
	

DECLARE @error_code INT, @error_description CHAR(50);
EXEC sp_CambiarEstadoTicket 
 @login = 'JCabral', 
 @ticketId = 3,
 @nuevoEstado = 'RE',
 @error_code = @error_code OUTPUT, 
 @error_description = @error_description OUTPUT;
 SELECT @error_code, @error_description;

-- Postcondición: Mostrar el estado final del ticket, el registro de cambio y las notificaciones generadas

 /* Mostrar el estado actualizado del ticket después del cambio */
 SELECT * FROM Tickets WHERE ticketId = 3;

	/* Mostrar el registro del cambio de estado con la fecha y hora actual */
	SELECT * FROM Registros WHERE ticketId = 3;


	/* Mostrar todas las notificaciones generadas */
	SELECT * FROM Notificaciones;

	

	/* Caso de prueba para cambiar el estado de un Ticket a Cerrado */

	-- Precondición: Mostrar el estado actual del TicketId: 3 antes del cambio
	SELECT * FROM Tickets WHERE ticketId = 3;

	-- Ejecutar el procedimiento almacenado para cambiar el estado del ticket a 'Cerrado'
	DECLARE @error_code INT, @error_description CHAR(50);
	EXEC sp_CambiarEstadoTicket 
		@login = 'JCabral', 
		@ticketId = 3,
		@nuevoEstado = 'CE',
		@error_code = @error_code OUTPUT, 
		@error_description = @error_description OUTPUT;
	SELECT @error_code AS Error_Code, @error_description AS Error_Description;

	-- Postcondición: Mostrar el estado final del TicketId: 3 después del cambio
	SELECT * FROM Tickets WHERE ticketId = 3;

	-- Mostrar el registro de cambio generado (RegistroId: 4 en este caso)
	SELECT * FROM Registros WHERE registroId = 4;


/* Caso de prueba: Intento de cambiar de estado un Ticket a un estado no permitido */

-- Precondición: Mostrar estado actual DE UN TICKET AÚN NO CREADO CON id 5
SELECT * FROM Tickets WHERE ticketId = 5;

-- Ejecutar la creación de un nuevo ticket
DECLARE @error_code INT;
DECLARE @error_description CHAR(50);
EXEC sp_CreaNuevoTicket 
    @login = 'asuarez',
    @tipologiald = 'FCARE',
    @servicioId = 1,
    @clienteld = 1,
    @error_code = @error_code OUTPUT,
    @error_description = @error_description OUTPUT;
SELECT @error_code AS ErrorCode, @error_description AS ErrorDescription;

-- Mostrar el estado actual de los tickets después de crear uno nuevo
SELECT * FROM Tickets WHERE ticketId = 5;

-- Intentar cambiar el estado del ticket 4 a 'PC' (no permitido desde 'AB')

DECLARE @error_code INT, @error_description CHAR(50);
EXEC sp_cambiarEstadoTicket 
    @login = 'asuarez', 
    @ticketId = 5,
    @nuevoEstado = 'PC',
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @error_code AS ErrorCode, @error_description AS ErrorDescription;

-- POSTcONDICIÓN: Se debe arrojar error. Mostrar el estado actualizado de los tickets después del intento de cambio de estado
SELECT * FROM Tickets WHERE ticketId = 5;

-- Mostrar registros después del intento de cambio de estado
SELECT * FROM Registros;



/* Caso de prueba: Reasignar un Ticket abierto a un usuario activo */

-- Precondición: Mostrar el estado actual del empleado AC, TicketId 1, antes de la reasignación
SELECT * FROM TICKETS WHERE TicketId = 1;
SELECT * FROM empleados WHERE estadoEmpId = 'AC';

-- Ejecutar la reasignación del TicketId 1 de jbadia a asuarez
DECLARE @TicketId INT = 1;
DECLARE @LoginActual VARCHAR(50) = 'jbadia';
DECLARE @NuevoLogin VARCHAR(50) = 'asuarez'; 
EXEC sp_ReasignarTicket @TicketId, @LoginActual, @NuevoLogin;

-- Postcondición: Mostrar el estado actualizado del TicketId 1 después de la reasignación
SELECT * FROM TICKETS WHERE TicketId = 1;



/* Caso de prueba: Intentar reasignar un Ticket a un usuario inactivo */

-- Precondición: Mostrar el estado actual de los empleados
SELECT * FROM EMPLEADOS;

-- Ejecutar la reasignación del TicketId 1 de asuarez a jmarquez (Empleado inactivo)
SELECT * FROM TICKETS WHERE TicketId = 1;

SELECT * FROM EMPLEADOS WHERE login = 'jmarquez';

DECLARE @TicketId INT = 1;
DECLARE @LoginActual VARCHAR(50) = 'asuarez';
DECLARE @NuevoLogin VARCHAR(50) = 'jmarquez'; 
EXEC sp_ReasignarTicket @TicketId, @LoginActual, @NuevoLogin;

-- Postcondición: Se debe mostrar error. Mostrar el estado actualizado del TicketId 1 después del intento de reasignación
SELECT * FROM TICKETS WHERE TicketId = 1;



/* Caso de prueba 1: Intentar hacer cualquier cambio del ticket con un usuario diferente al dueño */

-- Precondición: Mostrar el estado actual del TicketId 2 antes del intento de modificación
SELECT * FROM Tickets WHERE TicketId = 2;

-- Ejecutar el intento de modificación del TicketId 2 con el usuario 'jbadia', el cual o es el dueño del ticket
EXEC sp_ModificarTicket @ticketId = 2, @login = 'jbadia', @tipologiald = 'BSERV', @serviciold = 2, @clienteld = 2;

-- Postcondición: Se debe mostrar error. Mostrar el estado actual de los Tickets después del intento (se espera que no se haya modificado debido a un error)
SELECT * FROM Tickets WHERE TicketId = 2;


/* Caso de prueba 2: Realizar la modificación del TicketId 2 con el usuario correcto 'asuarez' */

-- Precondición: Mostrar el estado actual del TicketId 2 antes de la modificación
SELECT login, tipologiald FROM Tickets WHERE TicketId = 2;

-- Ejecutar la modificación del TicketId 2 con el usuario 'asuarez'
EXEC sp_ModificarTicket @ticketId = 2, @login = 'asuarez', @tipologiald = 'REIMF', @serviciold = 1, @clienteld = 1;

-- Postcondición: Mostrar el estado actualizado del TicketId 2 después de la modificación
SELECT * FROM Tickets WHERE TicketId = 2;



/* Caso de prueba: Modificar el nombre, apellido y fecha de nacimiento para un cliente con estado 'PR' */

-- Precondición: Mostrar el estado actual del cliente con clienteId = 2 antes de la modificación
SELECT * FROM Clientes WHERE clienteId = 2;

-- Ejecutar la modificación del nombre, apellido y fecha de nacimiento para el cliente con clienteId = 2
EXEC sp_ModificarCliente @clienteId = 2, @nombreNuevo = 'Jhon', @apellidoNuevo = 'diaz', @fecNacNueva = '1990-02-05';

-- Postcondición: Mostrar el estado actualizado del cliente con clienteId = 2 después de la modificación
SELECT * FROM Clientes WHERE clienteId = 2;


/* Caso de prueba: Intentar modificar el nombre y apellido para un cliente con estado 'AC' */

-- Precondición: Mostrar el estado actual del cliente con clienteId = 1 antes del intento de modificación
SELECT * FROM Clientes WHERE clienteId = 1;

-- Ejecutar el intento de modificar el nombre y apellido para el cliente con clienteId = 1
EXEC sp_ModificarCliente @clienteId = 1, @nombreNuevo = 'Laura', @apellidoNuevo = 'López';

-- Postcondición: Mostrar el estado actual del cliente con clienteId = 1 después del intento (se espera un mensaje de error)
SELECT * FROM Clientes WHERE clienteId = 1;



/* Caso de prueba: Intentar modificar la fecha de nacimiento para un cliente con estado 'AC' */

-- Precondición: Mostrar el estado actual del cliente con clienteId = 3 antes del intento de modificación
SELECT * FROM Clientes WHERE clienteId = 3;

-- Ejecutar el intento de modificar la fecha de nacimiento para el cliente con clienteId = 3
EXEC sp_ModificarCliente @clienteId = 3, @fecNacNueva = '1998-02-05';

-- Postcondición: Mostrar el estado actual del cliente con clienteId = 3 después del intento (se espera un mensaje de error)
SELECT * FROM Clientes WHERE clienteId = 3;



/* Caso de prueba: Intentar crear un cliente con un email inválido */

-- Precondición: Mostrar el estado actual de la tabla CLIENTES antes de intentar crear el cliente
SELECT * FROM CLIENTES;

-- Ejecutar el intento de crear un cliente con un email inválido
DECLARE @id_cliente INT, @error_code INT, @error_description CHAR(50);
EXEC sp_crearNuevoCliente 
    @nombre = 'Ramon', 
    @apellido = 'Ramirez', 
    @tipo_documento = 'DNI', 
    @numero_documento = '12345678', 
    @email = 'ramita.com', 
    @fecNac = '1990-01-01', 
    @estadoCliId = 'PR', 
    @id_cliente = @id_cliente OUTPUT, 
    @error_code = @error_code OUTPUT, 
    @error_description = @error_description OUTPUT;
SELECT @id_cliente AS 'ID Cliente Creado', @error_code AS 'Código de Error', @error_description AS 'Descripción de Error';

-- Postcondición: Se debe arrojar error. Mostrar el resultado de la ejecución y el estado actual de la tabla CLIENTES(sin cambios)
SELECT * FROM CLIENTES;

/************************************************************/
/*VISTAS------------------------------------------------------------*/
/*Devuelte el idCLiente, Nombre, Apellido y todos sus servicios */

select * from vw_Servicios_Por_Cliente

/* Devuelve id, nombre,apellido y cantidad de servicios activos del cliente*/
/* Vista de Servicios activos por cliente*/

select * from vw_Servicios_Activos_Cliente

/*Vista de calculo del SLA*/
/* Devuelve el id del Ticket, Nombre, Apellido, el total de tiempo de SLA en horas, el maximo permitido y la diferencia entre ambos*/
/* En caso de que la diferencia sea Negativa, el SLA esta dentro de los parametros aceptables*/

select * from vw_TicketsSLA
