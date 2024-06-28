/*DDL*/
/* CREACION DE TABLAS*/
BEGIN TRANSACTION

BEGIN TRY
BEGIN TRANSACTION

BEGIN TRY
   
/*--—--------------------------------Creación de la tabla EstadoEmpleados*/
CREATE TABLE EstadoEmpleados (
    estadoEmpId VARCHAR(5) PRIMARY KEY,
    estado VARCHAR(50) NOT NULL UNIQUE);
/*—----------------------------------- Creación de la tabla Empleados*/
CREATE TABLE Empleados (
    login VARCHAR(50)  PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    estadoEmpId VARCHAR(5) NOT NULL,
    FOREIGN KEY (estadoEmpId) REFERENCES EstadoEmpleados(estadoEmpId));
/*—----------------------------------------- Creación de la tabla EstadoClientes*/
CREATE TABLE EstadoClientes (
    estadoCliId VARCHAR(5) PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL);
/*—---------------------------------- Creación de la tabla Clientes*/
CREATE TABLE Clientes (
    clienteId INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    tipoDoc VARCHAR(20) NOT NULL,
    nroDoc VARCHAR(8) NOT NULL,
    email VARCHAR(50) DEFAULT NULL,
    fecNac DATE,
    estadoCliId VARCHAR(5),
    FOREIGN KEY (estadoCliId) REFERENCES EstadoClientes(estadoCliId),
    CHECK (LEN(nroDoc) <= 8 AND nroDoc NOT LIKE '%[^0-9]%'));
/*—--------------------------------------------- Creación de la tabla EstadoTickets*/
CREATE TABLE EstadoTickets (
    estadoTicketId VARCHAR(5) PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL UNIQUE);
/*—------------------------------------------------- Creación de la tabla Tipologias*/
CREATE TABLE Tipologias (
    tipologiaId VARCHAR(5) PRIMARY KEY,
	   sla INT,
    tipo VARCHAR(50) NOT NULL);
/*—--------------------------------------------- Creación de la tabla EstadoServicios*/
CREATE TABLE EstadoServicios (
    estadoServId VARCHAR(5) PRIMARY KEY,
    estado VARCHAR(50) NOT NULL UNIQUE);
/*—-------------------------------------------------- Creación de la tabla TipoServicios*/
CREATE TABLE TipoServicios (
    tipoServId VARCHAR(5) PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL UNIQUE);
/*—----------------------------------------------- Creación de la tabla Servicios*/
CREATE TABLE Servicios (
    servicioId INT IDENTITY(1,1) PRIMARY KEY,
    numero VARCHAR(10) NOT NULL,
    calle VARCHAR(50) NOT NULL,
    piso VARCHAR(10) NOT NULL,
    depto VARCHAR(10) NOT NULL,
    feclnicio DATETIME NOT NULL,
    telefono VARCHAR(15) DEFAULT NULL,
    clienteld INT NOT NULL,
    estadoServId VARCHAR(5)  NOT NULL DEFAULT 'AC',
    tipoServId VARCHAR(5) NOT NULL,
    FOREIGN KEY (clienteld) REFERENCES Clientes(clienteId),
    FOREIGN KEY (estadoServId) REFERENCES EstadoServicios(estadoServId),
    FOREIGN KEY (tipoServId) REFERENCES TipoServicios(tipoServId));
