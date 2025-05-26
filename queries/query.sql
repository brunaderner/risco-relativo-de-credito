#verificar os valores nulos da tabela user_info
SELECT 
 COUNT(*) AS total_linhas,
 COUNTIF(user_id IS NULL) AS nulos_user_id,
 COUNTIF(age IS NULL) AS nulos_age,
 COUNTIF(sex IS NULL) AS nulos_sex,
 COUNTIF(last_month_salary IS NULL) AS nulos_last_month_salary,
 COUNTIF(number_dependents IS NULL) AS nulos_number_dependents,

FROM `proj-03-458217.proj03lab.user_info`

#verificar os valores nulos da tabela loans_outstanding
SELECT 
 COUNT(*) AS total_linhas,
 COUNTIF(user_id IS NULL) AS nulos_user_id,
 COUNTIF(loan_id IS NULL) AS nulos_loan_id,
 COUNTIF(loan_type IS NULL) AS nulos_loan_type,

FROM `proj-03-458217.proj03lab.loans_outstanding`

#verificar os valores nulos da tabela loans_detail
SELECT 
 COUNT(*) AS total_linhas,
 COUNTIF(user_id IS NULL) AS nulos_user_id,
 COUNTIF(more_90_days_overdue IS NULL) AS nulos_more_90_days_overdue,
 COUNTIF(using_lines_not_secured_personal_assets IS NULL) AS nulos_using_lines_not_secured_personal_assets,
 COUNTIF(number_times_delayed_payment_loan_30_59_days IS NULL) AS nulos_number_times_delayed_payment_loan_30_59_days,
 COUNTIF(debt_ratio IS NULL) AS nulos_debt_ratio,
 COUNTIF(number_times_delayed_payment_loan_60_89_days IS NULL) AS nulos_number_times_delayed_payment_loan_60_89_days,

FROM `proj-03-458217.proj03lab.loans_detail`

#verificar os valores nulos da tabela default
SELECT 
 COUNT(*) AS total_linhas,
 COUNTIF(user_id IS NULL) AS nulos_user_id,
 COUNTIF(default_flag IS NULL) AS nulos_default_flag,

FROM `proj-03-458217.proj03lab.default`

#verificar os valores duplicados da tabela user_info
SELECT 
user_id,
 COUNT(*) as ocorrencias
FROM `proj-03-458217.proj03lab.user_info`
GROUP BY user_id
HAVING COUNT(*)>1
ORDER BY ocorrencias DESC

#verificar os valores duplicados da tabela loans_outstanding
SELECT 
user_id,
 COUNT(*) as ocorrencias
FROM `proj-03-458217.proj03lab.loans_outstanding`
GROUP BY user_id
HAVING COUNT(*)>1
ORDER BY ocorrencias DESC

#verificar os valores duplicados da tabela loans_detail
SELECT 
user_id,
 COUNT(*) as ocorrencias
FROM `proj-03-458217.proj03lab.loans_detail`
GROUP BY user_id
HAVING COUNT(*)>1
ORDER BY ocorrencias DESC

#verificar os valores duplicados da tabela default
SELECT 
user_id,
 COUNT(*) AS ocorrencias,
FROM `proj-03-458217.proj03lab.default`
GROUP BY user_id
HAVING COUNT(*)>1
ORDER BY ocorrencias DESC

#verificar media e mediana da tabela user_info para substituição de nulos
SELECT 
 avg(last_month_salary) as media,
FROM `proj-03-458217.proj03lab.user_info`
WHERE last_month_salary is not null

  #correlação more_90_days_overdue e number_times_delayed_payment_loan_30_59_days
SELECT
  CORR(more_90_days_overdue, number_times_delayed_payment_loan_30_59_days) AS correlacao
FROM
  `proj-03-458217.proj03lab.loans_detail` 

#correlação more_90_days_overdue e number_times_delayed_payment_loan_60_89_days
SELECT
  CORR(more_90_days_overdue, number_times_delayed_payment_loan_60_89_days) AS correlacao
FROM
  `proj-03-458217.proj03lab.loans_detail` 
  
  #calcular desvio padrão das variaveis para decidir qual manter
##more_90_days_overdue
  select
STDDEV(more_90_days_overdue)
from `proj-03-458217.proj03lab.loans_detail`

