#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'sendRequest' <-
function(commandType, requestID, msgBody) {

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
  writeBin(c(msgLength,msgHeader,msgBody), getSocket())

  return(invisible())
}

'getResponse' <-
function(nullError=TRUE, ...) {
  
  # Server Response Length
  msgLen <- readBin(getSocket(), integer(), size=4)
  
  if( length(msgLen) ) {
    # Server Response Header
    # Message Type, Command Status, Reserved Bytes, Command Type, Request ID
    header <- unpack('C C v V V', readBin(getSocket(), raw(), 12))
    names(header) <- c('msgType','cmdStatus','resvd','cmdType','requestID')

    # Server Response Body
    body <- readBin(getSocket(), raw(), msgLen-12)

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

'cancelRequest' <-
function(requestID, cmdType, ...) {
  
  # Create connection parameters
  otPar <- getParams()

  # Construct Message Body
  msgBody <- pack('a64 V',
    otPar$sessionID,  # Session ID
    requestID)        # Request ID
  
  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(cmdType, reqID, msgBody)
  
  # Server response
  response <- getResponse(nullError=FALSE, ...)

  return(invisible())
}
