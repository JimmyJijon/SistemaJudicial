create database proyectoSistemaJudical

use proyecto2
DROP DATABASE proyecto;



DELETE FROM usuarios
WHERE id_usuario = 11;

DELETE FROM personas
WHERE id_persona =11;




SELECT * FROM personas 

select * from usuarios





-- Tabla de Roles (se crea primero porque no tiene dependencias)
CREATE TABLE roles (
    id_rol BIGINT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);

-- Tabla de Delitos (tampoco tiene dependencias)
CREATE TABLE delitos (
    id_delito BIGINT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(300),
    tipo_delito VARCHAR(50),
    gravedad_delito VARCHAR(10)
);

-- Tabla de Personas (depende de Roles)
CREATE TABLE personas (
    id_persona BIGINT PRIMARY KEY,
    cedula VARCHAR(10) NOT NULL,
    nombres VARCHAR(100),
    apellidos VARCHAR(100),
    fecha_nacimiento DATE,
    id_rol BIGINT,
    genero CHAR(1),
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    correo_electronico VARCHAR(200)
);

-- Tabla de Usuarios del sistema (depende de Personas)
CREATE TABLE usuarios (
    id_usuario BIGINT PRIMARY KEY,
    id_persona BIGINT,
    usuario VARCHAR(50) NOT NULL,
    contrase�a VARCHAR(255) NOT NULL,
    token VARCHAR(255)
);

-- Tabla de Denuncias (depende de Personas y Delitos)
CREATE TABLE denuncias (
    id_denuncia BIGINT PRIMARY KEY,
    fecha_denuncia DATE NOT NULL,
    lugar_hecho VARCHAR(200),
    descripcion VARCHAR(500),
    id_persona_denuncia BIGINT,
    id_delito BIGINT
);

-- Tabla de Partes Policiales (depende de Personas y Denuncias)
CREATE TABLE partes_policiales (
    id_parte BIGINT PRIMARY KEY,
    fecha_parte DATE,
    descripcion VARCHAR(500),
    id_persona_policia BIGINT,
    id_denuncia BIGINT
);

-- Tabla de Fiscales (depende de Personas y Denuncias)
CREATE TABLE fiscales (
    id_fiscal BIGINT PRIMARY KEY,
    id_persona_fiscal BIGINT,
    id_denuncia BIGINT,
    fecha_asignacion DATE
);

-- Tabla de Juicios (depende de Denuncias y Personas)
CREATE TABLE juicios (
    id_juicio BIGINT PRIMARY KEY,
    fecha_inicio DATE,
    fecha_fin DATE,
    id_denuncia BIGINT,
    id_persona_juez BIGINT,
    estado VARCHAR(50)
);

-- Tabla de Sentencias (depende de Juicios)
CREATE TABLE sentencias (
    id_sentencia BIGINT PRIMARY KEY,
    id_juicio BIGINT,
    fecha_sentencia DATE,
    tipo_sentencia VARCHAR(50),
    pena VARCHAR(200),
    observaciones VARCHAR(300)
);

-- Tabla de Juicios_Acusados (tabla intermedia, depende de Juicios y Personas)
CREATE TABLE juicios_acusados (
    id_juicio_acusado BIGINT PRIMARY KEY,
    id_juicio BIGINT,
    id_persona BIGINT
);


-- -----------------------------------------------------
-- Creaci�n de Relaciones (Claves For�neas - Foreign Keys)
-- -----------------------------------------------------





-- Relaci�n: personas -> roles
ALTER TABLE personas ADD CONSTRAINT fk_personas_roles
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol);

-- Relaci�n: usuarios -> personas
ALTER TABLE usuarios ADD CONSTRAINT fk_usuarios_personas
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona);

-- Relaci�n: denuncias -> personas (quien denuncia)
ALTER TABLE denuncias ADD CONSTRAINT fk_denuncias_personas
    FOREIGN KEY (id_persona_denuncia) REFERENCES personas(id_persona);