##number_times_delayed_payment_loan_60_89_days
select
STDDEV(number_times_delayed_payment_loan_60_89_days)
from `proj-03-458217.proj03lab.loans_detail`

##number_times_delayed_payment_loan_30_59_days
select
STDDEV(number_times_delayed_payment_loan_30_59_days)
from `proj-03-458217.proj03lab.loans_detail`

#buscando valores distintos
SELECT DISTINCT loan_type
FROM `proj-03-458217.proj03lab.loans_outstanding`

#alterando para todos minusculos
Create or replace table`proj-03-458217.proj03lab.loans_outstanding-1` AS
SELECT 
  user_id,
  loan_id,
  LOWER(TRIM(loan_type)) AS loan_type_padronizado
FROM `proj-03-458217.proj03lab.loans_outstanding`

#buscando valores distintos na tabela nova
SELECT DISTINCT loan_type_padronizado
FROM `proj-03-458217.proj03lab.loans_outstanding-1`

#alterando others
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.loans_outstanding-1` AS
SELECT 
  user_id,
  loan_id,
  CASE 
    WHEN LOWER(TRIM(loan_type_padronizado)) IN ('others', 'other') THEN 'other'
    WHEN LOWER(TRIM(loan_type_padronizado)) IN ('real estate') THEN 'real_state'
    ELSE 'desconhecido'
  END AS loan_type_padronizado
FROM `proj-03-458217.proj03lab.loans_outstanding-1`

#alterando o tipo do dado tabela user_info
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.user_info` AS
SELECT 
CAST(user_id AS STRING) AS user_id,
age,
sex,
last_month_salary,
number_dependents,
FROM `proj-03-458217.proj03lab.user_info`

#alterando a tabela loans_detail
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.loans_detail1` AS
SELECT 
  CAST(user_id AS STRING) AS user_id,
  CAST(more_90_days_overdue AS INT64) AS more_90_days_overdue,
  CAST(REPLACE(REPLACE(using_lines_not_secured_personal_assets, '.', ''), ',', '.') AS FLOAT64) AS using_lines_not_secured_personal_assets,
  CAST(number_times_delayed_payment_loan_30_59_days AS INT64) AS number_times_delayed_payment_loan_30_59_days,
  CAST(REPLACE(REPLACE(debt_ratio, '.', ''), ',', '.') AS FLOAT64) AS debt_ratio,
  CAST(number_times_delayed_payment_loan_60_89_days AS INT64) AS number_times_delayed_payment_loan_60_89_days
FROM `proj-03-458217.proj03lab.loans_detail`

#alterando o tipo do dado tabela default
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.default` AS
SELECT 
CAST(user_id AS STRING) AS user_id,
default_flag,
FROM `proj-03-458217.proj03lab.default`

#identificando outliers
SELECT
  MIN(last_month_salary) AS minimo,
  MAX(last_month_salary) AS maximo,
  AVG(last_month_salary) AS media,
  APPROX_QUANTILES(last_month_salary, 2)[OFFSET(1)] AS mediana
FROM `proj-03-458217.proj03lab.user_info`
WHERE last_month_salary IS NOT NULL

#Fazendo IQR
##Etapa 1: calcular Q1, Q3 e IQR
WITH quartis AS (
  SELECT 
    APPROX_QUANTILES(last_month_salary, 4) AS q
  FROM `proj-03-458217.proj03lab.user_info`
  WHERE last_month_salary IS NOT NULL
),

limites AS (
  SELECT 
    q[OFFSET(1)] AS q1,        -- 25%
    q[OFFSET(3)] AS q3,        -- 75%
    q[OFFSET(3)] - q[OFFSET(1)] AS iqr
  FROM quartis
)

##Etapa 2: identificar outliers fora do intervalo
SELECT 
  u.*
FROM 
  `proj-03-458217.proj03lab.user_info` u,
  limites
WHERE 
  last_month_salary IS NOT NULL
  AND (last_month_salary < q1 - 1.5 * iqr 
       OR last_month_salary > q3 + 1.5 * iqr)
,


#identificando caracteristicas de dependentes
SELECT
  MIN(number_dependents) AS minimo,
  MAX(number_dependents) AS maximo,
  AVG(number_dependents) AS media,
  APPROX_QUANTILES(number_dependents, 2)[OFFSET(1)] AS mediana
