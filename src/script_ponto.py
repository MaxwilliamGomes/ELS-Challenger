import pdfplumber
import pandas as pd
import sys
import os

def extrair_dados_pdf():
    
    diretorio_base = r"C:\Users\PICHAU\Documents\ELS-Challenger\Base de Dados"
    
    
    if len(sys.argv) > 1:
        pdf_nome = sys.argv[1]
    else:
        pdf_nome = "Ponto.pdf"

    pdf_path = os.path.join(diretorio_base, pdf_nome)
    output_csv = os.path.join(diretorio_base, "saida_ponto.csv")
    
    # --- INÍCIO DA EXTRAÇÃO ---
    dados_finais = []
    colunas_cabecalho = ["PontoID", "FuncionarioID", "Data", "HoraEntrada", "HoraSaida"]

    print(f"Tentando abrir o arquivo: {pdf_path}")

    if not os.path.exists(pdf_path):
        print(f"ERRO: O arquivo {pdf_path} não foi encontrado!")
        sys.exit(1)

    try:
        with pdfplumber.open(pdf_path) as pdf:
            for i, pagina in enumerate(pdf.pages):
               
                tabela = pagina.extract_table()
                
                if tabela:
                   
                    if i == 0:
                        dados_finais.extend(tabela[1:])
                    else:
                        
                        dados_finais.extend(tabela[1:])
                
        # --- CRIAÇÃO DO DATAFRAME E SALVAMENTO ---
        if dados_finais:
           
            df = pd.DataFrame(dados_finais)
            
           
            df = df.iloc[:, 0:5] 
            df.columns = colunas_cabecalho

            
            df = df.dropna(how='all')

            
            df.to_csv(output_csv, index=False, sep=';', encoding='utf-8-sig')
            
            print(f"SUCESSO: Arquivo gerado com {len(df)} linhas.")
            print(f"Caminho do arquivo: {output_csv}")
        else:
            print("AVISO: Nenhuma tabela foi encontrada dentro do PDF.")

    except Exception as e:
        print(f"ERRO CRÍTICO: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    extrair_dados_pdf()