#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'errorHandler' <-
function(header, body, ok=NULL, customMessage=FALSE) {

  if(header$cmdStatus==2) {
    
    error <- unpack('v v/A', body)
    names(error) <- c('value','description')

    if(error[[1]] %in% ok) {
      return()
    } else {
      stop('FROM OT SERVER : ', error$description, call.=FALSE)
    }
  } else {
    return()
  }
}

'loggedIn' <-
function() {

  otPar <- getParams()
  
  if(otPar$loggedIn) {
    return(invisible())
  } else {
    stop('Not logged in', call.=FALSE)
  }
}
