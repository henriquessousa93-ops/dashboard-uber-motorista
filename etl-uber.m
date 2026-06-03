let
    CaminhoPasta = "C:\Users\HENRIQUE\OneDrive\Desktop\Bases Uber - Dash\PDFs Brutos",

    CategoriasUber = {
        "Uber X", "UberX", "Comfort", "Black", "Bag",
        "Uber Bag", "Black Bag", "Comfort Bag", "Comfort Planet",
        "Prioridade", "Uber Prioridade", "Priority"
    },

    ConverterMoeda = (valor as any) as nullable number =>
        let
            texto = if valor = null then null else Text.From(valor),
            limpo = if texto = null then null else Text.Trim(Text.Replace(Text.Replace(texto, "R$", ""), " ", "")),
            numero = try Number.FromText(limpo, "pt-BR") otherwise null
        in
            numero,

    ConverterData = (textoData as any, ano as any) as nullable date =>
        let
            texto = if textoData = null then null else Text.Lower(Text.Trim(Text.From(textoData))),
            semDiaSemana = if texto = null then null else if Text.Contains(texto, ",") then Text.Trim(Text.AfterDelimiter(texto, ",")) else texto,
            limpo = if semDiaSemana = null then null else Text.Replace(semDiaSemana, ".", ""),
            dia = try Number.FromText(Text.BeforeDelimiter(limpo, " de ")) otherwise null,
            mes =
                if Text.Contains(limpo, "jan") then 1 else
                if Text.Contains(limpo, "fev") then 2 else
                if Text.Contains(limpo, "mar") then 3 else
                if Text.Contains(limpo, "abr") then 4 else
                if Text.Contains(limpo, "mai") then 5 else
                if Text.Contains(limpo, "jun") then 6 else
                if Text.Contains(limpo, "jul") then 7 else
                if Text.Contains(limpo, "ago") then 8 else
                if Text.Contains(limpo, "set") then 9 else
                if Text.Contains(limpo, "out") then 10 else
                if Text.Contains(limpo, "nov") then 11 else
                if Text.Contains(limpo, "dez") then 12 else null,
            resultado = try #date(Number.From(ano), mes, dia) otherwise null
        in
            resultado,

    Fonte = Folder.Files(CaminhoPasta),
    ApenasPDFs = Table.SelectRows(Fonte, each Text.Lower([Extension]) = ".pdf"),

    LerPDFs = Table.AddColumn(
        ApenasPDFs,
        "DadosTratados",
        each
            let
                NomeArquivo = [Name],
                Pdf = Pdf.Tables([Content], [Implementation="1.3"]),

                Paginas = Table.SelectRows(Pdf, each [Kind] = "Page"),

                TextoPaginas = Text.Combine(
                    List.Transform(
                        List.Combine(
                            List.Transform(Paginas[Data], each List.Combine(Table.ToRows(_)))
                        ),
                        each try Text.From(_) otherwise ""
                    ),
                    " "
                ),

                TextoCabecalho =
                    try Text.Start(Text.AfterDelimiter(TextoPaginas, "Relatório semanal"), 160)
                    otherwise Text.Start(TextoPaginas, 160),

                AnosPossiveis = {2024, 2025, 2026},

                TabelaAnos = Table.FromRecords(
                    List.Transform(
                        AnosPossiveis,
                        each [
                            Ano = _,
                            Posicao = Text.PositionOf(TextoCabecalho, Text.From(_))
                        ]
                    )
                ),

                AnosEncontrados = Table.SelectRows(TabelaAnos, each [Posicao] >= 0),

                AnoCabecalho =
                    if Table.RowCount(AnosEncontrados) > 0
                    then Table.Sort(AnosEncontrados, {{"Posicao", Order.Ascending}}){0}[Ano]
                    else null,

                AnoArquivo =
                    if Text.StartsWith(NomeArquivo, "2024_") then 2024 else
                    if Text.StartsWith(NomeArquivo, "2025_") then 2025 else
                    if Text.StartsWith(NomeArquivo, "2026_") then 2026 else
                    null,

                AnoRelatorio =
                    if AnoArquivo <> null then AnoArquivo else AnoCabecalho,

                ApenasTabelas = Table.SelectRows(Pdf, each [Kind] = "Table"),
                Combinado = Table.Combine(ApenasTabelas[Data]),

                ColunasOriginais = Table.ColumnNames(Combinado),
                ColunasPadrao = List.Transform({1..List.Count(ColunasOriginais)}, each "Coluna" & Text.From(_)),

                Renomeado = Table.RenameColumns(
                    Combinado,
                    List.Zip({ColunasOriginais, ColunasPadrao})
                ),

                Selecionado = Table.SelectColumns(
                    Renomeado,
                    {"Coluna1", "Coluna2", "Coluna3", "Coluna4", "Coluna5", "Coluna6"},
                    MissingField.UseNull
                ),

                ComAno = Table.AddColumn(Selecionado, "AnoRelatorio", each AnoRelatorio),
                ComArquivo = Table.AddColumn(ComAno, "Arquivo", each NomeArquivo)
            in
                ComArquivo
    ),

    Expandir = Table.Combine(LerPDFs[DadosTratados]),

    CriarDataAux = Table.AddColumn(
        Expandir,
        "DataAux",
        each
            if [Coluna1] <> null and Text.Contains(Text.From([Coluna1]), ",") and Text.Contains(Text.From([Coluna1]), "de")
            then Text.From([Coluna1])
            else null,
        type text
    ),

    CriarHorarioAux = Table.AddColumn(
        CriarDataAux,
        "HorarioAux",
        each
            let
                texto = if [Coluna1] = null then null else Text.Select(Text.From([Coluna1]), {"0".."9"})
            in
                if texto <> null and Text.Length(texto) <= 4 and Text.Length(texto) >= 3 then texto else null,
        type text
    ),

    PreencherHorarioAcima = Table.FillUp(CriarHorarioAux, {"HorarioAux"}),
    PreencherDataAbaixo = Table.FillDown(PreencherHorarioAcima, {"DataAux"}),

    FiltrarCorridas = Table.SelectRows(
        PreencherDataAbaixo,
        each List.Contains(CategoriasUber, [Coluna2])
            and [AnoRelatorio] <> null
            and [DataAux] <> null
    ),

    CriarData = Table.AddColumn(
        FiltrarCorridas,
        "Processado",
        each ConverterData([DataAux], [AnoRelatorio]),
        type date
    ),

    FiltrarDataValida = Table.SelectRows(
        CriarData,
        each [Processado] <> null
    ),

    CriarHorario = Table.AddColumn(
        FiltrarDataValida,
        "Horário",
        each
            let
                Texto4 = Text.PadStart(Text.From([HorarioAux]), 4, "0")
            in
                Time.FromText(Text.Start(Texto4, 2) & ":" & Text.End(Texto4, 2)),
        type time
    ),

    RenomearCategoria = Table.RenameColumns(
        CriarHorario,
        {{"Coluna2", "Categoria Corrida"}}
    ),

    PadronizarCategoria = Table.TransformColumns(
        RenomearCategoria,
        {
            {
                "Categoria Corrida",
                each
                    let
                        Categoria = Text.Upper(Text.Trim(Text.From(_)))
                    in
                        if Categoria = "UBERX" or Categoria = "UBER X" then "Uber X"
                        else if Categoria = "COMFORT" then "Comfort"
                        else if Categoria = "BLACK" then "Black"
                        else if Categoria = "BAG" or Categoria = "UBER BAG" then "Bag"
                        else if Categoria = "BLACK BAG" then "Black Bag"
                        else if Categoria = "COMFORT BAG" then "Comfort Bag"
                        else if Categoria = "COMFORT PLANET" then "Comfort Planet"
                        else if Categoria = "PRIORIDADE" or Categoria = "UBER PRIORIDADE" or Categoria = "PRIORITY" then "Prioridade"
                        else Text.Proper(Text.Trim(Text.From(_))),
                type text
            }
        }
    ),

    CriarSeusGanhos = Table.AddColumn(
        PadronizarCategoria,
        "Seus ganhos",
        each ConverterMoeda([Coluna3]),
        Currency.Type
    ),

    FiltrarGanhosValidos = Table.SelectRows(
        CriarSeusGanhos,
        each [Seus ganhos] <> null and [Seus ganhos] > 0
    ),

    NomeDia = Table.AddColumn(
        FiltrarGanhosValidos,
        "Nome do Dia",
        each Date.DayOfWeekName([Processado], "pt-BR"),
        type text
    ),

    CriarReembolsosNulo = Table.AddColumn(
        NomeDia,
        "Reembolsos e despesas",
        each null,
        Currency.Type
    ),

    CriarTransferenciasNulo = Table.AddColumn(
        CriarReembolsosNulo,
        "Transferências",
        each null,
        Currency.Type
    ),

    CriarSaldoNulo = Table.AddColumn(
        CriarTransferenciasNulo,
        "Saldo",
        each null,
        Currency.Type
    ),

    SelecionarFinal = Table.SelectColumns(
        CriarSaldoNulo,
        {
            "Nome do Dia",
            "Processado",
            "Horário",
            "Categoria Corrida",
            "Seus ganhos",
            "Reembolsos e despesas",
            "Transferências",
            "Saldo",
            "Arquivo"
        }
    ),

    AgruparCorridasUnicas = Table.Group(
        SelecionarFinal,
        {
            "Nome do Dia",
            "Processado",
            "Horário",
            "Categoria Corrida",
            "Seus ganhos"
        },
        {
            {"Reembolsos e despesas", each null, Currency.Type},
            {"Transferências", each null, Currency.Type},
            {"Saldo", each null, Currency.Type},
            {"Arquivo", each Text.Combine(List.Distinct([Arquivo]), " | "), type text}
        }
    ),

    Classificar = Table.Sort(
        AgruparCorridasUnicas,
        {
            {"Processado", Order.Descending},
            {"Horário", Order.Descending}
        }
    ),
    #"Linhas Filtradas" = Table.SelectRows(Classificar, each true)
in
    #"Linhas Filtradas"
