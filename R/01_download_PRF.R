#
#
# download dado PRF
#
#
library(data.table)
library(magrittr)

link <- "http://arquivos.prf.gov.br/arquivos/index.php/s/jdDLrQIf33xXSCe/download"
dir.create("data")
dir.create("data-raw/")


# Agrupados por ocorrência
#
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/jdDLrQIf33xXSCe/download",destfile = "data-raw/2020.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/kRBUylqz6DyQznN/download",destfile = "data-raw/2019.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/MaC6cieXSFACNWT/download",destfile = "data-raw/2018.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/nqvFu7xEF6HhbAq/download",destfile = "data-raw/2017.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/AhSKXYgrFtfXMK3/download",destfile = "data-raw/2016.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/qqAsQep7J8FzpR5/download",destfile = "data-raw/2015.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/1QYIZKqjcUDOrXm/download",destfile = "data-raw/2014.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/ZBJgHd4fmYV2Hhr/download",destfile = "data-raw/2013.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/VIeiSbpxRxan33L/download",destfile = "data-raw/2012.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/mBWHzsujvZ7nZbe/download",destfile = "data-raw/2011.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/tx9oSTOPYrSqDhb/download",destfile = "data-raw/2010.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/QZXR9LVr4lynqbA/download",destfile = "data-raw/2009.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/WEP8Pu4sA64V7f6/download",destfile = "data-raw/2008.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/EzXry9IsLLJosSg/download",destfile = "data-raw/2007.rar")

# Agrupados por pessoa
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/35cUcYXWsrJd4tF/download",destfile = "data-raw/pessoa_2020.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/vw74viLA7WuZI4H/download",destfile = "data-raw/pessoa_2019.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/MJRqaDMQ27F60Ml/download",destfile = "data-raw/pessoa_2018.zip")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/PYMCvPsVa3ZHspf/download",destfile = "data-raw/pessoa_2017.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/xhayuB1bJhwapp7/download",destfile = "data-raw/pessoa_2016.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/hwLX6qhOh3PeYCD/download",destfile = "data-raw/pessoa_2015.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/SX9OjkKdermNOz2/download",destfile = "data-raw/pessoa_2014.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/IKvS9Ct4HrETjQV/download",destfile = "data-raw/pessoa_2013.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/SB4cbUhtNIwQ3np/download",destfile = "data-raw/pessoa_2012.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/2IWdQpI7EVj90DG/download",destfile = "data-raw/pessoa_2011.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/SUChWEElsoC1h8h/download",destfile = "data-raw/pessoa_2010.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/za17hh8I0jY9yGi/download",destfile = "data-raw/pessoa_2009.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/O805ZiovElHiwuY/download",destfile = "data-raw/pessoa_2008.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/2chKvzigLF9iZhy/download",destfile = "data-raw/pessoa_2007.rar")

# Agrupados por pessoa - Todas as causas e tipos de acidentes (a partir de 2017)
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/sdvJndbl5wLyh3J/download",destfile = "data-raw/agrupado_2019.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/EF4uPKCihT0ouXd/download",destfile = "data-raw/agrupado_2018.rar")
download.file(url = "http://arquivos.prf.gov.br/arquivos/index.php/s/kgJ0ea8QZrix5Yt/download",destfile = "data-raw/agrupado_2017.rar")
#download.file(url = "",destfile = "data-raw/agrupado_2019.rar")

# extract files
zip_files <- list.files(path = "data-raw",pattern = "agrupado",full.names = TRUE)
zip_files
# zip_file_names <- list.files(path = "data-raw/",full.names = FALSE)
# zip_file_names <- gsub(".zip","",zip_file_names)
# zip_file_names <- gsub(".rar","",zip_file_names)
# zip_file_names

for(i in seq_along(zip_files)){ # i = 25

  message(zip_files[i])
  if(zip_files[i] %like% ".rar"){
    archive_extract(archive = zip_files[i],dir =  "data/")
  }else{
    utils::unzip(zipfile = zip_files[i],exdir = "data/")
  }

}

#
# prep dnit rodovias shape
# https://www.gov.br/infraestrutura/pt-br/assuntos/dados-de-transportes/bit/bitmodosmapas#maprodo
#

br_shp <- sf::read_sf("data/rodovias-zip/rodovias.shp")
br_shp <- br_shp[br_shp$sg_uf == "PR",]
br_shp <- br_shp %>% sf::st_transform(4326)
readr::write_rds(x = br_shp,path = "data/rodovias-zip/rodovias_pr.rds",compress = "gz")
