select
    p.pontoid,
    p.funcionarioid,
    p.data_registro as data_id, 
    p.horaentrada_limpa,
    p.horasaida_limpa,
    p.jornada_duracao,
    extract(epoch from p.jornada_duracao) / 3600 as horas_trabalhadas_decimal,
    
        CASE 
            WHEN p.horaentrada_limpa IS NULL AND p.horasaida_limpa IS NULL 
            THEN TRUE 
            ELSE FALSE 
        END AS flag_ausencia,
        
        CASE 
            WHEN (p.horaentrada_limpa IS NULL AND p.horasaida_limpa IS NOT NULL)
              OR (p.horaentrada_limpa IS NOT NULL AND p.horasaida_limpa IS NULL)
            THEN TRUE 
            ELSE FALSE 
        END AS flag_registro_incompleto
from {{ ref('silver_ponto') }} p