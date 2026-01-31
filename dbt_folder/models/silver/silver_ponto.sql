with cleaned as (
    select
        ﻿pontoid as pontoid,
        funcionarioid,
        -- 1. Converte a coluna "Data" para o tipo DATE
        "Data"::date as data_registro, 
        
        -- 2. Valida e converte horaentrada para o tipo TIME (HH:MM:SS)
        case 
            when horaentrada ~ '^([01][0-9]|2[0-3]):[0-5][0-9]$' 
            then horaentrada::time 
            else null 
        end as horaentrada_limpa,

        -- 3. Valida e converte horasaida para o tipo TIME (HH:MM:SS)
        case 
            when horasaida ~ '^([01][0-9]|2[0-3]):[0-5][0-9]$' 
            then horasaida::time 
            else null 
        end as horasaida_limpa
    from {{ source('public', 'ponto') }}
)
select 
        *,
        -- Cálculo da jornada em horas (apenas se ambos forem válidos)
    case 
            when horaentrada_limpa is not null and horasaida_limpa is not null 
            then (horasaida_limpa::time - horaentrada_limpa::time)
            else null 
    end as jornada_duracao
from cleaned