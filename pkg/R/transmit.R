#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'sendRequest' <-
function(connection, commandType, requestID, msgBody) {

  # Create Message Header
  msgHeader <-
    pack("C C x x V V",
    OT$MES_REQUEST,      # Message Type
    OT$STATUS_OK,        # Command Status
    commandType,         # Command Type
    requestID)           # Request ID
  
  # Get Message Length
  msgLength <- pack("V",NROW(c(msgHeader,msgBody)))
  
  # Send Message
  writeBin(c(msgLength,msgHeader,msgBody), connection$connection)

  return(invisible())
}

'getResponse' <-
function(connection, nullError=TRUE, ...) {
  
  # Server Response Length
  msgLen <- readBin(connection$connection, integer(), size=4)
  
  if( length(msgLen) ) {
    # Server Response Header
    # Message Type, Command Status, Reserved Bytes, Command Type, Request ID
    header <- unpack('C C v V V', readBin(connection$connection, raw(), 12))
    names(header) <- c('msgType','cmdStatus','resvd','cmdType','requestID')

    # Server Response Body
    body <- readBin(connection$connection, raw(), msgLen-12)

    # Check for errors
    errorHandler(header, body, ...)

    return(list(header=header,body=body))
  } else {
    if(nullError) {
      stop('No server response', call.=FALSE)
    } else {
      return()
    }
  }
}

