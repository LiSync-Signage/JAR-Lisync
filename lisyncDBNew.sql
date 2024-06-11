CREATE DATABASE lisyncDB;
USE lisyncDB;
-- DROP database lisyncDB;
/*------------------------------------- EMPRESA -------------------------------------*/

CREATE  TABLE IF NOT EXISTS Empresa (
	idEmpresa 		INT PRIMARY KEY AUTO_INCREMENT,
	nomeFantasia 	VARCHAR(45),
	plano 			VARCHAR(45),
    cnpj            varchar(14),
	CONSTRAINT CHK_Plano CHECK (plano IN('Basico', 'Corporativo', 'Enterprise'))
    /*Interprise -> Enterprise*/
);

INSERT INTO Empresa (nomeFantasia, plano, cnpj) VALUES
	("SPTech", 'Corporativo', 12345678912345),
    ("Elera.", 'Basico', 12345678912345);

/*------------------------------------- AMBIENTE -------------------------------------*/

CREATE TABLE IF NOT EXISTS Ambiente (
	idAmbiente 		INT PRIMARY KEY AUTO_INCREMENT,
	setor 			VARCHAR(45),
	andar 			VARCHAR(45),
	fkEmpresa 		INT,
    
CONSTRAINT fkEmpresaAmbiente FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa)
);

/*------------------------------------- USUÁRIO -------------------------------------*/

CREATE TABLE IF NOT EXISTS Usuario (
	idUsuario 		INT PRIMARY KEY AUTO_INCREMENT,
    /* nome -> nomeUsuario */
	nomeUsuario		VARCHAR(45),
	email 			VARCHAR(225),
	senha 			VARCHAR(45),
	fkEmpresa 		INT,
	fkGestor 		INT,
    
	CONSTRAINT fkEmpresa FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa),
	CONSTRAINT fkGestor FOREIGN KEY (fkGestor) REFERENCES Usuario(idUsuario)
);

INSERT INTO Usuario (nomeUsuario, email, senha, fkEmpresa, fkGestor) VALUES 
	("Felipe Almeida", "felipe.almeida@sptech.school", "felipe123", 1, null),
	("Carlos Manoel", "carlos.manoel@sptech.school", "carlos123", 1, 1),
	("Marcela Lopez", "marcela.lopez@elera.io", "marcela123", 2, null),
	("José Felipe", "jose.felipe@elera.io", "jose123", 2, 1),
	("Admin Lisync", "admin@admin", "admin", null, null);
    
/*------------------------------------- TELEVISÃO -------------------------------------*/

CREATE TABLE IF NOT EXISTS Televisao (
	idTelevisao 	INT PRIMARY KEY AUTO_INCREMENT,
    /* nome -> nomeTelevisao */
	nomeTelevisao	VARCHAR(45), 
	taxaAtualizacao INT,
    /*hostName -> hostname*/
	hostname 		VARCHAR(80),
	fkAmbiente 		INT NOT NULL,
    
	CONSTRAINT fkAmbiente FOREIGN KEY (fkAmbiente) REFERENCES Ambiente(idAmbiente)
);

/*------------------------------------- COMPONENTE -------------------------------------*/

CREATE TABLE IF NOT EXISTS Componente (
	idComponente 	INT PRIMARY KEY AUTO_INCREMENT,
	modelo 			VARCHAR(225),
	identificador 	VARCHAR(225),
	tipoComponente 	VARCHAR(45),
	fkTelevisao 	INT NOT NULL,
    
	CONSTRAINT fkTv FOREIGN KEY (fkTelevisao) REFERENCES Televisao(idTelevisao)
);

/*------------------------------------- JANELA -------------------------------------*/

CREATE TABLE IF NOT EXISTS Janela (
	idJanela 		INT PRIMARY KEY AUTO_INCREMENT,
	pidJanela		VARCHAR(45),
	titulo 			VARCHAR(225),
	localizacao 	VARCHAR(225),
	visivel 		VARCHAR(45),
	fkTelevisao 	INT,
    
	CONSTRAINT fkTelevisaoJanela FOREIGN KEY (fkTelevisao) REFERENCES Televisao(idTelevisao)
);

/*------------------------------------- LOG PROCESSO -------------------------------------*/

CREATE TABLE IF NOT EXISTS LogProcesso (
	idLog 			INT PRIMARY KEY AUTO_INCREMENT,
	pid 			INT,
	dataHora 		VARCHAR(45),
    /*nome -> nomeProcesso*/
	nomeProcesso 	VARCHAR(80),
	valor 			DOUBLE,
	fkComponente 	INT NOT NULL,
    
	CONSTRAINT fkComponenteLog FOREIGN KEY (fkComponente) REFERENCES Componente(idComponente)
);

/*------------------------------------- LOG COMPONENTE -------------------------------------*/

CREATE TABLE IF NOT EXISTS LogComponente (
	idLogComponente INT PRIMARY KEY AUTO_INCREMENT,
	dataHora 		VARCHAR(45),
	valor 			DOUBLE,
	fkComponente 	INT NOT NULL,
    
	CONSTRAINT fkComponenteLogComponente FOREIGN KEY (fkComponente) REFERENCES Componente(idComponente)
);

/*------------------------------------- COMANDO -------------------------------------*/

CREATE TABLE IF NOT EXISTS Comando (
	idComando 		INT PRIMARY KEY AUTO_INCREMENT,
    /*nome -> nomeComando*/
	nomeComando 	text,
    resposta text,
	fkTelevisao		INT,
    
	CONSTRAINT fkTelevisaoComando FOREIGN KEY (fkTelevisao) REFERENCES Televisao(idTelevisao)
);

/*------------------------------------- SELECTS -------------------------------------*/

SELECT * FROM Janela;
SELECT * FROM LogProcesso;
SELECT * FROM LogComponente;
SELECT * FROM Componente;
SELECT * FROM Televisao;
SELECT * FROM Ambiente;
SELECT * FROM Empresa;
SELECT * FROM Usuario;
SELECT * FROM Comando;