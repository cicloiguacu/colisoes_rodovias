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




###plot1
# por estado fisico, por ano, por rodovia (BICICLETA)
#




tmp_plot <- data.table:::copy(vitima_all)[tipo_vitima %like% "bicicleta"]
tmp_plot <- tmp_plot[,sum(N),by = .(br,estado_fisico,ano)]

# add zero in between
# add zero on plots
br_aux <- unique(tmp_plot$br)
est_aux <- unique(tmp_plot$estado_fisico)
ano_aux <- unique(tmp_plot$ano)
dt0 <- lapply(1:uniqueN(tmp_plot$br),function(i){
  dt1 <- lapply(1:uniqueN(tmp_plot$estado_fisico),function(j){
    dt2 <- lapply(1:uniqueN(tmp_plot$ano),function(k){
      my_file <- tmp_plot[br == br_aux[i] &
                            estado_fisico == est_aux[j] &
                            ano == ano_aux[k]]
      if(nrow(my_file)==0){
        dt_output <- data.table::data.table(br = br_aux[i],
                                            estado_fisico = est_aux[j],
                                            ano = ano_aux[k],
                                            V1 = 0 )
        return(dt_output)
      }else{return(my_file)}
    }) %>% data.table::rbindlist()
    return(dt2)
  }) %>% data.table::rbindlist()
  return(dt1)
}) %>% data.table::rbindlist()

tmp_plot_new <- data.table::copy(dt0)
tmp_plot_new

tmp_plot_new$br_name <- factor(tmp_plot_new$br,
                               levels = c("153","116",
                                          "476","369",
                                          "376","277"),
                               labels = c("BR-153",
                                          'BR-116',
                                          "BR-476",
                                          "BR-369","BR-376","BR-277") )
tmp_plot_new$estado_fisico_f <-
  factor(tmp_plot_new$estado_fisico,
         levels = c("nao_informado",
                    "ileso","ferido leve","ferido grave",
                    "morto"),
         labels = c("Não informado","Ileso","Ferido leve",
                    "Ferido grave","Morte"))


my_roads <- c("116","153",
              "277","369",
              "376","476")

