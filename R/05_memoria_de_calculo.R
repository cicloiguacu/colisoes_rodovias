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
fwrite(vitima_all,"data/vitima_all.csv")
vitima_all[1]
# custo por vitima
# fonte: https://www.ipea.gov.br/portal/images/stories/PDFs/TDs/td_2565.pdf
custo_vitima <- vitima_all[,sum(N),by = .(estado_fisico,ano)]
custo_vitima[estado_fisico == "ileso",total := 1839.94 * V1]
custo_vitima[estado_fisico == "ferido leve",total := 8635.77 * V1]
custo_vitima[estado_fisico == "ferido grave",total := 141155.96 * V1]
custo_vitima[estado_fisico == "morto",total := 433286 * V1]
custo_vitima <- custo_vitima[!is.na(total)]
(custo_vitima[ano == '2020',]$total/10^6) %>% sum()
# [1] 545.7242
(custo_vitima$total/10^9) %>% sum()
# [1] 9.554445
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
