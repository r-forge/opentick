'otLogin' <-
function(connection, username=NULL, password=NULL) {

  # Get username and password
  if(is.null(username)) username <- readLines(n=1)
  if(is.null(password)) password <- readLines(n=1)
  
  # Build Request header
  reqHeader <- buildHeader(OT_LOGIN, connection$requestID+1)

  # Construct Message Body
  reqBody <- list()
  reqBody$ver <-     packBits(binary(OT_PROTOCOL_VER, 2*8))
  reqBody$osID <-    packBits(binary(getOS(), 1*8))
  reqBody$platid <-  packBits(binary(OT_PLATFORM_OT, 1*8))
  reqBody$platpwd <- raw(16)
  reqBody$mac <-     raw(6)
  reqBody$user <-    raw(64)
  reqBody$passwd <-  raw(64)
  reqBody$user[1:nchar(username)] <- charToRaw(username)
  reqBody$passwd[1:nchar(password)] <- charToRaw(password)
  reqBody <- unlist(reqBody, use.names=FALSE)

  # Send Request to OT Server
  res <- otRequest(connection, reqHeader, reqBody)

  # Parse Server Response Header
  resHeader <- parseHeader(res$header)
  
  # Need Error Handling
  
  # Parse Server Response Body (unpack will do this)
  resBody <- list()
  resBody$sessionID <-    readBin(res$body[1:64]   , character(), size=64)
  resBody$redirect <-     readBin(res$body[65]     , integer(),   size=1)
  resBody$redirectHost <- readBin(res$body[66:130] , character(), size=64)
  resBody$redirectPort <- readBin(res$body[130:132], integer(),   size=2)

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

'reqExchangeList' <-
function(connection) {

  # Build Request header
  reqHeader <- buildHeader(OT_REQUEST_LIST_EXCHANGES, connection$requestID+1)

  # Construct Message Body
  reqBody <- list()
  reqBody$sessionID <- charToRaw(connection$sessionID)
  reqBody <- unlist(reqBody, use.names=FALSE)

  # Send Request to OT Server
  res <- otRequest(connection, reqHeader, reqBody)

  # Parse Server Response Header
  resHeader <- parseHeader(res$header)
  
  # Need Error Handling
  
  # Parse Server Response Body (unpack will do this)
  resBody <- list()
  resBody$urlLen <-   readBin(res$body[1:2]      , integer(),   size=2)               ;loc <- 2
  resBody$url <-      readBin(res$body[-c(1:loc)], character(), size=resBody$urlLen)  ;loc <- loc + resBody$urlLen
  resBody$rows <-     readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
  results <- data.frame(code=rep(NA,resBody$rows), available=rep(NA,resBody$rows),
                        title=rep(NA,resBody$rows), description=rep(NA,resBody$rows))
  for(i in 1:resBody$rows) {
    results$code[i] <-      readBin(res$body[-c(1:loc)], character(), size=15)              ;loc <- loc + 15
    results$available[i] <- readBin(res$body[-c(1:loc)], integer(),   size=1)               ;loc <- loc + 1
    titleLen <-             readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
    results$title[i] <-     readBin(res$body[-c(1:loc)], character(), size=titleLen);loc <- loc + titleLen
    descLen <-              readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
    results$description[i] <- readBin(res$body[-c(1:loc)], character(), size=descLen) ;loc <- loc + descLen
  }
  #resBody$code <-     readBin(res$body[-c(1:loc)], character(), size=15)              ;loc <- loc + 15
  #resBody$flag <-     readBin(res$body[-c(1:loc)], integer(),   size=1)               ;loc <- loc + 1
  #resBody$titleLen <- readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
  #resBody$title <-    readBin(res$body[-c(1:loc)], character(), size=resBody$titleLen);loc <- loc + resBody$titleLen
  #resBody$descLen <-  readBin(res$body[-c(1:loc)], integer(),   size=2)               ;loc <- loc + 2
  #resBody$desc <-     readBin(res$body[-c(1:loc)], character(), size=resBody$descLen) ;loc <- loc + resBody$descLen

  return(c(resBody,list(results=results)))
}
