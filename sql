CREATE DATABASE keyfalls;
USE keyfalls;

CREATE TABLE concursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    esfera ENUM('Nacional', 'Estadual', 'Municipal') NOT NULL,
    data_prova DATE,
    edital TEXT
);

CREATE TABLE cargos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    concurso_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    vagas INT NOT NULL,
    FOREIGN KEY (concurso_id) REFERENCES concursos(id) ON DELETE CASCADE
);

CREATE TABLE candidatos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    login VARCHAR(50) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    bairro VARCHAR(100)
);

CREATE TABLE inscricoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT NOT NULL,
    cargo_id INT NOT NULL,
    numero_inscricao VARCHAR(30) UNIQUE NOT NULL,
    data_inscricao DATE,
    status ENUM('Pendente', 'Confirmada', 'Cancelada') DEFAULT 'Pendente',
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id),
    FOREIGN KEY (cargo_id) REFERENCES cargos(id)
);

CREATE TABLE boletos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscricao_id INT NOT NULL,
    valor DECIMAL(10,2),
    vencimento DATE,
    pago BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (inscricao_id) REFERENCES inscricoes(id) ON DELETE CASCADE
);

CREATE TABLE pedidos_isencao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscricao_id INT NOT NULL,
    data_pedido DATE,
    resultado ENUM('Em análise', 'Deferido', 'Indeferido') DEFAULT 'Em análise',
    FOREIGN KEY (inscricao_id) REFERENCES inscricoes(id) ON DELETE CASCADE
);

CREATE TABLE funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf CHAR(11) UNIQUE,
    cargo VARCHAR(80)
);

CREATE TABLE locais_prova (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150),
    cidade VARCHAR(100),
    bairro VARCHAR(100),
    endereco VARCHAR(200)
);

CREATE TABLE salas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    local_id INT NOT NULL,
    numero VARCHAR(20),
    capacidade INT,
    funcionario_id INT NOT NULL,
    FOREIGN KEY (local_id) REFERENCES locais_prova(id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id)
);

CREATE TABLE provas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cargo_id INT NOT NULL,
    nome VARCHAR(100),
    peso DECIMAL(4,2),
    FOREIGN KEY (cargo_id) REFERENCES cargos(id) ON DELETE CASCADE
);

CREATE TABLE questoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prova_id INT NOT NULL,
    numero INT NOT NULL,
    gabarito CHAR(1),
    anulada BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (prova_id) REFERENCES provas(id) ON DELETE CASCADE
);

CREATE TABLE aplicacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscricao_id INT NOT NULL,
    sala_id INT NOT NULL,
    FOREIGN KEY (inscricao_id) REFERENCES inscricoes(id),
    FOREIGN KEY (sala_id) REFERENCES salas(id)
);

CREATE TABLE presencas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aplicacao_id INT NOT NULL,
    assinou BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (aplicacao_id) REFERENCES aplicacoes(id) ON DELETE CASCADE
);

CREATE TABLE respostas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscricao_id INT NOT NULL,
    questao_id INT NOT NULL,
    resposta CHAR(1),
    correta BOOLEAN,
    FOREIGN KEY (inscricao_id) REFERENCES inscricoes(id),
    FOREIGN KEY (questao_id) REFERENCES questoes(id)
);

CREATE TABLE resultados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    inscricao_id INT NOT NULL,
    nota DECIMAL(5,2),
    acertos INT,
    erros INT,
    classificado BOOLEAN,
    FOREIGN KEY (inscricao_id) REFERENCES inscricoes(id) ON DELETE CASCADE
);

CREATE TABLE recursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    candidato_id INT NOT NULL,
    questao_id INT NOT NULL,
    justificativa TEXT,
    status ENUM('Em análise', 'Deferido', 'Indeferido') DEFAULT 'Em análise',
    FOREIGN KEY (candidato_id) REFERENCES candidatos(id),
    FOREIGN KEY (questao_id) REFERENCES questoes(id)
);
