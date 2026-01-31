select
        ﻿cargoid as cargoid,
        nomecargo,
        abs(salariobase) as salariobase,
        -- Padronização pesada dos níveis
        case 
            -- Tratamento para JUNIOR
            when upper(unaccent(nivel)) in ('JUNIOR', 'JUN1OR') then 'JUNIOR'
            
            -- Tratamento para PLENO
            when upper(unaccent(nivel)) in ('PLENO', 'PIENO', 'PLENOR') then 'PLENO'
            
            -- Tratamento para SENIOR
            when upper(unaccent(nivel)) in ('SENIOR', 'SENIORA') then 'SENIOR'
            
            -- Tratamento para Lixo/Nulos/Placeholders
            when nivel is null or upper(unaccent(nivel)) in ('XXX', '-', 'NULL') then 'NAO INFORMADO'
            
            -- Caso apareça algo novo que não mapeamos, mantém o original limpo ou joga para 'OUTROS'
            else 'NAO INFORMADO'
        end as nivel_padronizado
    from {{ source('public', 'cargo') }}