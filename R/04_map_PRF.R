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


vitima_all <- readr::read_rds("data/2017-2019_processed.rds")
# nomes para concessao
nomes_para_concessao <- c(277,373,376,476,153,369,272,158,163)

# PR cities
cities_pr <- geobr::read_municipality("all") %>%
  dplyr::filter(abbrev_state == "PR")

# shape state
state_pr <- geobr::read_state(code_state = "PR",simplified = FALSE) %>%
  sf::st_transform(4326)

# pr roads
roads_pr <- readr::read_rds("data/rodovias-zip/rodovias_pr.rds")




####
#### plot0 - mapa absoluto-----
#

tmp_map <- vitima_all[tipo_vitima %chin% "Pedestre" & !is.na(br) &
                        br %in% nomes_para_concessao,]
tmp_map <- tmp_map[,N := .N,by = .(br,km,sentido_via)][,.SD[1],by = .(br,km,sentido_via)]

tmp_map <- tmp_map %>%
  sfheaders::sf_point(x = "longitude", y= "latitude",keep = TRUE) %>%
  sf::st_as_sf() %>%
  sf::st_set_crs(4326) %>%
  dplyr::mutate(ano = as.character(ano))

# exclude point out of map
aux <- sf::st_within(tmp_map$geometry,state_pr$geom)
aux <- sapply(seq_along(aux),function(i){length(aux[[i]])})
tmp_map <- tmp_map[-which(aux<1),]
tmp_map$name <- paste0("BR ",tmp_map$br)

# roads_pr_concessao
rodas_pr_concessao <- roads_pr[roads_pr$vl_br %in% nomes_para_concessao,]

#
tmp_map$estado_fisico_f <-
  factor(tmp_map$estado_fisico,
         levels = c("nao_informado",
                    "ileso","ferido leve","ferido grave",
                    "morto"),
         labels = c("Não informado","Ileso","Ferido leve",
                    "Ferido grave","Morte"))

#mapview(roads_pr[roads_pr$ds_legenda != "Planejada" ,])

