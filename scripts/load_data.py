from sqlalchemy import create_engine
import pandas as pd

usuario = 'seu_usuario'
senha = 'sua_senha'
host = 'seu_host'
porta = 'sua_porta'
banco = 'nome_banco'

engine = create_engine(
    f'mysql+mysqlconnector://{usuario}:{senha}@{host}:{porta}/{banco}')

df = pd.read_csv(
    "amazon_products_sales_data_uncleaned.csv",
    on_bad_lines='skip',
    encoding='utf-8'
)

tabela = 'bronze_amazon_products'

# Envia para o MySQL
df.to_sql(name=tabela, con=engine, if_exists='replace', index=False)
