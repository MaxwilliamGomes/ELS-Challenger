select
    f.funcionarioid,
    f.empresaid,
    f.salario as salario_base,
    sum(coalesce(ps.valor_plano, 0)) as custo_plano_saude
from {{ ref('silver_funcionarios') }} f
left join {{ ref('silver_PlanoSaude') }} ps on f.funcionarioid = ps.funcionarioid
group by f.funcionarioid,
         f.empresaid,
         f.salario