ggplot() +
  geom_sf(data = state_pr$geom) +
  geom_sf(data = rodas_pr_concessao$geometry,cex = 0.55,color = "grey71") +
  geom_sf(data = tmp_map,aes(fill = name, size = N),shape= 21) +
  viridis::scale_fill_viridis(option = "D",discrete = T,direction = -1)  +
  #geom_sf(data = tmp_map,cex = 0.85,color = "black") +
  #geom_area(aes(x = ano, y = V1, fill = estado_fisico_f))+
  #geom_line(aes(x = ano, y = V1, color = estado_fisico_f))+
  #geom_point(aes(x = ano, y = V1, color = estado_fisico_f))+
  #scale_x_continuous(breaks = c(2007,2010,2015,2020))+
  #facet_wrap(facets = vars(ano),nrow = 1)+
  theme(plot.caption = element_text(hjust = 0)) +
  labs(x = NULL,
       y = NULL,
       fill = "Registros \npor rodovia",
       size = "Número de \nregistros",
       title = 'Registros envolvendo pedestres',
       subtitle = 'Número absoluto de atropelamentos por rodovia e frequência',
       caption = "
       Fonte: PRF (2017-2020).
       Elaboração: João Bazzo (2021).")


ggsave("figures/map_sinistros_pedestres.png",
       scale = 1.1,width = 18.5,height = 13,dpi = 300, units = "cm")
#### plot1 - mapa absoluto-----
#

tmp_map <- vitima_all[tipo_vitima %chin% "Ocupante bicicleta" & !is.na(br) &
                        br %in% nomes_para_concessao,]
tmp_map <- tmp_map[,N := .N,by = .(br,km,sentido_via)][,.SD[1],by = .(br,km,sentido_via)]

tmp_map <- tmp_map %>%
  sfheaders::sf_point(x = "longitude", y= "latitude",keep = TRUE) %>%
  sf::st_as_sf() %>%
  sf::st_set_crs(4326) %>%
  dplyr::mutate(ano = as.character(ano))

# exclude point out of map
aux <- sf::st_within(tmp_map$geometry,state_pr$geom)
aux <- sapply(seq_along(aux),function(i){length(aux[[i]])})
tmp_map <- tmp_map[-which(aux<1),]
tmp_map$name <- paste0("BR ",tmp_map$br)

# roads_pr_concessao
rodas_pr_concessao <- roads_pr[roads_pr$vl_br %in% nomes_para_concessao,]

#
tmp_map$estado_fisico_f <-
  factor(tmp_map$estado_fisico,
         levels = c("nao_informado",
                    "ileso","ferido leve","ferido grave",
                    "morto"),
         labels = c("Não informado","Ileso","Ferido leve",
                    "Ferido grave","Morte"))

mapview(roads_pr[roads_pr$ds_legenda != "Planejada" ,])

ggplot() +
  geom_sf(data = state_pr$geom) +
  geom_sf(data = rodas_pr_concessao$geometry,cex = 0.55,color = "grey71") +
  geom_sf(data = tmp_map,aes(fill = name, size = N),shape= 21) +
  viridis::scale_fill_viridis(option = "D",discrete = T,direction = -1)  +
  #geom_sf(data = tmp_map,cex = 0.85,color = "black") +
  #geom_area(aes(x = ano, y = V1, fill = estado_fisico_f))+
  #geom_line(aes(x = ano, y = V1, color = estado_fisico_f))+
  #geom_point(aes(x = ano, y = V1, color = estado_fisico_f))+
  #scale_x_continuous(breaks = c(2007,2010,2015,2020))+
  #facet_wrap(facets = vars(ano),nrow = 1)+
  theme(plot.caption = element_text(hjust = 0)) +
  labs(x = NULL,
       y = NULL,
       fill = "Registros \npor rodovia",
       size = "Número de \nregistros",
       title = 'Registros envolvendo ciclistas',
       subtitle = 'Número absoluto de registros por rodovia e frequência',
       caption = "
       Fonte: PRF (2017-2020).
       Bicicletas - bicicleta e ciclomotor
       Elaboração: João Bazzo (2021).")


ggsave("figures/map_sinistros_bicicleta.png",
       scale = 1.1,width = 18.5,height = 13,dpi = 300, units = "cm")

#
#
#
#
# ### plot por modo de transporte------
# read
tmp_map <- data.table::copy(vitima_all)[!is.na(br) & estado_fisico == "morto",]
tmp_map <- tmp_map[tipo_vitima %like% "Pedestre"  |
                     tipo_vitima %like% "bicicleta" |
                     tipo_vitima %like% "motocicleta" |
                     tipo_vitima %like% "pequeno porte" |
                     tipo_vitima %like% "grande porte",]
tmp_map <- tmp_map[,N := .N,by = .(br,km,tipo_vitima)]
tmp_map <- tmp_map[,.SD[1],by = .(br,km,tipo_vitima)]
tmp_map[,perc := (100 * N/sum(N)) %>% round(2), by =.(br,tipo_vitima)]
tmp_map <- tmp_map %>%
  sfheaders::sf_point(x = "longitude", y= "latitude",keep = TRUE) %>%
  sf::st_as_sf() %>%
  sf::st_set_crs(4326)

# exclude point out of map
aux <- sf::st_within(tmp_map$geometry,state_pr$geom)
aux <- sapply(seq_along(aux),function(i){length(aux[[i]])})
tmp_map <- tmp_map[-which(aux<1),]

# name br
tmp_map$name <- paste0("BR ",tmp_map$br)

# roads_pr_concessao
roads_pr_concessao <- roads_pr[roads_pr$vl_br %in% nomes_para_concessao,]

# plot
ggplot(data = tmp_map) +
  geom_sf(data = state_pr$geom) +
  #geom_sf(data = cities_pr$geom,cex = 0.35,color = "grey71") +
  geom_sf(data = roads_pr_concessao$geometry,
          cex = 0.75,color = "grey71") +
  geom_sf(aes(color = name,size = perc)) +
  #geom_sf(data = tmp_map,cex = 0.85,color = "black") +
  #geom_area(aes(x = ano, y = V1, fill = estado_fisico_f))+
  #geom_line(aes(x = ano, y = V1, color = estado_fisico_f))+
  #geom_point(aes(x = ano, y = V1, color = estado_fisico_f))+
  #scale_x_continuous(breaks = c(2007,2010,2015,2020))+
  facet_wrap(facets = vars(tipo_vitima))#+
  viridis::scale_color_viridis(option = "D",discrete = T,direction = -1)  +
  theme(plot.caption = element_text(hjust = 0)) +
  labs(x = NULL,
       y = NULL,
       color = "Tipo de vítima",
       title = 'Colisões envolvendo ciclistas',
       subtitle = 'Número absoluto de colisões por estado de gravidade da vítima',
       caption = "
       Fonte: PRF (2007-2020).
       Bicicletas - bicicleta e ciclomotor
       Elaboração: João Bazzo (2021).")


# cities that boundaries roads

# cities_pr_select <- sf::st_intersects(
#   (cities_pr %>% sf::st_transform(29192)),
#   (sf::st_buffer(sf::st_transform(roads_pr$geometry,29192),1000)))
#
# cities_pr_select <- sapply(seq_along(cities_pr_select),function(i){
#   length(cities_pr_select[[i]])})
# cities_pr_select <- cities_pr[-which(cities_pr_select<1),]
#
# mapview(rodas_pr_concessao$geometry,
#         alpha = 0.75,
#         lwd = 1) +
#   mapview(tmp_map,
#           #zcol = "N",
#           layer.name ="Número de \nregistros",
#           alpha = 0.75,
#           cex = "N")