FROM `proj-03-458217.proj03lab.user_info`
WHERE number_dependents IS NOT NULL

#identificando caracteristicas de idade
SELECT
  MIN(age) AS minimo,
  MAX(age) AS maximo,
  AVG(age) AS media,
  APPROX_QUANTILES(age, 2)[OFFSET(1)] AS mediana
FROM `proj-03-458217.proj03lab.user_info`
WHERE age IS NOT NULL

#tratando nulos na coluna de salários substituindo para mediana, e criando nova variavel de classificação de dependentes e faixa etária
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.user_info1` AS
SELECT
  user_id,
  age,
  sex,
  COALESCE(last_month_salary, 5366) AS last_month_salary,
  number_dependents,

  -- Faixa de dependentes
  CASE
    WHEN number_dependents IS NULL THEN 'ausente'
    WHEN number_dependents < 1 THEN '0'
    WHEN number_dependents BETWEEN 1 AND 2 THEN '1-2'
    WHEN number_dependents BETWEEN 3 AND 4 THEN '3-4'
    WHEN number_dependents BETWEEN 5 AND 6 THEN '5-6'
    ELSE '7 ou mais'
  END AS faixa_dependentes,

  -- Faixa etária baseada na mediana = 52
  CASE
    WHEN age IS NULL THEN 'ausente'
    WHEN age < 30 THEN 'até 29'
    WHEN age BETWEEN 30 AND 44 THEN '30-44'
    WHEN age BETWEEN 45 AND 59 THEN '45-59'
    WHEN age BETWEEN 60 AND 74 THEN '60-74'
    ELSE '75 ou mais'
  END AS faixa_idade

FROM `proj-03-458217.proj03lab.user_info`

#criando variaveis agrupando loan_type e qtd de emprestimos
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.loans_user_summary` AS
SELECT
  user_id,
  COUNT(loan_id) AS total_emprestimos,
  SUM(CASE WHEN loan_type = 'real_estate' THEN 1 ELSE 0 END) AS qtde_real_estate,
  SUM(CASE WHEN loan_type = 'other' THEN 1 ELSE 0 END) AS qtde_other
FROM `proj-03-458217.proj03lab.loans_outstanding`
GROUP BY user_id

#união das tabelas
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
SELECT
  u.user_id,
  u.last_month_salary,
  u.age,
  u.faixa_idade,
  u.number_dependents,
  u.faixa_dependentes,
  d.more_90_days_overdue,
  d.using_lines_not_secured_personal_assets,
  d.debt_ratio,
  f.default_flag,
  o.total_emprestimos,
  o.qtde_real_estate,
  o.qtde_other
FROM `proj-03-458217.proj03lab.user_info1` u
inner JOIN `proj-03-458217.proj03lab.loans_outstanding-2` o ON CAST(u.user_id AS STRING) = CAST(o.user_id AS STRING)
inner JOIN `proj-03-458217.proj03lab.loans_detail_corrigida` d ON CAST(u.user_id AS STRING) = CAST(d.user_id AS STRING)
inner JOIN `proj-03-458217.proj03lab.default` f ON CAST(u.user_id AS STRING) = CAST(f.user_id AS STRING)

