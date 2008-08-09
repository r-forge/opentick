#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'otLogin' <-
function(connection, username=NULL, password=NULL) {

  # Prompt for username and password
  if(is.null(username)) username <- readLines(n=1)
  if(is.null(password)) password <- readLines(n=1)
  
  # Construct Message Body
  msgBody <-
  pack("v C C a16 a6 a64 a64",
    OT$PROTOCOL_VER,  #  2 : OT Protocol Version
    getOS(),          #  1 : Operating System ID
    OT$PLATFORM_OT,   #  1 : Platform ID
    '',               # 16 : Platform ID password
    '',               #  6 : MAC address
    username,         # 64 : Username
    password)         # 64 : Password

  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(connection, OT$LOGIN, reqID, msgBody)
  
  # Server response
  response <- getResponse(connection, nullError=TRUE)

  # Parse Response Body
  # SessionID, redirect (boolean), redirect host, redirect port
  resBody <- unpack('A64 C A64 v', response$body)
  names(resBody) <- c('sessionID','redirect','redirectHost','redirectPort')
  
  # Add sessionID and loggedIn value to otConnection Object
  #conObj <- unlist(strsplit(deparse(match.call())," = |,"))
  #conObj <- conObj[grep('connection',conObj)+1]
  #assign(paste(conObj,'$loggedIn',sep=''), TRUE, envir=sys.frame())
  #assign(paste(conObj,'$sessionID',sep=''), resBody$sessionID, envir=sys.frame())
  connection$loggedIn <- TRUE
  connection$sessionID <- resBody$sessionID

  # Redirect?
  if( resBody$redirect ) {
    #assign(paste(conObj,'$host',sep=''), resBody$redirectHost, envir=sys.frame())
    #assign(paste(conObj,'$port',sep=''), resBody$redirectPort, envir=sys.frame())
    connection$host <- resBody$redirectHost
    connection$port <- resBody$redirectPort
  }
  return(connection)
}

'otLogout' <-
function(connection) {

  loggedIn(connection)
  
  # Construct Message Body
  msgBody <-
    pack('a64', connection$sessionID)

  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(connection, OT$LOGOUT, reqID, msgBody)
  
  # Server response
  response <- getResponse(connection)

  # Add sessionID and loggedIn value to otConnection Object
  connection$loggedIn <- FALSE
  connection$sessionID <- ''

  return(connection)
}

'otExchangeList' <-
function(connection) {

  loggedIn(connection)
  
  # Construct Message Body
  msgBody <-
    pack('a64', connection$sessionID)
  
  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(connection, OT$REQUEST_LIST_EXCHANGES, reqID, msgBody)

  results <- NULL
  while(TRUE) {
    
    # Server response
    response <- getResponse(connection)
    if(is.null(response)) break
  
    # Parse Server Response Body
    resBody <- unpack('v/A v a*', response$body)

    # Initialize results data.frame
    result <- data.frame( code=rep(NA,resBody[[2]]), available=rep(NA,resBody[[2]]),
                          title=rep(NA,resBody[[2]]), description=rep(NA,resBody[[2]]) )

    # Get information for each exchange
    remain <- resBody[[3]]
    for(i in 1:resBody[[2]]) {
      row <- unpack('A15 C v/A v/A a*', remain)
      result[i,] <- row[1:4]
      remain <- row[[5]]
    }

    results <- rbind(results,result)
  }
  
  # Only keep subscription URL
  #resBody[2:3] <- NULL

  return(results)
}
