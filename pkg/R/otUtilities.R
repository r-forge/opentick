#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'transmit' <-
function(connection, commandType, msgBody) {


  # Create Message Header
  # Message Type, Command Status, Reserved Bytes, Command Type, Request ID
  #msgHeader <- pack("C C x x V V", 1, 1, commandType, requestID)
  msgHeader <- pack("C C x x V V", 1, 1, commandType, connection$requestID+1)
  
  # Get Message Length
  msgLength <- pack("V",NROW(c(msgHeader,msgBody)))
  
  # Send Message
  writeBin(c(msgLength,msgHeader,msgBody), connection$connection)

  # Server Response Length
  resLength <- readBin(connection$connection, integer(), size=4)
  
  # Server Response Header
  # Message Type, Command Status, Reserved Bytes, Command Type, Request ID
  resHeader <- unpack('C C v V V', readBin(connection$connection, raw(), 12))
  names(resHeader) <- c('msgType','cmdStatus','resvd','cmdType','requestID')
  
  # Server Response Body
  resBody <- readBin(connection$connection, raw(), resLength-12)

  result <- list(length=resLength,header=resHeader,body=resBody)
  return(result)
  #return(structure(result, class='otResponse'))
}

#'getMAC' <- function()

'getOS' <- function() {
  
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
