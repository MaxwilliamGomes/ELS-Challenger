import pandas as pd
import io
import requests

url = "https://docs.google.com/spreadsheets/d/1mceJWzaezjviyQA38ghP3RTtChEKNa71HgqjRtyqSyI/export?format=csv"

def extrair_e_limpar_dados():
    try:
        response = requests.get(url)
        
        content = response.content.decode('utf-8-sig')
        
        # Lemos como string para não perder os dados sujos
        df = pd.read_csv(io.StringIO(content), dtype=str)

        # 1. Limpeza de Typos na DataFundacao
        df['DataFundacao'] = df['DataFundacao'].str.replace('1o', '10')
        df['DataFundacao'] = df['DataFundacao'].str.replace('oo:oo', '00:00')
        df['DataFundacao'] = df['DataFundacao'].str.replace('..', ':')
        df['DataFundacao'] = df['DataFundacao'].str.replace(';', ':')
        df['DataFundacao'] = df['DataFundacao'].str.replace('*', '', regex=False)
        
        # 2. Padronização do Formato da Data (Converte tudo para YYYY-MM-DD HH:mm:ss)
        
        df['DataFundacao'] = pd.to_datetime(df['DataFundacao'], dayfirst=True, errors='coerce')
        
        # 3. Limpeza do campo Ativa
        df['Ativa'] = df['Ativa'].str.replace('I', '0').str.replace('o', '0')
        df['Ativa'] = df['Ativa'].fillna('0') # Onde estiver vazio, assume inativa
        
        # 4. Salvar CSV Limpo
        df.to_csv("Empresa_Limpo.csv", index=False, encoding='utf-8')
        print("Arquivo Empresa_Limpo.csv gerado com sucesso e dados padronizados!")

    except Exception as e:
        print(f"Erro: {e}")

if __name__ == "__main__":
    extrair_e_limpar_dados()