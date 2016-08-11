#' Exponentially Weighted Moving Average Graph Function
#'
#' This function takes the results of an EWMA filter (such as the list returned by ewma_function) and generates a line graph of EWMA statistic and upper control limit (UCL) by reaction time.
#' @param ewma_results List that must contain a cutoff reaction time called "cutoff" and a dataframe, called "results," with a column of EWMA statistics called "cs", a column of UCLs called "UCL," and a column of reaction times called "rt."
#' @keywords ewma ddm hddm graph
#' @export
#' @return Lineplot of EWMA statistics and UCLs by reaction time. 
#' ewma_graph()

ewma_graph <- function(ewma_results){
  results <- as.data.frame(ewma_results['results'])
  cutoff <- as.numeric(ewma_results['cutoff'])
  plot <- ggplot(results, aes(results.rt)) +
    geom_line(aes(y = results.cs, color = "cs")) +
    geom_line(aes(y = results.ucl, color = "UCL")) +
    geom_vline(aes(xintercept = cutoff), linetype = 2) +
    ylab("Moving Average") + xlab("Reaction Time") +
    theme(text = element_text(size = 20))
  
  return(plot)
}