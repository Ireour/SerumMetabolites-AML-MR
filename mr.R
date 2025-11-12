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
##获取当前路径下所有的文件
file_list <- list.files(pattern = "\\.csv$")
##初始化结果列表
all_results <- list()
##遍历每个文件
for (file in file_list) {
  cat("读取文件：", file, "\n")
  ##读取数据
  dat <- read.csv(file, stringsAsFactors = FALSE)
  ##保留可以用于 MR 分析的 SNP
  dat <- subset(dat, mr_keep == TRUE)
  ##如果没有有效 SNP，跳过
  if (nrow(dat) < 3) {
    cat("文件" ,file, " 中有效 SNP 少于 3 个，跳过。\n")
    next
  }
  ##执行 MR 分析
  result <- mr(dat)
  
  # 添加结果到总列表
  all_results[[file]] <- result
}

# 合并所有结果为一个数据框
combined_results <- do.call(rbind, all_results)

# 输出到文件（可选）
write.csv(combined_results, "MR_results_all.csv", row.names = TRUE)

