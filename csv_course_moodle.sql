

WITH disciplinas_cte(codigoModulo,nomeModulo,descricaoCurso,turma,duracao,ano,inicio,termino,codigo_grade)

AS (
	
	SELECT
	    DISTINCT(m.codigo_modulo),
	    m.nome_modulo fullname,
	    c.descricao_curso,
	    g.turma,
	    pt.duracao,
	    g.ano,
	    gm.inicio inicio,
	    gm.termino termino,
	    g.codigo_grade
	FROM
	    UsersPos.dbo.grade g
	    INNER JOIN UsersPos.dbo.grade_modulo gm
	        ON g.codigo_grade = gm.codigo_grade
	    INNER JOIN UsersPos.dbo.didatico d
	        ON g.codigo_grade = d.codigo_grade
	        AND gm.codigo_modulo = d.codigo_modulo
	    INNER JOIN Users.dbo.curso c
	        ON g.codigo_curso = c.codigo_curso
	    INNER JOIN UsersPos.dbo.modulo m
	        ON gm.codigo_modulo = m.codigo_modulo
	    LEFT OUTER JOIN UsersPos.dbo.CategoriaModulo ct
	        ON m.CodigoCategoria = ct.CodigoCategoria
	    INNER JOIN UsersPos.dbo.curso cc
	        ON g.codigo_curso = cc.codigo_curso
	    INNER JOIN UsersPos.dbo.projeto_turma pt
	        ON g.ano = pt.ano AND g.semestre = pt.semestre
	        AND cc.codigo_projeto = pt.codigo_projeto
	        AND g.codigo_turma = pt.codigo_turma
	    INNER JOIN UsersPos.dbo.modulo_projeto mp
	        ON g.ano = mp.ano
	        AND g.semestre = mp.semestre
	        AND cc.codigo_projeto = mp.codigo_projeto
	        AND gm.codigo_modulo = mp.codigo_modulo
	    INNER JOIN UsersPos.dbo.docente dc
	        ON mp.codigo_docente_responsavel = dc.codigo_docente
	    INNER JOIN UsersPos.dbo.projeto p
	        ON cc.codigo_projeto = p.codigo_projeto
	        AND g.ano = p.ano
	        AND g.semestre = p.semestre
	    INNER JOIN UsersPos.dbo.docente coord
	        ON p.codigo_coordenador = coord.codigo_docente
	    INNER JOIN UsersPos.dbo.aluno a
	        ON d.codigo_aluno = a.codigo_aluno                                                                                                                          
	WHERE
	    c.codigo_tipo_curso = 13
	    AND gm.inicio BETWEEN '2022-01-01' AND '2022-02-28'
	    AND a.codigo_situacao_aluno = 1  and d.aproveitamento = 0

)


SELECT
	DISTINCT(CONCAT(cte.codigoModulo,';',cte.duracao,';',REPLACE( CONVERT( varchar, cte.inicio, 103), '/', ''))) idnumber,
	CONCAT(SUBSTRING(CONCAT('Disciplina: ',cte.nomeModulo),1,65),CONCAT(' - [',CONVERT(varchar, cte.inicio, 3),'-',CONVERT(varchar, cte.termino, 3),']')) shortname,
	CONCAT('Disciplina: ',cte.nomeModulo,' - [',CONVERT(varchar, cte.inicio, 3),'-',CONVERT(varchar, cte.termino, 3),']') fullname,
    '' category,
	'0' visible,
	CONVERT( varchar, (cte.inicio-02), 104) startdate,
	CONVERT( varchar, (cte.termino+02), 104) enddate,
	'tiles' format,
	'pt_br' lang,
	'0' newsitems,
	'1' showgrades,
	'0' showreports,
	'0' legacyfiles,
	'1' enablecompletion,
	mc.shortname templatecourse
FROM
	disciplinas_cte cte
	INNER JOIN Moodle.dbo.mdl_course mc
		ON mc.idnumber = CONCAT('modelo;',cte.codigoModulo)
GROUP BY
    cte.codigoModulo,
    cte.nomeModulo,
    cte.descricaoCurso,
    cte.duracao,
    cte.inicio,
    cte.termino,
	mc.shortname