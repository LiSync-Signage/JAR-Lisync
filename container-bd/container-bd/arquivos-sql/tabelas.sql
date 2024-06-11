
CREATE DATABASE lisyncDB;
USE lisyncDB;

CREATE  TABLE IF NOT EXISTS Empresa (
	idEmpresa 		INT PRIMARY KEY AUTO_INCREMENT,
	nomeFantasia 		VARCHAR(45),
	plano 			VARCHAR(45),
    	cnpj            	VARCHAR(14),
	CONSTRAINT CHK_Plano CHECK (plano IN('Basico', 'Corporativo', 'Enterprise'))
    /*Interprise -> Enterprise*/
);

CREATE TABLE IF NOT EXISTS Ambiente (
	idAmbiente 		INT PRIMARY KEY AUTO_INCREMENT,
	setor 			VARCHAR(45),
	andar 			VARCHAR(45),
	fkEmpresa 		INT,
    
CONSTRAINT fkEmpresaAmbiente FOREIGN KEY (fkEmpresa) REFERENCES Empresa(idEmpresa)
);

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

CREATE TABLE IF NOT EXISTS Televisao (
	idTelevisao 		INT PRIMARY KEY AUTO_INCREMENT,
	nomeTelevisao		VARCHAR(45), 
	taxaAtualizacao 	INT,
	hostname 		VARCHAR(80),
	fkAmbiente 		INT NOT NULL,
    
	CONSTRAINT fkAmbiente FOREIGN KEY (fkAmbiente) REFERENCES Ambiente(idAmbiente)
);

CREATE TABLE IF NOT EXISTS Componente (
	idComponente 		INT PRIMARY KEY AUTO_INCREMENT,
	modelo 			VARCHAR(225),
	identificador 		VARCHAR(225),
	tipoComponente 		VARCHAR(45),
	fkTelevisao 		INT NOT NULL,
    
	CONSTRAINT fkTv FOREIGN KEY (fkTelevisao) REFERENCES Televisao(idTelevisao)
);

CREATE TABLE IF NOT EXISTS Janela (
	idJanela 		INT PRIMARY KEY AUTO_INCREMENT,
	pidJanela		VARCHAR(45),
	titulo 			VARCHAR(225),
	localizacao 		VARCHAR(225),
	visivel 		VARCHAR(45),
	fkTelevisao 		INT,
    
	CONSTRAINT fkTelevisaoJanela FOREIGN KEY (fkTelevisao) REFERENCES Televisao(idTelevisao)
);

CREATE TABLE IF NOT EXISTS LogProcesso (
	idLog 			INT PRIMARY KEY AUTO_INCREMENT,
	pid 			INT,
	dataHora 		VARCHAR(45),
	nomeProcesso 		VARCHAR(80),
	valor 			DOUBLE,
	fkComponente 		INT NOT NULL,
    
	CONSTRAINT fkComponenteLog FOREIGN KEY (fkComponente) REFERENCES Componente(idComponente)
);

CREATE TABLE IF NOT EXISTS LogComponente (
	idLogComponente INT PRIMARY KEY AUTO_INCREMENT,
	dataHora 		VARCHAR(45),
	valor 			DOUBLE,
	fkComponente 	INT NOT NULL,
    
	CONSTRAINT fkComponenteLogComponente FOREIGN KEY (fkComponente) REFERENCES Componente(idComponente)
);

CREATE TABLE IF NOT EXISTS Comando (
	idComando 		INT PRIMARY KEY AUTO_INCREMENT,
   	nomeComando 		VARCHAR(255),
    	resposta 		TEXT,
	fkTelevisao		INT,
    
	CONSTRAINT fkTelevisaoComando FOREIGN KEY (fkTelevisao) REFERENCES Televisao(idTelevisao)
);

