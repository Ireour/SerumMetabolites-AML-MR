##系统报错改为英文
Sys.setenv(LANGUAGE = "en")
##禁止转化为因子
options(stringsAsFactors = FALSE)
##清空环境
rm(list=ls())
gc()
dev.off()
dev.new()
##设置路径
setwd("C:/Code/R/MR/data")
getwd()
##加载R包
library(TwoSampleMR)
library(dplyr)
library(data.table)
##获取当前工作目录下所有文件
exposure_files <- list.files(pattern = "^final_(M\\d+)\\.csv$")
for (exposure_file in exposure_files) {
  id <- sub("^final_(M\\d+)\\.csv$", "\\1", exposure_file)
  outcome_file <- paste0(id, "_outcome.csv")
  cat("正在处理：", exposure_file, "与", outcome_file, "\n")
  
  exposure_dat <- read_exposure_data(
    filename = exposure_file,
    sep = ",",
    snp_col = "SNP",
    beta_col = "beta.exposure",
    se_col = "se.exposure",
    eaf_col = "eaf.exposure",
    effect_allele_col = "effect_allele.exposure",
    other_allele_col = "other_allele.exposure",
    pval_col = "pval.exposure",
    chr_col = "chr.exposure",
    pos_col = "pos.exposure",
    clump = FALSE
  )
  
  outcome_dat <- read_outcome_data(
    filename = outcome_file,
    sep = ",",
    snp_col = "SNP",
    beta_col = "beta.outcome",
    se_col = "se.outcome",
    eaf_col = "eaf.outcome",
    effect_allele_col = "effect_allele.outcome",
    other_allele_col = "other_allele.outcome",
    pval_col = "pval.outcome",
    chr_col = "chr.outcome",
    pos_col = "pos.outcome",
  )
  
  ##数据校准
  dat <- harmonise_data(
    exposure_dat = exposure_dat,
    outcome_dat = outcome_dat,
    action = 2
  )
  dat <- subset(dat, mr_keep == TRUE)
  
  ##保存数据
  output_file <- paste0(id, ".csv")
  write.csv(dat, file = output_file, row.names = FALSE)
  cat("已保存为：", output_file, "\n\n")
}

