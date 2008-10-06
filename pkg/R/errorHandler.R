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

'connected' <-
function(stop=TRUE) {
  open <- TRUE
  debug <- FALSE
  
  # Check if server is listening on connection
  if(open) {
    suppressWarnings({
      canWrite <- socketSelect(list(getSocket()), write=TRUE, timeout=1)
    })
    if(debug) cat('open1',canWrite,'\n')
    if(!canWrite) open <- FALSE
  }
  # If we can write to connection, see if server accepts request
  if(open) {
    Sys.sleep(0.5)
    canWrite <- try(sendRequest(OT$HEARTBEAT, 0, raw(0)),silent=TRUE)
    canWrite <- inherits(canWrite,'try-error')
    if(debug) cat('open2',canWrite,'\n')
    if(!canWrite) open <- FALSE
  }
  # Try again, because sometimes previous request causes
  # server to drop connection
  if(open) {
    Sys.sleep(0.5)
    canWrite <- try(sendRequest(OT$HEARTBEAT, 0, raw(0)),silent=TRUE)
    canWrite <- inherits(canWrite,'try-error')
    if(debug) cat('open3',canWrite,'\n')
    if(!canWrite) open <- FALSE
  }
  # See if server is still listening
  if(open) {
    suppressWarnings({
      canWrite <- socketSelect(list(getSocket()), write=TRUE, timeout=3)
    })
    if(debug) cat('open4',canWrite,'\n')
    if(!canWrite) open <- FALSE
  }

  if(stop) {
    stop('Not Connected', call.=FALSE)
  } else {
    return(open)
  }
}
