#!/bin/bash

nomeImagem="banco-lisync"
nomeContainer="banco-lisync"
portaHost=3306
portaContainer=3306
dirDockerfile="container-bd"
dirSQL="arquivos-sql"

if ! command -v docker &> /dev/null; then
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) O Docker não está instalado. Iniciando o processo de instalação..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) Docker instalado com sucesso."
    else
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) Docker já está instalado."
    fi
    sleep 5
    # Verificar se o Docker Compose está instalado
    if ! command -v docker-compose &> /dev/null; then
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) O Docker Compose não está instalado. Iniciando o processo de instalação..."
        sudo apt install docker-compose -y
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) Docker Compose instalado com sucesso."
    else
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) Docker Compose já está instalado."
    fi
    sleep 5
    # Verificar se o Java 17 está instalado
    if ! command -v java &> /dev/null || [[ $(java -version 2>&1 | grep -c "17\..*") -eq 0 ]]; then
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) O Java 17 não está instalado. Iniciando o processo de instalação..."
        sudo apt update
        sudo apt install openjdk-17-jdk -y
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) Java 17 instalado com sucesso."
    else
        echo "$(tput setaf 4)[LIS]:$(tput setaf 7) Java 17 já está instalado."
    fi

docker pull mysql

mkdir $dirDockerfile
cd $dirDockerfile
touch Dockerfile

cat <<EOF > Dockerfile

FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=urubu100 \
    MYSQL_DATABASE=lisyncDB \
    MYSQL_USER=Ubuntu \
    MYSQL_PASSWORD=urubu100

COPY ./arquivos-sql/ /docker-entrypoint-initdb.d/
COPY ./arquivos-sql/ /tabelas/

EXPOSE 3306

EOF

mkdir $dirSQL
cd $dirSQL
touch tabelas.sql

cat <<EOF > tabelas.sql

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

EOF

docker build -t $nomeImagem $dirDockerfile

docker run -d --name $nomeContainer -p $portaHost:$portaContainer $nomeImagem

if [ "$(docker ps -q -f name=$nomeContainer)" ]; then
    echo "Container $nomeContainer criado com sucesso!"
else
    echo "Falha ao criar o container $nomeContainer."
fi