#correlação entre variáveis 
##debt_ratio e using_lines_not_secured_personal_assets
SELECT
  CORR(debt_ratio, using_lines_not_secured_personal_assets) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise`
  
 ##default_flag e using_lines_not_secured_personal_assets
 SELECT
  CORR(default_flag, using_lines_not_secured_personal_assets) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 
 
 ##default_flag e more_90_days_overdue
  SELECT
  CORR(default_flag, more_90_days_overdue) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 
  
  ##default_flag, last_month_salary
SELECT 
  CORR(default_flag, last_month_salary) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 

##default_flag, total_emprestimos
SELECT
  CORR(default_flag, total_emprestimos) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 
  
  ##last_month_salary, total_emprestimos
  SELECT
  CORR(last_month_salary, total_emprestimos) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 

##last_month_salary, debt_ratio
SELECT
  CORR(last_month_salary, debt_ratio) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 
  
  
 ##qtde_other, qtde_real_estate
SELECT
  CORR(qtde_other, qtde_real_estate) AS correlacao
FROM
  `proj-03-458217.proj03lab.analise` 
  
  
  #quartil salários
  WITH salario_quartis AS (
  SELECT 
    user_id,
    last_month_salary,
    NTILE(4) OVER (ORDER BY last_month_salary) AS quartil_salario
  FROM `proj-03-458217.proj03lab.analise`
  WHERE last_month_salary IS NOT NULL
)

SELECT 
  quartil_salario,
  COUNT(*) AS qtd_usuarios,
  MIN(last_month_salary) AS salario_min,
  MAX(last_month_salary) AS salario_max,
  AVG(last_month_salary) AS media_salario
FROM salario_quartis
GROUP BY quartil_salario
ORDER BY quartil_salario;

#adicionando a tabela analise 
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
SELECT 
  *,
  NTILE(4) OVER (ORDER BY last_month_salary) AS quartil_salario
FROM `proj-03-458217.proj03lab.analise`
WHERE last_month_salary IS NOT NULL;


#quartil das demais variaveis
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
SELECT 
  *,
NTILE(4) OVER (ORDER BY age) AS quartil_age,
 NTILE(4) OVER (ORDER BY debt_ratio) AS quartil_debt_ratio,
    NTILE(4) OVER (ORDER BY using_lines_not_secured_personal_assets) AS quartil_using_lines_not_secured_personal_assets,
    NTILE(4) OVER (ORDER BY total_emprestimos) AS quartil_total_emprestimos,
    NTILE(4) OVER (ORDER BY more_90_days_overdue) AS quartil_more_90_days_overdue
  FROM `proj-03-458217.proj03lab.analise`
  WHERE last_month_salary IS NOT NULL
 
  #quartis de idade
  WITH idade_quartis AS (
  SELECT 
    user_id,
    age,
    NTILE(4) OVER (ORDER BY age) AS quartil_age
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE age IS NOT NULL
)

SELECT 
  quartil_age,
  COUNT(*) AS qtd_usuarios,
  MIN(age) AS idade_min,
  MAX(age) AS idade_max,
  AVG(age) AS media_idade
FROM idade_quartis
GROUP BY quartil_age
ORDER BY quartil_age;

  #calculei quartil pra idade
 
###calculando risco relativo de idade
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
WITH base AS (
  SELECT
    quartil_age AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_age IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
),
risco_idade AS (
  SELECT
    c.grupo AS quartil_age,
    SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
    SAFE_DIVIDE(
      SAFE_DIVIDE(c.inadimplentes, c.total),
      SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
    ) AS risco_relativo_idade
  FROM contagem c
  CROSS JOIN media_geral m
)
SELECT 
  a.*,
  r.risco_relativo_idade
FROM `proj-03-458217.proj03lab.analise` a
LEFT JOIN risco_idade r
  ON a.quartil_age = r.quartil_age;
  
  #identificando os quartis de salário
  WITH salarios_quartis AS (
  SELECT 
    user_id,
    last_month_salary,
    NTILE(4) OVER (ORDER BY last_month_salary) AS quartil_salario
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE last_month_salary IS NOT NULL
)

SELECT 
  quartil_salario,
  COUNT(*) AS qtd_usuarios,
  MIN(last_month_salary) AS salario_min,
  MAX(last_month_salary) AS salario_max,
  AVG(last_month_salary) AS media_salario
FROM salarios_quartis
GROUP BY quartil_salario
ORDER BY quartil_salario;

  
  ##visualizando o risco relativo de salário
  WITH dados AS (
  SELECT
    last_month_salary
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE last_month_salary IS NOT NULL
)
SELECT
  APPROX_QUANTILES(last_month_salary, 4)[OFFSET(1)] AS Q1,
  APPROX_QUANTILES(last_month_salary, 4)[OFFSET(2)] AS Q2_mediana,
  APPROX_QUANTILES(last_month_salary, 4)[OFFSET(3)] AS Q3,
  MIN(last_month_salary) AS minimo,
  MAX(last_month_salary) AS maximo
FROM dados;


###calculando risco relativo de salário
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
WITH base AS (
  SELECT
    quartil_salario AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_salario IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
),
risco_salario AS (
  SELECT
    c.grupo AS quartil_salario,
    SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
    SAFE_DIVIDE(
      SAFE_DIVIDE(c.inadimplentes, c.total),
      SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
    ) AS risco_relativo_salario
  FROM contagem c
  CROSS JOIN media_geral m
)
SELECT 
  a.*,
  r.risco_relativo_salario
FROM `proj-03-458217.proj03lab.analise` a
LEFT JOIN risco_salario r
  ON a.quartil_salario = r.quartil_salario;
  


#identificando os quartis de emprestimos
WITH total_emprestimos_quartis AS (
  SELECT 
    user_id,
    total_emprestimos,
    NTILE(4) OVER (ORDER BY total_emprestimos) AS quartil_total_emprestimos
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE total_emprestimos IS NOT NULL
)

SELECT 
  quartil_total_emprestimos,
  COUNT(*) AS qtd_usuarios,
  MIN(total_emprestimos) AS total_emprestimos_min,
  MAX(total_emprestimos) AS total_emprestimos_max,
  AVG(total_emprestimos) AS media_total_emprestimos
FROM total_emprestimos_quartis
GROUP BY quartil_total_emprestimos
ORDER BY quartil_total_emprestimos;

##calculando risco relativo emprestimos por quartil
WITH base AS (
  SELECT
    quartil_total_emprestimos AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE quartil_total_emprestimos IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
)

SELECT
  c.grupo AS quartil_total_emprestimos,
  c.total,
  c.inadimplentes,
  SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
  SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
  SAFE_DIVIDE(
    SAFE_DIVIDE(c.inadimplentes, c.total),
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
  ) AS risco_relativo
FROM contagem c
CROSS JOIN media_geral m
ORDER BY risco_relativo DESC;

### Calculando risco relativo de empréstimos e colocando na tabela 
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
WITH base AS (
  SELECT
    quartil_total_emprestimos AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_total_emprestimos IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
),
risco_emprestimos AS (
  SELECT
    c.grupo AS quartil_total_emprestimos,
    SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
    SAFE_DIVIDE(
      SAFE_DIVIDE(c.inadimplentes, c.total),
      SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
    ) AS risco_relativo_total_emprestimos
  FROM contagem c
  CROSS JOIN media_geral m
)
SELECT 
  a.*,
  r.risco_relativo_total_emprestimos
FROM `proj-03-458217.proj03lab.analise` a
LEFT JOIN risco_emprestimos r
  ON a.quartil_total_emprestimos = r.quartil_total_emprestimos;
  
  
  #visualizando os quartis de debt ratio
  WITH debt_ratio_quartis AS (
  SELECT 
    user_id,
    debt_ratio,
    NTILE(4) OVER (ORDER BY debt_ratio) AS quartil_debt_ratio
  FROM `proj-03-458217.proj03lab.analise`
  WHERE debt_ratio IS NOT NULL
)

SELECT 
  quartil_debt_ratio,
  COUNT(*) AS qtd_usuarios,
  MIN(debt_ratio) AS debt_ratio_min,
  MAX(debt_ratio) AS debt_ratio_max,
  AVG(debt_ratio) AS media_debt_ratio
FROM debt_ratio_quartis
GROUP BY quartil_debt_ratio
ORDER BY quartil_debt_ratio;

## calculando risco relativo por quartil
WITH base AS (
  SELECT
    quartil_debt_ratio AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE quartil_debt_ratio IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
)

SELECT
  c.grupo AS quartil_debt_ratio,
  c.total,
  c.inadimplentes,
  SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
  SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
  SAFE_DIVIDE(
    SAFE_DIVIDE(c.inadimplentes, c.total),
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
  ) AS risco_relativo
FROM contagem c
CROSS JOIN media_geral m
ORDER BY risco_relativo DESC;

#adicionando risco relativo de debt na tabela
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
WITH base AS (
  SELECT
    quartil_debt_ratio AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_debt_ratio IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
),
risco_debt AS (
  SELECT
    c.grupo AS quartil_debt_ratio,
    SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
    SAFE_DIVIDE(
      SAFE_DIVIDE(c.inadimplentes, c.total),
      SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
    ) AS risco_relativo_debt_ratio
  FROM contagem c
  CROSS JOIN media_geral m
)
SELECT 
  a.*,
  r.risco_relativo_debt_ratio
FROM `proj-03-458217.proj03lab.analise` a
LEFT JOIN risco_debt r
  ON a.quartil_debt_ratio = r.quartil_debt_ratio;

#visuzalizando os quartis de 90 dias
WITH more_90_days_overdue_quartis AS (
  SELECT 
    user_id,
    more_90_days_overdue,
    NTILE(4) OVER (ORDER BY more_90_days_overdue) AS quartil_more_90_days_overdue
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE more_90_days_overdue IS NOT NULL
)

SELECT 
  quartil_more_90_days_overdue,
  COUNT(*) AS qtd_usuarios,
  MIN(more_90_days_overdue) AS minimo,
  MAX(more_90_days_overdue) AS maximo,
  AVG(more_90_days_overdue) AS media
FROM more_90_days_overdue_quartis
GROUP BY quartil_more_90_days_overdue
ORDER BY quartil_more_90_days_overdue;

##calculando risco relativo e 90 dias por quartis
WITH base AS (
  SELECT
    quartil_more_90_days_overdue AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE quartil_more_90_days_overdue IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
)

SELECT
  c.grupo AS quartil_more_90_days_overdue,
  c.total,
  c.inadimplentes,
  SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
  SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
  SAFE_DIVIDE(
    SAFE_DIVIDE(c.inadimplentes, c.total),
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
  ) AS risco_relativo
FROM contagem c
CROSS JOIN media_geral m
ORDER BY risco_relativo DESC;

###criando risco relativo de 90 dias
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
WITH base AS (
  SELECT
    quartil_more_90_days_overdue AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_more_90_days_overdue IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
),
risco_more_90_days_overdue AS (
  SELECT
    c.grupo AS quartil_more_90_days_overdue,
    SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
    SAFE_DIVIDE(
      SAFE_DIVIDE(c.inadimplentes, c.total),
      SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
    ) AS risco_relativo_more_90_days_overdue
  FROM contagem c
  CROSS JOIN media_geral m
)
SELECT 
  a.*,
  r.risco_relativo_more_90_days_overdue
FROM `proj-03-458217.proj03lab.analise` a
LEFT JOIN risco_more_90_days_overdue r
  ON a.quartil_more_90_days_overdue = r.quartil_more_90_days_overdue;

#visualizando os quartis de using_lines_not_secured_personal_assets
WITH using_lines_not_secured_personal_assets_quartis AS (
  SELECT 
    user_id,
   using_lines_not_secured_personal_assets,
    NTILE(4) OVER (ORDER BY using_lines_not_secured_personal_assets) AS quartil_using_lines_not_secured_personal_assets
  FROM `proj-03-458217.proj03lab.analise`
  WHERE using_lines_not_secured_personal_assets IS NOT NULL
)

SELECT 
  quartil_using_lines_not_secured_personal_assets,
  COUNT(*) AS qtd_usuarios,
  MIN(using_lines_not_secured_personal_assets) AS minimo,
  MAX(using_lines_not_secured_personal_assets) AS maximo,
  AVG(using_lines_not_secured_personal_assets) AS media
FROM using_lines_not_secured_personal_assets_quartis
GROUP BY quartil_using_lines_not_secured_personal_assets
ORDER BY quartil_using_lines_not_secured_personal_assets;

##calculando risco relativo por quartil
WITH base AS (
  SELECT
    quartil_using_lines_not_secured_personal_assets AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_using_lines_not_secured_personal_assets IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
)

SELECT
  c.grupo AS quartil_using_lines_not_secured_personal_assets,
  c.total,
  c.inadimplentes,
  SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
  SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
  SAFE_DIVIDE(
    SAFE_DIVIDE(c.inadimplentes, c.total),
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
  ) AS risco_relativo
FROM contagem c
CROSS JOIN media_geral m
ORDER BY risco_relativo DESC;

### criando risco relativo de using_lines_not_secured_personal_assets
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
WITH base AS (
  SELECT
    quartil_using_lines_not_secured_personal_assets AS grupo,
    default_flag
  FROM `proj-03-458217.proj03lab.analise`
  WHERE quartil_using_lines_not_secured_personal_assets IS NOT NULL
),
contagem AS (
  SELECT
    grupo,
    COUNT(*) AS total,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes
  FROM base
  GROUP BY grupo
),
media_geral AS (
  SELECT
    COUNT(*) AS total_geral,
    SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM base
),
risco_using_lines_not_secured_personal_assets AS (
  SELECT
    c.grupo AS quartil_using_lines_not_secured_personal_assets,
    SAFE_DIVIDE(c.inadimplentes, c.total) AS taxa_quartil,
    SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral) AS taxa_geral,
    SAFE_DIVIDE(
      SAFE_DIVIDE(c.inadimplentes, c.total),
      SAFE_DIVIDE(m.inadimplentes_geral, m.total_geral)
    ) AS risco_relativo_using_lines_not_secured_personal_assets
  FROM contagem c
  CROSS JOIN media_geral m
)
SELECT 
  a.*,
  r.risco_relativo_using_lines_not_secured_personal_assets
FROM `proj-03-458217.proj03lab.analise` a
LEFT JOIN risco_using_lines_not_secured_personal_assets r
  ON a.quartil_using_lines_not_secured_personal_assets = r.quartil_using_lines_not_secured_personal_assets;



### corrigindo cagadas
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise1` AS
SELECT
  user_id,
  last_month_salary,
  number_dependents,
  faixa_dependentes,
  age,
  faixa_idade,
  more_90_days_overdue,
  using_lines_not_secured_personal_assets,
  debt_ratio,
  default_flag,
  total_emprestimos,
  qtde_real_estate,
  qtde_other,
  quartil_salario
  quartil_debt_ratio,
  quartil_using_lines_not_secured_personal_assets,
  quartil_total_emprestimos,
  quartil_more_90_days_overdue,
  quartil_age,
  risco_relativo_idade,
  risco_relativo_emprestimos,
  risco_relativo_debt_ratio,
  risco_relativo_more_90_days_overdue,
  risco_relativo_using_lines_not_secured_personal_assets,

