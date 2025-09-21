# ETL de Produtos Amazon

## 1. Introdução

O objetivo deste projeto é construir um pipeline de ETL para transformar dados brutos de produtos da Amazon em informações confiáveis e prontas para análise.
O projeto envolve três etapas principais:

- Bronze (dados crus): ingestão e verificação dos dados originais.

- Silver (limpeza e transformação): padronização, conversão de tipos e cálculos de métricas.

- Visualização via view: criação de uma visão analítica para facilitar consultas e relatórios.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 2. Bronze Verificação de Dados

A camada Bronze contém os dados originais. Antes de qualquer análise, realizamos verificações e ajustes:

- **Quantidade de linhas**: verificação do volume do dataset.

- **Preços**: criação da coluna listed_price priorizando listed_price, depois current_discounted_price e, por fim, price_on_variant. Valores convertidos de texto para decimal.

- **Ratings e reviews**: extração apenas dos números de rating e remoção de vírgulas em number_of_reviews.

- **Compras no último mês**: transformação de valores com "K" em milhares e conversão para inteiros.

- **Delivery details**: padronização de datas para o formato yyyy-mm-dd.

- **Colunas categóricas**: limpeza de espaços em branco nas colunas is_best_seller, is_sponsored, is_couponed, buy_box_availability e sustainability_badges.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 3. Silver: Limpeza e Transformação

Na camada Silver, aplicamos todas as transformações necessárias para análise:

- Conversão de preços, ratings e reviews em tipos numéricos.

- Cálculo de listed_price com prioridade entre colunas de preço.

- Conversão de datas de entrega para tipo DATE.

- Padronização de valores categóricos.

- Inserção de todos os dados transformados na tabela silver_amazon_products.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 4. View Analítica

Para facilitar análises e dashboards, criamos a view vw_amazon_products_analysis:

- Seleção das principais informações de produtos, incluindo nome, preço original, preço com desconto, rating, reviews, compras no último mês, tags de sustentabilidade, disponibilidade de cupom e buy box.

- Cálculo do percentual de desconto para cada produto.

- Integração com a tabela amazon_products_sales para incluir a categoria de produto.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------

## 5. Conclusão

O pipeline ETL criado neste projeto:

Garantiu a qualidade e confiabilidade dos dados brutos.

Transformou dados inconsistentes em informações estruturadas e limpas.

Permitiu análises precisas sobre preços, descontos, vendas e popularidade dos produtos.

