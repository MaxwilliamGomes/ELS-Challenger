
select
    funcionarioid,
    initcap(nome) as nome_funcionario,
    
    -- Lógica dos CPFs: Prefixo fixo '12345678' + (ID mod 99) preenchido com 2 dígitos.
    -- Isso garante que os nulos sigam a sequência 01, 02... 98, 00, 01...
    '12345678' || lpad((funcionarioid % 99)::text, 2, '0') as cpf_limpo,
    
    datanascimento::date as datanascimento,
    
    -- Mantendo a data de admissão original (apenas cast para date)
    dataadmissao::date as dataadmissao,
    
    empresaid,
    
    -- Limpezas básicas de integridade
    coalesce(cargoid, -1) as cargoid,
    coalesce(abs(salario), 0) as salario
    from {{ source('public', 'funcionarios') }}