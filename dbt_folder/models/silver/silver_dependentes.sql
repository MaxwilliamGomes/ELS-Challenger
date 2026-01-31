select
        dependenteid,
        funcionarioid,
        initcap(nomedependente) as nomedependente,
        datanascimento,
        case 
            -- Captura FILHO, FILHA, FILHE (Ex: Filhe/36198)
            when upper(unaccent(trim(parentesco))) like 'FILH%' then 'FILHO'
            
            -- Captura variações de MÃE com barra e código (Ex: Mar/44418, Mainha/42929)
            when upper(unaccent(trim(parentesco))) like 'MAE%' 
                 or upper(unaccent(trim(parentesco))) like 'MAR%' 
                 or upper(unaccent(trim(parentesco))) like 'MAINH%' then 'MAE'
            
            -- Captura PAI (Ex: Pai/39717)
            when upper(unaccent(trim(parentesco))) like 'PAI%' then 'PAI'
            
            -- Captura CONJUGE (Ex: Conjuge/37880)
            when upper(unaccent(trim(parentesco))) like 'CONJ%' then 'CONJUGE'
            
            else 'OUTROS'
        end as parentesco_descricao
    from {{ source('public', 'dependentes') }}