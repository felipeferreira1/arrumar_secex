# Rotina para organizar os dados da SECEX
# Feito por: Felipe Simpl�cio Ferreira
# �ltima atualiza��o: 11/08/2020


# Definindo diret�rios a serem utilizados
getwd()
# setwd("//srjn4/projetos/Projeto GAP-DIMAC/Automatiza��es/Att semanais")
setwd("D:\\Documentos")

# Carregando pacotes que ser�o utilizados
library(dplyr)
library(zoo)
library(rio)

# Download dos dados
temp <- tempfile()
download.file("https://balanca.economia.gov.br/balanca/IPQ/arquivos/Dados_brutos.zip",temp)
dados <- read.csv2(unz(temp, "arquivos/Dados_totais_mensal.csv"), row.names = 1)
unlink(temp)

# Organiza��o dos dados
dados$DATA <- as.yearmon(paste(dados$CO_ANO, dados$CO_MES), "%Y %m")

tipo <- unique(dados$TIPO)

tipo_indice <- unique(dados$TIPO_INDICE)

nomes <- NA
for (i in 1:length(tipo)){
  for (j in 1:length(tipo_indice)){
    nome <- paste(tipo[i] , tipo_indice[j], sep = "_")
    data_f <- dados %>% filter(TIPO == tipo[i], TIPO_INDICE == tipo_indice[j]) %>% select(DATA, INDICE) %>% arrange(DATA)
    assign(nome, data_f)
    nomes <- append(nomes, nome)
  }
}

nomes <- nomes[-1]

for (i in 1:length(nomes)){
  if (i == 1)
    export(get(nomes[i]), "dados.xlsx", sheetName = nomes[i])
  else
    export(get(nomes[i]), "dados.xlsx", which = nomes[i])
}