for(i in 1:length(my_roads)){ # i = 1
  ggplot(data = tmp_plot_new[br %in% my_roads[i]]) +
    geom_area(aes(x = ano, y = V1, fill = estado_fisico_f))+
    #geom_line(aes(x = ano, y = V1, color = estado_fisico_f))+
    #geom_point(aes(x = ano, y = V1, color = estado_fisico_f))+
    scale_x_continuous(breaks = c(2007,2010,2015,2020))+
    facet_wrap(facets = vars(br_name),scales = "free")+
    viridis::scale_fill_viridis("Estado físico",
                                option = "D",discrete = T,direction = -1)  +
    theme(plot.caption = element_text(hjust = 0)) +
    labs(x = NULL,
         y = "Número de ocorrências",
         title = 'Colisões envolvendo ciclistas',
         subtitle = 'Número absoluto de colisões por estado de gravidade da vítima',
         caption = "
       Fonte: PRF (2007-2020).
       Convenção:
       Bicicletas - bicicleta e ciclomotor
       Elaboração: João Bazzo (2021).")
  ggsave(sprintf("figures/instagram/sinistros_bicicleta_BR-%s.png",my_roads[i]),
         scale = 1,width = 18,height = 13,dpi = 300, units = "cm")
}

###
# por ocupante, por ano, por rodovia
#

tmp_plot <- data.table:::copy(vitima_all)
tmp_plot <- tmp_plot[,sum(N),by = .(br,tipo_vitima,ano)]
tmp_plot <- tmp_plot[tipo_vitima %nin% c("Ocupante cavalo",
                                         "Não identificado")]
tmp_plot$br_name <- factor(tmp_plot$br,
                           levels = c("153","116",
                                      "476","369",
                                      "376","277"),
                           labels = c("BR-153",
                                      'BR-116',
                                      "BR-476",
                                      "BR-369","BR-376","BR-277") )
tmp_plot$tipo_vitima_f <- factor(tmp_plot$tipo_vitima,
                                 levels=c("Pedestre","Ocupante bicicleta",
                                          "Ocupante motocicleta",
                                          "Ocupante veic. pequeno porte",
                                          "Ocupante veic. médio porte",
                                          "Ocupante veic. grande porte"),
                                 labels = c("Pedestre","Ocupante \nbicicleta",
                                            "Ocupante \nmotocicleta",
                                            "Ocupante veic. \npequeno porte",
                                            "Ocupante veic. \nmédio porte",
                                            "Ocupante veic. \ngrande porte"))

my_roads <- c("116","153",
              "277","369",
              "376","476")

for(i in 1:length(my_roads)){ # i = 1
ggplot(data = tmp_plot[br %in% my_roads[i]]) +
  geom_area(aes(x = ano, y = V1, fill = tipo_vitima_f))+
  facet_wrap(facets = vars(br_name),scales = "free")+
  viridis::scale_fill_viridis("Tipo de vítima",
                              option = "D",discrete = T,direction = -1)  +
  theme(plot.caption = element_text(hjust = 0),
        legend.key.size = unit(.85, "cm")) +
  scale_x_continuous(breaks = c(2007,2010,2015,2020))+
  labs(x = NULL,
       title = "Evolução das colisões nas rodovias federais paranaenses",
       y = 'Número registros',
       subtitle = 'Número absoluto de colisões por tipo vítima',
       caption = "
       Fonte: PRF (2007-2020).
       Convenção:
       Bicicletas - bicicleta e ciclomotor;
       Veículos de pequeno porte - autómovel, camioneta, camionhete;
       Veículos de médio porte - microonibus, utilitario, reboque;
       Veículos de grande porte - caminhao, semi-reboque, ônibus, trator.
       Ocupante de cavalo e 'não identificados' foram excluídos.
       Elaboração: João Bazzo (2021).")

ggsave(sprintf("figures/instagram/colisoes_totais_por_vitima_BR-%s.png",my_roads[i]),
       scale = 1,width = 18,height = 13,dpi = 300, units = "cm")
}
###
# por ocupante, por ano, por rodovia (VITIMA LEVE/GRAVE/FATAL)
#

tmp_plot <- data.table:::copy(vitima_all)[estado_fisico == "morto"]
tmp_plot <- tmp_plot[,sum(N),by = .(br,tipo_vitima,ano)]
tmp_plot <- tmp_plot[tipo_vitima %nin% c("Ocupante cavalo",
                                         "Não identificado")]

# add zero on plots
br_aux <- unique(tmp_plot$br)
vit_aux <- unique(tmp_plot$tipo_vitima)
ano_aux <- unique(tmp_plot$ano)

# add zero in between
#
dt0 <- lapply(1:uniqueN(tmp_plot$br),function(i){
  dt1 <- lapply(1:uniqueN(tmp_plot$tipo_vitima),function(j){
    dt2 <- lapply(1:uniqueN(tmp_plot$ano),function(k){
      my_file <- tmp_plot[br == br_aux[i] &
                            tipo_vitima == vit_aux[j] &
                            ano == ano_aux[k]]
      if(nrow(my_file)==0){
        dt_output <- data.table::data.table(br = br_aux[i],
                                            tipo_vitima = vit_aux[j],
                                            ano = ano_aux[k],
                                            V1 = 0 )
        return(dt_output)
      }else{return(my_file)}
    }) %>% data.table::rbindlist()
    return(dt2)
  }) %>% data.table::rbindlist()
  return(dt1)
}) %>% data.table::rbindlist()

tmp_plot_new <- data.table::copy(dt0)
tmp_plot_new$br_name <- factor(tmp_plot_new$br,
                               levels = c("153","116",
                                          "476","369",
                                          "376","277"),
                               labels = c("BR-153",
                                          'BR-116',
                                          "BR-476",
                                          "BR-369","BR-376","BR-277") )
tmp_plot_new$tipo_vitima_f <- factor(tmp_plot_new$tipo_vitima,
                                     levels=c("Pedestre","Ocupante bicicleta",
                                              "Ocupante motocicleta",
                                              "Ocupante veic. pequeno porte",
                                              "Ocupante veic. médio porte",
                                              "Ocupante veic. grande porte"),
                                     labels = c("Pedestre","Ocupante \nbicicleta",
                                                "Ocupante \nmotocicleta",
                                                "Ocupante veic. \npequeno porte",
                                                "Ocupante veic. \nmédio porte",
                                                "Ocupante veic. \ngrande porte"))

my_roads <- c("116","153",
              "277","369",
              "376","476")

for(i in 1:length(my_roads)){ # i = 1
  ggplot(data = tmp_plot_new[br %in% my_roads[i]]) +
  geom_area(aes(x = ano, y = V1, fill = tipo_vitima_f))+
  #geom_line(aes(x = ano, y = V1, color = tipo_vitima))+
  #geom_point(aes(x = ano, y = V1, color = tipo_vitima))+
  scale_x_continuous(breaks = c(2007,2010,2015,2020))+
  facet_wrap(facets = vars(br_name),scales = "free")+
  viridis::scale_fill_viridis("Tipo de vítima",
                              option = "C",discrete = T,direction = +1)  +
  theme(plot.caption = element_text(hjust = 0),
        legend.key.size = unit(.85, "cm")) +
  labs(x = NULL,
       title = "Evolução de óbitos nas rodovias federais paranaenses",
       y = 'Número registros',
       subtitle = 'Número absoluto de colisões/atropelamentos fatais por tipo de vítima',
       caption = "
       Fonte: PRF (2007-2020).
       Convenção:
       Bicicletas - bicicleta e ciclomotor;
       Veículos de pequeno porte - autómovel, camioneta, camionhete;
       Veículos de médio porte - microonibus, utilitario, reboque;
       Veículos de grande porte - caminhao, semi-reboque, ônibus, trator.
       Ocupante de cavalo e 'não identificados' foram excluídos.
       Elaboração: João Bazzo (2021).")
  ggsave(sprintf("figures/instagram/colisoes_fatais_por_vitima_BR-%s.png",my_roads[i]),
         scale = 1,width = 18,height = 13,dpi = 300, units = "cm")
}



###
## mortalidade por modo de transporte
#



tmp_plot <- data.table:::copy(vitima_all)
tmp_plot$tipo_vitima %>% table()
tmp_plot <- tmp_plot[tipo_vitima %nin% c("Não identificado","Ocupante cavalo")]
tmp_plot <- tmp_plot[,sum(N),by = .(tipo_vitima,ano,estado_fisico)]
# add zero in between
# add zero on plots
est_aux <- unique(tmp_plot$estado_fisico)
vit_aux <- unique(tmp_plot$tipo_vitima)
ano_aux <- unique(tmp_plot$ano)
dt0 <- lapply(1:uniqueN(tmp_plot$estado_fisico),function(i){
  dt1 <- lapply(1:uniqueN(tmp_plot$tipo_vitima),function(j){
    dt2 <- lapply(1:uniqueN(tmp_plot$ano),function(k){
      my_file <- tmp_plot[estado_fisico == est_aux[i] &
                            tipo_vitima == vit_aux[j] &
                            ano == ano_aux[k]]
      if(nrow(my_file)==0){
        dt_output <- data.table::data.table(tipo_vitima = vit_aux[j],
                                            ano = ano_aux[k],
                                            estado_fisico = est_aux[i],
                                            V1 = 0 )
        return(dt_output)
      }else{return(my_file)}
    }) %>% data.table::rbindlist()
    return(dt2)
  }) %>% data.table::rbindlist()
  return(dt1)
}) %>% data.table::rbindlist()

tmp_plot_new <- dt0
tmp_plot_new[,relativo := round(100 * V1 / sum(V1),2) , by = .(tipo_vitima,ano)]
#tmp_plot$tipo_vitima %>% table()
tmp_plot_new$estado_fisico_f <-
  factor(tmp_plot_new$estado_fisico,
         levels = c("nao_informado",
                    "ileso","ferido leve","ferido grave",
                    "morto"),
         labels = c("Não informado","Ileso","Ferido leve",
                    "Ferido grave","Morte"))

tmp_plot_new$tipo_vitima_f <- factor(tmp_plot_new$tipo_vitima,
                                     levels=c("Pedestre","Ocupante bicicleta",
                                              "Ocupante motocicleta",
                                              "Ocupante veic. pequeno porte",
                                              "Ocupante veic. médio porte",
                                              "Ocupante veic. grande porte"))


my_roads <-c("Pedestre","Ocupante bicicleta",
             "Ocupante motocicleta",
             "Ocupante veic. pequeno porte",
             "Ocupante veic. médio porte",
             "Ocupante veic. grande porte")

for(i in 1:length(my_roads)){ # i = 1
  ggplot(data = tmp_plot_new[tipo_vitima_f %in% my_roads[i]]) +
  geom_area(aes(x = ano, y = relativo,
                fill = estado_fisico_f))+
  #scale_fill_brewer(type = "seq",palette = "Reds") +

  viridis::scale_fill_viridis("Estado físico",
                              option = "D",discrete = T,direction = -1)  +
  facet_wrap(facets = vars(tipo_vitima_f)) +
  theme(plot.caption = element_text(hjust = 0)) +
  labs(x = NULL,
       y = "Proporção das vítimas (%)",
       title = 'Severidade em colisões e atropelamentos',
       subtitle = 'Proporção de tipos de estado físico de vítimas conforme modo de transporte',
       caption = "
       Fonte: PRF (2007-2020).
       Convenção:
       Bicicletas - bicicleta e ciclomotor;
       Veículos de pequeno porte - autómovel, camioneta, camionhete;
       Veículos de médio porte - microonibus, utilitario, reboque;
       Veículos de grande porte - caminhao, semi-reboque, ônibus, trator.
       Elaboração: João Bazzo (2021).")

# ggsave("figures/severidade_por_vitima.png",
#        scale = 1,width = 23.5,height = 13,dpi = 300, units = "cm")
ggsave(sprintf("figures/instagram/severidade_por_vitima.png_BR-%s.png",my_roads[i]),
       scale = 1,width = 18,height = 13,dpi = 300, units = "cm")
}