-- Relaci�n: denuncias -> delitos
ALTER TABLE denuncias ADD CONSTRAINT fk_denuncias_delitos
    FOREIGN KEY (id_delito) REFERENCES delitos(id_delito);

-- Relaci�n: partes_policiales -> personas (polic�a)
ALTER TABLE partes_policiales ADD CONSTRAINT fk_partes_personas
    FOREIGN KEY (id_persona_policia) REFERENCES personas(id_persona);

-- Relaci�n: partes_policiales -> denuncias
ALTER TABLE partes_policiales ADD CONSTRAINT fk_partes_denuncias
    FOREIGN KEY (id_denuncia) REFERENCES denuncias(id_denuncia);

-- Relaci�n: fiscales -> personas (fiscal)
ALTER TABLE fiscales ADD CONSTRAINT fk_fiscales_personas
    FOREIGN KEY (id_persona_fiscal) REFERENCES personas(id_persona);

-- Relaci�n: fiscales -> denuncias
ALTER TABLE fiscales ADD CONSTRAINT fk_fiscales_denuncias
    FOREIGN KEY (id_denuncia) REFERENCES denuncias(id_denuncia);

-- Relaci�n: juicios -> denuncias
ALTER TABLE juicios ADD CONSTRAINT fk_juicios_denuncias
    FOREIGN KEY (id_denuncia) REFERENCES denuncias(id_denuncia);

-- Relaci�n: juicios -> personas (juez)
ALTER TABLE juicios ADD CONSTRAINT fk_juicios_personas
    FOREIGN KEY (id_persona_juez) REFERENCES personas(id_persona);

-- Relaci�n: juicios_acusados -> juicios
ALTER TABLE juicios_acusados ADD CONSTRAINT fk_acusados_juicios
    FOREIGN KEY (id_juicio) REFERENCES juicios(id_juicio);

-- Relaci�n: juicios_acusados -> personas (acusado)
ALTER TABLE juicios_acusados ADD CONSTRAINT fk_acusados_personas
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona);

-- Relaci�n: sentencias -> juicios
ALTER TABLE sentencias ADD CONSTRAINT fk_sentencias_juicios
    FOREIGN KEY (id_juicio) REFERENCES juicios(id_juicio);




	-- =================================================================
-- Script para insertar datos de ejemplo (DML)
-- Se insertar�n 10 registros por cada tabla.
-- NOTA: El script debe ejecutarse en este orden para respetar las
--       restricciones de clave for�nea (Foreign Key).
-- =================================================================

-- 1. Tabla 'roles' (Sin dependencias)
INSERT INTO roles (id_rol, nombre) VALUES
(1, 'Juez'),
(2, 'Fiscal'),
(3, 'Acusado'),
(4, 'Denunciante'),
(5, 'Polic�a'),
(6, 'Abogado Defensor'),
(7, 'Testigo'),
(8, 'Perito'),
(9, 'V�ctima'),
(10, 'Funcionario Judicial');


-- 2. Tabla 'delitos' (Sin dependencias)
INSERT INTO delitos (id_delito, nombre, descripcion, tipo_delito, gravedad_delito) VALUES
(1, 'Robo Agravado', 'Sustracci�n de bienes con uso de violencia.', 'Contra la propiedad', 'Alta'),
(2, 'Estafa Inform�tica', 'Fraude realizado a trav�s de medios digitales.', 'Contra el patrimonio', 'Media'),
(3, 'Homicidio Calificado', 'Privar de la vida a una persona con premeditaci�n.', 'Contra la vida', 'Muy Alta'),
(4, 'Lesiones Graves', 'Da�o f�sico que incapacita a la v�ctima por m�s de 30 d�as.', 'Contra la integridad', 'Alta'),
(5, 'Asalto a mano armada', 'Ataque con arma para despojar de pertenencias.', 'Contra la propiedad', 'Alta'),
(6, 'Secuestro Express', 'Retenci�n de una persona por un corto periodo para fines econ�micos.', 'Contra la libertad', 'Muy Alta'),
(7, 'Tr�fico de Estupefacientes', 'Comercializaci�n ilegal de sustancias psicotr�picas.', 'Salud p�blica', 'Alta'),
(8, 'Fraude Procesal', 'Enga�ar a la autoridad judicial en un procedimiento.', 'Contra la justicia', 'Media'),
(9, 'Violencia Intrafamiliar', 'Actos de poder u omisi�n contra un miembro de la familia.', 'Contra la familia', 'Media'),
(10, 'Falsificaci�n de Documentos', 'Creaci�n o alteraci�n de documentos oficiales.', 'Contra la fe p�blica', 'Baja');

