select
    empresaid,
    nomeempresa,
    cnpj_limpo,
    data_fundacao,
    is_ativa
from {{ ref('silver_empresas') }}