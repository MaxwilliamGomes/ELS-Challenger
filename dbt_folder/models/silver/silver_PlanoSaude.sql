select
        planosaudeid,
        funcionarioid,
        -- Padronização para corrigir erros de digitação e variações
        case 
            -- Corrige "Intemedim" e mantém "Intermediario"
            when upper(unaccent(trim(nomeplano))) in ('INTERMEDIARIO', 'INTEMEDIM') then 'Intermediario'
            
            -- Garante o padrão para os outros
            when upper(unaccent(trim(nomeplano))) = 'BASICO' then 'Basico'
            when upper(unaccent(trim(nomeplano))) = 'PREMIUM' then 'Premium'
            
            -- Fallback para qualquer outro valor que apareça
            else initcap(unaccent(trim(nomeplano)))
        end as nomeplano_padronizado,
        
        coalesce(abs(valor), 0) as valor_plano
    from {{ source('public', 'plano_saude') }}