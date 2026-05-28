# dashboard-uber-motorista
Dashboard em Power BI para análise de ganhos, corridas, transferências e taxas de um motorista Uber, com dados extraídos de PDFs e tratados no Power Query.

## 🎥 Preview

![Preview do Dashboard](ativos/dashboard-preview.gif)

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
