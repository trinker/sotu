# #' A \code{data_store} Object for the United States Presidential State of the Union Addresses
# #'
# #' A dataset containing a list of data elements created by \pkg{hclustext}'s
# #' \href{https://github.com/trinker/hclustext/blob/master/R/data_store.R}{\code{data_store}}.
# #'
# #' @details
# #' \describe{
# #'   \item{dtm}{A \code{DocumentTermMatrix} (documents: 23,521, terms: 25,847)
# #'   with common stop words removed.  Each row corresponds to a paragraph from
# #'   an address from the original \code{sotu} data set.}
# #'   \item{text}{The text vector of address paragraphs.}
# #'   \item{removed}{The non information elements removed from the original text
# #'   vector passed to \code{data_store}.}
# #'   \item{n.nonsparse}{The 1,278,450 non-zero elements of the \code{DocumentTermMatrix}.}
# #' }
# #'
# #' @docType data
# #' @keywords datasets
# #' @name sotu_ds
# #' @usage data(sotu_ds)
# #' @format A list with 4 elements
# #' @references
# #' Peters, G. & Woolley, J. T. (1999). The American Presidency Project.
# #' Retrieved from \url{http://www.presidency.ucsb.edu} \cr
# #'
# #' Col, J. (2001). The Presidents of the United States of America. Retrieved
# #' from \url{http://www.enchantedlearning.com/history/us/pres/list.shtml}
# NULL
