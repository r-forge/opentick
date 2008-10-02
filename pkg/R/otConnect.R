#-------------------------------------------------------------------------#
# opentick R package, copyright (C) Joshua M. Ulrich, 2007-2008           #
# Distributed under GNU GPL version 3                                     #
#-------------------------------------------------------------------------#

'otConnect' <-
function(host='delayed1.opentick.com', port=10015, ...) {

  # Make sure host/port args agree
  host <- match.arg(host, c('feed1.opentick.com','feed2.opentick.com',
                            'delayed1.opentick.com','delayed2.opentick.com'), several.ok=FALSE)
  
  if( !(regexpr('^[fF]',host) > 0 && port == 10010) &&
      !(regexpr('^[dD]',host) > 0 && port == 10015) )
    stop('\'host\' and \'port\' do not align')
  
  if(NROW(host)!=NROW(port)) {
    stop('\'host\' and \'port\' must have same length')
  }

  # Create connection parameters
  otPar <- getParams()
  otPar$host <- host
  otPar$port <- port
  otPar$platform <- OT$PLATFORM_OT
  otPar$platformPassword <- ''

  # Get environment
  env <- as.environment("package:opentick")

  # Check if binding locked; unlock if needed
  locked <- bindingIsLocked('.otConnection', env)
  if(locked) {
    unlockBinding('.otConnection', env)
  }

  for(i in 1:NROW(host)) {
    if(inherits(try(
      assign('.otConnection',socketConnection(host[i], port[i], open='r+b', blocking=TRUE),env),
    silent=TRUE),'try-error')) {
      next
    } else {
      otPar$host <- host[i]
      otPar$port <- port[i]
      break
    }
  }
  setParams(otPar)
  
  # Re-lock, if needed
  if(locked) {
    suppressWarnings({
      lockBinding('.otConnection', env)
    })
  }

  return(invisible(1))
}

'.otReconnect' <-
function() {

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
  # Reconnect, if connection is not open
  if(!open) {
    # Create connection parameters
    otPar <- getParams()
    # Make sure old connection is closed
    .otDisconnect()
    # Make a new connection
    otConnect()
    # Login to new connection
    otLogin(otPar$username,otPar$password)
  } else {
    return(invisible())
  }
}

'.otDisconnect' <-
function() {
  x <- try(close(getSocket()), silent=TRUE)
}

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

  .otDisconnect()
  
  return(invisible(1))
}

'.otAddHost' <-
function(host, port) {

  if( !(regexpr('^[fF]',host) > 0 && port == 10010) &&
      !(regexpr('^[dD]',host) > 0 && port == 10015) )
    stop('\'host\' and \'port\' do not align')
  
  x <- getParams()
  x$host <- c(host,x$host)
  x$port <- c(port,x$port)
  setParams(x)
}

# Actual Socket Connection
'.otConnection' <- list()

'getSocket' <- function() {
   x <- get('.otConnection',as.environment("package:opentick"))
}

# Socket Connection Parameters
'.otParams' <- list(
  host=NULL,
  port=NULL,
  redirect=FALSE,
  redirectHost=NULL,
  redirectPort=NULL,
  username='',
  password='',
  loggedIn=FALSE,
  sessionID='',
  requestID=0,
  platform=NULL,
  platformPassword=NULL)

'getParams' <- function() {
   x <- get('.otParams',as.environment("package:opentick"))
}

'setParams' <- function(x) {
  
  # Get environment
  env <- as.environment("package:opentick")
  environment(x) <- env

  # Check if binding locked; unlock if needed
  locked <- bindingIsLocked('.otParams', env)
  if(locked) {
    unlockBinding('.otParams', env)
  }
  
  # Assign new parameter to object
  #assign('.otParams', { otp <- get('.otParams'); otp[param] <- value; otp }, env )
  assign('.otParams', x, env)

  # Re-lock, if needed
  if(locked) {
    suppressWarnings({
      lockBinding('.otParams', env)
    })
   }
  return(invisible(1))
}
