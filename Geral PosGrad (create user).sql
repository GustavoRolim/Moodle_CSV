DECLARE @Modalidade VARCHAR(2) = 12
USE Fac

SELECT  
	c.codigo_aluno AS username,
        lu.senhausuario AS password,
	SUBSTRING(c.nome,1,CHARINDEX(' ',c.nome)) AS firstname,
	SUBSTRING(c.nome, CHARINDEX(' ',c.nome)+1,LEN(c.nome))AS lastname,
	c.email,
        cidade_corresp AS city,
        'pt-br' AS lang,
        (SELECT  distinct CONCAT('TURMA ',a.turma,@Modalidade,' - CURSO: ',c.nome_curso))AS curso 
          FROM PosGrad.dbo.didatico d
		LEFT JOIN PosGrad.dbo.aluno a
			ON d.codigo_aluno = a.codigo_aluno
                        AND a.codigo_aluno = c.codigo_aluno
                INNER JOIN PosGrad.dbo.curso c
			ON c.codigo_curso = a.codigo_curso
                        AND nome_curso LIKE CONCAT('%',@Modalidade,'%')
        ) profile_field_Turma,
FROM    
	Grad.dbo.complemento c
        INNER JOIN Grad.dbo.login_usuario lu 
		ON c.codigo_aluno = lu.codigo
WHERE
	codigo_aluno = 2019336