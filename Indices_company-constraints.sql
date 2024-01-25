-- Desafio DIO
-- AVISO: O último cenário do desafio foi feito no primeiro sem querer. 
-- Então, modifiquei o último cenário para um novo contexto.
/*
	Qual o departamento com maior número de pessoas
    Quais os departamentos por cidade
    Relação entre salários de empregados e departamentos
*/
USE company_constraints;

-- Cria um índice que referencia o empregado ao seu departamento
/*
Optei pela indexação BTREE pois preciso de ordenação e agrupamento dos dados, além de uma busca
sustentável e escalonável
*/
CREATE INDEX relationship_employees_by_departament ON employee(Dno);
CREATE INDEX index_number_of_departament ON departament(Dnumber);

SELECT DISTINCT Dnumber AS Departament_Number, Dname AS Departament_Name, COUNT(*) OVER(PARTITION BY Dnumber) AS Employees
FROM employee, departament
WHERE employee.Dno = departament.Dnumber;

-- Cria um índice que mapeia os departamentos por cidade
/*
Optei pela indexação BTREE pois preciso de ordenação e agrupamento dos dados, além de uma busca
sustentável e escalonável
*/
CREATE INDEX relationship_number_of_departament_by_location ON dept_locations(Dnumber);
CREATE INDEX index_city_of_departament ON dept_locations(Dlocation);

SELECT DISTINCT COUNT(*) OVER(PARTITION BY Dlocation) AS Departaments, Dlocation as Localizacao_Departamento
FROM departament, dept_locations
WHERE departament.Dnumber = dept_locations.Dnumber;

-- Cria um índice que mapeia os departamentos com maiores salários
/*
Optei pela indexação BTREE pois preciso de ordenação e agrupamento dos dados, além de uma busca
sustentável e escalonável
*/
CREATE INDEX salary_index ON employee(Salary);

SELECT DISTINCT Dnumber AS Departament_Number, departament.Dname AS Departament_Name, SUM(Salary) as Total_Salary, COUNT(*) AS Number_Of_Employees
FROM employee, departament
WHERE departament.Dnumber = employee.Dno
GROUP BY Dname, Dnumber
ORDER BY Dnumber;
