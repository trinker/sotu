#' United States Presidential State of the Union Addresses
#'
#' A dataset containing United States Presidential State of the Union Addresses.
#' SOTU address data scraped from Peters, G. & Woolley, J. T. (1999) and
#' augmented with demographic information scraped from Col, J. (2001).  At the
#' time of the scrape (2016-02-07) the \file{robots.txt} permitted the scrape.
#'
#' @details
#' \itemize{
#'   \item id. The ID number given by The American Presidency Project.  Each
#'   address gets a unique ID number.
#'   \item Order. A number corresponding to the order in which the personw as
#'   president.  Persons serving non-consecutive terms get an \code{Order} ID
#'   for each period.
#'   \item President. The name of the President.
#'   \item Party. The political afficiliation of the president.
#'   \item Born. Year the President was born.
#'   \item Died. Year the President died.
#'   \item Start. Year of start of the term(s).
#'   \item End. Year of end of the term(s)
#'   \item Delivered. Date the address was delivered.
#'   \item Word_Count. Word count of the text chunk (paragraph).
#'   \item Paragraph. The paragraph number (ordered) of the address text.
#'   \item Text. The address text.
#' }
#'
#' @docType data
#' @keywords datasets
#' @name sotu
#' @usage data(sotu)
#' @format A data frame with 23531 rows and 12 variables
#' @references
#' Peters, G. & Woolley, J. T. (1999). The American Presidency Project.
#' Retrieved from \url{http://www.presidency.ucsb.edu} \cr
#'
#' Col, J. (2001). The Presidents of the United States of America. Retrieved
#' from \url{http://www.enchantedlearning.com/history/us/pres/list.shtml}
NULL
