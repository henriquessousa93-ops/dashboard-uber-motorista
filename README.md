# dashboard-uber-motorista
Dashboard em Power BI para análise de ganhos, corridas, transferências e taxas de um motorista Uber, com dados extraídos de PDFs e tratados no Power Query.

## 🎥 Preview

![Preview do Dashboard](assets/dashboard-preview.gif)

## 📌 Objetivo

Transformar dados extraídos de arquivos PDF em uma visão clara e estratégica para acompanhamento financeiro e operacional.

## 📊 Indicadores

- Ganhos totais
- Total de corridas
- Ticket médio
- Ganhos por mês
- Ganhos por categoria
- Melhores dias de faturamento
- Transferências para conta bancária
- Taxas do Instant Pay

## ⚙️ Ferramentas

- Power BI
- Power Query
- Excel
- DAX

## ⚠️ Observação

Os dados utilizados são fictícios/simulados para fins de estudo e portfólio.

## 🔄 Processo ETL

O projeto contou com um fluxo de ETL desenvolvido no Power Query, responsável por transformar arquivos PDF brutos em tabelas estruturadas para análise no Power BI.

### Etapas do processo:

1. **Extração**
   - Leitura dos arquivos PDF contendo os extratos de ganhos.
   - Importação dos dados para o Power Query.

2. **Transformação**
   - Padronização das colunas.
   - Tratamento de datas, horários e valores monetários.
   - Identificação das categorias de corrida.
   - Separação entre ganhos, transferências e taxas.
   - Criação de tabelas fato para análise.

3. **Carga**
   - Carregamento dos dados tratados no modelo do Power BI.
   - Construção dos indicadores e visuais do dashboard.

Esse processo permitiu transformar dados originalmente pouco estruturados em informações organizadas e úteis para análise financeira e operacional.

**Antes e Depois do ETL**

Dados extraídos do PDF (Antes)

<img width="1360" height="833" alt="ETL" src="https://github.com/user-attachments/assets/9f70d2b3-6ae1-4f4f-80b5-2040019ded94" />

Os dados chegam com estrutura pouco organizada, contendo colunas genéricas, cabeçalhos repetidos e informações distribuídas em diferentes posições da tabela, dificultando análises e consolidações.

Dados tratados e padronizados (Depois)

<img width="1628" height="799" alt="ETL2" src="https://github.com/user-attachments/assets/7c448f54-af56-417f-97b9-3eaf48b2745c" />

Após a aplicação das regras de transformação, os dados passam a possuir estrutura consistente, categorias padronizadas, datas e horários tratados e colunas preparadas para modelagem e análise no Power BI.

Exemplo de Padronização de Categorias

<img width="338" height="460" alt="image" src="https://github.com/user-attachments/assets/ca9d56a8-500a-41b2-83bb-6f15ab0d8d0f" />
<img width="336" height="412" alt="image" src="https://github.com/user-attachments/assets/e5b9ec25-681e-4df0-b212-62d760404e46" />



A padronização garante que categorias equivalentes sejam analisadas de forma agrupada, evitando distorções nos indicadores e dashboards.
