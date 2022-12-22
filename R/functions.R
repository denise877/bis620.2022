#@x should be a LBTEST full name, y is the dataset
#with lab standards information
find_max_labs <- function(x) {
  #find the max visiting days for each subject on x
  y <- dl[[2]]
  temp1 <- y |>
    dplyr::filter(LBTEST == x)|>
    dplyr::group_by(SUBJID)|>
    dplyr::summarise(max_day = max(VISITDY), lab_standard = x)

  # we don't want the max visit day is the same as baseline, because there is no
  # change in the lab standard, so we exclude the condition LBBASE='Y'
  max_data <- temp1 |>
    dplyr::left_join(y, by = c("SUBJID", "max_day" = "VISITDY",
                       "lab_standard" = "LBTEST")) |>
    dplyr::filter(LBBASE == "N")|>
    dplyr::mutate(max_labs = LBSTRESN)|>
    dplyr::select(SUBJID, lab_standard, max_labs)
  return(max_data)
}

#@x should be a LBTEST full name, y is the
# dataset with lab standards information
#find the baseline lab standards for each subject on x
find_base_labs <- function(x) {
  y <- dl$adlb
  base_data <- y|>
    dplyr::filter(LBBASE == "Y", LBTEST == x)|>
    dplyr::select(SUBJID, LBSTRESN)
  return(base_data)
}

# Plot the histogram of numbers of "Mutant", "Wild-type" and "Unknown" biomarker

# Obtain the status of some groups of genes.
# If there is more than 0 mutant gene the biomarker will be noted as mutant
get_biomarker <- function(x) {
  if (x[["Mutant"]] > 0) {
    return("Mutant")
  }
  if (x[["Wild-type"]] >  x[["Unknown"]]) {
    return("Wild-type")
  }
  return("Unknown")
}

get_nras <- function() {
  nras <- dl$biomark |>
    dplyr::select(SUBJID, BMMTNM4:BMMTR6, BMMTNM16, BMMTR16) |>
    pivot_longer(-SUBJID) |>
    dplyr::group_by(SUBJID) |>
    dplyr::summarize(
      Mutant = sum(value == "Mutant"),
      Unknown = sum(value == "" | value == "Failure"),
      `Wild-type` = sum(value == "Wild-type")
    )
  nras$biomarker <- purrr::map_chr(seq_len(nrow(nras)),
                                   ~ get_biomarker(nras[.x, ]))
  return(nras)
}

get_lab_std <- function(labname) {
  labs <- dl$adlb
  max_std <- find_max_labs(labname)
  base_std <- find_base_labs(labname)
  out <- base_std |>
    dplyr::inner_join(max_std) |>
    dplyr::mutate(change_of_albumin = max_labs - LBSTRESN)|>
    dplyr::select(SUBJID, change_of_albumin)
  out <- na.omit(out)
  colnames(out) <- c("SUBJID", labname)
  return(out)
}

get_nras_table <- function() {
  nras <- get_nras()
  nras <- dplyr::left_join(
    nras |>
      dplyr::filter(biomarker != "Unknown)") |>
      dplyr::select(SUBJID, biomarker),
    dl$adsl |>
      dplyr::select(SUBJID, RACE, AGE, SEX,
                    B_WEIGHT, B_HEIGHT, PRSURG, DTH, TRT),
    by = "SUBJID"
  ) |>
    dplyr::filter(biomarker != "Unknown")
  nras$RACE <- as.numeric(as.factor(nras$RACE))
  nras$SEX <- as.numeric(as.factor(nras$SEX))
  nras$biomarker <- as.numeric(as.factor(nras$biomarker))
  nras$TRT <- as.numeric(as.factor(nras$TRT))
  nras$PRSURG <- as.numeric(as.factor(nras$PRSURG))
  return(nras)
}