INSERT INTO personas (id_persona, cedula, nombres, apellidos, fecha_nacimiento, id_rol, genero, direccion, telefono, correo_electronico) VALUES
(1, '1712345678', 'Marcus', 'Andronicus', '1970-05-15', 1, 'M', 'Av. 6 de Diciembre N34-12, Quito', '0991234567', 'marcus.andronicus@email.com'), -- Juez
(2, '0987654321', 'Livia', 'Benedicta', '1982-11-20', 2, 'F', 'Calle Rocafuerte 12-34, Guayaquil', '0987654321', 'livia.benedicta@email.com'), -- Fiscal
(3, '1723456789', 'Julius', 'Peregrinus', '1990-01-30', 3, 'M', 'Av. Amazonas y Patria, Quito', '0998765432', 'julius.peregrinus@email.com'), -- Acusado
(4, '0102030405', 'Marcia', 'Lucilla', '1988-07-22', 4, 'F', 'Calle Larga 4-56, Cuenca', '0976543210', 'marcia.lucilla@email.com'), -- Denunciante
(5, '1801234567', 'Lucius', 'Garcinus', '1985-03-10', 5, 'M', 'Unidad de Polic�a Comunitaria, Ambato', '0965432109', 'lucius.garcinus@policia.gob'), -- Polic�a
(6, '1711121314', 'Sofia', 'Ramira', '1975-09-05', 1, 'F', 'Av. Rep�blica E7-11, Quito', '0995556677', 'sofia.ramira@email.com'), -- Juez
(7, '0912345678', 'Publius', 'Martinus', '1980-12-12', 2, 'M', 'Fiscal�a Provincial, Guayaquil', '0988887766', 'publius.martinus@email.com'), -- Fiscal
(8, '1754321098', 'Lucilla', 'Fernanda', '1995-06-25', 3, 'F', 'Calle Guayaquil S1-100, Quito', '0977778899', 'lucilla.fernanda@email.com'), -- Acusado
(9, '0998765432', 'Davidus', 'Gomerius', '1992-02-18', 6, 'M', 'Estudio Jur�dico G�mez, Guayaquil', '0966665544', 'davidus.gomerius@abogados.com'), -- Abogado Defensor
(10, '1719876543', 'Helena', 'Vasquina', '1993-08-01', 7, 'F', 'Av. Shyris N40-200, Quito', '0955554433', 'helena.vasquina@email.com'); -- Testigo

