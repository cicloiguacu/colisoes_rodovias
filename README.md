# colisoes_rodovias

O presente repositório tem objetivo de analisar os dados de colisões e atropelamentos em rodovias federais a partir da base de dados da Polícia Rodoviária Federal, disponível em <https://portal.prf.gov.br/dados-abertos-acidentes>.

##### **Etapas**
As etapas de processamento estão apresentadas por ordem os scripts, que tem os seguintes objetivos:

`1_download_PRF.R`: baixa todos os registros na página da PRF

`2_read_PRF.R`: realiza o pré-processamento dos dados (agrupados por pessoa) baixados e faz limpeza dos dados

`2_read_PRF_spatial.R`: realiza o pré-processamento dos dados (Agrupados por pessoa - Todas as causas e tipos de acidentes -a partir de 2017) baixados e faz limpeza dos dados

`3_plot_PRF.R`: geração dos gráficos

`4_map_PRF.R`: geração dos mapas

`5_memoria_de_calculo.R`: faz algumas estimativas pontuais para fins de discussão do relatório

##### **Contato**

Dúvidas e/ou sugestões podem ser direcionadas nas issues do repositório ou pelo e-mail `joao.bazzo@gmail.com`
