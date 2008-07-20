#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'errorHandler' <-
function(x) {

  # Error Handling
#  if(header$commandStatus==2) {
#    error <- 'r(198);'
#    return(error)
#    error <- list()
#    error$errorCode <- readBin(res$body[1:2], integer(), size=2); loc <- 2
#    error$errorDescLen <- readBin(res$body[-c(1:loc)], integer(), size=2);loc <- loc + 2
#    error$errorDesc <- readBin(res$body[-c(1:loc)], character(), size=resBody$errorDescLen)
#    error <- unlist(reqBody, use.names=FALSE)
#    return(error)
#  }

#  if(header$commandType==OT$INT_UNKNOWN) {
#    stop('Unknown Command')
#  }
  return(x)
}