/*—---------------------------------------- Creación de la tabla Tickets*/
CREATE TABLE Tickets (
    ticketId INT IDENTITY(1,1) PRIMARY KEY,
    fecReso DATETIME,
    fecCierre DATETIME,      
    fecApertura DATETIME NOT NULL,
    login VARCHAR(50) NOT NULL, 
    estadoTicketId VARCHAR(5) NOT NULL DEFAULT 'AB', 
    tipologiald VARCHAR(5) NOT NULL,
    serviciold INT,
    clienteld INT NOT NULL,
    FOREIGN KEY (login ) REFERENCES Empleados(login ),
    FOREIGN KEY (estadoTicketId) REFERENCES EstadoTickets(estadoTicketId),
    FOREIGN KEY (tipologiald) REFERENCES Tipologias(tipologiaId),
    FOREIGN KEY (serviciold) REFERENCES Servicios(servicioId),
    FOREIGN KEY (clienteld) REFERENCES Clientes(clienteId)
);
/*—----------------------------------------- Creación de la tabla Actividades*/
CREATE TABLE Actividades (
    actividadId INT IDENTITY(1,1) PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    ticketId INT NOT NULL,
    FOREIGN KEY (ticketId) REFERENCES Tickets(ticketId)
);
/*—-------------------------------------- Creación de la tabla Tipologias_TipoServicios*/
CREATE TABLE Tipologias_TipoServicios (
    tipoServId VARCHAR(5),
    tipologiaId VARCHAR(5),
 
    CONSTRAINT PK_Tipologias_TipoServicios PRIMARY KEY (tipoServId, tipologiaId),
    FOREIGN KEY (tipoServId) REFERENCES TipoServicios(tipoServId),
    FOREIGN KEY (tipologiaId) REFERENCES Tipologias(tipologiaId)
);
/*—--------------------------------------------- Creación de la tabla Notificaciones*/
CREATE TABLE Notificaciones (
    notificacionId INT IDENTITY(1,1) PRIMARY KEY,
	fecEnvio DATETIME NOT NULL,
    email VARCHAR(50) NOT NULL,
    ticketId INT NOT NULL,
    FOREIGN KEY (ticketId) REFERENCES Tickets(ticketId)
);

/*—--------------------------------------------- Creación de la tabla Registros*/
CREATE TABLE Registros(
      registroId INT IDENTITY(1,1) PRIMARY KEY,
      fecInicio DATETIME NOT NULL,
	fecCierre DATETIME,
	estadoTicketId VARCHAR(5) NOT NULL,
      ticketId INT NOT NULL,
FOREIGN KEY (ticketId) REFERENCES Tickets(ticketId),
FOREIGN KEY (estadoTicketId) REFERENCES EstadoTickets(estadoTicketId))
/*—--------------------------------------------- Creación de la tabla TransicionesEstados*/
CREATE TABLE TransicionesEstados (
    EstadoActual VARCHAR(5),
    EstadoSiguiente VARCHAR(5),
    PRIMARY KEY (EstadoActual, EstadoSiguiente)
);

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

/*DML*/
/* INSERT DE DATOS INICIALES*/

BEGIN TRANSACTION


BEGIN TRY

   /*—------------------------------------- Insertar datos en EstadoEmpleados */
INSERT INTO EstadoEmpleados (estadoEmpId, estado) VALUES
('AC', 'Activo'),
('IN', 'Inactivo');

--SELECT * from EstadoEmpleados;
/*—----------------------------------------- Insertar datos en Empleados */
INSERT INTO Empleados (login, nombre, apellido, estadoEmpId) VALUES
('jbadia', 'Juan', 'Badia', 'AC'),
('asuarez', 'Ana', 'Suarez', 'AC'),
('jmarquez', 'Jorge', 'Marquez', 'IN'),
('JCabral', 'Juan', 'Cabral', 'AC');

--SELECT * from Empleados;
/*—--------------------------------------- Insertar datos en EstadoClientes */
INSERT INTO EstadoClientes (estadoCliId, tipo) VALUES
('AC', 'Activo'),
('IN', 'Inactivo'),
('PR' , 'Prospecto');

--SELECT * from EstadoClientes;
/*—------------------------------------------- Insertar datos en Clientes */
INSERT INTO Clientes (nombre, apellido, tipoDoc, nroDoc, email, fecNac, estadoCliId) VALUES
('Carlos', 'Perez', 'DNI', '12345678', 'carlos_perez@hotmail.com', '1980-01-15', 'AC'),
('Maria', 'Gomez', 'DNI', '87654321', 'maria_gomezhotmail.com', '1990-05-20', 'PR'),
('Jose', 'Martinez', 'DNI', '45678912', 'jose_martinez@hotmail.com', '1985-10-10', 'IN');

--SELECT * from Clientes;
/*—------------------------------------- Insertar datos en EstadoTickets */
INSERT INTO EstadoTickets (estadoTicketId, tipo) VALUES
('AB', 'Abierto'),
('CE', 'Cerrado'),
('EP', 'En Progreso'),
('PC', 'Pendiente Cliente'),
('RE', 'Resuelto');


--SELECT * from EstadoTickets;
/*—-------------------------------------- Insertar datos en Tipologias */
INSERT INTO Tipologias (tipologiaId, tipo,sla) VALUES
('REIMF', 'Reimpresión de Factura',10),
('SERDE', 'Servicio Degradado',20),
('BSERV', 'Baja de Servicio',30),
('FCARE', 'Facturación de Cargos Erróneos',35),
('CAMVE', 'Cambio de Velocidad',40),
('MUDSE', 'Mudanza de servicio',60);

