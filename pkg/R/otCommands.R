#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'otListExchanges' <-
function() {

  loggedIn()
  .otReconnect()

  # Connectoin parameters
  otPar <- getParams()

  # Construct Message Body
  msgBody <-
    pack('a64', otPar$sessionID)
  
  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(OT$REQUEST_LIST_EXCHANGES, reqID, msgBody)

  results <- NULL
  #while(TRUE) {
    
    # Server response
    response <- getResponse()
    if(is.null(response)) break
  
    # Parse Server Response Body
    resBody <- unpack('v/A v H*', response$body)

    # Initialize results data.frame
    result <- data.frame( code=rep(NA,resBody[[2]]), available=rep(NA,resBody[[2]]),
                          title=rep(NA,resBody[[2]]), description=rep(NA,resBody[[2]]) )

    # Get information for each exchange
    remain <- resBody[[3]]
    for(i in 1:resBody[[2]]) {
      row <- unpack('A15 C v/A v/A H*', remain)
      result[i,] <- row[1:4]
      remain <- row[[5]]
    }

    results <- rbind(results,result)
  #}

  return(results)
}

'otListSymbols' <-
function(exchange) {

  loggedIn()
  .otReconnect()

  # Connectoin parameters
  otPar <- getParams()

  # Construct Message Body
  msgBody <-
    pack('a64 a15', otPar$sessionID, exchange)
  
  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(OT$REQUEST_LIST_SYMBOLS, reqID, msgBody)

  results <- NULL
  loop <- TRUE
  while(loop) {

    # Server response
    response <- getResponse()
    if(is.null(response)) {
      loop <- FALSE
      break
    }
  
    # Parse Server Response Body
    resBody <- unpack('v H*', response$body)

    # Initialize results data.frame
    result <- data.frame(
      currencyID=rep(NA,resBody[[1]]), symbolCode=rep(NA,resBody[[1]]),
      type=rep(NA,resBody[[1]]), company=rep(NA,resBody[[1]]) )

    # Check if there are any rows
    if(resBody[[1]]) {
      remain <- resBody[[2]]
      # Get information for each exchange
      for(i in 1:resBody[[1]]) {
        row <- unpack('A4 A15 C v/A H*', remain)
        result[i,] <- row[1:4]
        remain <- row[[5]]
      }
    } else {
      loop <- FALSE
      break
    }

    results <- rbind(results,result)
  }

  return(results)
}
