with cleaned_source as (
    select 
        *,
        -- Remove caracteres especiais do CNPJ para isolar apenas os números
        regexp_replace(cnpj, '[^0-9]', '', 'g') as cnpj_only_numbers
    from {{ source('public', 'empresa') }}
),

identificando_sequencia as (
    select 
        *,
        -- Extrai os últimos 5 dígitos como inteiro
        right(cnpj_only_numbers, 5)::int as cnpj_num,
        -- Cria grupos de preenchimento: o NULL herda o valor do último preenchido
        count(cnpj_only_numbers) over (order by empresaid) as grupo_preenchimento
    from cleaned_source
),

preenchendo_lacunas as (
    select
        *,
        -- Calcula o valor sequencial para os campos nulos
        first_value(cnpj_num) over (partition by grupo_preenchimento order by empresaid) 
        + (row_number() over (partition by grupo_preenchimento order by empresaid) - 1) as cnpj_num_final
    from identificando_sequencia
)

select
    empresaid,
    nomeempresa,
    -- Reconstrói o CNPJ com o prefixo fixo e o contador de 5 dígitos preenchido com zeros
    '12345678' || lpad(cnpj_num_final::text, 5, '0') as cnpj_limpo,
    -- Converte o timestamp original para o tipo DATE (AAAA-MM-DD)
    datafundacao::date as data_fundacao,
    -- Converte a flag de ativa para booleano
    case when ativa = 1 then true else false end as is_ativa
from preenchendo_lacunas