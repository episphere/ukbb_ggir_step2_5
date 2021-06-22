#!/usr/bin/env Rscript

library(argparse)
suppressPackageStartupMessages(library(tidyverse))
parser <- ArgumentParser()
#required = parser$add_argument_group('required arguments')
#required$add_argument("-f0", type="integer", help="first file index (start at 1)", required=TRUE)
#required$add_argument("-f1", type="integer", help="last file index (start at 1)", required=TRUE)
parser$add_argument("nproc",nargs=1,type="integer", help="number of processes")
parser$add_argument("f0",nargs=1,type="integer", help="first file index (start at 1)")
parser$add_argument("f1",nargs=1,type="integer", help="last file index (start at 1)")
parser$add_argument("datadir",nargs=1,help="root of GGIR step 1 results")
args <- parser$parse_args()

create_swarm <-function(args){
  swarmfile <- paste0("swarm_",args$f0,"_",args$f1,".swarm")
  if (file.exists(swarmfile)) stop(swarmfile," exists")
  x= with(args,f0:f1)
  x = split(x,sort(rank(x) %% args$nproc) ) %>% map(~c(min(.x),max(.x)))
  f0 <- map_int(x,min)
  f1 <- map_int(x,max)

  script <- "/data/druss/ukbb/GGIR_pipeline2_5/ggir_pipeline_steps2_5.R"
  
  f0 %>% map2(f1,~paste0("time Rscript ",script," ",args$datadir," ",.x," ",.y )) %>% 
    unlist %>%
    cat(file=swarmfile,sep = "\n")
}

main<-function(args){
  create_swarm(args)
  invisible()
}

main(args)

