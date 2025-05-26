# Análise de Risco Relativo de Crédito (Banco Super Caja)

Este repositório reúne todo o pipeline de análise de risco relativo de crédito desenvolvido para o Banco Super Caja — da ingestão de dados à modelagem preditiva, dashboards interativos e slides de apresentação.

## Objetivo

Identificar os principais fatores que explicam o risco de inadimplência na carteira de crédito e automatizar a pontuação de risco para aprimorar a tomada de decisão, reduzindo atrasos e perdas financeiras.

## Tecnologias & Ambiente

- **Linguagens:** SQL (BigQuery), Python  
- **Ferramentas:**  
  - **BigQuery** (armazenamento e preparação de dados)  
  - **Google Colab** (análises e modelagem)  
  - **Looker Studio** (dashboards interativos)  
  - **Google Slides** (apresentação)  
  - **Loom** (vídeo de apresentação)  
- **Principais bibliotecas Python:** pandas, NumPy, scikit-learn, matplotlib, seaborn, statsmodels

## Estrutura do Repositório
- `dados-primarios/`: Dados brutos fornecidos inicialmente para a análise
- `dataset/`: Arquivos processados e prontos para exploração
- `notebooks/`: Análises em Python no Google Colab
- `ficha-técnica/`: Documentação do projeto (.pdf)
- `presentation/`: Apresentação final com os principais resultados (.pdf)
- `queries/`: Consultas SQL aplicadas no Google BigQuery

## Arquivos Principais
- [Notebook com pipeline completo, testes estatísticos e modelo preditivo (Google Colab)](notebooks/bruna-derner-colab.3.ipynb)  
- [Dashboard Interativo (Looker Studio)](https://lookerstudio.google.com/reporting/acb7b497-ba2c-485b-bbcf-c640a76cacb3)  
- [Apresentação Final (PDF)](presentation/bd-bruna-derner-03.pdf)  
- [Consultas SQL (BigQuery)](queries/query.sql)  
- [Ficha Técnica](ficha-técnica/bd-bruna-derner-fichatec.03.pdf)  

## Metodologia

1. **Ingestão & limpeza**  
   - Importação de CSVs para BigQuery; tratamento de nulos e duplicatas; padronização de categorias; remoção de outliers em salários.  
2. **Criação de variáveis**  
   - Quartis de idade, salário, endividamento e uso de linhas não garantidas; dummies para os grupos de maior risco; cálculo do `score_risco_total`.  
3. **Dashboard**  
   - Looker Studio com filtros por inadimplência, age, salary, atraso e uso de crédito; KPIs e gráficos de distribuição.  
4. **Modelagem**  
   - **Regressão Logística** com `class_weight='balanced'` (score contínuo e dummies); **XGBoost**; **Decision Tree**.  
5. **Avaliação**  
   - Métricas: acurácia (~93 %), AUC-ROC (≈ 0,95), recall (87 % para inadimplentes), precision (19 % para sinalizações de risco).  
   - Confusion matrix e curvas ROC para comparar performance e trade-offs.

## Principais Resultados

- **Concentração de risco:**  
  - 85 % dos casos de inadimplência estão em clientes com 3–5 atrasos ou uso estourado de limite.  
  - Baixa renda: up to 57 % mais risco que a média.  
  - Jovens (≤ 29 anos): ~15 % de probabilidade de inadimplir.

- **Modelos preditivos:**  
  - Regressão Logística: AUC ≈ 0,95; recall ≈ 87 %; precision ≈ 19 %.  
  - XGBoost e Decision Tree obtiveram AUC ≈ 0,96 e ≈ 0,95, respectivamente, mas com volume similar de falsos-positivos.

## Recomendações

1. **Priorizar top 10 %** dos scores para revisões manuais (atrasos + uso estourado).  
2. **Ajustar threshold** para reduzir sinalizações indevidas sem perder cobertura de risco.  
3. **Políticas customizadas** de limite/garantia para perfis vulneráveis (jovens, baixa renda).  
4. **Monitoramento contínuo**: revisar métricas mensalmente e refinar parâmetros.

## Vídeo de Apresentação

Assista à apresentação completa:

[![Assista ao vídeo no Loom](https://img.shields.io/badge/Ver%20Apresentação-Loom-%23F9C646?style=for-the-badge&logo=loom)](https://www.loom.com/share/8afd71618bf04d9db5f45ffaece0d965?sid=2897f8bd-6443-4c80-812b-7764d481a894)


## Autora

Bruna Derner  
Economista e Analista de Dados  
[LinkedIn](https://www.linkedin.com/in/bruna-derner/)