get_kras <- function() {
  kras <- dl$biomark |>
    dplyr::select(SUBJID, BMMTNM1, BMMTNM2, BMMTNM3, BMMTNM15,
           BMMTR1, BMMTR2, BMMTR3, BMMTR15) |>
    pivot_longer(-SUBJID) |>
    dplyr::group_by(SUBJID) |>
    dplyr::summarize(
      Mutant = sum(value == "Mutant"),
      Unknown = sum(value == "" | value == "Failure"),
      `Wild-type` = sum(value == "Wild-type")
    )
  kras$biomarker <- purrr::map_chr(seq_len(nrow(kras)),
                                   ~ get_biomarker(kras[.x, ]))
  return(kras)
}

get_kras_table <- function() {
  kras <- get_kras()
  kras <- dplyr::left_join(
    kras |>
      dplyr::filter(biomarker != "Unknown)") |>
      dplyr::select(SUBJID, biomarker),
    dl$adsl |>
      dplyr::select(SUBJID, RACE, AGE, SEX,
                    B_WEIGHT, B_HEIGHT, PRSURG, DTH, TRT),
    by = "SUBJID"
  ) |>
    dplyr::filter(biomarker != "Unknown")
  kras$RACE <- as.numeric(as.factor(kras$RACE))
  kras$SEX <- as.numeric(as.factor(kras$SEX))
  kras$biomarker <- as.numeric(as.factor(kras$biomarker))
  kras$TRT <- as.numeric(as.factor(kras$TRT))
  kras$PRSURG <- as.numeric(as.factor(kras$PRSURG))
  return(kras)
}

get_gender_interval <- function(gender, sig) {
  total <- dl$adsl
  total_male <- total[which(total$SEX == gender), ]
  n1 <- sum(total_male$TRT == "FOLFOX alone")
  n2 <- sum(total_male$TRT == "Panitumumab + FOLFOX")
  phat1 <- sum(total_male$DTH[total_male$TRT == "FOLFOX alone"]) /
    length(total_male$DTH[total_male$TRT == "FOLFOX alone"])
  phat2 <- sum(total_male$DTH[total_male$TRT == "Panitumumab + FOLFOX"]) /
    length(total_male$DTH[total_male$TRT == "Panitumumab + FOLFOX"])
  est <- phat1 - phat2
  int_len <- sqrt(phat1 * (1 - phat1) / n1 +
                    phat2 * (1 - phat2) / n2) * qnorm(sig)
  itvl <- c(est - int_len, est + int_len)
  return(itvl)
}

get_nras_interval <- function(biomk, sig) {
  nras <- get_nras_table()
  nras_sele <- nras[which(nras$biomarker == biomk), ]
  n1 <- sum(nras_sele$TRT == 1)
  n2 <- sum(nras_sele$TRT == 2)
  phat1 <- sum(nras_sele$DTH[nras_sele$TRT == 1]) /
    length(nras_sele$DTH[nras_sele$TRT == 1])
  phat2 <- sum(nras_sele$DTH[nras_sele$TRT == 2]) /
    length(nras_sele$DTH[nras_sele$TRT == 2])
  est <- phat1 - phat2
  int_len <- sqrt(phat1 * (1 - phat1) / n1 +
                    phat2 * (1 - phat2) / n2) * qnorm(sig)
  itvl <- c(est - int_len, est + int_len)
  return(itvl)
}

get_kras_interval <- function(biomk, sig) {
  kras <- get_kras_table()
  kras_sele <- kras[which(kras$biomarker == biomk), ]
  n1 <- sum(kras_sele$TRT == 1)
  n2 <- sum(kras_sele$TRT == 2)
  phat1 <- sum(kras_sele$DTH[kras_sele$TRT == 1]) /
    length(kras_sele$DTH[kras_sele$TRT == 1])
  phat2 <- sum(kras_sele$DTH[kras_sele$TRT == 2]) /
    length(kras_sele$DTH[kras_sele$TRT == 2])
  est <- phat1 - phat2
  int_len <- sqrt(phat1 * (1 - phat1) / n1 +
                    phat2 * (1 - phat2) / n2) * qnorm(sig)
  itvl <- c(est - int_len, est + int_len)
  return(itvl)
}