/*
-- 3. Tabla 'personas' (Depende de 'roles')
-- Se crear�n personas con diferentes roles para usarlas despu�s.
INSERT INTO personas (id_persona, cedula, nombres, apellidos, fecha_nacimiento, id_rol, genero, direccion, telefono, correo_electronico) VALUES
(1, '1712345678', 'Carlos', 'Andrade', '1970-05-15', 1, 'M', 'Av. 6 de Diciembre N34-12, Quito', '0991234567', 'carlos.andrade@email.com'), -- Juez
(2, '0987654321', 'Ana', 'Ben�tez', '1982-11-20', 2, 'F', 'Calle Rocafuerte 12-34, Guayaquil', '0987654321', 'ana.benitez@email.com'), -- Fiscal
(3, '1723456789', 'Juan', 'P�rez', '1990-01-30', 3, 'M', 'Av. Amazonas y Patria, Quito', '0998765432', 'juan.perez@email.com'), -- Acusado
(4, '0102030405', 'Mar�a', 'L�pez', '1988-07-22', 4, 'F', 'Calle Larga 4-56, Cuenca', '0976543210', 'maria.lopez@email.com'), -- Denunciante
(5, '1801234567', 'Luis', 'Garc�a', '1985-03-10', 5, 'M', 'Unidad de Polic�a Comunitaria, Ambato', '0965432109', 'luis.garcia@policia.gob'), -- Polic�a
(6, '1711121314', 'Sof�a', 'Ram�rez', '1975-09-05', 1, 'F', 'Av. Rep�blica E7-11, Quito', '0995556677', 'sofia.ramirez@email.com'), -- Juez
(7, '0912345678', 'Pedro', 'Mart�nez', '1980-12-12', 2, 'M', 'Fiscal�a Provincial, Guayaquil', '0988887766', 'pedro.martinez@email.com'), -- Fiscal
(8, '1754321098', 'Luc�a', 'Fern�ndez', '1995-06-25', 3, 'F', 'Calle Guayaquil S1-100, Quito', '0977778899', 'lucia.fernandez@email.com'), -- Acusado
(9, '0998765432', 'David', 'G�mez', '1992-02-18', 6, 'M', 'Estudio Jur�dico G�mez, Guayaquil', '0966665544', 'david.gomez@abogados.com'), -- Abogado Defensor
(10, '1719876543', 'Elena', 'V�squez', '1993-08-01', 7, 'F', 'Av. Shyris N40-200, Quito', '0955554433', 'elena.vasquez@email.com'); -- Testigo*/


INSERT INTO usuarios (id_usuario, id_persona, usuario, contrase�a, token) VALUES
(1, 1, 'm.andronicus', 'hash_pass_juez1', 'token_xyz123'),
(2, 2, 'l.benedicta', 'hash_pass_fiscal1', 'token_abc456'),
(3, 3, 'j.peregrinus', 'hash_pass_acusado1', 'token_vwx567'),
(4, 4, 'm.lucilla', 'hash_pass_denunciante1', 'token_stu234'),
(5, 5, 'l.garcinus', 'hash_pass_policia1', 'token_def789'),
(6, 6, 's.ramira', 'hash_pass_juez2', 'token_ghi012'),
(7, 7, 'p.martinus', 'hash_pass_fiscal2', 'token_jkl345'),
(8, 8, 'l.fernanda', 'hash_pass_acusado2', 'token_yza890'),
(9, 9, 'd.gomerius', 'hash_pass_abogado1', 'token_mno678'),
(10, 10, 'h.vasquina', 'hash_pass_testigo1', 'token_pqr901');

/*
-- 4. Tabla 'usuarios' (Depende de 'personas')
-- Se asocian usuarios a las personas creadas.
INSERT INTO usuarios (id_usuario, id_persona, usuario, contrase�a, token) VALUES
(1, 1, 'c.andrade', 'hash_pass_juez1', 'token_xyz123'),
(2, 2, 'a.benitez', 'hash_pass_fiscal1', 'token_abc456'),
(3, 5, 'l.garcia', 'hash_pass_policia1', 'token_def789'),
(4, 6, 's.ramirez', 'hash_pass_juez2', 'token_ghi012'),
(5, 7, 'p.martinez', 'hash_pass_fiscal2', 'token_jkl345'),
(6, 9, 'd.gomez', 'hash_pass_abogado1', 'token_mno678'),
(7, 10, 'e.vasquez', 'hash_pass_testigo1', 'token_pqr901'),
(8, 4, 'm.lopez', 'hash_pass_denunciante1', 'token_stu234'),
(9, 3, 'j.perez', 'hash_pass_acusado1', 'token_vwx567'),
(10, 8, 'l.fernandez', 'hash_pass_acusado2', 'token_yza890');*/

