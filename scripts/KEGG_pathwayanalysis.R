library(tidyverse)
library(ggplot2)
library(EnhancedVolcano)
library(clusterProfiler) 
library(org.Hs.eg.db) 
library(gplots)
library(readxl)
library(writexl)

#------------------------------------------------------------------------------#
# Reading in the data ####
#------------------------------------------------------------------------------#
p.level <- 0.05
q.level <- 0.05
pval.enr <- 0.05
qval.enr <- 0.05

#Hospitalised cases####
#Prepare data
Hosp <- read_csv("data/proc/hosp_entrez_211027.csv")
Hosp_All_sig <- Hosp %>% dplyr::filter(qvalue <= q.level)


#Severe cases####
#Prepare data
Severe <- read_csv("data/proc/severe_entrez_211027.csv")
Sev_All_sig <- Severe %>%dplyr::filter(qvalue <= q.level)


#------------------------------------------------------------------------------#
# KEGG Analyses ####
#------------------------------------------------------------------------------#

KEGG_hosp <- enrichKEGG(Hosp_All_sig$ENTREZID, 
                        universe = paste(Hosp$ENTREZID),
                        pAdjustMethod = "fdr",
                        organism = "hsa", 
                        keyType = "ncbi-geneid", 
                        pvalueCutoff = pval.enr, 
                        use_internal_data = FALSE)

dt_KEGG_hosp <- KEGG_hosp@result
View(dt_KEGG_hosp)

KEGG_sev <- enrichKEGG(Sev_All_sig$ENTREZID, 
                       universe = paste(Severe$ENTREZID),
                       pAdjustMethod = "fdr",
                       organism = "hsa", 
                       keyType = "ncbi-geneid", 
                       pvalueCutoff = pval.enr, 
                       use_internal_data = FALSE)

dt_KEGG_sev <- KEGG_sev@result 
View(dt_KEGG_sev)