get_albumin_interval <- function(sig) {
  albu <- get_lab_std("Albumin")
  bigtable <- dplyr::inner_join(dl$adsl, albu, by = "SUBJID")
  n2 <- sum(bigtable$DTH == 1)
  n1 <- sum(bigtable$DTH == 0)
  alb1 <- mean(bigtable[which(bigtable$DTH == 0), ]$Albumin)
  alb2 <- mean(bigtable[which(bigtable$DTH == 1), ]$Albumin)
  albs1 <- var(bigtable[which(bigtable$DTH == 0), ]$Albumin)
  albs2 <- var(bigtable[which(bigtable$DTH == 1), ]$Albumin)
  albest <- alb1 - alb2
  intlen <- sqrt(albs1 / n1 + albs2 / n2) * qnorm(sig)
  return(c(albest - intlen, albest + intlen))
}


get_gender_albumin <- function(gender, sig) {
  total <- dl$adsl
  total_gender <- total[which(total$SEX == gender), ]
  albu <- get_lab_std("Albumin")
  bigtable <- dplyr::inner_join(total_gender, albu, by = "SUBJID")
  n1 <- sum(bigtable$TRT == "FOLFOX alone")
  n2 <- sum(bigtable$TRT == "Panitumumab + FOLFOX")
  alb1 <- mean(bigtable[which(bigtable$TRT == "FOLFOX alone"),
                        ]$Albumin)
  alb2 <- mean(bigtable[which(bigtable$TRT == "Panitumumab + FOLFOX"),
                        ]$Albumin)
  albs1 <- var(bigtable[which(bigtable$TRT == "FOLFOX alone"),
                        ]$Albumin)
  albs2 <- var(bigtable[which(bigtable$TRT == "Panitumumab + FOLFOX"),
                        ]$Albumin)
  albest <- alb1 - alb2
  intlen <- sqrt(albs1 / n1 + albs2 / n2) * qnorm(sig)
  return(c(albest - intlen, albest + intlen))
}

get_nras_albumin <- function(biomk, sig) {
  nras <- get_nras_table()
  nras_sele <- nras[which(nras$biomarker == biomk), ]
  albu <- get_lab_std("Albumin")
  bigtable <- dplyr::inner_join(nras_sele, albu,
                         by = "SUBJID")
  n1 <- sum(bigtable$TRT == 1)
  n2 <- sum(bigtable$TRT == 2)
  alb1 <- mean(bigtable[which(bigtable$TRT == 1), ]$Albumin)
  alb2 <- mean(bigtable[which(bigtable$TRT == 2), ]$Albumin)
  albs1 <- var(bigtable[which(bigtable$TRT == 1), ]$Albumin)
  albs2 <- var(bigtable[which(bigtable$TRT == 2), ]$Albumin)
  albest <- alb1 - alb2
  intlen <- sqrt(albs1 / n1 + albs2 / n2) * qnorm(sig)
  return(c(albest - intlen, albest + intlen))
}

get_kras_albumin <- function(biomk, sig) {
  kras <- get_kras_table()
  kras_sele <- kras[which(kras$biomarker == biomk), ]
  albu <- get_lab_std("Albumin")
  bigtable <- dplyr::inner_join(kras_sele, albu,
                         by = "SUBJID")
  n1 <- sum(bigtable$TRT == 1)
  n2 <- sum(bigtable$TRT == 2)
  alb1 <- mean(bigtable[which(bigtable$TRT == 1), ]$Albumin)
  alb2 <- mean(bigtable[which(bigtable$TRT == 2), ]$Albumin)
  albs1 <- var(bigtable[which(bigtable$TRT == 1), ]$Albumin)
  albs2 <- var(bigtable[which(bigtable$TRT == 2), ]$Albumin)
  albest <- alb1 - alb2
  intlen <- sqrt(albs1 / n1 + albs2 / n2) * qnorm(sig)
  return(c(albest - intlen, albest + intlen))
}