--SELECT * from Tipologias;
/*—------------------------------------- Insertar datos en EstadoServicios */
INSERT INTO EstadoServicios (estadoServId, estado) VALUES
('AC', 'Activo'),
('IN', 'Inactivo');

--SELECT * from EstadoServicios;
/*—--------------------------------------- Insertar datos en TipoServicios */
INSERT INTO TipoServicios (tipoServId, tipo) VALUES
('TF', 'Telefonía fija'),
('IN', 'Internet'),
('VO', 'VOIP');

--SELECT * from TipoServicios;
/*—------------------------------------------- Insertar datos en Servicios */
INSERT INTO Servicios (numero, calle, piso, depto, feclnicio, telefono, clienteld, estadoServId, tipoServId) VALUES
('1234', 'Av. Siempre Viva', '1', 'A', '2022-01-01', '1112345678', 1, 'AC', 'TF'),
('5678', 'Calle Falsa', '2', 'B', '2023-02-15', '2223456789', 2, 'AC', 'IN');

--SELECT * from Servicios;
/*—----------------------------------------- Insertar datos en Tickets */
INSERT INTO Tickets (fecReso, fecCierre, fecApertura, login, estadoTicketId, tipologiald, serviciold, clienteld) VALUES
('2023-05-01 10:00:00', NULL, '2023-04-30 09:00:00', 'jbadia', 'AB', 'REIMF', 1, 1),
('2023-05-02 11:00:00', '2023-05-02 12:00:00', '2023-05-02 10:00:00', 'asuarez', 'CE', 'BSERV', 2, 2),
('2023-05-02 11:00:00', '2023-05-02 12:00:00', '2023-05-02 10:00:00', 'JCabral', 'RE', 'BSERV', 2, 2);

--SELECT * from Tickets;
/*—-------------------------------------- Insertar datos en Actividades */
INSERT INTO Actividades (tipo, ticketId) VALUES
('Reinicio Router', 1),
('Cambio de cableado interno', 2),
('Envío de factura', 1),
('Cambio Bajada Cableado desde Azotea', 2);

--SELECT * from Actividades;
/*—-------------------------- Insertar datos en Tipologias_TipoServicios */
INSERT INTO Tipologias_TipoServicios (tipoServId, tipologiaId) VALUES
('TF', 'FCARE'),
('IN', 'BSERV');

--SELECT * from Tipologias_TipoServicios;
/*—--------------------------------------- Insertar datos en Notificaciones */
INSERT INTO Notificaciones (fecEnvio, email, ticketId) VALUES
('2023-05-02 12:00:00','carlos_perez@hotmail.com', 1),
('2023-05-04 12:00:00','maria_gomez@hotmail.com', 2);

--SELECT * from Notificaciones;
/*—--------------------------------------- Insertar datos en Registros */
INSERT INTO Registros (fecInicio, fecCierre, estadoTicketId, ticketId) VALUES 
('2023-04-30', NULL, 'AB', 1),
('2023-05-02', '2023-05-02', 'CE', 2);

--SELECT * FROM Registros;
/*—------------------------------------- Insertar datos en TransicionesEstados (transiciones válidas) */
INSERT INTO TransicionesEstados (EstadoActual, EstadoSiguiente) VALUES
('AB', 'EP'),
('EP', 'PC'),
('EP', 'RE'),
('PC', 'EP'),
('RE', 'CE'),
('RE', 'EP')

--SELECT * FROM TransicionesEstados;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

/*—----------------------------------- Borrado de Tablas*/

BEGIN TRANSACTION
BEGIN TRY
DROP TABLE Notificaciones;
DROP TABLE Tipologias_TipoServicios;
DROP TABLE Actividades;
DROP TABLE Registros;
DROP TABLE Tickets;
DROP TABLE Servicios;
DROP TABLE TipoServicios;
DROP TABLE EstadoServicios;
DROP TABLE Tipologias;
DROP TABLE EstadoTickets;
DROP TABLE Clientes;
DROP TABLE EstadoClientes;
DROP TABLE Empleados;
DROP TABLE EstadoEmpleados;
DROP TABLE TransicionesEstados;

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
