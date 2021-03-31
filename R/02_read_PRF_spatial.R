#
# 04_plot_PRF
#
rm(list=ls())

library(data.table)
library(magrittr)
library(mapview)
library(ggplot2)
library(stringr)
library(readr)
`%nin%` = Negate(`%in%`)
`%nlike%` = Negate(`%like%`)

### read files - vitima
#

# collisions
list_years_acidentes <- list.files("data",pattern = "acidentes",full.names = "TRUE")
list_years_acidentes <- list_years_acidentes[list_years_acidentes %like% "_todas_causas_"]


base_id_veiculo <- lapply(seq_along(list_years_acidentes),function(i){ # i = 1
  tmp_fleet <- data.table::fread(list_years_acidentes[i],encoding = "Latin-1")
  tmp_fleet <- tmp_fleet[id_veiculo != "(null)" & tipo_veiculo != "(null)"]
  tmp_fleet <- tmp_fleet[,.SD[1],by = .(id_veiculo,tipo_veiculo,marca)][,.(id_veiculo,tipo_veiculo,marca)]
  return(tmp_fleet)
}) %>% data.table::rbindlist()
base_id_veiculo <- base_id_veiculo[,.SD[1],by = .(id_veiculo)]

vitima_all <- lapply(seq_along(list_years_acidentes),function(i){ # i = 1

  # i = 12
  # initial message
  message("-------------------------------------")
  message(list_years_acidentes[i])
  message("-------------------------------------")

  # read
  tmp_file <- data.table::fread(list_years_acidentes[i],encoding = "Latin-1",dec = ",")
  tmp_file <- tmp_file[uf == "PR",]

  # adjust date
  tmp_file[,ano := data.table::as.IDate(data_inversa, format = "%d/%m/%Y") %>% data.table::year()]
  tmp_file[,ano := data.table::fifelse(ano == 16,2016,ano)]

  # estado fisico da vitima

  tmp_file[,estado_fisico := stringi::stri_trans_general(str = estado_fisico,id = "Latin-ASCII") %>% tolower()]

  if(tmp_file$ano[1] %in% c(2017,2018,2019,2020)){
    tmp_file[feridos_graves == 1,estado_fisico := "ferido grave"]
    tmp_file[feridos_leves == 1,estado_fisico := "ferido leve"]
    tmp_file[mortos == 1,estado_fisico := "morto"]
    tmp_file[ilesos == 1,estado_fisico := "ileso"]
    tmp_file[estado_fisico == "nao informado", estado_fisico := "nao_informado"]
  }else{

    tmp_file[estado_fisico %like% "ferido grave" , estado_fisico := "ferido grave"]
    tmp_file[estado_fisico %like% "ferido leve" , estado_fisico := "ferido leve"]
    tmp_file[estado_fisico %like% "morto" , estado_fisico := "morto"]
    tmp_file[estado_fisico %like% "ileso" , estado_fisico := "ileso"]
    tmp_file[estado_fisico %like% "ignorado" |
               estado_fisico %like% "(null)", estado_fisico := "nao_informado"]

    # por classificacao de acidente
    tmp_file[classificacao_acidente %like% "Sem Vítimas" & estado_fisico == "nao_informado",
             estado_fisico := "ileso"]

  }


  tmp_file$estado_fisico %>% base::table(useNA = "always")

  # remove testemunhas
  tmp_file <- tmp_file[tipo_envolvido %nin% "Testemunha"]

  # classificacao veiculo
  # add missing fleet data
  if(nrow(tmp_file[tipo_veiculo == "(null)"]) > 0){

    message("completando com base externa de frota")


    id_to_fix <- c(which(tmp_file$tipo_veiculo == "(null)"), which(tmp_file$id_veiculo != "(null)"))
    id_to_fix <- id_to_fix[duplicated(id_to_fix)]
    # add base
    tmp_file[base_id_veiculo,on = "id_veiculo",tipo_veiculo_base := i.tipo_veiculo]
    tmp_file[id_to_fix, tipo_veiculo := tipo_veiculo_base]
    tmp_file[,tipo_veiculo_base := NULL]
  }

  # to lower
  tmp_file[,tipo_veiculo := stringi::stri_trans_general(str = tipo_veiculo,id = "Latin-ASCII") %>% tolower()]
  tmp_file[,tipo_envolvido := stringi::stri_trans_general(str = tipo_envolvido,id = "Latin-ASCII") %>% tolower()]

  tmp_file$tipo_veiculo %>% base::table(useNA = "always")
  tmp_file$tipo_envolvido %>% base::table(useNA = "always")

  tmp_file[tipo_envolvido %in% "pedestre" , tipo_veiculo := "pedestre"]
  tmp_file[tipo_veiculo %in% "pedestre" , classe_veiculo := "pedestre"]
  tmp_file[tipo_veiculo %in% c("bicicleta","ciclomotor"),classe_veiculo := "bicicleta"]
  tmp_file[tipo_veiculo %in% c("motocicletas","motocicleta","triciclo",
                               "motoneta","quadriciclo"),classe_veiculo := "motocicleta"]
  tmp_file[tipo_veiculo %in% c("automovel","caminhonete",
                               "camioneta"),classe_veiculo := "veiculos_leves"]
  tmp_file[tipo_veiculo %in% c("microonibus","micro-onibus",
                               "utilitario","reboque"),classe_veiculo := "veiculo_medio_porte"]
  tmp_file[tipo_veiculo %in% c("caminhao","caminhao-trator","semi-reboque","semireboque",
                               "bonde / trem","trem-bonde","caminhao-tanque","onibus",
                               "trator de rodas","trator misto","trator de esteira",
                               "trator de esteiras"), classe_veiculo := "veiculo_grande_porte"]
  tmp_file[tipo_veiculo %in% c("carroca","charrete",
                               "carroca-charrete"),classe_veiculo := "veiculo_grande_porte"]
  tmp_file[tipo_veiculo == "chassi-plataforma", classe_veiculo := "nao identificado"]
  tmp_file[tipo_veiculo == "nao identificado" |
             tipo_veiculo == "outros" |
             tipo_veiculo == "nao informado", classe_veiculo := "nao identificado"]

  tmp_file$classe_veiculo %>% base::table(useNA = "always")

  tmp_file[is.na(classe_veiculo)]

  # classificacao tipo de vitima conforme veiculo do ocupante

  tmp_file$tipo_envolvido %>% base::table(useNA = "always")

  tmp_file[ tipo_veiculo %in% "pedestre" |
              tipo_veiculo %in% "carro-de-mao" |
              tipo_veiculo %in% "carro de mao",tipo_vitima := "Pedestre"]
  tmp_file[classe_veiculo %like% "motocicleta",tipo_vitima := "Ocupante motocicleta"]
  tmp_file[classe_veiculo %like% "veiculos_leves",tipo_vitima := "Ocupante veic. pequeno porte"]
  tmp_file[classe_veiculo %like% "veiculo_medio_porte",tipo_vitima := "Ocupante veic. médio porte"]
  tmp_file[classe_veiculo %like% "veiculo_grande_porte",tipo_vitima := "Ocupante veic. grande porte"]
  tmp_file[classe_veiculo %like% "bicicleta",tipo_vitima := "Ocupante bicicleta"]
  tmp_file[tipo_envolvido %like% "cavaleiro",tipo_vitima := "Ocupante cavalo"]
  tmp_file[classe_veiculo %like% "nao identificado",tipo_vitima := "Não identificado"]

  tmp_file[is.na(tipo_vitima)]

  # checagem
  if(nrow(tmp_file[is.na(tipo_vitima)]) > 0){
    message(paste0("check file ",list_years_acidentes[i]))
    message(paste0("tmp_file[is.na(tipo_vitima)] = "),nrow(tmp_file[is.na(tipo_vitima)]))
    tmp_file[is.na(tipo_vitima) ,tipo_vitima := "Não identificado"]
  }

  tmp_file$tipo_vitima %>% table()
  # summary
  tmp_file[, km := gsub(",",".",km)]
  tmp_file <- tmp_file[,.(id,data_inversa, dia_semana,horario,uf,br,km,municipio,
                          tipo_acidente,sentido_via,tipo_pista, tipo_veiculo,
                          tipo_envolvido,estado_fisico,
                          latitude,longitude,ano,classe_veiculo, tipo_vitima)]

  return(tmp_file)
}) %>% data.table::rbindlist()


readr::write_rds(vitima_all,"data/2017-2019_processed.rds",compress="gz")