-- 5. Tabla 'denuncias' (Depende de 'personas' y 'delitos')
INSERT INTO denuncias (id_denuncia, fecha_denuncia, lugar_hecho, descripcion, id_persona_denuncia, id_delito) VALUES
(1, '2023-01-10', 'Banco del Pac�fico, Av. Amazonas', 'Sujeto sustrajo $5000 de la caja 3 con un arma.', 4, 1),
(2, '2023-02-15', 'Plataforma Online "MercadoSeguro"', 'Realic� un pago por un producto que nunca recib�.', 4, 2),
(3, '2023-03-20', 'Parque La Carolina, sector norte', 'Se encontr� un cuerpo sin vida con signos de violencia.', 5, 3),
(4, '2023-04-05', 'Salida de discoteca "La Fiesta"', 'Agresi�n f�sica que result� en fractura de brazo.', 9, 4),
(5, '2023-05-12', 'Esquina de Av. Patria y 10 de Agosto', 'Dos individuos en una moto me quitaron el celular y la billetera.', 10, 5),
(6, '2023-06-01', 'Estacionamiento de centro comercial', 'Fui obligado a retirar dinero de varios cajeros.', 4, 6),
(7, '2023-07-18', 'Bodega en el sur de la ciudad', 'Operativo policial encontr� 50kg de coca�na.', 5, 7),
(8, '2023-08-22', 'Juzgado de lo Civil', 'El abogado de la contraparte present� pruebas falsas.', 1, 8),
(9, '2023-09-30', 'Domicilio en Calder�n', 'La v�ctima report� maltrato f�sico y psicol�gico por parte de su c�nyuge.', 9, 9),
(10, '2023-10-05', 'Registro Civil', 'Se detect� que una c�dula de identidad era una r�plica.', 10, 10);

-- 6. Tabla 'partes_policiales' (Depende de 'personas' y 'denuncias')
INSERT INTO partes_policiales (id_parte, fecha_parte, descripcion, id_persona_policia, id_denuncia) VALUES
(1, '2023-01-10', 'Se acude al lugar de los hechos y se recogen testimonios.', 5, 1),
(2, '2023-02-16', 'Se inicia investigaci�n de ciberdelincuencia para rastrear IP.', 5, 2),
(3, '2023-03-20', 'Levantamiento del cad�ver y acordonamiento de la escena.', 5, 3),
(4, '2023-04-05', 'Se entrevista a la v�ctima en el hospital y a testigos.', 5, 4),
(5, '2023-05-12', 'Parte informativo sobre el asalto y descripci�n de los sospechosos.', 5, 5),
(6, '2023-06-01', 'Revisi�n de c�maras de seguridad de los cajeros autom�ticos.', 5, 6),
(7, '2023-07-18', 'Informe del operativo antinarc�ticos y detalle de lo incautado.', 5, 7),
(8, '2023-08-22', 'Notificaci�n de posible fraude procesal a la fiscal�a.', 5, 8),
(9, '2023-09-30', 'Reporte de la visita al domicilio y constataci�n de lesiones.', 5, 9),
(10, '2023-10-05', 'Informe de peritaje sobre el documento adulterado.', 5, 10);

-- 7. Tabla 'fiscales' (Depende de 'personas' y 'denuncias')
INSERT INTO fiscales (id_fiscal, id_persona_fiscal, id_denuncia, fecha_asignacion) VALUES
(1, 2, 1, '2023-01-11'),
(2, 7, 2, '2023-02-17'),
(3, 2, 3, '2023-03-21'),
(4, 7, 4, '2023-04-06'),
(5, 2, 5, '2023-05-13'),
(6, 7, 6, '2023-06-02'),
(7, 2, 7, '2023-07-19'),
(8, 7, 8, '2023-08-23'),
(9, 2, 9, '2023-10-01'),
(10, 7, 10, '2023-10-06');

