CREATE SCHEMA academico;
CREATE SCHEMA seguranca;

CREATE TABLE academico.aluno (
    id_aluno INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    endereco VARCHAR(150),
    data_ingresso DATE,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.disciplina (
    id_disciplina VARCHAR(10) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    carga_h INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.professor (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.operador_pedagogico (
    id_operador VARCHAR(10) PRIMARY KEY,
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE academico.turma (
    id_turma SERIAL PRIMARY KEY,
    id_disciplina VARCHAR(10) NOT NULL,
    id_professor INT NOT NULL,
    id_operador VARCHAR(10) NOT NULL,
    ciclo VARCHAR(10) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (id_disciplina) REFERENCES academico.disciplina(id_disciplina),
    FOREIGN KEY (id_professor) REFERENCES academico.professor(id_professor),
    FOREIGN KEY (id_operador) REFERENCES academico.operador_pedagogico(id_operador)
);

CREATE TABLE academico.matricula (
    id_matricula SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    nota NUMERIC(4,2),
    ativo BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (id_aluno) REFERENCES academico.aluno(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES academico.turma(id_turma)
);


CREATE OR REPLACE FUNCTION academico.bloquear_delete()
RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION 'DELETE não permitido. Use campo ativo = false';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_aluno_delete
BEFORE DELETE ON academico.aluno
FOR EACH ROW EXECUTE FUNCTION academico.bloquear_delete();

CREATE TRIGGER trg_disciplina_delete
BEFORE DELETE ON academico.disciplina
FOR EACH ROW EXECUTE FUNCTION academico.bloquear_delete();

CREATE TRIGGER trg_professor_delete
BEFORE DELETE ON academico.professor
FOR EACH ROW EXECUTE FUNCTION academico.bloquear_delete();

CREATE TRIGGER trg_turma_delete
BEFORE DELETE ON academico.turma
FOR EACH ROW EXECUTE FUNCTION academico.bloquear_delete();

CREATE TRIGGER trg_matricula_delete
BEFORE DELETE ON academico.matricula
FOR EACH ROW EXECUTE FUNCTION academico.bloquear_delete();

-- =========================
-- INSERTS
-- =========================

INSERT INTO academico.aluno VALUES
(2026001,'Ana Beatriz Lima','ana.lima@aluno.edu.br','Bragança Paulista/SP','2026-01-20',TRUE),
(2026002,'Bruno Henrique Souza','bruno.souza@aluno.edu.br','Atibaia/SP','2026-01-21',TRUE),
(2026003,'Camila Ferreira','camila.ferreira@aluno.edu.br','Jundiaí/SP','2026-01-22',TRUE),
(2026004,'Diego Martins','diego.martins@aluno.edu.br','Campinas/SP','2026-01-23',TRUE),
(2026005,'Eduarda Nunes','eduarda.nunes@aluno.edu.br','Itatiba/SP','2026-01-24',TRUE),
(2026006,'Felipe Araújo','felipe.araujo@aluno.edu.br','Louveira/SP','2026-01-25',TRUE),
(2025010,'Gabriela Torres','gabriela.torres@aluno.edu.br','Nazaré Paulista/SP','2025-08-05',TRUE),
(2025011,'Helena Rocha','helena.rocha@aluno.edu.br','Piracaia/SP','2025-08-06',TRUE),
(2025012,'Igor Santana','igor.santana@aluno.edu.br','Jarinu/SP','2025-08-07',TRUE);

INSERT INTO academico.disciplina VALUES
('ADS101','Banco de Dados',80,TRUE),
('ADS102','Engenharia de Software',80,TRUE),
('ADS103','Algoritmos',60,TRUE),
('ADS104','Redes de Computadores',60,TRUE),
('ADS105','Sistemas Operacionais',60,TRUE),
('ADS106','Estruturas de Dados',80,TRUE);

INSERT INTO academico.professor (nome) VALUES
('Prof. Carlos Mendes'),
('Profa. Juliana Castro'),
('Prof. Eduardo Pires'),
('Prof. Renato Alves'),
('Profa. Marina Lopes'),
('Prof. Ricardo Faria');

INSERT INTO academico.operador_pedagogico VALUES
('OP9001',TRUE),
('OP9002',TRUE),
('OP9003',TRUE),
('OP9004',TRUE),
('OP8999',TRUE),
('OP9000',TRUE);

INSERT INTO academico.turma (id_disciplina,id_professor,id_operador,ciclo) VALUES
('ADS101',1,'OP9001','2026/1'),
('ADS102',2,'OP9001','2026/1'),
('ADS105',3,'OP9001','2026/1'),
('ADS103',4,'OP9002','2026/1'),
('ADS104',5,'OP9002','2026/1'),
('ADS106',6,'OP9002','2026/1');

INSERT INTO academico.matricula (id_aluno,id_turma,nota) VALUES
(2026001,1,9.1),
(2026001,2,8.4),
(2026001,3,8.9),
(2026002,1,7.3);


CREATE ROLE professor_role;
CREATE ROLE coordenador_role;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academico TO coordenador_role;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA seguranca TO coordenador_role;

GRANT SELECT ON academico.matricula TO professor_role;
GRANT SELECT ON academico.aluno TO professor_role;
GRANT SELECT ON academico.disciplina TO professor_role;

GRANT UPDATE (nota) ON academico.matricula TO professor_role;

SELECT a.nome AS aluno, d.nome AS disciplina, t.ciclo
FROM academico.matricula m
JOIN academico.aluno a ON a.id_aluno = m.id_aluno
JOIN academico.turma t ON t.id_turma = m.id_turma
JOIN academico.disciplina d ON d.id_disciplina = t.id_disciplina
WHERE t.ciclo = '2026/1';

SELECT d.nome AS disciplina, AVG(m.nota) AS media
FROM academico.matricula m
JOIN academico.turma t ON t.id_turma = m.id_turma
JOIN academico.disciplina d ON d.id_disciplina = t.id_disciplina
GROUP BY d.nome
HAVING AVG(m.nota) < 6;

SELECT p.nome AS professor, d.nome AS disciplina
FROM academico.professor p
LEFT JOIN academico.turma t ON p.id_professor = t.id_professor
LEFT JOIN academico.disciplina d ON t.id_disciplina = d.id_disciplina;

SELECT a.nome AS aluno, m.nota
FROM academico.matricula m
JOIN academico.aluno a ON a.id_aluno = m.id_aluno
JOIN academico.turma t ON t.id_turma = m.id_turma
JOIN academico.disciplina d ON d.id_disciplina = t.id_disciplina
WHERE d.nome = 'Banco de Dados'
AND m.nota = (
    SELECT MAX(m2.nota)
    FROM academico.matricula m2
    JOIN academico.turma t2 ON t2.id_turma = m2.id_turma
    JOIN academico.disciplina d2 ON d2.id_disciplina = t2.id_disciplina
    WHERE d2.nome = 'Banco de Dados'
);