FROM `proj-03-458217.proj03lab.analise1`
WHERE last_month_salary < 1560100


CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise1` AS
SELECT 
  *,
 NTILE(4) OVER (ORDER BY last_month_salary) AS quartil_salario,
  FROM `proj-03-458217.proj03lab.analise1`
  WHERE last_month_salary IS NOT NULL
  
  
   ###### Dummys por variavel 
  CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
SELECT
  *,
  
  CASE WHEN quartil_age = 1 THEN 1 ELSE 0 END AS dummy_idade_risco,
  CASE WHEN quartil_salario = 1 THEN 1 ELSE 0 END AS dummy_salario_risco,
  CASE WHEN quartil_total_emprestimos = 1 THEN 1 ELSE 0 END AS dummy_emprestimos_risco,
  CASE WHEN quartil_debt_ratio = 3 THEN 1 ELSE 0 END AS dummy_debt_ratio_risco,
  CASE WHEN quartil_more_90_days_overdue = 4 THEN 1 ELSE 0 END AS dummy_90dias_risco,
  CASE WHEN quartil_using_lines_not_secured_personal_assets = 4 THEN 1 ELSE 0 END AS dummy_linhas_credito_risco

FROM `proj-03-458217.proj03lab.analise`;



## somando elas
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise` AS
SELECT
  *,
  (
    dummy_idade_risco +
    dummy_salario_risco +
    dummy_90dias_risco +
    dummy_linhas_credito_risco
  ) AS score_risco_total
FROM `proj-03-458217.proj03lab.analise`;

## colocando classificação de bom e mau pagador
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise_final` AS
SELECT
  *,
  CASE
    WHEN previsao_inadimplente = 1 THEN 'Mau Pagador'
    ELSE 'Bom Pagador'
  END AS classificacao_pagador
FROM `proj-03-458217.proj03lab.analise_final`

## FAIXAS DE SALARIO
CREATE OR REPLACE TABLE `proj-03-458217.proj03lab.analise_final` AS
SELECT *,
CASE
  WHEN last_month_salary < 2000 THEN 'Até R$2.000'
  WHEN last_month_salary < 4000 THEN 'R$2.001 a R$4.000'
  WHEN last_month_salary < 6000 THEN 'R$4.001 a R$6.000'
  WHEN last_month_salary < 10000 THEN 'R$6.001 a R$10.000'
  ELSE 'Acima de R$10.000'
END AS faixa_salarial

FROM `proj-03-458217.proj03lab.analise_final`

