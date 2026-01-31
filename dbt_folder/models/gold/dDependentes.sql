select
    dependenteid,
    funcionarioid, 
    nomedependente,
    parentesco_descricao 
from {{ ref('silver_dependentes') }}