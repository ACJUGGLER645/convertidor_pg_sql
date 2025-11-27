SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE `depto` (
    iddepto integer NOT NULL,
    descrip VARCHAR(40),
    localidad VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `empleado` (
    idemp integer NOT NULL,
    apellidos VARCHAR(50),
    nombres VARCHAR(50),
    cargo VARCHAR(30),
    salario DOUBLE,
    comm DOUBLE,
    iddepto integer,
    idjefe integer
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `depto` (iddepto, descrip, localidad) VALUES
('10', 'Gerencia', 'Bogotá'),
('20', 'Sub-gerencia', 'Bogotá'),
('30', 'Contabilidad', 'Bogotá'),
('40', 'Ventas', 'Bogotá'),
('50', 'Recursos Humanos', 'Bogotá');
INSERT INTO `empleado` (idemp, apellidos, nombres, cargo, salario, comm, iddepto, idjefe) VALUES
('12', 'Rodríguez Beltrán', 'manuel ', 'Sub-Gerente', '6000', '0', '10', '1'),
('101', 'Alvarez Corniza', 'Antonio José', 'Asistente de Contabilidad', '2000', '0', '20', '100'),
('10', 'Morales Cañón', 'Humberto  José', 'Gerente', '10000', '0', '10', '0'),
('200', 'Acosta Cabrera', 'Andrés', 'Director de Ventas', '3000', '0', '40', '1'),
('202', 'Castillo Gil', 'Johnson Stiven', 'Vendedor', '1500', '1500', '40', '200'),
('104', 'Gonzalez Médez', 'Andres Felipe', 'Asistente Contabilidad', '2000', '0', '20', '100'),
('106', 'Casas Arroyo', 'Pedro Manuel', 'Contador', '3000', '0', '20', '100'),
('201', 'Arevalo Angel', 'Tomás David', 'Vendedor', '1500', '4000', '40', '200'),
('203', 'Cuervo Bello', 'Jahider Felipe', 'Vendedor', '1500', '3500', '40', '200'),
('100', 'Martínez Gómez', 'Kevin Elías ', 'Director Contabolidad', '3000', '0', '20', '1');
ALTER TABLE `depto`
    ADD CONSTRAINT depto_pkey PRIMARY KEY (iddepto);
ALTER TABLE `empleado`
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (idemp);
ALTER TABLE `empleado`
    ADD CONSTRAINT empleado_iddepto_fkey FOREIGN KEY (iddepto) REFERENCES `depto`(iddepto);
SET FOREIGN_KEY_CHECKS = 1;
