#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

#'getMAC' <- function()

'getOS' <-
function() {
  
  os <- OT$OS_UNKNOWN
  osStr <- sessionInfo()$R.version$os

  # This is probably a bug-prone way to determine the OS...
  # but it works for me ;)
  if( regexpr('.*(nux|nix|osx).*', osStr, TRUE)>0 ) {
    os <- OT$OS_LINUX
  } else if( regexpr('.*XP.*',   osStr)>0 ) {
    os <- OT$OS_WINXP
  } else if( regexpr('.*2000.*', osStr)>0 ) {
    os <- OT$OS_WIN2000
  } else if( regexpr('.*NT.*',   osStr)>0 ) {
    os <- OT$OS_WINNT
  } else if( regexpr('.*Mill.*', osStr)>0 ) {
    os <- OT$OS_WINME
  } else if( regexpr('.*98SE.*', osStr)>0 ) {
    os <- OT$OS_WIN98SE
  } else if( regexpr('.*98.*',   osStr)>0 ) {
    os <- OT$OS_WIN98
  } else if( regexpr('.*95.*',   osStr)>0 ) {
    os <- OT$OS_WIN95
  }
  return(os)
}

'getRequestID' <-
function() {
  
  x <- getParams()
  x$requestID <- x$requestID + 1
  setParams(x)

  return(x$requestID)
}

