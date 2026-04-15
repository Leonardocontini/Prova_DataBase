Um SGBD relacional como PostgreSQL é mais adequado porque garante as propriedades ACID, essenciais para manter a integridade dos dados. Isso assegura que operações sejam completas (atomicidade), válidas (consistência com PK/FK), seguras em acessos simultâneos (isolamento) e permanentes (durabilidade). Em um sistema acadêmico, onde há relações entre alunos, disciplinas e notas, isso evita inconsistências e perda de dados, algo que NoSQL não prioriza.

Organização:
O uso de schemas (como academico e seguranca) melhora a organização, separa responsabilidades, facilita manutenção e permite controle de acesso mais seguro. Diferente do uso apenas do public, evita confusão, conflitos de nomes e melhora a governança do banco.
--------------------------------------------------------------------------------------------------------------
Isolamento: garante que uma transação não atrapalhe outra quando estão rodando ao mesmo tempo.

Locks: são “travas” que o banco usa para impedir que duas pessoas alterem o mesmo dado simultaneamente.

Concorrência de updates: quando duas alterações acontecem ao mesmo tempo na mesma nota, o banco organiza a ordem para evitar conflito.

Lost update: acontece quando uma alteração sobrescreve a outra sem controle; o banco evita isso usando isolamento e locks.

--------------------------------------------------------------------------------------------------------------

Modelo Lógico (Normalização)

**ALUNO**
- id_aluno (PK)
- nome
- email
- endereco
- data_ingresso
- ativo

**PROFESSOR**
- id_professor (PK)
- nome
- ativo

**DISCIPLINA**
- id_disciplina (PK)
- nome
- carga_h
- ativo

**OPERADOR_PEDAGOGICO**
- id_operador (PK)
- ativo

**TURMA**
- id_turma (PK)
- id_disciplina (FK)
- id_professor (FK)
- id_operador (FK)
- ciclo
- ativo

**MATRICULA**
- id_matricula (PK)
- id_aluno (FK)
- id_turma (FK)
- nota
- ativo

