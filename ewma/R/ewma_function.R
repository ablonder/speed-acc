#' Exponentially Weighted Moving Average Function
#'
#' Calculates the EWMA statistic and upper control limit (UCL) for each trial in a dataframe in order of reaction time. It also generates a cutoff threshold past which accuracy should be above chance.
#' @param data The dataframe you want to run the EWMA for, must include binary responses in a column named "correct" and reaction times in a column named "RT"
#' @param lambda Weight of previously calculated EWMA statistics. Between 0 and 1. If 1, only the current observation is used. If 0, all previous observations are weighted equally. Defaults to .01
#' @param cs Control mean, used as the previous EWMA statistic for the first iteration. Defaults to .5 (chance)
#' @param sigma Control standard deviation. Defaults to .5
#' @param L Width of control limits in standard deviations. Low to ensure a sensitive test. Defaults to 1.5
#' @keywords ewma ddm hddm
#' @export
#' @return List containing the generated cutoff threshold and a dataframe of EWMA statistics and UCLs for each trial with their corresponding reaction times.

ewma_function <- function(data, lambda = .01, cs = .5, sigma = .5, L = 1.5){
  data <- arrange(data, RT)
  results <- data.frame(rt = integer(), cs = integer(), ucl = integer())
  for(row in 1:nrow(data)){
    subj <- data[row, ]
    acc <- as.integer(subj["correct"])
    rt <- as.integer(subj["RT"])
    cs <- lambda*acc + (1-lambda)*cs # weighted average for each rt (row)
    UCL <- .5 + L*sigma*sqrt((lambda/(2 - lambda))*(1-((1-lambda)^(2*row)))) # threshold
    results[row, ] <- c(rt, cs, UCL)
    if(row != 1 && cs < UCL)
      cutoff <- rt
  }
  
  return(list(cutoff = cutoff, results = results))
}