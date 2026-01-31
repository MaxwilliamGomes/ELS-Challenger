with base_calculos as (
    select
        f.funcionarioid,
        f.nome_funcionario,
        f.cpf_limpo,
        f.datanascimento,
        f.dataadmissao,
        c.nomecargo,
        c.nivel_padronizado as nivel_cargo,
        -- Métrica descritiva de dependentes
        (select count(*) from {{ ref('silver_dependentes') }} d where d.funcionarioid = f.funcionarioid) as qtd_dependentes,
        
        -- Cálculo da Idade baseado na data máxima (2027-05-09)
        extract(year from age('2027-05-09'::date, f.datanascimento))::int as idade,
        
        -- Cálculo do Tempo de Empresa baseado na data máxima
        -- Usamos GREATEST para garantir que, se a admissão for futura (2030), o tempo seja 0 em vez de negativo
        greatest(0, extract(year from age('2027-05-09'::date, f.dataadmissao)))::int as tempo_empresa
    from {{ ref('silver_funcionarios') }} f
    left join {{ ref('silver_cargo') }} c on f.cargoid = c.cargoid
)

select
    *,
    -- Faixa Etária recalibrada com a nova idade
    case 
        when idade < 20 then 'Até 19 anos'
        when idade between 20 and 29 then '20 a 29 anos'
        when idade between 30 and 39 then '30 a 39 anos'
        when idade between 40 and 49 then '40 a 49 anos'
        when idade between 50 and 59 then '50 a 59 anos'
        else '60 anos ou mais'
    end as faixa_etaria
from base_calculos