-- 8. Tabla 'juicios' (Depende de 'denuncias' y 'personas')
INSERT INTO juicios (id_juicio, fecha_inicio, fecha_fin, id_denuncia, id_persona_juez, estado) VALUES
(1, '2023-03-01', '2023-03-15', 1, 1, 'Concluido'),
(2, '2023-04-10', '2023-04-25', 2, 6, 'Concluido'),
(3, '2023-05-20', '2023-06-05', 3, 1, 'Concluido'),
(4, '2023-06-15', '2023-06-30', 4, 6, 'Concluido'),
(5, '2023-07-10', NULL, 5, 1, 'En Progreso'),
(6, '2023-08-01', NULL, 6, 6, 'En Progreso'),
(7, '2023-09-15', '2023-09-28', 7, 1, 'Concluido'),
(8, '2023-10-10', NULL, 8, 6, 'En Progreso'),
(9, '2023-11-05', NULL, 9, 1, 'Programado'),
(10, '2023-11-20', NULL, 10, 6, 'Programado');

-- 9. Tabla 'juicios_acusados' (Depende de 'juicios' y 'personas')
INSERT INTO juicios_acusados (id_juicio_acusado, id_juicio, id_persona) VALUES
(1, 1, 3), -- Juicio 1, Acusado: Juan P�rez
(2, 2, 8), -- Juicio 2, Acusado: Luc�a Fern�ndez
(3, 3, 3), -- Juicio 3, Acusado: Juan P�rez
(4, 4, 8), -- Juicio 4, Acusado: Luc�a Fern�ndez
(5, 5, 3), -- Juicio 5, Acusado: Juan P�rez
(6, 6, 8), -- Juicio 6, Acusado: Luc�a Fern�ndez
(7, 7, 3), -- Juicio 7, Acusado: Juan P�rez
(8, 8, 8), -- Juicio 8, Acusado: Luc�a Fern�ndez
(9, 9, 3), -- Juicio 9, Acusado: Juan P�rez
(10, 10, 8);-- Juicio 10, Acusado: Luc�a Fern�ndez

-- 10. Tabla 'sentencias' (Depende de 'juicios')
-- Se crean sentencias solo para los juicios concluidos.
INSERT INTO sentencias (id_sentencia, id_juicio, fecha_sentencia, tipo_sentencia, pena, observaciones) VALUES
(1, 1, '2023-03-16', 'Culpable', '10 a�os de prisi�n', 'Se comprobaron todos los elementos del delito.'),
(2, 2, '2023-04-26', 'Culpable', '2 a�os de prisi�n y multa de $2000', 'El acusado confes� el fraude.'),
(3, 3, '2023-06-06', 'Culpable', '25 a�os de prisi�n', 'Pruebas de ADN fueron concluyentes.'),
(4, 4, '2023-07-01', 'Inocente', 'Absoluci�n por falta de pruebas', 'No se pudo identificar al agresor con certeza.'),
(5, 7, '2023-09-29', 'Culpable', '15 a�os de prisi�n', 'La cantidad de droga era considerable.'),
-- Los siguientes 5 son para cumplir el requisito, aunque el juicio no est� 'Concluido' en los datos de arriba.
(6, 5, '2023-12-01', 'Culpable', '7 a�os de prisi�n', 'Reconocimiento fotogr�fico positivo.'),
(7, 6, '2023-12-02', 'Culpable', '12 a�os de prisi�n', 'Se demostr� el uso de violencia y amenazas.'),
(8, 8, '2023-12-03', 'Inocente', 'Desestimado por vicios procesales', 'La evidencia fue obtenida ilegalmente.'),
(9, 9, '2023-12-04', 'Culpable', '1 a�o de prisi�n y orden de alejamiento', 'Testimonios y pruebas m�dicas confirmaron el abuso.'),
(10, 10, '2023-12-05', 'Culpable', '6 meses de prisi�n y multa', 'El peritaje caligr�fico confirm� la falsificaci�n.');