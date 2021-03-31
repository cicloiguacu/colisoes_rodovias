#
# 03_plot_PRF
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


vitima_all <- readr::read_rds("data/vitima_all.rds")

# geral
vitima_all$estado_fisico %>% unique()
vitima_all[estado_fisico %in% c("ferido leve","ferido grave","morto"),N] %>% sum()

# bicicleta
vitima_all$tipo_vitima %>% unique()
tmp <- vitima_all[estado_fisico %in% "morto",sum(N),by=tipo_vitima]
tmp[,percent := round(V1/sum(V1) * 100,2)]
tmp$V1 %>% sum()
# [1] 8413
tmp[tipo_vitima %in% c("Pedestre","Ocupante bicicleta")]$V1 %>% sum()
# [1] 2171
tmp[tipo_vitima %in% c("Pedestre","Ocupante bicicleta")]$percent %>% sum()
# [1] 25.81
