suppressPackageStartupMessages(library(tidyverse))
library(boxr)
library(GGIR)
library(argparse)

build_dirs <- function(root){
  dir.create(root,showWarnings = FALSE,recursive = T)
  build_branch <- function(branch_dir,kids){
    dir.create(branch_dir,showWarnings = F)
    kids %>% walk(~dir.create(file.path(branch_dir,.),showWarnings = FALSE) )
  }
  
  # first the meta branch...
  build_branch(file.path(root,"meta"),c("basic","csv") )
  build_branch(file.path(root,"results"),c("file summary reports","QC") )
}

stage_input_files <-function(remote_root,local_root,f0=1,f1=0){
  if (!file.exists(remote_root)) stop(remote_root," does not exist")
  from_dir <- file.path(remote_root,"meta","basic")
  
  ## build the dir structure for the local remote
  build_dirs(local_root)
  to_dir <- file.path(local_root,"meta","basic")
  if (!file.exists(to_dir)) stop("could not create ",to_dir)
  
  f0 = as.integer(f0)
  files <- list.files(from_dir)
  if (f0>length(files)) stop("f0 (",f0,") is larger than the number of files (",length(files),"). ")
  if (f0<1) stop("f0 (",f0,") is less than 1")
  if (f1==0 || f1>length(files)) f1=length(files)
  if (f1<f0) stop("f1 (",f1,") is less than f0 (",f0,")")
  
  ok <- file.copy(file.path(from_dir,files[f0:f1]),to_dir)
  if (!all(ok)){
    message("trouble staging files:")
    print(files[f0:f1][!ok])
  }
}

stage_results <- function(local_root,remote_root,f0,f1){
  print(local_root)
  print(remote_root)
  if (!file.exists(local_root)) stop(local_root," does not exist")
  if (!file.exists(remote_root)) stop(remote_root," does not exist")
  
  current_files <- list.files(file.path(local_root,"results"),recursive = T,include.dirs = T)
  to_files <- ifelse(startsWith(basename(current_files),"Report"),current_files,sub("(.csv|.pdf)$",paste0("_",f0,"_",f1,"\\1"),current_files) )
  print(to_files)
    
  local_res <- file.path(local_root,"results")
  to_res <- file.path(remote_root,"results")
  from_files <- file.path(local_res,current_files)
  to_files <- file.path(to_res,to_files)

  print(from_files)
  print(to_files)
  ok <- file.copy(from_files,to_files)
  if (!all(ok)){
     message("trouble staging results:")
     print(current_files[!ok])
   }
} 

#stage_root <- "/lscratch/17581223/stage/"
#stage_final <- "/data/UKBB_Matthews"
#stage_results(stage_root,stage_final)

run_ggir<-function(datadir){
  g.shell.GGIR(
    mode=2:5,
    metadatadir=dirname(datadir),
    outputdir = dirname(datadir),
    studyname="accelerometer",
    do.report=c(2,4,5),
    #=====================
    # Part 2
    #=====================
    strategy = 1,
    hrs.del.start = 0,          hrs.del.end = 0,
    maxdur = 9,                 includedaycrit = 16,
    qwindow=c(0,24),
    mvpathreshold =c(125),
    bout.metric = 4,
    excludefirstlast = FALSE,
    includenightcrit = 16,
    epochvalues2csv = TRUE,
    #=====================
    # Part 3 + 4
    #=====================
    def.noc.sleep = 1,
    nnights = 7,
    relyonguider=FALSE,
    outliers.only = TRUE,
    criterror = 4,
    do.visual = TRUE,
    excludefirst.part4=FALSE,
    #=====================
    # Part 5
    #=====================
    strategy=1, 
    maxdur=7, hrs.del.start=0, hrs.del.end =0,
    excludefirstlast.part5=FALSE, 
    windowsizes=c(5,900,3600),acc.metric="ENMO", boutcriter.mvpa=0.9, 
    boutcriter.in=0.9, boutcriter.lig=0.9, storefolderstructure=FALSE, 
    threshold.lig = c(40,30), threshold.mod = c(100,125),
    threshold.vig = c(400), timewindow=c("MM","WW"), 
    boutdur.mvpa = c(1,5,10), boutdur.in = c(10,20,30), 
    boutdur.lig = c(1,5,10), winhr = 2, M5L5res = 10,
    overwrite=TRUE, desiredtz="", 
    bout.metric=4, dayborder=0, save_ms5rawlevels=TRUE, do.parallel=FALSE,
    part5_agg2_60seconds = FALSE, save_ms5raw_format="csv",
    save_ms5raw_without_invalid=FALSE,
    data_cleaning_file=c(), includedaycrit.part5=2/3,includedaycrit.part5=TRUE,
    ignorenonwear=TRUE,
    
    
    #=====================
    # Visual report
    #=====================
    timewindow = c("WW"),
    visualreport=TRUE)
}

get_stage_root <- function(){
  if (nchar(Sys.getenv("SLURM_ARRAY_TASK_ID"))>0 ){
    # we are running as part of a swarm
    # the local scratch space is /lscratch/${SLURM_JOB_ID}...
    # Create a subdirectory /lscratch/${SLURM_JOB_ID}/${SLURM_ARRAY_TAKS_ID}/accelerometer
    # if we have two jobs running on the same node, we dont want them copying to the
    # same directory...
    tmp_dir = paste0("/lscratch/",Sys.getenv("SLURM_JOB_ID"),"/",Sys.getenv("SLURM_ARRAY_TASK_ID"),"/stage/output_accelerometer")
  } else if (nchar(Sys.getenv("SLURM_JOB_ID"))>0 ) {
    # we are not part of a swarm but on a biowulf node ...
    tmp_dir = paste0("/lscratch/",Sys.getenv("SLURM_JOB_ID"),"/stage/output_accelerometer")
  } else{
    ## not sure where I am...
    tmp_dir = file.path(tempdir(),"stage")
  }
  tmp_dir
}

cleanup <- function(stage_root){
  if (startsWith(stage_root,"/lscratch")) {
    unlink(stage_root,recursive = T)
  }
}

run_ggir_step2_5 <- function(data_root,f0,f1,cleanup=TRUE){
  stage_root <- get_stage_root()
  stage_input_files(data_root,stage_root,f0,f1)
  run_ggir(datadir = stage_root )
  stage_results(stage_root,data_root,f0,f1)
  if (cleanup){
    cleanup(stage_root)
  }
}

main <- function(){
  parser <- ArgumentParser()
  parser$add_argument("datadir",nargs=1,help="root of GGIR step 1 results")
  parser$add_argument("f0",nargs=1,type="integer", help="first file index (start at 1)")
  parser$add_argument("f1",nargs=1,type="integer", help="last file index (start at 1)")
  args <- parser$parse_args()
  
  run_ggir_step2_5(args$datadir,args$f0,args$f1)
}

if (Sys.info()['sysname']=="Darwin"){
  message("debugging on my mac...")
}else {
  main()
}
