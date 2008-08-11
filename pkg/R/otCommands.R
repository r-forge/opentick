#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'otLogin' <-
function(username=NULL, password=NULL) {

  # Prompt for username and password
  if(is.null(username)) username <- readLines(n=1)
  if(is.null(password)) password <- readLines(n=1)
  
  # Connectoin parameters
  otPar <- getParams()

  # Construct Message Body
  msgBody <-
  pack("v C C a16 a6 a64 a64",
    OT$PROTOCOL_VER,         #  2 : OT Protocol Version
    getOS(),                 #  1 : Operating System ID
    otPar$platform,          #  1 : Platform ID
    otPar$platformPassword,  # 16 : Platform ID password
    '',                      #  6 : MAC address
    username,                # 64 : Username
    password)                # 64 : Password

  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(OT$LOGIN, reqID, msgBody)

  # Server response
  response <- getResponse(nullError=TRUE)

  # Parse Response Body
  resBody <- unpack('A64 C A64 v', response$body)
  names(resBody) <- c('sessionID','redirect','redirectHost','redirectPort')

  # Update connection parameters
  otPar$redirect <- as.logical(resBody$redirect)
  otPar$redirectHost <- resBody$redirectHost
  otPar$redirectPort <- resBody$redirectPort
  otPar$username <- username
  otPar$password <- password
  otPar$loggedIn <- TRUE
  otPar$sessionID <- resBody$sessionID
  setParams(otPar)

  # Redirect?
  if( otPar$redirect ) {
    .otAddHost(otPar$redirectHost,otPar$redirectPort)
    otLogin(username,password)
  }
  
  return(invisible(1))
}

'otLogout' <-
function() {

  loggedIn()
  
  # Connectoin parameters
  otPar <- getParams()

  # Construct Message Body
  msgBody <-
    pack('a64', otPar$sessionID)

  # Transmit to OT Server
  reqID <- getRequestID()
  sendRequest(OT$LOGOUT, reqID, msgBody)
  
  # Server response
  response <- getResponse()

  # Add sessionID and loggedIn values to connection parameters
  otPar$loggedIn <- FALSE
  otPar$sessionID <- ''
  setParams()

  return(invisible(1))
}

'otExchangeList' <-
function() {

  loggedIn()
  
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
  #}

  return(results)
}
